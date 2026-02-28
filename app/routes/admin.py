"""
KeralaSeva AI – Scholarship Navigator
FILE: app/routes/admin.py
PURPOSE: Admin-only routes for managing scholarship data.
         All routes are protected by @login_required + @admin_required.
         The service role client is used for writes (bypasses RLS on insert).
"""

from flask import Blueprint, request, jsonify
from app.middleware.auth import login_required, admin_required
from app.extensions import supabase_admin

admin_bp = Blueprint("admin", __name__)

VALID_COMMUNITIES = {
    "Muslim", "SC", "ST", "SC/ST", "OBC", "SC/OBC",
    "Minority", "General", "Any"
}
VALID_GENDERS = {"Male", "Female", "Any"}
VALID_EDUCATION_LEVELS = {
    "School", "PostMatric", "Diploma", "Degree",
    "PG", "PhD", "Professional", "Technical", "Engineering", "Any"
}


# ──────────────────────────────────────────────────────────────────
# SCHOLARSHIP CRUD
# ──────────────────────────────────────────────────────────────────

@admin_bp.route("/scholarships", methods=["POST"])
@login_required
@admin_required
def add_scholarship():
    """
    Add a new scholarship.
    
    Request Body:
        {
            "name": "New Scholarship Name",
            "description": "Description text",
            "deadline": "2025-12-31",       (optional, YYYY-MM-DD)
            "income_limit": 250000,
            "amount_min": 10000,
            "amount_max": 25000,
            "portal_url": "https://example.gov.in",
            "is_active": true
        }
    
    Response 201:
        { "message": "Scholarship created", "scholarship": { ...created row... } }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    name = data.get("name", "").strip()
    if not name:
        return jsonify({"error": "scholarship name is required"}), 422

    row = {
        "name":         name,
        "description":  data.get("description", ""),
        "deadline":     data.get("deadline"),       # None allowed
        "income_limit": int(data.get("income_limit", 0)),
        "amount_min":   int(data.get("amount_min", 0)),
        "amount_max":   int(data.get("amount_max", 0)),
        "portal_url":   data.get("portal_url", ""),
        "is_active":    bool(data.get("is_active", True))
    }

    try:
        result = supabase_admin.table("scholarships").insert(row).execute()
        return jsonify({
            "message":     "Scholarship created",
            "scholarship": result.data[0]
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@admin_bp.route("/scholarships/<string:scholarship_id>", methods=["PUT"])
@login_required
@admin_required
def update_scholarship(scholarship_id: str):
    """
    Update an existing scholarship.
    Accepts partial updates – only provided fields are changed.
    
    Response 200:
        { "message": "Scholarship updated", "scholarship": { ... } }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    allowed = {
        "name", "description", "deadline", "income_limit",
        "amount_min", "amount_max", "portal_url", "is_active"
    }
    update_data = {k: v for k, v in data.items() if k in allowed}
    if not update_data:
        return jsonify({"error": "No valid fields provided for update"}), 400

    # Type coerce numeric fields
    for field in ("income_limit", "amount_min", "amount_max"):
        if field in update_data:
            update_data[field] = int(update_data[field])

    try:
        result = (
            supabase_admin
            .table("scholarships")
            .update(update_data)
            .eq("id", scholarship_id)
            .execute()
        )
        if result.data:
            return jsonify({"message": "Scholarship updated", "scholarship": result.data[0]}), 200
        else:
            return jsonify({"error": "Scholarship not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@admin_bp.route("/scholarships/<string:scholarship_id>", methods=["DELETE"])
@login_required
@admin_required
def deactivate_scholarship(scholarship_id: str):
    """
    Soft-delete a scholarship by setting is_active = false.
    (Preserves data integrity; hard delete is not exposed via API.)
    
    Response 200:
        { "message": "Scholarship deactivated" }
    """
    try:
        result = (
            supabase_admin
            .table("scholarships")
            .update({"is_active": False})
            .eq("id", scholarship_id)
            .execute()
        )
        if result.data:
            return jsonify({"message": "Scholarship deactivated"}), 200
        return jsonify({"error": "Scholarship not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ──────────────────────────────────────────────────────────────────
# ELIGIBILITY MANAGEMENT
# ──────────────────────────────────────────────────────────────────

@admin_bp.route("/scholarships/<string:scholarship_id>/eligibility", methods=["POST"])
@login_required
@admin_required
def add_eligibility(scholarship_id: str):
    """
    Add one or more eligibility rows to a scholarship.
    
    Request Body:
        {
            "rows": [
                { "community": "Muslim",  "gender": "Female", "education_level": "Degree" },
                { "community": "Minority","gender": "Any",    "education_level": "PostMatric" }
            ]
        }
    
    Response 201:
        { "message": "Eligibility rows added", "added": 2 }
    """
    data = request.get_json(silent=True)
    if not data or "rows" not in data:
        return jsonify({"error": "Provide 'rows' array in request body"}), 400

    rows = data["rows"]
    if not isinstance(rows, list) or len(rows) == 0:
        return jsonify({"error": "'rows' must be a non-empty array"}), 422

    errors = []
    validated_rows = []
    for i, row in enumerate(rows):
        community       = row.get("community")
        gender          = row.get("gender")
        education_level = row.get("education_level")
        if community not in VALID_COMMUNITIES:
            errors.append(f"Row {i}: invalid community '{community}'")
        if gender not in VALID_GENDERS:
            errors.append(f"Row {i}: invalid gender '{gender}'")
        if education_level not in VALID_EDUCATION_LEVELS:
            errors.append(f"Row {i}: invalid education_level '{education_level}'")
        if not errors:
            validated_rows.append({
                "scholarship_id":  scholarship_id,
                "community":       community,
                "gender":          gender,
                "education_level": education_level
            })

    if errors:
        return jsonify({"error": "Validation failed", "details": errors}), 422

    try:
        result = supabase_admin.table("eligibility").insert(validated_rows).execute()
        return jsonify({"message": "Eligibility rows added", "added": len(result.data)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ──────────────────────────────────────────────────────────────────
# DOCUMENTS MANAGEMENT
# ──────────────────────────────────────────────────────────────────

@admin_bp.route("/scholarships/<string:scholarship_id>/documents", methods=["POST"])
@login_required
@admin_required
def add_documents(scholarship_id: str):
    """
    Add required documents for a scholarship.
    
    Request Body:
        {
            "documents": [
                "Aadhaar Card",
                "Income Certificate",
                "Mark Sheet"
            ]
        }
    
    Response 201:
        { "message": "Documents added", "added": 3 }
    """
    data = request.get_json(silent=True)
    if not data or "documents" not in data:
        return jsonify({"error": "Provide 'documents' array in request body"}), 400

    docs = data["documents"]
    if not isinstance(docs, list) or len(docs) == 0:
        return jsonify({"error": "'documents' must be a non-empty array"}), 422

    rows = [
        {"scholarship_id": scholarship_id, "document_name": d.strip()}
        for d in docs if d.strip()
    ]
    if not rows:
        return jsonify({"error": "All document names are empty"}), 422

    try:
        result = supabase_admin.table("documents_required").insert(rows).execute()
        return jsonify({"message": "Documents added", "added": len(result.data)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ──────────────────────────────────────────────────────────────────
# APPLICATION STEPS MANAGEMENT
# ──────────────────────────────────────────────────────────────────

@admin_bp.route("/scholarships/<string:scholarship_id>/steps", methods=["POST"])
@login_required
@admin_required
def add_steps(scholarship_id: str):
    """
    Add application steps for a scholarship.
    Steps are identified by step_number (must be unique per scholarship).
    
    Request Body:
        {
            "steps": [
                { "step_number": 1, "step_text": "Register on the portal..." },
                { "step_number": 2, "step_text": "Fill in your details..." }
            ]
        }
    
    Response 201:
        { "message": "Steps added", "added": 2 }
    """
    data = request.get_json(silent=True)
    if not data or "steps" not in data:
        return jsonify({"error": "Provide 'steps' array in request body"}), 400

    steps = data["steps"]
    if not isinstance(steps, list) or len(steps) == 0:
        return jsonify({"error": "'steps' must be a non-empty array"}), 422

    errors = []
    validated_steps = []
    for i, step in enumerate(steps):
        step_number = step.get("step_number")
        step_text   = step.get("step_text", "").strip()
        if not isinstance(step_number, int) or step_number < 1:
            errors.append(f"Step {i}: step_number must be a positive integer")
        if not step_text:
            errors.append(f"Step {i}: step_text cannot be empty")
        if not errors:
            validated_steps.append({
                "scholarship_id": scholarship_id,
                "step_number":    step_number,
                "step_text":      step_text
            })

    if errors:
        return jsonify({"error": "Validation failed", "details": errors}), 422

    try:
        result = supabase_admin.table("application_steps").insert(validated_steps).execute()
        return jsonify({"message": "Application steps added", "added": len(result.data)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ──────────────────────────────────────────────────────────────────
# ADMIN DASHBOARD OVERVIEW
# ──────────────────────────────────────────────────────────────────

@admin_bp.route("/overview", methods=["GET"])
@login_required
@admin_required
def admin_overview():
    """
    High-level dashboard stats for admins.
    
    Response 200:
        {
            "total_scholarships": 25,
            "active_scholarships": 23,
            "total_users": 412,
            "total_notifications_sent": 1089
        }
    """
    try:
        scholarships_result = (
            supabase_admin.table("scholarships").select("id, is_active").execute()
        )
        all_scholarships = scholarships_result.data or []
        active_count     = sum(1 for s in all_scholarships if s.get("is_active"))

        profiles_result = supabase_admin.table("profiles").select("id").execute()
        total_users     = len(profiles_result.data or [])

        notif_result          = supabase_admin.table("notifications").select("id").execute()
        total_notifications   = len(notif_result.data or [])

        return jsonify({
            "total_scholarships":      len(all_scholarships),
            "active_scholarships":     active_count,
            "total_users":             total_users,
            "total_notifications_sent": total_notifications
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

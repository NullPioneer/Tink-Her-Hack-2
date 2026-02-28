"""
KeralaSeva AI – Scholarship Navigator
FILE: app/routes/profile.py
PURPOSE: User profile CRUD – create, read, update
"""

from flask import Blueprint, request, jsonify, g
from app.middleware.auth import login_required, get_user_client

profile_bp = Blueprint("profile", __name__)

VALID_COMMUNITIES     = {"Muslim", "SC", "ST", "SC/ST", "OBC", "SC/OBC", "General", "Minority"}
VALID_GENDERS         = {"Male", "Female", "Other"}
VALID_EDUCATION_LEVELS = {
    "School", "PostMatric", "Diploma", "Degree",
    "PG", "PhD", "Professional", "Technical", "Engineering"
}


def _validate_profile_payload(data: dict) -> list[str]:
    """Validate profile fields. Returns list of error messages."""
    errors = []
    if not data.get("name", "").strip():
        errors.append("Name is required")
    if data.get("community") not in VALID_COMMUNITIES:
        errors.append(f"community must be one of: {', '.join(sorted(VALID_COMMUNITIES))}")
    if data.get("gender") not in VALID_GENDERS:
        errors.append(f"gender must be one of: {', '.join(VALID_GENDERS)}")
    if data.get("education_level") not in VALID_EDUCATION_LEVELS:
        errors.append(f"education_level must be one of: {', '.join(sorted(VALID_EDUCATION_LEVELS))}")
    try:
        income = int(data.get("income", -1))
        if income < 0:
            errors.append("income must be a non-negative integer")
    except (TypeError, ValueError):
        errors.append("income must be a valid integer")
    if not data.get("district", "").strip():
        errors.append("district is required")
    return errors


@profile_bp.route("/", methods=["GET"])
@login_required
def get_profile():
    """
    Get the authenticated user's profile.
    
    Headers:
        Authorization: Bearer <access_token>
    
    Response 200:
        {
            "id": "uuid",
            "name": "Fatima Khan",
            "community": "Muslim",
            "gender": "Female",
            "education_level": "Degree",
            "income": 180000,
            "district": "Malappuram",
            "is_admin": false
        }
    """
    user_id = g.user.id
    client  = get_user_client(g.token)

    try:
        result = (
            client
            .table("profiles")
            .select("*")
            .eq("id", user_id)
            .single()
            .execute()
        )
        if result.data:
            return jsonify(result.data), 200
        else:
            return jsonify({"error": "Profile not found. Please complete your profile setup."}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@profile_bp.route("/create", methods=["POST"])
@login_required
def create_profile():
    """
    Create a profile for the authenticated user.
    Called once after signup.
    
    Request Body:
        {
            "name": "Fatima Khan",
            "community": "Muslim",
            "gender": "Female",
            "education_level": "Degree",
            "income": 180000,
            "district": "Malappuram"
        }
    
    Response 201:
        { "message": "Profile created", "profile": { ... } }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    errors = _validate_profile_payload(data)
    if errors:
        return jsonify({"error": "Validation failed", "details": errors}), 422

    user_id = g.user.id
    client  = get_user_client(g.token)

    profile_row = {
        "id":              user_id,
        "name":            data["name"].strip(),
        "community":       data["community"],
        "gender":          data["gender"],
        "education_level": data["education_level"],
        "income":          int(data["income"]),
        "district":        data["district"].strip(),
        "is_admin":        False   # Never allow self-promotion to admin
    }

    try:
        result = (
            client
            .table("profiles")
            .insert(profile_row)
            .execute()
        )
        return jsonify({"message": "Profile created successfully", "profile": result.data[0]}), 201
    except Exception as e:
        if "duplicate key" in str(e).lower() or "unique" in str(e).lower():
            return jsonify({"error": "Profile already exists. Use PUT /api/profile/ to update."}), 409
        return jsonify({"error": str(e)}), 500


@profile_bp.route("/", methods=["PUT"])
@login_required
def update_profile():
    """
    Update the authenticated user's profile.
    Only allows updating allowed fields (not id or is_admin).
    
    Request Body (partial update supported):
        {
            "name": "Updated Name",
            "education_level": "PG",
            "income": 250000
        }
    
    Response 200:
        { "message": "Profile updated", "profile": { ... } }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    # Allowed fields for update (exclude id and is_admin for security)
    allowed_fields = {"name", "community", "gender", "education_level", "income", "district"}
    update_data = {k: v for k, v in data.items() if k in allowed_fields}

    if not update_data:
        return jsonify({"error": "No valid fields to update"}), 400

    # Validate only the fields being updated
    partial_errors = _validate_profile_payload({
        "name":            update_data.get("name", "valid"),
        "community":       update_data.get("community", "Muslim"),
        "gender":          update_data.get("gender", "Male"),
        "education_level": update_data.get("education_level", "Degree"),
        "income":          update_data.get("income", 0),
        "district":        update_data.get("district", "valid")
    })
    if partial_errors:
        return jsonify({"error": "Validation failed", "details": partial_errors}), 422

    # Clean string fields
    if "name" in update_data:
        update_data["name"] = update_data["name"].strip()
    if "district" in update_data:
        update_data["district"] = update_data["district"].strip()
    if "income" in update_data:
        update_data["income"] = int(update_data["income"])

    user_id = g.user.id
    client  = get_user_client(g.token)

    try:
        result = (
            client
            .table("profiles")
            .update(update_data)
            .eq("id", user_id)
            .execute()
        )
        if result.data:
            return jsonify({"message": "Profile updated successfully", "profile": result.data[0]}), 200
        else:
            return jsonify({"error": "Profile not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

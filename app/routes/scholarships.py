"""
KeralaSeva AI – Scholarship Navigator
FILE: app/routes/scholarships.py
PURPOSE: Scholarship browsing, personalized matching, and detail view
"""

from flask import Blueprint, request, jsonify, g
from app.middleware.auth import login_required
from app.extensions import supabase_client, supabase_admin

scholarships_bp = Blueprint("scholarships", __name__)


@scholarships_bp.route("/", methods=["GET"])
@login_required
def list_all_scholarships():
    """
    Return all active scholarships (no personalization filter).
    Supports advanced filtering via query parameters.

    Query Params:
        search      : text search on scholarship name
        deadline    : 'upcoming'
        community   : SC / ST / OBC / Minority / etc
        gender      : Male / Female
        education   : Degree / PG / etc
        income      : max income limit (integer)
    """

    search_term     = request.args.get("search", "").strip()
    deadline_filter = request.args.get("deadline", "")
    community       = request.args.get("community")
    gender          = request.args.get("gender")
    education       = request.args.get("education")
    income          = request.args.get("income")

    try:
        query = (
            supabase_client
            .table("scholarships")
            .select("*")
            .eq("is_active", True)
            .order("deadline", desc=False)
        )

        # 🔍 Keyword search (name)
        if search_term:
            query = query.ilike("name", f"%{search_term}%")

        # 💰 Income filter
        if income:
            query = query.or_(f"income_limit.eq.0,income_limit.gte.{income}")

        result = query.execute()
        scholarships = result.data or []

        # 📅 Deadline filter (upcoming only)
        if deadline_filter == "upcoming":
            from datetime import date
            today = date.today().isoformat()
            scholarships = [
                s for s in scholarships
                if s.get("deadline") and s["deadline"] >= today
            ]

        # 🎯 Advanced eligibility filtering
        if community or gender or education:
            filtered = []

            for s in scholarships:
                eligibilities = (
                    supabase_client
                    .table("eligibility")
                    .select("*")
                    .eq("scholarship_id", s["id"])
                    .execute()
                    .data or []
                )

                for e in eligibilities:
                    if community and community.lower() not in e.get("community", "").lower():
                        continue
                    if gender and gender.lower() not in e.get("gender", "").lower():
                        continue

                    if education and education.lower() not in e.get("education_level", "").lower():
                        continue

                    filtered.append(s)
                    break

            scholarships = filtered

        return jsonify({
            "count": len(scholarships),
            "scholarships": scholarships
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@scholarships_bp.route("/matching", methods=["GET"])
@login_required
def get_matching_scholarships():
    """
    Return personalized scholarship matches for logged-in user.
    Uses SQL RPC function: get_matching_scholarships(p_user_id UUID)
    """

    user_id = g.user.id

    try:
        result = (
            supabase_client
            .rpc("get_matching_scholarships", {"p_user_id": user_id})
            .execute()
        )

        scholarships = result.data or []

        return jsonify({
            "count": len(scholarships),
            "scholarships": scholarships
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@scholarships_bp.route("/<string:scholarship_id>", methods=["GET"])
@login_required
def get_scholarship_detail(scholarship_id: str):
    """
    Full detail page for a single scholarship.
    Returns all related data: eligibility, documents, steps.
    
    Response 200:
        {
            "scholarship": {
                "id": "uuid",
                "name": "...",
                "description": "...",
                "deadline": "2025-11-30",
                "income_limit": 200000,
                "amount_min": 5000,
                "amount_max": 12000,
                "portal_url": "https://...",
                "is_active": true,
                "created_at": "..."
            },
            "eligibility": [
                { "id": 1, "community": "Muslim", "gender": "Female", "education_level": "Degree" },
                ...
            ],
            "documents_required": [
                { "id": 1, "document_name": "Aadhaar Card" },
                ...
            ],
            "application_steps": [
                { "id": 1, "step_number": 1, "step_text": "Register on portal..." },
                ...
            ]
        }
    """
    try:
        # 1. Fetch scholarship base record
        s_result = (
            supabase_client
            .table("scholarships")
            .select("*")
            .eq("id", scholarship_id)
            .single()
            .execute()
        )
        if not s_result.data:
            return jsonify({"error": "Scholarship not found"}), 404

        scholarship = s_result.data

        # 2. Fetch eligibility rows
        e_result = (
            supabase_client
            .table("eligibility")
            .select("id, community, gender, education_level")
            .eq("scholarship_id", scholarship_id)
            .execute()
        )

        # 3. Fetch required documents
        d_result = (
            supabase_client
            .table("documents_required")
            .select("id, document_name")
            .eq("scholarship_id", scholarship_id)
            .execute()
        )

        # 4. Fetch application steps ordered by step_number
        steps_result = (
            supabase_client
            .table("application_steps")
            .select("id, step_number, step_text")
            .eq("scholarship_id", scholarship_id)
            .order("step_number", desc=False)
            .execute()
        )

        return jsonify({
            "scholarship":        scholarship,
            "eligibility":        e_result.data or [],
            "documents_required": d_result.data or [],
            "application_steps":  steps_result.data or []
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@scholarships_bp.route("/notifications", methods=["GET"])
@login_required
def get_my_notifications():
    """
    Get all deadline notifications for the authenticated user.
    RLS ensures users only see their own notifications.
    
    Response 200:
        {
            "unread_count": 3,
            "notifications": [
                {
                    "id": 1,
                    "scholarship_id": "uuid",
                    "message": "Deadline alert: CH Muhammed Koya Scholarship is due in 5 days!",
                    "is_read": false,
                    "created_at": "2025-11-25T08:00:00Z"
                },
                ...
            ]
        }
    """
    user_id = g.user.id

    try:
        result = (
            supabase_client
            .table("notifications")
            .select("*")
            .eq("user_id", user_id)
            .order("created_at", desc=True)
            .execute()
        )
        notifications = result.data or []
        unread_count  = sum(1 for n in notifications if not n.get("is_read"))

        return jsonify({
            "unread_count":  unread_count,
            "notifications": notifications
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@scholarships_bp.route("/notifications/<int:notif_id>/read", methods=["PUT"])
@login_required
def mark_notification_read(notif_id: int):
    """
    Mark a single notification as read.
    RLS ensures users can only update their own notifications.
    
    Response 200:
        { "message": "Notification marked as read" }
    """
    user_id = g.user.id

    try:
        result = (
            supabase_client
            .table("notifications")
            .update({"is_read": True})
            .eq("id", notif_id)
            .eq("user_id", user_id)   # extra safety: only own notifs
            .execute()
        )
        if result.data:
            return jsonify({"message": "Notification marked as read"}), 200
        else:
            return jsonify({"error": "Notification not found or access denied"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

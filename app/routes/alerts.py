"""
KeralaSeva AI – Scholarship Navigator
FILE: app/routes/alerts.py
PURPOSE: 
  1. User alert preference management (set how many days before deadline to alert)
  2. Deadline alert system routes (manual trigger + status)
  3. Core alert logic called by the daily cron job
"""

from datetime import date, timedelta
from flask import Blueprint, request, jsonify, g
from app.middleware.auth import login_required, admin_required
from app.extensions import supabase_admin, supabase_client
from app.middleware.auth import get_user_client

alerts_bp = Blueprint("alerts", __name__)


# ──────────────────────────────────────────────────────────────────
# USER ALERT PREFERENCES
# ──────────────────────────────────────────────────────────────────

@alerts_bp.route("/preferences", methods=["GET"])
@login_required
def get_alert_preferences():
    """
    Get the authenticated user's alert preference.
    
    Response 200:
        { "user_id": "uuid", "alert_before_days": 7 }
    """
    user_id = g.user.id
    client  = get_user_client(g.token)

    try:
        result = (
            client
            .table("user_alert_preferences")
            .select("*")
            .eq("user_id", user_id)
            .single()
            .execute()
        )
        if result.data:
            return jsonify(result.data), 200
        else:
            # Return the default if no preference is set
            return jsonify({"user_id": user_id, "alert_before_days": 7}), 200
    except Exception as e:
        return jsonify({"user_id": user_id, "alert_before_days": 7}), 200


@alerts_bp.route("/preferences", methods=["PUT"])
@login_required
def set_alert_preferences():
    """
    Set or update the user's alert preference.
    
    Request Body:
        { "alert_before_days": 14 }
    
    Response 200:
        { "message": "Alert preference saved", "alert_before_days": 14 }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    alert_before_days = data.get("alert_before_days")
    if not isinstance(alert_before_days, int) or alert_before_days < 1 or alert_before_days > 90:
        return jsonify({"error": "alert_before_days must be an integer between 1 and 90"}), 422

    user_id = g.user.id
    client  = get_user_client(g.token)

    row = {"user_id": user_id, "alert_before_days": alert_before_days}

    try:
        # Upsert: insert or update on conflict on user_id
        result = (
            client
            .table("user_alert_preferences")
            .upsert(row, on_conflict="user_id")
            .execute()
        )
        return jsonify({
            "message":           "Alert preference saved",
            "alert_before_days": alert_before_days
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ──────────────────────────────────────────────────────────────────
# CORE DEADLINE ALERT JOB
# ──────────────────────────────────────────────────────────────────

def run_deadline_alert_job() -> dict:
    """
    Core alert function called by the daily cron job or admin trigger.
    
    Algorithm:
    1. Fetch all alert preferences for all users
    2. For each user:
       a. Determine their alert_before_days threshold
       b. Get scholarships with deadline <= today + threshold
       c. For each such scholarship, check if the user is eligible
          by calling get_matching_scholarships() SQL function
       d. If eligible AND no existing notification → INSERT notification
    
    This avoids creating duplicate alerts (UNIQUE constraint on user_id + scholarship_id).
    
    Returns:
        { "notifications_created": int, "users_processed": int, "errors": list }
    """
    today             = date.today()
    errors            = []
    notifications_created = 0
    users_processed   = 0

    try:
        # Step 1: Get all users with their alert preferences
        # We use admin client to bypass RLS for the server job
        prefs_result = supabase_admin.table("user_alert_preferences").select("*").execute()
        all_prefs    = prefs_result.data or []

        # Also get users WITHOUT preferences (use default of 7 days)
        profiles_result = supabase_admin.table("profiles").select("id").execute()
        all_profile_ids = {p["id"] for p in (profiles_result.data or [])}
        pref_user_ids   = {p["user_id"] for p in all_prefs}
        
        # Build user → days map
        user_days_map = {p["user_id"]: p["alert_before_days"] for p in all_prefs}
        for uid in all_profile_ids - pref_user_ids:
            user_days_map[uid] = 7  # default

        # Step 2: For each user, find eligible upcoming scholarships
        for user_id, alert_before_days in user_days_map.items():
            users_processed += 1
            alert_cutoff = (today + timedelta(days=alert_before_days)).isoformat()

            try:
                # Get all scholarships matching this user via our SQL function
                matching_result = supabase_admin.rpc(
                    "get_matching_scholarships",
                    {"p_user_id": user_id}
                ).execute()
                matching = matching_result.data or []

                # Filter to those whose deadline is within the alert window
                upcoming_eligible = [
                    s for s in matching
                    if s.get("deadline") and s["deadline"] <= alert_cutoff
                    and s["deadline"] >= today.isoformat()
                ]

                # Step 3: Insert notifications (skip if already exists)
                for scholarship in upcoming_eligible:
                    s_id     = scholarship["scholarship_id"]
                    s_name   = scholarship["name"]
                    deadline = scholarship["deadline"]
                    days_left = scholarship.get("days_until_due", "?")

                    message = (
                        f"⏰ Deadline Alert: '{s_name}' deadline is on {deadline} "
                        f"({days_left} days remaining). Apply now!"
                    )

                    try:
                        supabase_admin.table("notifications").insert({
                            "user_id":        user_id,
                            "scholarship_id": s_id,
                            "message":        message,
                            "is_read":        False
                        }).execute()
                        notifications_created += 1
                    except Exception as insert_err:
                        # Unique constraint violation = duplicate, skip silently
                        if "unique" in str(insert_err).lower():
                            pass
                        else:
                            errors.append(f"user {user_id}, scholarship {s_id}: {str(insert_err)}")

            except Exception as user_err:
                errors.append(f"Processing user {user_id}: {str(user_err)}")

    except Exception as e:
        errors.append(f"Fatal error in alert job: {str(e)}")

    return {
        "notifications_created": notifications_created,
        "users_processed":       users_processed,
        "run_date":              today.isoformat(),
        "errors":                errors
    }


@alerts_bp.route("/run-job", methods=["POST"])
@login_required
@admin_required
def trigger_alert_job():
    """
    Admin-only endpoint to manually trigger the deadline alert job.
    Normally this is called by a cron job (APScheduler, Celery, or system cron).
    
    Response 200:
        {
            "message": "Alert job completed",
            "result": {
                "notifications_created": 14,
                "users_processed": 87,
                "run_date": "2025-11-25",
                "errors": []
            }
        }
    """
    result = run_deadline_alert_job()
    return jsonify({
        "message": "Alert job completed",
        "result":  result
    }), 200

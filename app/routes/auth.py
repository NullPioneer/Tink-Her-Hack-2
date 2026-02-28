"""
KeralaSeva AI – Scholarship Navigator
FILE: app/routes/auth.py
PURPOSE: Authentication routes – signup, login, logout, password reset
         All auth is delegated to Supabase; Flask only proxies and wraps responses.
"""

from flask import Blueprint, request, jsonify
from app.extensions import supabase_client

auth_bp = Blueprint("auth", __name__)
@auth_bp.route("/signup", methods=["POST"])
def signup():
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    email = data.get("email", "").strip().lower()
    password = data.get("password", "")

    name = data.get("name", "New User")
    community = data.get("community", "General")
    gender = data.get("gender", "Male")
    education_level = data.get("education_level", "Degree")
    income = data.get("income", 0)
    district = data.get("district", "Unknown")

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    if len(password) < 8:
        return jsonify({"error": "Password must be at least 8 characters"}), 400

    try:
        # 1️⃣ Create auth user
        result = supabase_client.auth.sign_up({
            "email": email,
            "password": password
        })

        if not result.user:
            return jsonify({"error": "Signup failed"}), 400

        user_id = result.user.id

        # 2️⃣ Insert profile
        from app.extensions import supabase_admin

        profile_insert = supabase_admin.table("profiles").insert({
            "id": user_id,
            "name": name,
            "community": community,
            "gender": gender,
            "education_level": education_level,
            "income": income,
            "district": district
        }).execute()

        print("PROFILE INSERT DATA:", profile_insert.data)

        return jsonify({
            "message": "Signup successful. Please verify your email.",
            "user_id": user_id
        }), 201

    except Exception as e:
        print("SIGNUP ERROR:", str(e))
        return jsonify({"error": str(e)}), 400


@auth_bp.route("/login", methods=["POST"])
def login():
    """
    Authenticate user and receive JWT access token.
    
    Request Body:
        {
            "email": "user@example.com",
            "password": "securePassword123"
        }
    
    Response 200:
        {
            "access_token": "eyJ...",
            "refresh_token": "...",
            "user": { "id": "uuid", "email": "..." }
        }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    email    = data.get("email", "").strip().lower()
    password = data.get("password", "")

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    try:
        result = supabase_client.auth.sign_in_with_password({
            "email":    email,
            "password": password
        })
        if result.session:
            return jsonify({
                "access_token":  result.session.access_token,
                "refresh_token": result.session.refresh_token,
                "user": {
                    "id":    result.user.id,
                    "email": result.user.email
                }
            }), 200
        else:
            return jsonify({"error": "Login failed. Check credentials."}), 401
    except Exception as e:
        return jsonify({"error": str(e)}), 401


@auth_bp.route("/logout", methods=["POST"])
def logout():
    """
    Invalidate the current Supabase session.
    Client should also discard tokens from local storage.
    
    Response 200:
        { "message": "Logged out successfully" }
    """
    try:
        supabase_client.auth.sign_out()
        return jsonify({"message": "Logged out successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@auth_bp.route("/reset-password", methods=["POST"])
def reset_password():
    """
    Send a password reset email via Supabase.
    
    Request Body:
        { "email": "user@example.com" }
    
    Response 200:
        { "message": "Password reset email sent" }
    """
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Request body must be JSON"}), 400

    email = data.get("email", "").strip().lower()
    if not email:
        return jsonify({"error": "Email is required"}), 400

    try:
        supabase_client.auth.reset_password_email(email)
        return jsonify({"message": "Password reset email sent if the account exists"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400
# ─────────────────────────────────────────────
# GET CURRENT PROFILE
# ─────────────────────────────────────────────
@auth_bp.route("/profile/me", methods=["GET"])
def get_profile():
    try:
        token = request.headers.get("Authorization", "").replace("Bearer ", "")

        user_response = supabase_client.auth.get_user(jwt=token)

        if not user_response or not user_response.user:
            return jsonify({"error": "Unauthorized"}), 401

        user_id = user_response.user.id

        profile = supabase_client.table("profiles") \
            .select("*") \
            .eq("id", user_id) \
            .single() \
            .execute()

        return jsonify(profile.data), 200

    except Exception as e:
        print("PROFILE LOAD ERROR:", e)
        return jsonify({"error": str(e)}), 400


# ─────────────────────────────────────────────
# UPDATE PROFILE
# ─────────────────────────────────────────────
@auth_bp.route("/profile/update", methods=["PUT"])
def update_profile():
    try:
        token = request.headers.get("Authorization", "").replace("Bearer ", "")

        user_response = supabase_client.auth.get_user(jwt=token)

        if not user_response or not user_response.user:
            return jsonify({"error": "Unauthorized"}), 401

        user_id = user_response.user.id
        data = request.get_json()

        supabase_client.table("profiles") \
            .update({
                "name": data.get("name"),
                "community": data.get("community"),
                "gender": data.get("gender"),
                "education_level": data.get("education_level"),
                "income": data.get("income"),
                "district": data.get("district")
            }) \
            .eq("id", user_id) \
            .execute()

        return jsonify({"message": "Profile updated"}), 200

    except Exception as e:
        print("PROFILE UPDATE ERROR:", e)
        return jsonify({"error": str(e)}), 400
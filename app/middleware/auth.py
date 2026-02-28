"""
KeralaSeva AI – Scholarship Navigator
FILE: app/middleware/auth.py
PURPOSE: JWT authentication and admin authorization decorators
"""

import functools
from typing import Callable, Any

from flask import request, jsonify, g
from supabase import Client

from app.extensions import supabase_client


def _extract_bearer_token() -> str | None:
    """Extract Bearer token from Authorization header."""
    auth_header = request.headers.get("Authorization", "")
    if auth_header.startswith("Bearer "):
        return auth_header[len("Bearer "):]
    return None


def login_required(f: Callable) -> Callable:
    """
    Decorator: verifies Supabase JWT and loads user into Flask g.
    
    Usage:
        @app.route("/api/something")
        @login_required
        def my_view():
            user_id = g.user.id   # Supabase user object
            ...
    
    On failure: returns 401 JSON error.
    """
    @functools.wraps(f)
    def decorated(*args: Any, **kwargs: Any):
        token = _extract_bearer_token()
        if not token:
            return jsonify({"error": "Missing authorization token"}), 401

        try:
            # Verify the JWT with Supabase and get the user object
            response = supabase_client.auth.get_user(token)
            if not response or not response.user:
                return jsonify({"error": "Invalid or expired token"}), 401
            
            # Store user on Flask's request context object
            g.user  = response.user
            g.token = token   # Preserve token for downstream RLS-aware calls
        except Exception as e:
            return jsonify({"error": "Authentication failed", "detail": str(e)}), 401

        return f(*args, **kwargs)
    return decorated


def admin_required(f: Callable) -> Callable:
    """
    Decorator: requires authenticated user WITH is_admin = True in profiles.
    Must be used AFTER @login_required.
    
    Usage:
        @app.route("/api/admin/something")
        @login_required
        @admin_required
        def admin_view():
            ...
    """
    @functools.wraps(f)
    def decorated(*args: Any, **kwargs: Any):
        # g.user must already be set by @login_required
        user_id = g.user.id

        try:
            result = (
                supabase_client
                .table("profiles")
                .select("is_admin")
                .eq("id", user_id)
                .single()
                .execute()
            )
            if not result.data or not result.data.get("is_admin"):
                return jsonify({"error": "Admin access required"}), 403
        except Exception:
            return jsonify({"error": "Could not verify admin status"}), 403

        return f(*args, **kwargs)
    return decorated


def get_user_client(token: str) -> Client:
    """
    Returns a Supabase client with the user's JWT injected.
    This ensures RLS policies are applied using the user's identity.
    """
    from supabase import create_client
    import os
    client = create_client(
        os.environ.get("SUPABASE_URL", ""),
        os.environ.get("SUPABASE_KEY", "")
    )
    # Set the session so RLS policies evaluate as this user
    client.auth.set_session(token, "")
    return client

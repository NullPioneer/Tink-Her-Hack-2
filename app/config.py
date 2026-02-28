"""
KeralaSeva AI – Scholarship Navigator
FILE: app/config.py
PURPOSE: Centralized configuration from environment variables
"""

import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    """Base configuration class."""

    # ── Flask ──────────────────────────────────────────────────────
    SECRET_KEY = os.environ.get("SECRET_KEY") or "change-this-in-production-please"
    DEBUG      = os.environ.get("FLASK_DEBUG", "0") == "1"

    # ── Supabase ───────────────────────────────────────────────────
    # SUPABASE_URL:      Your project URL from Supabase dashboard
    # SUPABASE_KEY:      Anon (public) key for user-facing requests
    # SUPABASE_SERVICE_KEY: Service role key for backend-only operations
    #                       (bypasses RLS – keep this SECRET)
    SUPABASE_URL         = os.environ.get("SUPABASE_URL", "")
    SUPABASE_KEY         = os.environ.get("SUPABASE_KEY", "")
    SUPABASE_SERVICE_KEY = os.environ.get("SUPABASE_SERVICE_KEY", "")

    # ── CORS ───────────────────────────────────────────────────────
    ALLOWED_ORIGINS = os.environ.get(
        "ALLOWED_ORIGINS",
        "http://localhost:3000,http://127.0.0.1:5500"
    ).split(",")


class ProductionConfig(Config):
    DEBUG = False


class DevelopmentConfig(Config):
    DEBUG = True


# Map string → config class for easy selection
config_map = {
    "production":  ProductionConfig,
    "development": DevelopmentConfig,
    "default":     DevelopmentConfig,
}

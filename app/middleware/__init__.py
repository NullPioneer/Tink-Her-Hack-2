"""
KeralaSeva AI – Scholarship Navigator
FILE: app/__init__.py
PURPOSE: Flask application factory with configuration
"""

from flask import Flask, render_template
from flask_cors import CORS

from app.config import Config
from app.extensions import supabase_client


def create_app(config_class=Config) -> Flask:
    """
    Application factory pattern.
    Creates and configures the Flask application.
    """
    app = Flask(__name__)
    app.config.from_object(config_class)

    # ── CORS: allow frontend origin ────────────────────────────────
    CORS(app, resources={
        r"/api/*": {
            "origins": app.config["ALLOWED_ORIGINS"],
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Authorization", "Content-Type"]
        }
    })

    # ── Register Blueprints ────────────────────────────────────────
    from app.routes.auth       import auth_bp
    from app.routes.profile    import profile_bp
    from app.routes.scholarships import scholarships_bp
    from app.routes.admin      import admin_bp
    from app.routes.alerts     import alerts_bp

    app.register_blueprint(auth_bp,         url_prefix="/api/auth")
    app.register_blueprint(profile_bp,      url_prefix="/api/profile")
    app.register_blueprint(scholarships_bp, url_prefix="/api/scholarships")
    app.register_blueprint(admin_bp,        url_prefix="/api/admin")
    app.register_blueprint(alerts_bp,       url_prefix="/api/alerts")

    # ── Health Check ───────────────────────────────────────────────
    @app.route("/api/health")
    def health_check():
        return {"status": "ok", "app": "KeralaSeva AI"}, 200
    @app.route("/")
    def home():
        return render_template("index.html")

    return app

import os
from flask import Flask, render_template
from flask_cors import CORS
from app.config import Config

def create_app(config_class=Config):

    base_dir = os.path.abspath(os.path.dirname(__file__))
    template_dir = os.path.join(base_dir, "templates")

    app = Flask(
        __name__,
        template_folder=template_dir,
        static_folder=None
    )

    app.config.from_object(config_class)

    CORS(app, resources={
        r"/api/*": {
            "origins": "*",
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Authorization", "Content-Type"]
        }
    })

    # 🔹 Register Blueprints
    from app.routes.auth import auth_bp
    from app.routes.profile import profile_bp
    from app.routes.scholarships import scholarships_bp
    from app.routes.admin import admin_bp
    from app.routes.alerts import alerts_bp
    from app.routes.chat import chat_bp

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(profile_bp, url_prefix="/api/profile")
    app.register_blueprint(scholarships_bp, url_prefix="/api/scholarships")
    app.register_blueprint(admin_bp, url_prefix="/api/admin")
    app.register_blueprint(alerts_bp, url_prefix="/api/alerts")
    app.register_blueprint(chat_bp, url_prefix="/api")

    @app.route("/")
    def home():
        return render_template("index.html")

    return app
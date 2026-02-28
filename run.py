"""
KeralaSeva AI – Scholarship Navigator
FILE: run.py
PURPOSE: Application entry point. Starts Flask server and APScheduler cron job.
Usage:
    python run.py
Or with gunicorn in production:
    gunicorn -w 4 -b 0.0.0.0:5000 "run:app"
"""
from flask import Flask, request, jsonify
from app.extensions import supabase_client
import os
from dotenv import load_dotenv
load_dotenv()

import atexit
import logging

from apscheduler.schedulers.background import BackgroundScheduler
from zoneinfo import ZoneInfo

from apscheduler.triggers.cron import CronTrigger

from app import create_app
from app.config import config_map

# ── Create app ─────────────────────────────────────────────────────
env = os.environ.get("FLASK_ENV", "development")
app = create_app(config_map.get(env, config_map["default"]))

# ── Logging ────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s – %(message)s"
)
logger = logging.getLogger("keralaseva")


# ── Daily Alert Cron Job ────────────────────────────────────────────
def daily_alert_task():
    """
    Runs the deadline alert job every day at 08:00 AM IST (02:30 UTC).
    Creates notifications for users whose eligible scholarships are
    approaching their deadlines.
    """
    from app.routes.alerts import run_deadline_alert_job
    logger.info("Running daily deadline alert job...")
    with app.app_context():
        result = run_deadline_alert_job()
        logger.info(
            f"Alert job done: {result['notifications_created']} notifications created "
            f"for {result['users_processed']} users. Errors: {len(result['errors'])}"
        )
        if result["errors"]:
            for err in result["errors"]:
                logger.warning(f"Alert job error: {err}")


# Start APScheduler only when not in test mode
if not app.config.get("TESTING") and os.environ.get("DISABLE_SCHEDULER") != "1":
    scheduler = BackgroundScheduler(timezone=ZoneInfo("Asia/Kolkata"))
    scheduler.add_job(
        func=daily_alert_task,
        trigger=CronTrigger(hour=8, minute=0),   # 8:00 AM IST daily
        id="daily_deadline_alerts",
        name="Daily Scholarship Deadline Alerts",
        replace_existing=True
    )
    scheduler.start()
    logger.info("✅ APScheduler started – daily alerts at 08:00 IST")

    # Gracefully shut down scheduler when app exits
    atexit.register(lambda: scheduler.shutdown())


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    debug = os.environ.get("FLASK_DEBUG", "0") == "1"
    logger.info(f"🚀 Starting KeralaSeva AI on port {port}")
    app.run(host="0.0.0.0", port=port, debug=debug, use_reloader=False)

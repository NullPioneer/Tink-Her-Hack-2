from flask import Blueprint, request, jsonify
from app.extensions import supabase_client
import requests

chat_bp = Blueprint("chat", __name__)

@chat_bp.route("/chat", methods=["POST"])
def chat():

    data = request.json
    question = data.get("message", "").strip()

    if not question:
        return jsonify({"reply": "Please ask a question."}), 400

    # 🔹 Fetch all active scholarships
    scholarships = supabase_client.table("scholarships") \
        .select("*") \
        .eq("is_active", True) \
        .execute()

    all_data_text = ""

    for s in scholarships.data or []:
        scholarship_id = s["id"]

        eligibility = supabase_client.table("eligibility") \
            .select("*") \
            .eq("scholarship_id", scholarship_id) \
            .execute()

        documents = supabase_client.table("documents_required") \
            .select("*") \
            .eq("scholarship_id", scholarship_id) \
            .execute()

        steps = supabase_client.table("application_steps") \
            .select("*") \
            .eq("scholarship_id", scholarship_id) \
            .order("step_number") \
            .execute()

        all_data_text += f"""
----------------------------------------------------
Scholarship Name: {s.get('name')}
Description: {s.get('description')}
Deadline: {s.get('deadline')}
Income Limit: {s.get('income_limit')}
Amount: {s.get('amount_min')} - {s.get('amount_max')}
Apply Here: {s.get('portal_url')}

Eligibility:
{eligibility.data}

Documents Required:
{documents.data}

Application Steps:
{steps.data}
"""

    try:
        ollama_response = requests.post(
            "http://localhost:11434/api/generate",
            json={
                "model": "llama3",
                "prompt": f"""
You are KeralaSeva AI Assistant.

You MUST answer only from the database below.
If information is not found, say:
"I could not find that information in the database."

DATABASE:
{all_data_text}

USER QUESTION:
{question}

Answer clearly and structured.
""",
                "stream": False
            }
        )

        reply_text = ollama_response.json().get("response", "Sorry, I could not answer that.")

        return jsonify({"reply": reply_text})

    except Exception as e:
        print("OLLAMA ERROR:", e)
        return jsonify({"reply": "AI service unavailable."}), 200
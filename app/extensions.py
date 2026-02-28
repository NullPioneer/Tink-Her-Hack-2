"""
KeralaSeva AI – Scholarship Navigator
FILE: app/extensions.py
PURPOSE: Initialize shared Supabase clients
  - supabase_client   : uses anon key (subject to RLS – for user-facing ops)
  - supabase_admin    : uses service role key (bypasses RLS – for server-only ops)
"""

import os
from supabase import create_client, Client

# ── Anon client: respects RLS policies ────────────────────────────
# Used when acting ON BEHALF of an authenticated user
supabase_client: Client = create_client(
    os.environ.get("SUPABASE_URL", ""),
    os.environ.get("SUPABASE_KEY", "")
)

# ── Admin client: bypasses RLS ─────────────────────────────────────
# Used ONLY for server-side operations like:
#   - Sending deadline notifications
#   - Admin writes
# NEVER expose this client to user-controlled input paths
supabase_admin: Client = create_client(
    os.environ.get("SUPABASE_URL", ""),
    os.environ.get("SUPABASE_SERVICE_KEY", "")
)
print("SERVICE KEY:", os.environ.get("SUPABASE_SERVICE_KEY"))
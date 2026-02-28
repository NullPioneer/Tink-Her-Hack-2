# KeralaSeva AI – Scholarship Navigator
## Complete Backend Documentation

---

## Folder Structure

```
keralaseva/
│
├── sql/                              # All SQL files (paste into Supabase SQL editor)
│   ├── 01_schema.sql                 # Tables, indexes, triggers
│   ├── 02_seed_data.sql              # 25 scholarships with eligibility, docs, steps
│   └── 03_matching_and_rls.sql       # Matching function + RLS policies
│
└── backend/                          # Flask application
    ├── run.py                        # Entry point + APScheduler cron job
    ├── requirements.txt
    ├── .env.example                  # Copy to .env and fill values
    │
    └── app/
        ├── __init__.py               # App factory (create_app)
        ├── config.py                 # Config from env vars
        ├── extensions.py             # Supabase client initialization
        │
        ├── middleware/
        │   ├── __init__.py
        │   └── auth.py               # @login_required, @admin_required decorators
        │
        └── routes/
            ├── __init__.py
            ├── auth.py               # /api/auth/*
            ├── profile.py            # /api/profile/*
            ├── scholarships.py       # /api/scholarships/*
            ├── admin.py              # /api/admin/* (admin only)
            └── alerts.py             # /api/alerts/* + cron job logic
```

---

## Setup Instructions

### 1. Database Setup (Supabase)

In your Supabase project → SQL Editor, run the files IN ORDER:
1. `sql/01_schema.sql` — creates all tables
2. `sql/02_seed_data.sql` — inserts all 25 scholarships
3. `sql/03_matching_and_rls.sql` — creates matching function + RLS

### 2. Backend Setup

```bash
cd backend
cp .env.example .env
# Fill in your SUPABASE_URL, SUPABASE_KEY, SUPABASE_SERVICE_KEY in .env

pip install -r requirements.txt
python run.py
```

---

## API Reference

All endpoints require `Authorization: Bearer <access_token>` unless otherwise noted.

---

### Authentication  (`/api/auth`)

| Method | Endpoint              | Auth Required | Description              |
|--------|-----------------------|---------------|--------------------------|
| POST   | `/api/auth/signup`    | No            | Register new user        |
| POST   | `/api/auth/login`     | No            | Login, get JWT           |
| POST   | `/api/auth/logout`    | No            | Invalidate session       |
| POST   | `/api/auth/reset-password` | No       | Send password reset email |

---

### Profile (`/api/profile`)

| Method | Endpoint               | Description                    |
|--------|------------------------|--------------------------------|
| GET    | `/api/profile/`        | Get own profile                |
| POST   | `/api/profile/create`  | Create profile (after signup)  |
| PUT    | `/api/profile/`        | Update own profile             |

---

### Scholarships (`/api/scholarships`)

| Method | Endpoint                                  | Description                         |
|--------|-------------------------------------------|-------------------------------------|
| GET    | `/api/scholarships/`                      | All active scholarships             |
| GET    | `/api/scholarships/matching`              | Personalized matches for user       |
| GET    | `/api/scholarships/<id>`                  | Full detail: docs, steps, eligibility |
| GET    | `/api/scholarships/notifications`         | User's deadline alerts              |
| PUT    | `/api/scholarships/notifications/<id>/read` | Mark notification as read         |

---

### Admin (`/api/admin`) — Admin Only

| Method | Endpoint                                          | Description               |
|--------|---------------------------------------------------|---------------------------|
| GET    | `/api/admin/overview`                             | Dashboard stats           |
| POST   | `/api/admin/scholarships`                         | Add scholarship           |
| PUT    | `/api/admin/scholarships/<id>`                    | Update scholarship        |
| DELETE | `/api/admin/scholarships/<id>`                    | Soft-delete scholarship   |
| POST   | `/api/admin/scholarships/<id>/eligibility`        | Add eligibility rows      |
| POST   | `/api/admin/scholarships/<id>/documents`          | Add required documents    |
| POST   | `/api/admin/scholarships/<id>/steps`              | Add application steps     |

---

### Alerts (`/api/alerts`)

| Method | Endpoint                    | Description                          |
|--------|-----------------------------|--------------------------------------|
| GET    | `/api/alerts/preferences`   | Get alert preference                 |
| PUT    | `/api/alerts/preferences`   | Set alert_before_days                |
| POST   | `/api/alerts/run-job`       | Manually trigger alert job (admin)   |

---

## Sample Request/Response JSON

### Login

**Request:**
```json
POST /api/auth/login
{
  "email": "fatima@example.com",
  "password": "MyPassword123"
}
```

**Response 200:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "f5a1bcd...",
  "user": {
    "id": "a1b2c3d4-0000-0000-0000-000000000001",
    "email": "fatima@example.com"
  }
}
```

---

### Create Profile

**Request:**
```json
POST /api/profile/create
Authorization: Bearer <token>

{
  "name": "Fatima Khan",
  "community": "Muslim",
  "gender": "Female",
  "education_level": "Degree",
  "income": 180000,
  "district": "Malappuram"
}
```

**Response 201:**
```json
{
  "message": "Profile created successfully",
  "profile": {
    "id": "a1b2c3d4-...",
    "name": "Fatima Khan",
    "community": "Muslim",
    "gender": "Female",
    "education_level": "Degree",
    "income": 180000,
    "district": "Malappuram",
    "is_admin": false
  }
}
```

---

### Get Matching Scholarships

**Request:**
```
GET /api/scholarships/matching
Authorization: Bearer <token>
```

**Response 200** (for a Muslim Female, Degree, income 180000):
```json
{
  "user_id": "a1b2c3d4-...",
  "matched_count": 7,
  "scholarships": [
    {
      "scholarship_id": "uuid-001",
      "name": "CH Muhammed Koya Scholarship",
      "description": "Scholarship for Muslim women...",
      "deadline": "2025-11-30",
      "income_limit": 200000,
      "amount_min": 5000,
      "amount_max": 12000,
      "portal_url": "https://dcescholarship.kerala.gov.in",
      "days_until_due": 45
    },
    {
      "scholarship_id": "uuid-002",
      "name": "Post Matric Scholarship for Minorities",
      "description": "Central scholarship for minority students...",
      "deadline": "2025-10-15",
      "income_limit": 200000,
      "amount_min": 7000,
      "amount_max": 12000,
      "portal_url": "https://scholarships.gov.in",
      "days_until_due": -2
    }
  ]
}
```

---

### Get Scholarship Detail

**Request:**
```
GET /api/scholarships/uuid-001
Authorization: Bearer <token>
```

**Response 200:**
```json
{
  "scholarship": {
    "id": "uuid-001",
    "name": "CH Muhammed Koya Scholarship",
    "description": "Scholarship for Muslim women...",
    "deadline": "2025-11-30",
    "income_limit": 200000,
    "amount_min": 5000,
    "amount_max": 12000,
    "portal_url": "https://dcescholarship.kerala.gov.in",
    "is_active": true,
    "created_at": "2025-01-15T00:00:00Z"
  },
  "eligibility": [
    { "id": 1, "community": "Muslim", "gender": "Female", "education_level": "PostMatric" },
    { "id": 2, "community": "Muslim", "gender": "Female", "education_level": "Degree" }
  ],
  "documents_required": [
    { "id": 1, "document_name": "Aadhaar Card" },
    { "id": 2, "document_name": "Community Certificate (Muslim)" },
    { "id": 3, "document_name": "Income Certificate from Village Officer" },
    { "id": 4, "document_name": "Previous Year Mark Sheet" },
    { "id": 5, "document_name": "Bank Passbook (First Page)" }
  ],
  "application_steps": [
    { "id": 1, "step_number": 1, "step_text": "Register on the DCE Scholarship Portal..." },
    { "id": 2, "step_number": 2, "step_text": "Log in and fill in your personal details..." },
    { "id": 3, "step_number": 3, "step_text": "Upload scanned copies of all documents..." },
    { "id": 4, "step_number": 4, "step_text": "Submit the application and note your reference number..." },
    { "id": 5, "step_number": 5, "step_text": "Visit your institution to get the application verified..." }
  ]
}
```

---

### Add Scholarship (Admin)

**Request:**
```json
POST /api/admin/scholarships
Authorization: Bearer <admin-token>

{
  "name": "New State Scholarship 2025",
  "description": "For OBC students in technical courses",
  "deadline": "2025-12-15",
  "income_limit": 300000,
  "amount_min": 8000,
  "amount_max": 15000,
  "portal_url": "https://scholarships.kerala.gov.in",
  "is_active": true
}
```

**Response 201:**
```json
{
  "message": "Scholarship created",
  "scholarship": {
    "id": "new-uuid-here",
    "name": "New State Scholarship 2025",
    ...
  }
}
```

---

## Scholarship Matching Logic Summary

The `get_matching_scholarships(user_id)` SQL function applies ALL conditions with AND:

| Filter    | Condition                                                              |
|-----------|------------------------------------------------------------------------|
| Income    | `income_limit = 0` OR `income_limit >= user.income`                   |
| Community | exact match OR `Any` OR `Minority` (when user is Muslim) OR composite |
| Gender    | exact match OR `Any`                                                   |
| Education | exact match OR `Any` OR `PostMatric` (superset of Diploma/Degree/etc) |

---

## Security Architecture

- **All user routes**: Protected by Supabase JWT validation via `@login_required`
- **Admin routes**: Double-protected by `@login_required` + `@admin_required`
- **RLS Policies**: Database-level enforcement — users cannot access other users' data even with a valid JWT
- **Service Key**: Used ONLY for server-side cron job (alert insertion). Never exposed to users
- **is_admin**: Set only by DB administrator directly. Cannot be self-assigned via API

---

## Cron Job

The APScheduler background job (`daily_alert_task`) runs automatically at **08:00 AM IST** every day.

To trigger manually (admin only):
```
POST /api/alerts/run-job
Authorization: Bearer <admin-token>
```

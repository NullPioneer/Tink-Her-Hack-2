-- ============================================================
-- KeralaSeva AI – Scholarship Navigator
-- FILE: 01_schema.sql
-- PURPOSE: Full database schema with tables, indexes, and constraints
-- Run this first in the Supabase SQL Editor
-- ============================================================

-- ----------------------------------------------------------------
-- EXTENSION: Enable UUID generation
-- ----------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ----------------------------------------------------------------
-- TABLE: profiles
-- Stores extended user info linked to Supabase Auth users
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name          TEXT NOT NULL,
    community     TEXT NOT NULL CHECK (community IN ('Muslim', 'SC', 'ST', 'SC/ST', 'OBC', 'SC/OBC', 'General', 'Minority')),
    gender        TEXT NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
    education_level TEXT NOT NULL CHECK (education_level IN (
                        'School', 'PostMatric', 'Diploma', 'Degree',
                        'PG', 'PhD', 'Professional', 'Technical', 'Engineering'
                    )),
    income        INTEGER NOT NULL DEFAULT 0 CHECK (income >= 0),
    district      TEXT NOT NULL,
    is_admin      BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- TABLE: scholarships
-- Core scholarship records
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.scholarships (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name          TEXT NOT NULL,
    description   TEXT,
    deadline      DATE,
    income_limit  INTEGER NOT NULL DEFAULT 0,   -- 0 = no income restriction
    amount_min    INTEGER NOT NULL DEFAULT 0,
    amount_max    INTEGER NOT NULL DEFAULT 0,
    portal_url    TEXT,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ----------------------------------------------------------------
-- TABLE: eligibility
-- One scholarship can have MULTIPLE eligibility rows (OR logic within table)
-- AND logic is applied across community + gender + education
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.eligibility (
    id               SERIAL PRIMARY KEY,
    scholarship_id   UUID NOT NULL REFERENCES public.scholarships(id) ON DELETE CASCADE,
    community        TEXT NOT NULL CHECK (community IN (
                         'Muslim', 'SC', 'ST', 'SC/ST', 'OBC', 'SC/OBC',
                         'Minority', 'General', 'Any'
                     )),
    gender           TEXT NOT NULL CHECK (gender IN ('Male', 'Female', 'Any')),
    education_level  TEXT NOT NULL CHECK (education_level IN (
                         'School', 'PostMatric', 'Diploma', 'Degree',
                         'PG', 'PhD', 'Professional', 'Technical', 'Engineering', 'Any'
                     ))
);

-- ----------------------------------------------------------------
-- TABLE: documents_required
-- Documents needed per scholarship
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.documents_required (
    id              SERIAL PRIMARY KEY,
    scholarship_id  UUID NOT NULL REFERENCES public.scholarships(id) ON DELETE CASCADE,
    document_name   TEXT NOT NULL
);

-- ----------------------------------------------------------------
-- TABLE: application_steps
-- Step-by-step application guidance per scholarship
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.application_steps (
    id              SERIAL PRIMARY KEY,
    scholarship_id  UUID NOT NULL REFERENCES public.scholarships(id) ON DELETE CASCADE,
    step_number     INTEGER NOT NULL,
    step_text       TEXT NOT NULL,
    UNIQUE(scholarship_id, step_number)
);

-- ----------------------------------------------------------------
-- TABLE: user_alert_preferences
-- How many days before deadline should user be alerted?
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_alert_preferences (
    user_id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    alert_before_days INTEGER NOT NULL DEFAULT 7 CHECK (alert_before_days > 0)
);

-- ----------------------------------------------------------------
-- TABLE: notifications
-- Per-user scholarship deadline and event alerts
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.notifications (
    id              SERIAL PRIMARY KEY,
    user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    scholarship_id  UUID NOT NULL REFERENCES public.scholarships(id) ON DELETE CASCADE,
    message         TEXT NOT NULL,
    is_read         BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Prevent duplicate alerts for same user+scholarship pair
    UNIQUE(user_id, scholarship_id)
);

-- ----------------------------------------------------------------
-- INDEXES: Speed up common query patterns
-- ----------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_eligibility_scholarship_id  ON public.eligibility(scholarship_id);
CREATE INDEX IF NOT EXISTS idx_eligibility_community       ON public.eligibility(community);
CREATE INDEX IF NOT EXISTS idx_eligibility_education_level ON public.eligibility(education_level);
CREATE INDEX IF NOT EXISTS idx_documents_scholarship_id    ON public.documents_required(scholarship_id);
CREATE INDEX IF NOT EXISTS idx_steps_scholarship_id        ON public.application_steps(scholarship_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id       ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read       ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_scholarships_deadline       ON public.scholarships(deadline);
CREATE INDEX IF NOT EXISTS idx_scholarships_is_active      ON public.scholarships(is_active);

-- ----------------------------------------------------------------
-- TRIGGER: Auto-update updated_at on profiles
-- ----------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- KeralaSeva AI – Scholarship Navigator
-- FILE: 03_matching_function.sql
-- PURPOSE: SQL function for personalized scholarship matching
-- ============================================================

-- ----------------------------------------------------------------
-- FUNCTION: get_matching_scholarships
-- 
-- Matching Logic:
--   Income:    income_limit = 0  OR  income_limit >= user's income
--   Community: eligibility.community = user's community
--              OR eligibility.community = 'Minority' (matches Muslim users)
--              OR eligibility.community = 'Any'
--   Gender:    eligibility.gender = user's gender
--              OR eligibility.gender = 'Any'
--   Education: eligibility.education_level = user's education_level
--              OR eligibility.education_level = 'PostMatric'
--                 (PostMatric is a catch-all for Diploma/Degree/Technical)
--              OR eligibility.education_level = 'Any'
--
--   All four conditions are AND-combined.
--   Returns DISTINCT scholarships that are currently active.
-- ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_matching_scholarships(p_user_id UUID)
RETURNS TABLE (
    scholarship_id   UUID,
    name             TEXT,
    description      TEXT,
    deadline         DATE,
    income_limit     INTEGER,
    amount_min       INTEGER,
    amount_max       INTEGER,
    portal_url       TEXT,
    days_until_due   INTEGER
) 
LANGUAGE plpgsql
SECURITY DEFINER   -- runs with function owner's privileges, not caller's
AS $$
DECLARE
    v_community       TEXT;
    v_gender          TEXT;
    v_education_level TEXT;
    v_income          INTEGER;
BEGIN
    -- Step 1: Fetch the user's profile data
    SELECT 
        p.community,
        p.gender,
        p.education_level,
        p.income
    INTO 
        v_community,
        v_gender,
        v_education_level,
        v_income
    FROM public.profiles p
    WHERE p.id = p_user_id;

    -- If no profile found, return empty
    IF NOT FOUND THEN
        RETURN;
    END IF;

    -- Step 2: Return matching scholarships
    RETURN QUERY
    SELECT DISTINCT
        s.id              AS scholarship_id,
        s.name,
        s.description,
        s.deadline,
        s.income_limit,
        s.amount_min,
        s.amount_max,
        s.portal_url,
        -- Days until deadline (negative means already past)
        CAST(s.deadline - CURRENT_DATE AS INTEGER) AS days_until_due
    FROM 
        public.scholarships s
        INNER JOIN public.eligibility e ON e.scholarship_id = s.id
    WHERE
        -- Only active scholarships
        s.is_active = TRUE

        -- ── Income Filter ──────────────────────────────────────────
        -- 0 means no income restriction; otherwise must be >= user income
        AND (s.income_limit = 0 OR s.income_limit >= v_income)

        -- ── Community Filter ───────────────────────────────────────
        -- Direct match, OR the scholarship is open to 'Any', OR
        -- if user is Muslim it also matches generic 'Minority' eligibility
        AND (
            e.community = v_community
            OR e.community = 'Any'
            OR (v_community = 'Muslim' AND e.community = 'Minority')
            -- SC/ST composite community: match individual SC or ST rows too
            OR (v_community = 'SC/ST' AND e.community IN ('SC', 'ST'))
            OR (v_community = 'SC'   AND e.community = 'SC/OBC')
            OR (v_community = 'OBC'  AND e.community = 'SC/OBC')
        )

        -- ── Gender Filter ──────────────────────────────────────────
        AND (
            e.gender = v_gender
            OR e.gender = 'Any'
        )

        -- ── Education Filter ────────────────────────────────────────
        -- Direct match, OR the scholarship uses 'PostMatric' (wildcard for
        -- Diploma, Degree, Technical, Engineering, Professional which are
        -- all post-10th qualifications), OR 'Any' wildcard
        AND (
            e.education_level = v_education_level
            OR e.education_level = 'Any'
            OR (
                e.education_level = 'PostMatric'
                AND v_education_level IN ('PostMatric','Diploma','Degree','PG','PhD','Technical','Engineering','Professional')
            )
        )

    ORDER BY
        -- Scholarships with upcoming deadlines first (soonest at top)
        CASE WHEN s.deadline IS NOT NULL AND s.deadline >= CURRENT_DATE
             THEN s.deadline
             ELSE '9999-12-31'::DATE
        END ASC,
        s.name ASC;

END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.get_matching_scholarships(UUID) TO authenticated;


-- ================================================================
-- FILE: 04_rls_policies.sql
-- PURPOSE: Row Level Security policies for all tables
-- ================================================================

-- ----------------------------------------------------------------
-- Enable RLS on all public-facing tables
-- ----------------------------------------------------------------
ALTER TABLE public.profiles            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scholarships        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eligibility         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents_required  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.application_steps   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_alert_preferences ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------
-- POLICIES: profiles table
-- ----------------------------------------------------------------

-- Users can read their OWN profile only
CREATE POLICY "profiles_select_own"
ON public.profiles
FOR SELECT
USING (auth.uid() = id);

-- Users can insert their OWN profile (registration)
CREATE POLICY "profiles_insert_own"
ON public.profiles
FOR INSERT
WITH CHECK (auth.uid() = id);

-- Users can update their OWN profile
CREATE POLICY "profiles_update_own"
ON public.profiles
FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Admins can read all profiles
CREATE POLICY "profiles_admin_select_all"
ON public.profiles
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.profiles p
        WHERE p.id = auth.uid() AND p.is_admin = TRUE
    )
);

-- ----------------------------------------------------------------
-- POLICIES: scholarships table
-- ----------------------------------------------------------------

-- All authenticated users can VIEW scholarships
CREATE POLICY "scholarships_select_authenticated"
ON public.scholarships
FOR SELECT
TO authenticated
USING (TRUE);

-- Only admins can INSERT scholarships
CREATE POLICY "scholarships_insert_admin_only"
ON public.scholarships
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.profiles p
        WHERE p.id = auth.uid() AND p.is_admin = TRUE
    )
);

-- Only admins can UPDATE scholarships
CREATE POLICY "scholarships_update_admin_only"
ON public.scholarships
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.profiles p
        WHERE p.id = auth.uid() AND p.is_admin = TRUE
    )
);

-- Only admins can DELETE scholarships
CREATE POLICY "scholarships_delete_admin_only"
ON public.scholarships
FOR DELETE
USING (
    EXISTS (
        SELECT 1 FROM public.profiles p
        WHERE p.id = auth.uid() AND p.is_admin = TRUE
    )
);

-- ----------------------------------------------------------------
-- POLICIES: eligibility table (same as scholarships)
-- ----------------------------------------------------------------

CREATE POLICY "eligibility_select_authenticated"
ON public.eligibility FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY "eligibility_insert_admin_only"
ON public.eligibility FOR INSERT
WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.is_admin = TRUE)
);

CREATE POLICY "eligibility_update_admin_only"
ON public.eligibility FOR UPDATE
USING (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.is_admin = TRUE)
);

-- ----------------------------------------------------------------
-- POLICIES: documents_required table
-- ----------------------------------------------------------------

CREATE POLICY "documents_select_authenticated"
ON public.documents_required FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY "documents_insert_admin_only"
ON public.documents_required FOR INSERT
WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.is_admin = TRUE)
);

-- ----------------------------------------------------------------
-- POLICIES: application_steps table
-- ----------------------------------------------------------------

CREATE POLICY "steps_select_authenticated"
ON public.application_steps FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY "steps_insert_admin_only"
ON public.application_steps FOR INSERT
WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.is_admin = TRUE)
);

-- ----------------------------------------------------------------
-- POLICIES: notifications table
-- ----------------------------------------------------------------

-- Users can only see THEIR OWN notifications
CREATE POLICY "notifications_select_own"
ON public.notifications
FOR SELECT
USING (auth.uid() = user_id);

-- Users can mark their own notifications as read
CREATE POLICY "notifications_update_own"
ON public.notifications
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Only the backend service role can INSERT notifications (via alert job)
-- The Flask backend uses the service role key, not user JWT
CREATE POLICY "notifications_insert_service_role"
ON public.notifications
FOR INSERT
TO service_role
WITH CHECK (TRUE);

-- ----------------------------------------------------------------
-- POLICIES: user_alert_preferences table
-- ----------------------------------------------------------------

CREATE POLICY "alert_prefs_select_own"
ON public.user_alert_preferences
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "alert_prefs_insert_own"
ON public.user_alert_preferences
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "alert_prefs_update_own"
ON public.user_alert_preferences
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

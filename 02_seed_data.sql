-- ============================================================
-- KeralaSeva AI – Scholarship Navigator
-- FILE: 02_seed_data.sql
-- PURPOSE: Insert all 25 scholarships with eligibility, documents, and steps
-- ============================================================

-- ----------------------------------------------------------------
-- HELPER: We use DO blocks to capture UUIDs and insert related rows
-- ----------------------------------------------------------------

-- ================================================================
-- SECTION 1: MINORITY CATEGORY
-- ================================================================

-- ----------------------------------------------------------------
-- 1. CH Muhammed Koya Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'CH Muhammed Koya Scholarship',
            'Scholarship for Muslim women pursuing PostMatric and Degree level education in Kerala, administered by the Minority Welfare Department.',
            '2025-11-30', 200000, 5000, 12000,
            'https://dcescholarship.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Muslim', 'Female', 'PostMatric'),
        (v_id, 'Muslim', 'Female', 'Degree');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Community Certificate (Muslim)'),
        (v_id, 'Income Certificate from Village Officer'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Institution Bonafide Certificate'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Register on the DCE Scholarship Portal at dcescholarship.kerala.gov.in using your mobile number and email.'),
        (v_id, 2, 'Log in and fill in your personal details, education details, and bank account information accurately.'),
        (v_id, 3, 'Upload scanned copies of all required documents (Aadhaar, community certificate, income certificate, mark sheets).'),
        (v_id, 4, 'Submit the application and note your application reference number for future tracking.'),
        (v_id, 5, 'Visit your institution''s office to get the application verified and forwarded to the district office before the deadline.');
END $$;

-- ----------------------------------------------------------------
-- 2. APJ Abdul Kalam Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'APJ Abdul Kalam Scholarship',
            'Scholarship for Minority community students pursuing Diploma courses, encouraging technical education among minority youth.',
            '2025-10-31', 200000, 6000, 10000,
            'https://minority.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Minority', 'Any', 'Diploma'),
        (v_id, 'Muslim',   'Any', 'Diploma');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Minority/Community Certificate'),
        (v_id, 'Income Certificate from Village Officer'),
        (v_id, 'Diploma Admission Letter or Student ID'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Visit the Kerala Minority Welfare Department portal and create a new applicant account.'),
        (v_id, 2, 'Complete the online application form with personal, academic, and family income details.'),
        (v_id, 3, 'Upload all required documents ensuring file size is within the specified limit (usually 200KB per file).'),
        (v_id, 4, 'Submit the form online. Print a copy of the submitted application for your records.'),
        (v_id, 5, 'Take the printout to your institution for principal verification and forward it to the district minority office.');
END $$;

-- ----------------------------------------------------------------
-- 3. Merit-cum-Means (Minority) – Professional/Engineering
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Merit-cum-Means Scholarship (Minority)',
            'Central government scholarship for minority students in professional and engineering courses. Covers course fees and maintenance allowance.',
            '2025-09-30', 250000, 20000, 30000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Minority', 'Any', 'Professional'),
        (v_id, 'Minority', 'Any', 'Engineering'),
        (v_id, 'Muslim',   'Any', 'Engineering'),
        (v_id, 'Muslim',   'Any', 'Degree');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Minority Community Certificate'),
        (v_id, 'Income Certificate (less than 2.5 lakh per annum)'),
        (v_id, 'Previous Year Academic Mark Sheet'),
        (v_id, 'Fee Receipt from Institution'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Register on the National Scholarship Portal (NSP) at scholarships.gov.in using your mobile number.'),
        (v_id, 2, 'Fill in the Merit-cum-Means application form with course, institute, income, and bank details.'),
        (v_id, 3, 'Upload required documents: minority certificate, income certificate, mark sheet, and fee receipt.'),
        (v_id, 4, 'Submit the application. The institute nodal officer will verify and forward the application online.'),
        (v_id, 5, 'Track application status on NSP dashboard. Approved funds are directly transferred to your bank account.');
END $$;

-- ----------------------------------------------------------------
-- 4. Post Matric Minority Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Post Matric Scholarship for Minorities',
            'Central scholarship scheme for minority students studying at Post Matric level (Class 11 onwards) to provide financial assistance for education.',
            '2025-10-15', 200000, 7000, 12000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Minority', 'Any', 'PostMatric'),
        (v_id, 'Muslim',   'Any', 'PostMatric'),
        (v_id, 'Minority', 'Any', 'Diploma'),
        (v_id, 'Minority', 'Any', 'Degree');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Minority Certificate'),
        (v_id, 'Income Certificate'),
        (v_id, 'Class 10 or Last Exam Mark Sheet'),
        (v_id, 'Admission Letter from Current Institution'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Visit the National Scholarship Portal (NSP) and register as a new student applicant.'),
        (v_id, 2, 'Select "Post Matric Scholarship for Minorities" from the available schemes and fill the form.'),
        (v_id, 3, 'Provide your institution details, course information, and upload all necessary documents.'),
        (v_id, 4, 'Submit the application and verify it with your institution''s designated nodal officer.'),
        (v_id, 5, 'Monitor the application status on NSP. Amount is disbursed directly to your bank account upon approval.');
END $$;

-- ----------------------------------------------------------------
-- 5. Pre-Matric Minority Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Pre-Matric Scholarship for Minorities',
            'Scholarship for minority students in Class 1 to Class 10 to prevent dropout and encourage school education.',
            '2025-09-15', 100000, 1000, 10000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Minority', 'Any', 'School'),
        (v_id, 'Muslim',   'Any', 'School');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card of Student'),
        (v_id, 'Parent/Guardian Aadhaar Card'),
        (v_id, 'Minority Certificate'),
        (v_id, 'Income Certificate from Village Officer'),
        (v_id, 'Previous Year Report Card / Mark Sheet'),
        (v_id, 'Bank Passbook in Student Name or Joint Account'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Parent or guardian should register on NSP portal on behalf of the student using their mobile number.'),
        (v_id, 2, 'Select the Pre-Matric Minority Scholarship scheme and fill student and family income details.'),
        (v_id, 3, 'Upload required documents including minority certificate, income proof, and report card.'),
        (v_id, 4, 'Submit the application. The school headmaster must verify and forward the application on NSP.'),
        (v_id, 5, 'Scholarship amount is transferred to the student''s bank account after government approval.');
END $$;

-- ----------------------------------------------------------------
-- 6. Maulana Azad National Fellowship (PhD – Minority)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Maulana Azad National Fellowship',
            'UGC fellowship for minority students pursuing M.Phil or PhD. Provides JRF and SRF fellowship amounts for research scholars.',
            '2025-12-31', 600000, 31000, 35000,
            'https://manf.ugc.ac.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Minority', 'Any', 'PhD'),
        (v_id, 'Muslim',   'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Minority Community Certificate'),
        (v_id, 'Income Certificate (family income below 6 lakh)'),
        (v_id, 'UGC NET/JRF Scorecard'),
        (v_id, 'PhD Enrollment Letter from University'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Research Proposal Summary');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Qualify UGC NET/JRF examination. Only NET/JRF qualified candidates are eligible.'),
        (v_id, 2, 'Register on the UGC MANF portal at manf.ugc.ac.in when the annual application window opens.'),
        (v_id, 3, 'Fill the detailed application form with PhD enrollment details, supervisor info, and research area.'),
        (v_id, 4, 'Upload all documents and get application countersigned by your Research Supervisor and University.'),
        (v_id, 5, 'Track status on UGC portal. Fellowship is paid monthly to your bank account after award letter.');
END $$;

-- ================================================================
-- SECTION 2: SC/ST CATEGORY
-- ================================================================

-- ----------------------------------------------------------------
-- 7. Post Matric Scholarship (SC/ST)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Post Matric Scholarship for SC/ST Students',
            'Central government scholarship for SC/ST students studying at post matric level. Covers maintenance allowance and other charges.',
            '2025-10-31', 250000, 7000, 14000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC',    'Any', 'PostMatric'),
        (v_id, 'ST',    'Any', 'PostMatric'),
        (v_id, 'SC/ST', 'Any', 'PostMatric'),
        (v_id, 'SC',    'Any', 'Diploma'),
        (v_id, 'SC',    'Any', 'Degree');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'SC/ST Caste Certificate from Tahsildar'),
        (v_id, 'Income Certificate from Village Officer'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Fee Receipt from Institution'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Register on NSP portal or Kerala SC/ST Development Department portal with valid credentials.'),
        (v_id, 2, 'Select Post Matric Scholarship for SC/ST and enter your personal, caste, and education details.'),
        (v_id, 3, 'Upload caste certificate, income certificate, mark sheets, and fee receipt as required.'),
        (v_id, 4, 'Submit application and get it verified at institution level by the designated nodal officer.'),
        (v_id, 5, 'Scholarship amount is transferred to linked bank account upon district-level approval.');
END $$;

-- ----------------------------------------------------------------
-- 8. Pre-Matric SC/ST Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Pre-Matric Scholarship for SC/ST Students',
            'Scholarship for SC/ST students studying in Class 9 and 10 to support education and reduce dropout rates.',
            '2025-09-30', 200000, 3500, 7000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC',    'Any', 'School'),
        (v_id, 'ST',    'Any', 'School'),
        (v_id, 'SC/ST', 'Any', 'School');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card of Student'),
        (v_id, 'SC/ST Caste Certificate'),
        (v_id, 'Income Certificate from Village Officer'),
        (v_id, 'Previous Class Report Card'),
        (v_id, 'School Enrollment Certificate'),
        (v_id, 'Bank Passbook (Joint Account with Parent)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Parent or guardian registers on the NSP portal and selects the appropriate scholarship scheme.'),
        (v_id, 2, 'Fill in student details, class enrollment, and parental income information accurately.'),
        (v_id, 3, 'Upload caste certificate, income proof, and recent report card with school seal.'),
        (v_id, 4, 'Submit and get the application verified by the school headmaster on the portal.'),
        (v_id, 5, 'Scholarship disbursed to student bank account after approval. Status trackable via NSP dashboard.');
END $$;

-- ----------------------------------------------------------------
-- 9. Rajiv Gandhi National Fellowship (SC/ST PhD)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Rajiv Gandhi National Fellowship (SC/ST)',
            'UGC fellowship for SC/ST students undertaking M.Phil or PhD programmes. Provides JRF and SRF level financial assistance.',
            '2025-11-30', 600000, 31000, 35000,
            'https://rgnf.ucanwest.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC',    'Any', 'PhD'),
        (v_id, 'ST',    'Any', 'PhD'),
        (v_id, 'SC/ST', 'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'SC/ST Caste Certificate'),
        (v_id, 'Income Certificate'),
        (v_id, 'PhD Registration Letter from University'),
        (v_id, 'Supervisor Consent Letter'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Research Area Statement / Synopsis');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Check eligibility: must be registered for PhD/M.Phil in a recognized university.'),
        (v_id, 2, 'Register on the RGNF portal when the annual application window is announced by UGC.'),
        (v_id, 3, 'Fill application with PhD details, supervisor name, department, and funding history.'),
        (v_id, 4, 'Upload all documents and get them attested by the Research Supervisor and Registrar.'),
        (v_id, 5, 'Await selection list on RGNF portal. Fellowship paid monthly to registered bank account.');
END $$;

-- ----------------------------------------------------------------
-- 10. Top Class Education Scheme (SC – Degree)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Top Class Education Scheme for SC Students',
            'Scholarship for SC students admitted to top institutions in India (IITs, NITs, AIIMS, etc.) for full course fee reimbursement and living allowance.',
            '2025-10-15', 800000, 40000, 120000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC', 'Any', 'Degree'),
        (v_id, 'SC', 'Any', 'Professional'),
        (v_id, 'SC', 'Any', 'Engineering');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'SC Caste Certificate from Tahsildar'),
        (v_id, 'Income Certificate (family income below 8 lakh)'),
        (v_id, 'Admission Letter from Notified Top Institution'),
        (v_id, 'Fee Receipt / Demand Letter from Institution'),
        (v_id, 'Previous Year Mark Sheet with good academic record'),
        (v_id, 'Bank Passbook (First Page)');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Confirm that your institution is on the Ministry''s notified list of Top Class Institutions.'),
        (v_id, 2, 'Register on NSP and select Top Class Education Scheme from the Central Schemes section.'),
        (v_id, 3, 'Enter admission details, course fees, and upload income and caste certificates.'),
        (v_id, 4, 'Institute nodal officer verifies your enrollment and forwards the application on NSP.'),
        (v_id, 5, 'Ministry of Social Justice and Empowerment releases scholarship directly to your bank account.');
END $$;

-- ----------------------------------------------------------------
-- 11. E-Grantz Kerala (SC/ST/OBC PostMatric + Technical)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'E-Grantz Scholarship (Kerala)',
            'State government scholarship for SC/ST/OBC students in Kerala pursuing PostMatric and Technical courses. Applied through Kerala''s E-Grantz portal.',
            '2025-11-15', 250000, 6000, 15000,
            'https://egrantz.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC',    'Any', 'PostMatric'),
        (v_id, 'ST',    'Any', 'PostMatric'),
        (v_id, 'SC/ST', 'Any', 'PostMatric'),
        (v_id, 'OBC',   'Any', 'PostMatric'),
        (v_id, 'SC',    'Any', 'Technical'),
        (v_id, 'OBC',   'Any', 'Technical'),
        (v_id, 'SC',    'Any', 'Diploma'),
        (v_id, 'OBC',   'Any', 'Diploma');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Caste Certificate from Tahsildar'),
        (v_id, 'Non-Creamy Layer Certificate (for OBC)'),
        (v_id, 'Income Certificate'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Fee Receipt from Institution'),
        (v_id, 'Bank Passbook linked to Aadhaar');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Visit the Kerala E-Grantz portal at egrantz.kerala.gov.in and register with your Aadhaar number.'),
        (v_id, 2, 'Select the appropriate scheme (SC/ST or OBC) and fill in personal and academic details.'),
        (v_id, 3, 'Upload required documents: caste certificate, income certificate, mark sheet, and fee receipt.'),
        (v_id, 4, 'Submit the online application. The institution must verify enrollment on the portal.'),
        (v_id, 5, 'Amount is disbursed directly to your Aadhaar-linked bank account via PFMS after approval.');
END $$;

-- ----------------------------------------------------------------
-- 12. Overseas Scholarship (SC/ST Kerala – PG/PhD)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Overseas Scholarship for SC/ST (Kerala)',
            'Scholarship for SC/ST students from Kerala to pursue PG or PhD studies abroad in top ranked foreign universities.',
            '2025-01-31', 800000, 100000, 500000,
            'https://welfarescholarships.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC',    'Any', 'PG'),
        (v_id, 'ST',    'Any', 'PG'),
        (v_id, 'SC/ST', 'Any', 'PG'),
        (v_id, 'SC',    'Any', 'PhD'),
        (v_id, 'ST',    'Any', 'PhD'),
        (v_id, 'SC/ST', 'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'SC/ST Caste Certificate'),
        (v_id, 'Income Certificate (family income below 8 lakh)'),
        (v_id, 'Offer Letter from Foreign University'),
        (v_id, 'Valid Passport Copy'),
        (v_id, 'Academic Transcripts (All degrees)'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Research Proposal or Statement of Purpose');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Secure admission to a recognized foreign university and obtain the official offer/admission letter.'),
        (v_id, 2, 'Apply through the Kerala SC/ST Welfare Department portal with all required documents.'),
        (v_id, 3, 'Submit your Statement of Purpose, university ranking details, and course structure information.'),
        (v_id, 4, 'Appear for departmental interview/selection process if called by the Welfare Department.'),
        (v_id, 5, 'Upon selection, scholarship is released in installments: pre-departure grant and annual maintenance.');
END $$;

-- ================================================================
-- SECTION 3: OBC CATEGORY
-- ================================================================

-- ----------------------------------------------------------------
-- 13. Post Matric OBC Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Post Matric Scholarship for OBC Students',
            'Central scheme for OBC students at post matric level providing maintenance allowance and study expenses.',
            '2025-10-31', 250000, 5000, 12000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'OBC', 'Any', 'PostMatric'),
        (v_id, 'OBC', 'Any', 'Diploma'),
        (v_id, 'OBC', 'Any', 'Degree');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'OBC Non-Creamy Layer Certificate'),
        (v_id, 'Income Certificate (below 2.5 lakh per annum)'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Current Year Fee Receipt'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Register on NSP portal with your mobile number and email ID. OBC students must select the correct Central scheme.'),
        (v_id, 2, 'Fill in Post Matric OBC application form with caste, income, and academic details.'),
        (v_id, 3, 'Upload OBC Non-Creamy Layer certificate, income proof, and current year fee structure.'),
        (v_id, 4, 'Submit and route through institution nodal officer for verification and forwarding.'),
        (v_id, 5, 'Scholarship credited directly to bank account upon state government''s final approval.');
END $$;

-- ----------------------------------------------------------------
-- 14. OBC Pre-Matric Scholarship
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Pre-Matric Scholarship for OBC Students',
            'Financial support for OBC students in Classes 1 to 10 to ensure school education completion and reduce dropout.',
            '2025-09-30', 100000, 1500, 5000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'OBC', 'Any', 'School');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card of Student'),
        (v_id, 'OBC Non-Creamy Layer Certificate'),
        (v_id, 'Income Certificate from Village Officer'),
        (v_id, 'Previous Year Report Card'),
        (v_id, 'School Enrollment Certificate'),
        (v_id, 'Bank Passbook (Joint Account with Parent)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Parent or guardian applies on NSP on behalf of student. Select OBC Pre-Matric scheme.'),
        (v_id, 2, 'Enter school details, class, admission number, and parental occupation and income details.'),
        (v_id, 3, 'Upload OBC certificate, income certificate, and latest report card.'),
        (v_id, 4, 'School headmaster verifies the application on NSP before submission deadline.'),
        (v_id, 5, 'Scholarship disbursed to student or joint account after district education officer approval.');
END $$;

-- ----------------------------------------------------------------
-- 15. Central OBC Scholarship Scheme (Degree)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Central Sector OBC Scholarship Scheme',
            'Scholarship for meritorious OBC students in Degree programmes to cover educational expenses and encourage higher education.',
            '2025-11-15', 800000, 10000, 20000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'OBC', 'Any', 'Degree'),
        (v_id, 'OBC', 'Any', 'Engineering'),
        (v_id, 'OBC', 'Any', 'Professional');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'OBC Certificate (Central List)'),
        (v_id, 'Income Certificate (below 8 lakh per annum)'),
        (v_id, 'Class 12 Mark Sheet showing 80%+ in board exam'),
        (v_id, 'Admission Letter for Degree Course'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Confirm eligibility: must have scored 80%+ in Class 12 Board and belong to Central List OBC.'),
        (v_id, 2, 'Apply on NSP portal selecting Central OBC Scholarship. Complete all form sections carefully.'),
        (v_id, 3, 'Upload OBC certificate (Central List), income proof, Class 12 mark sheet, and admission letter.'),
        (v_id, 4, 'Institution verifies enrollment and forwards the application to state nodal department.'),
        (v_id, 5, 'Scholarship processed and disbursed by Ministry of Social Justice to your bank account.');
END $$;

-- ----------------------------------------------------------------
-- 16. E-Grantz OBC (Technical/PostMatric)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'E-Grantz OBC Scholarship (Kerala)',
            'Kerala state scholarship for OBC students in technical and post matric programmes, disbursed via the E-Grantz portal.',
            '2025-11-15', 250000, 5000, 12000,
            'https://egrantz.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'OBC', 'Any', 'Technical'),
        (v_id, 'OBC', 'Any', 'PostMatric'),
        (v_id, 'OBC', 'Any', 'Diploma'),
        (v_id, 'OBC', 'Any', 'Engineering');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'OBC Non-Creamy Layer Certificate'),
        (v_id, 'Income Certificate'),
        (v_id, 'Admission / Enrollment Certificate'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Bank Passbook linked to Aadhaar'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Visit E-Grantz Kerala portal and register using your Aadhaar number and mobile OTP.'),
        (v_id, 2, 'Select the OBC scholarship category and fill in institution details, course, and income details.'),
        (v_id, 3, 'Upload Non-Creamy Layer certificate, income certificate, and admission documents.'),
        (v_id, 4, 'Institution verifies enrollment on the portal. Ensure verification before deadline.'),
        (v_id, 5, 'Scholarship disbursed via PFMS to your Aadhaar-linked bank account.');
END $$;

-- ----------------------------------------------------------------
-- 17. Dr. Ambedkar Centrally Sponsored Scheme (SC/OBC – Degree/PG)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Dr. Ambedkar Centrally Sponsored Scheme (OBC/SC)',
            'Scholarship for SC and OBC students pursuing Degree and PG level education to provide interest subsidy on education loans and direct financial support.',
            '2025-10-31', 800000, 15000, 35000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'SC',    'Any', 'Degree'),
        (v_id, 'SC',    'Any', 'PG'),
        (v_id, 'OBC',   'Any', 'Degree'),
        (v_id, 'OBC',   'Any', 'PG'),
        (v_id, 'SC/OBC','Any', 'Degree'),
        (v_id, 'SC/OBC','Any', 'PG');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'SC or OBC Caste Certificate'),
        (v_id, 'Income Certificate (family income below 8 lakh)'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Admission Letter for Degree/PG Course'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Ensure you belong to SC or OBC category and are enrolled in a Degree or PG course.'),
        (v_id, 2, 'Apply via NSP portal. Select the Dr. Ambedkar Centrally Sponsored Scheme from the list.'),
        (v_id, 3, 'Fill application form and upload caste certificate, income proof, and enrollment details.'),
        (v_id, 4, 'Get application forwarded by institution nodal officer within the portal deadline.'),
        (v_id, 5, 'Financial support released to bank account by Ministry of Social Justice post verification.');
END $$;

-- ================================================================
-- SECTION 4: FEMALE SPECIFIC
-- ================================================================

-- ----------------------------------------------------------------
-- 18. AICTE Pragati Scholarship (Female – Diploma/Degree)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'AICTE Pragati Scholarship for Girls',
            'AICTE scholarship exclusively for girl students in AICTE-approved Diploma and Degree technical programmes. Covers tuition fees and incidentals.',
            '2025-10-31', 800000, 30000, 50000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Female', 'Diploma'),
        (v_id, 'Any', 'Female', 'Degree'),
        (v_id, 'Any', 'Female', 'Engineering');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Income Certificate (family income below 8 lakh)'),
        (v_id, 'Admission Letter from AICTE-approved Institution'),
        (v_id, 'Previous Year Mark Sheet with good academic record'),
        (v_id, 'Fee Receipt or Demand Letter'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Confirm that your institution is AICTE-approved. Only AICTE-approved courses are eligible.'),
        (v_id, 2, 'Register on NSP and select AICTE Pragati Scholarship. Only girl students can apply.'),
        (v_id, 3, 'Fill the form with institution code, course, semester, income details, and bank information.'),
        (v_id, 4, 'Upload income certificate, fee receipt, and previous year mark sheet.'),
        (v_id, 5, 'Institution verifies via NSP. Scholarship of Rs 30,000 + Rs 20,000 released per academic year.');
END $$;

-- ----------------------------------------------------------------
-- 19. UGC Single Girl Child Scholarship (Female – PG)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'UGC Single Girl Child Scholarship (PG)',
            'UGC scholarship for single girl child pursuing Post Graduate studies in any discipline from UGC-recognised universities.',
            '2025-09-30', 800000, 10000, 36200,
            'https://scholarships.ugc.ac.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Female', 'PG');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Affidavit confirming you are the only child of your parents'),
        (v_id, 'Income Certificate'),
        (v_id, 'PG Admission Letter from UGC-recognised University'),
        (v_id, 'UG Final Year Mark Sheet'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Confirm you are the single girl child of your parents. An affidavit is required as proof.'),
        (v_id, 2, 'Apply via UGC scholarship portal or NSP. Select the Single Girl Child PG Scholarship.'),
        (v_id, 3, 'Fill in university, department, course details and upload the parent affidavit and academic documents.'),
        (v_id, 4, 'University Dean / Registrar must countersign and verify the application on the portal.'),
        (v_id, 5, 'UGC releases Rs 36,200 per year as monthly stipend to your bank account upon renewal.');
END $$;

-- ----------------------------------------------------------------
-- 20. CBSE Single Girl Child Scholarship (Female – School)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'CBSE Merit Scholarship for Single Girl Child',
            'Scholarship for meritorious single girl child studying in Class 11 and 12 in CBSE-affiliated schools.',
            '2025-09-15', 800000, 500, 1500,
            'https://cbse.nic.in/scholarships', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Female', 'School');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card of Student'),
        (v_id, 'Affidavit from Parent confirming single girl child status'),
        (v_id, 'Class 10 CBSE Mark Sheet with 60%+ marks'),
        (v_id, 'School Enrollment Certificate for Class 11/12'),
        (v_id, 'Bank Passbook in Student Name'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Confirm you are a single girl child studying in Class 11 or 12 in a CBSE-affiliated school.'),
        (v_id, 2, 'Apply online on the CBSE scholarship portal. The school''s principal initiates the application.'),
        (v_id, 3, 'Submit parent affidavit, Class 10 mark sheet, and current enrollment proof through the school.'),
        (v_id, 4, 'CBSE verifies eligibility based on Class 10 board examination marks and school affiliation.'),
        (v_id, 5, 'Monthly stipend of Rs 500 per month credited for 2 years (Class 11 and 12) to bank account.');
END $$;

-- ----------------------------------------------------------------
-- 21. Mother Teresa Scholarship (Female – Professional)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Mother Teresa Scholarship for Women',
            'State level scholarship for women from economically backward families pursuing professional courses (MBBS, BDS, Law, Engineering, etc.) in Kerala.',
            '2025-11-30', 300000, 10000, 25000,
            'https://minority.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Female', 'Professional'),
        (v_id, 'Any', 'Female', 'Engineering'),
        (v_id, 'Any', 'Female', 'Degree');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'Income Certificate from Village Officer (below 3 lakh)'),
        (v_id, 'Admission Letter for Professional Course'),
        (v_id, 'Previous Year Mark Sheet'),
        (v_id, 'Fee Receipt from Institution'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Passport Size Photograph');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Register on Kerala''s minority welfare portal and navigate to the Mother Teresa Scholarship section.'),
        (v_id, 2, 'Fill the application form with personal, academic, and income details. Upload photograph.'),
        (v_id, 3, 'Upload income certificate, admission letter, and fee receipt. Ensure all docs are clear scans.'),
        (v_id, 4, 'Submit online. Printout the application and submit to the District Minority Welfare Office.'),
        (v_id, 5, 'District collector''s office verifies and releases scholarship to bank account post committee approval.');
END $$;

-- ================================================================
-- SECTION 5: RESEARCH / PhD
-- ================================================================

-- ----------------------------------------------------------------
-- 22. CM Research Fellowship (PhD – No income restriction)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'Chief Minister''s Research Fellowship (Kerala)',
            'Kerala government fellowship for outstanding PhD scholars in Kerala universities to promote research and innovation.',
            '2025-06-30', 0, 25000, 35000,
            'https://kscste.kerala.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'PhD Registration Certificate from Kerala University'),
        (v_id, 'Research Proposal (5-10 pages)'),
        (v_id, 'Supervisor Recommendation Letter'),
        (v_id, 'Academic Certificates (All Degrees)'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Publications List (if any)');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Ensure you are a full-time PhD scholar registered in a Kerala state university.'),
        (v_id, 2, 'Apply via KSCSTE portal with your PhD registration details and research proposal.'),
        (v_id, 3, 'Submit research proposal, supervisor letter, and all academic certificates online.'),
        (v_id, 4, 'KSCSTE expert committee evaluates the research proposal. Shortlisted candidates may be called for interview.'),
        (v_id, 5, 'Selected scholars receive monthly fellowship for up to 3 years. Renewable annually based on progress.');
END $$;

-- ----------------------------------------------------------------
-- 23. UGC JRF Fellowship (PhD – No income restriction)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'UGC Junior Research Fellowship (JRF)',
            'Prestigious national fellowship for pursuing PhD in humanities, social sciences, and sciences. Awarded to NET-JRF qualified candidates.',
            '2025-09-30', 0, 31000, 35000,
            'https://ugcnet.nta.nic.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'UGC NET JRF Result Letter / E-Certificate'),
        (v_id, 'PhD Enrollment Letter from University'),
        (v_id, 'Research Supervisor Assignment Letter'),
        (v_id, 'PG Mark Sheet and Degree Certificate'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Caste Certificate (for reservation category, if applicable)');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Qualify UGC NET examination and secure JRF rank. JRF award letter is valid for 3 years.'),
        (v_id, 2, 'Get enrolled as a full-time PhD student in a recognized university within the JRF validity period.'),
        (v_id, 3, 'Submit JRF joining report through your university to UGC within 30 days of PhD enrollment.'),
        (v_id, 4, 'University forwards the joining intimation to UGC. Fellowship starts from date of enrollment.'),
        (v_id, 5, 'Fellowship of Rs 31,000/month (JRF) and Rs 35,000/month (SRF from 3rd year) paid through university.');
END $$;

-- ----------------------------------------------------------------
-- 24. CSIR Fellowship (PhD – Science)
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'CSIR Junior Research Fellowship',
            'Fellowship for PhD researchers in Science disciplines (Life Sciences, Physical Sciences, Chemical Sciences, Earth Sciences, Engineering Sciences).',
            '2025-09-30', 0, 31000, 35000,
            'https://csirhrdg.res.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'Any', 'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'CSIR-UGC NET JRF Result Certificate'),
        (v_id, 'PhD Enrollment Letter'),
        (v_id, 'Supervisor and Institute Acceptance Letter'),
        (v_id, 'BSc and MSc Mark Sheets and Degree Certificates'),
        (v_id, 'Bank Passbook (First Page)'),
        (v_id, 'Caste Certificate (if applicable)');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Qualify the CSIR-UGC NET examination in one of the five science streams. JRF cutoff must be met.'),
        (v_id, 2, 'Secure admission to a PhD programme in a CSIR lab or recognized university.'),
        (v_id, 3, 'Submit JRF joining report to CSIR-HRDG within 2 years of the NET result date.'),
        (v_id, 4, 'CSIR verifies enrollment and research area suitability. Fellowship activated upon confirmation.'),
        (v_id, 5, 'Fellowship of Rs 31,000/month (JRF 2 years) and Rs 35,000/month (SRF) paid via CSIR institute.');
END $$;

-- ----------------------------------------------------------------
-- 25. National Fellowship for Higher Education (SC – PhD/PG overlap)
--     Adding this as a bonus to ensure SC + PG pathway coverage
-- ----------------------------------------------------------------
DO $$
DECLARE v_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.scholarships (id, name, description, deadline, income_limit, amount_min, amount_max, portal_url, is_active)
    VALUES (v_id,
            'National Fellowship for Higher Education of ST Students',
            'Ministry of Tribal Affairs fellowship for ST students to pursue M.Phil and PhD in universities/institutions recognised by UGC.',
            '2025-11-15', 600000, 31000, 35000,
            'https://scholarships.gov.in', TRUE);

    INSERT INTO public.eligibility (scholarship_id, community, gender, education_level) VALUES
        (v_id, 'ST',    'Any', 'PhD'),
        (v_id, 'ST',    'Any', 'PG'),
        (v_id, 'SC/ST', 'Any', 'PhD');

    INSERT INTO public.documents_required (scholarship_id, document_name) VALUES
        (v_id, 'Aadhaar Card'),
        (v_id, 'ST Caste Certificate'),
        (v_id, 'Income Certificate'),
        (v_id, 'PhD/M.Phil Enrollment Letter'),
        (v_id, 'Research Supervisor Letter'),
        (v_id, 'PG Degree Certificate'),
        (v_id, 'Bank Passbook (First Page)');

    INSERT INTO public.application_steps (scholarship_id, step_number, step_text) VALUES
        (v_id, 1, 'Confirm you belong to a Scheduled Tribe and are enrolled for PhD/M.Phil in a UGC-recognised university.'),
        (v_id, 2, 'Apply via NSP or Ministry of Tribal Affairs portal during the open application window.'),
        (v_id, 3, 'Upload ST certificate, PhD enrollment letter, supervisor letter, and bank details.'),
        (v_id, 4, 'University verifies and forwards to Ministry of Tribal Affairs for further processing.'),
        (v_id, 5, 'Fellowship approved for 5 years. Monthly amount directly transferred to bank account.');
END $$;

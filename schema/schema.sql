--
-- PostgreSQL database dump
--

\restrict 64Qifoh8VbIdKTonjUL7w1j7U811UiSUoGSQ9RykRTkdPToDEpTkxtXH9X1GvhD

-- Dumped from database version 14.22 (Ubuntu 14.22-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: districts; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.districts (
    id text NOT NULL,
    district text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.districts OWNER TO health_builders;

--
-- Name: health_centers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.health_centers (
    id text NOT NULL,
    name text,
    district text,
    longitude numeric,
    latitude numeric,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type text,
    district_id text,
    is_synced boolean DEFAULT true
);


ALTER TABLE public.health_centers OWNER TO health_builders;

--
-- Name: pharmacy_drugs; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pharmacy_drugs (
    id bigint NOT NULL,
    drug_name character varying(255) NOT NULL,
    is_novartis boolean DEFAULT false NOT NULL,
    is_hospital boolean DEFAULT false NOT NULL,
    is_health_center boolean DEFAULT false NOT NULL,
    is_medicalised_health_center boolean DEFAULT false NOT NULL,
    "HTN medications" boolean,
    "DM medications" boolean,
    "Heart failure medications" boolean,
    "Dyslipidemia medications" boolean,
    "Sanofi_project" boolean
);


ALTER TABLE public.pharmacy_drugs OWNER TO health_builders;

--
-- Name: qr_code_types; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.qr_code_types (
    id smallint NOT NULL,
    name character varying(255)
);


ALTER TABLE public.qr_code_types OWNER TO health_builders;

--
-- Name: qr_codes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.qr_codes (
    survey_year character varying(255),
    district character varying(255),
    health_center character varying(255),
    is_synced boolean DEFAULT true NOT NULL,
    id uuid NOT NULL,
    created_at timestamp without time zone,
    created_by uuid,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    last_synced_at timestamp with time zone,
    district_id text,
    health_center_id text,
    is_active boolean DEFAULT true NOT NULL,
    type_id smallint NOT NULL
);


ALTER TABLE public.qr_codes OWNER TO health_builders;

--
-- Name: stock_managements; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.stock_managements (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    drug_name text,
    available boolean,
    not_expired boolean,
    requested boolean,
    stock_card_available boolean,
    bottom_of_card_filled_for_each_month boolean,
    stock_monthly_inventory_available boolean,
    quantity_listed_on_stock_card bigint,
    quantity_on_shelf bigint,
    evidence_of_excess_available boolean,
    drug_properly_labeled boolean,
    number_of_stock_out_days bigint,
    days_with_stock_less_than_threshold bigint,
    last_synced_at timestamp with time zone,
    group_drug_name character varying(255)
);


ALTER TABLE public.stock_managements OWNER TO health_builders;

--
-- Name: 123; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."123" AS
 SELECT districts.district,
    health_centers.name AS "HC_Name",
    qr_code_types.name AS type_name,
    stock_managements.drug_name,
    stock_managements.available
   FROM (((((public.qr_codes
     JOIN public.qr_code_types ON ((qr_code_types.id = qr_codes.type_id)))
     JOIN public.health_centers ON ((health_centers.id = qr_codes.health_center_id)))
     JOIN public.districts ON (((districts.id = health_centers.district_id) AND (districts.id = qr_codes.district_id))))
     JOIN public.stock_managements ON ((stock_managements.survey_id = qr_codes.id)))
     JOIN public.pharmacy_drugs ON (((pharmacy_drugs.drug_name)::text = stock_managements.drug_name)));


ALTER VIEW public."123" OWNER TO health_builders;

--
-- Name: NCD_screening_high_BP_BS_Nyabihu; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public."NCD_screening_high_BP_BS_Nyabihu" (
    health_center character varying(255),
    full_name character varying(255),
    sex character varying(255),
    village character varying(255),
    blood_pressure character varying(255),
    systolic integer,
    diastolic integer,
    blood_sugar_numeric integer,
    bp_category character varying(255)
);


ALTER TABLE public."NCD_screening_high_BP_BS_Nyabihu" OWNER TO health_builders;

--
-- Name: Check duplicates NCD; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."Check duplicates NCD" AS
 SELECT t.health_center,
    t.full_name,
    t.sex,
    t.village,
    count(*) AS duplicate_count
   FROM public."NCD_screening_high_BP_BS_Nyabihu" t
  GROUP BY t.health_center, t.full_name, t.sex, t.village
 HAVING (count(*) > 1)
  ORDER BY (count(*)) DESC;


ALTER VIEW public."Check duplicates NCD" OWNER TO health_builders;

--
-- Name: dispensary_managements; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.dispensary_managements (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    drug_name text,
    not_expired boolean,
    request_form_signed_and_stamped boolean,
    consumption_register_up_to_date boolean,
    tally_sheets_used_throughout_the_day boolean,
    tally_sheets_match_consumption_register boolean,
    consumption_register_totalled boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.dispensary_managements OWNER TO health_builders;

--
-- Name: Drugs_availability; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."Drugs_availability" AS
 WITH stock_dispense AS (
         SELECT sm.survey_id,
            sm.drug_name,
            sm.available AS stock_available,
            sm.not_expired AS stock_not_expired,
            sm.requested AS stock_requested,
            sm.stock_card_available,
            sm.bottom_of_card_filled_for_each_month,
            sm.stock_monthly_inventory_available,
            sm.evidence_of_excess_available,
            sm.drug_properly_labeled,
            sm.number_of_stock_out_days,
            sm.days_with_stock_less_than_threshold,
            sm.quantity_listed_on_stock_card,
            sm.quantity_on_shelf,
            dm.available AS pharmacy_available,
            dm.consumption_register_up_to_date,
            dm.request_form_signed_and_stamped,
            dm.not_expired AS pharmacy_not_expired,
            dm.tally_sheets_used_throughout_the_day,
            dm.tally_sheets_match_consumption_register,
            dm.consumption_register_totalled
           FROM (public.stock_managements sm
             JOIN public.dispensary_managements dm ON (((dm.survey_id = sm.survey_id) AND (dm.drug_name = sm.drug_name))))
        )
 SELECT sd.survey_id,
    d.district AS district_name,
    hc.name AS health_center_name,
    sd.drug_name,
    qc.survey_year,
    bool_or(sd.stock_available) AS stock_available,
    bool_or(sd.stock_not_expired) AS stock_not_expired,
    bool_or(sd.stock_requested) AS stock_requested,
    bool_or(sd.stock_card_available) AS stock_card_available,
    bool_or(sd.bottom_of_card_filled_for_each_month) AS stock_card_filled_monthly,
    bool_or(sd.stock_monthly_inventory_available) AS monthly_inventory_available,
    bool_or(sd.evidence_of_excess_available) AS evidence_of_excess,
    bool_or(sd.drug_properly_labeled) AS drug_properly_labeled,
    sum(sd.quantity_listed_on_stock_card) AS quantity_listed_on_card,
    sum(sd.quantity_on_shelf) AS quantity_on_shelf,
    sum(sd.number_of_stock_out_days) AS total_stock_out_days,
    sum(sd.days_with_stock_less_than_threshold) AS total_days_below_threshold,
    bool_or(sd.pharmacy_available) AS pharmacy_available,
    bool_or(sd.consumption_register_up_to_date) AS consumption_register_up_to_date,
    bool_or(sd.request_form_signed_and_stamped) AS request_form_signed,
    bool_or(sd.pharmacy_not_expired) AS pharmacy_not_expired,
    bool_or(sd.tally_sheets_used_throughout_the_day) AS tally_sheets_used,
    bool_or(sd.tally_sheets_match_consumption_register) AS tally_matches_register,
    bool_or(sd.consumption_register_totalled) AS consumption_register_totalled,
    bool_or(pd.is_novartis) AS has_novartis_drugs,
    bool_or(pd.is_hospital) AS hospital_level_drugs,
    bool_or(pd.is_health_center) AS health_center_drugs,
    bool_or(pd.is_medicalised_health_center) AS medicalised_hc_drugs,
    bool_or(pd."HTN medications") AS has_htn_meds,
    bool_or(pd."DM medications") AS has_dm_meds,
    bool_or(pd."Heart failure medications") AS has_hf_meds,
    bool_or(pd."Dyslipidemia medications") AS has_dyslipidemia_meds,
    bool_or(pd."Sanofi_project") AS under_sanofi_project
   FROM ((((stock_dispense sd
     JOIN public.qr_codes qc ON ((qc.id = sd.survey_id)))
     JOIN public.health_centers hc ON ((hc.id = qc.health_center_id)))
     JOIN public.districts d ON ((d.id = hc.district_id)))
     JOIN public.pharmacy_drugs pd ON (((pd.drug_name)::text = sd.drug_name)))
  GROUP BY sd.survey_id, hc.name, sd.drug_name, d.district, qc.survey_year
  ORDER BY qc.survey_year, d.district, hc.name, sd.drug_name;


ALTER VIEW public."Drugs_availability" OWNER TO health_builders;

--
-- Name: Drugs_availability_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."Drugs_availability_copy1" AS
 SELECT stock_managements.survey_id,
    qr_codes.district,
    qr_codes.health_center,
    qr_codes.survey_year,
    stock_managements.drug_name AS drug_name_stock,
    stock_managements.available AS available_stock,
    dispensary_managements.available AS available_pharmacy,
    stock_managements.number_of_stock_out_days,
    stock_managements.days_with_stock_less_than_threshold,
    districts.district AS district_name,
    health_centers.name AS "HC_name",
    pharmacy_drugs.is_novartis,
    pharmacy_drugs.is_hospital,
    pharmacy_drugs.is_health_center,
    pharmacy_drugs.is_medicalised_health_center,
    pharmacy_drugs."HTN medications",
    pharmacy_drugs."DM medications",
    pharmacy_drugs."Heart failure medications",
    pharmacy_drugs."Dyslipidemia medications",
    pharmacy_drugs."Sanofi_project"
   FROM (((((public.stock_managements
     JOIN public.qr_codes ON ((qr_codes.id = stock_managements.survey_id)))
     JOIN public.dispensary_managements ON ((dispensary_managements.survey_id = qr_codes.id)))
     JOIN public.health_centers ON ((health_centers.id = qr_codes.health_center_id)))
     JOIN public.districts ON (((districts.id = health_centers.district_id) AND (districts.id = qr_codes.district_id))))
     JOIN public.pharmacy_drugs ON (((pharmacy_drugs.drug_name)::text = stock_managements.drug_name)));


ALTER VIEW public."Drugs_availability_copy1" OWNER TO health_builders;

--
-- Name: project_question_categories; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_question_categories (
    id bigint NOT NULL,
    category text,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.project_question_categories OWNER TO health_builders;

--
-- Name: project_questions; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_questions (
    id text NOT NULL,
    question text,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.project_questions OWNER TO health_builders;

--
-- Name: project_questions_maps; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_questions_maps (
    project_id text NOT NULL,
    question_id text NOT NULL
);


ALTER TABLE public.project_questions_maps OWNER TO health_builders;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.projects (
    id text NOT NULL,
    name text,
    description text,
    start_date text,
    end_date text,
    status_id bigint,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.projects OWNER TO health_builders;

--
-- Name: question_categories_maps; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.question_categories_maps (
    question_id text NOT NULL,
    category_id bigint NOT NULL
);


ALTER TABLE public.question_categories_maps OWNER TO health_builders;

--
-- Name: HBS-HMS questions; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."HBS-HMS questions" AS
 SELECT projects.id AS "Project_id",
    project_questions.id AS "Question_id",
    projects.name,
    project_questions.question,
    project_questions.created_at,
    project_question_categories.category,
    question_categories_maps.category_id
   FROM ((((public.projects
     JOIN public.project_questions_maps ON ((project_questions_maps.project_id = projects.id)))
     JOIN public.project_questions ON ((project_questions_maps.question_id = project_questions.id)))
     JOIN public.question_categories_maps ON ((question_categories_maps.question_id = project_questions.id)))
     JOIN public.project_question_categories ON ((project_question_categories.id = question_categories_maps.category_id)));


ALTER VIEW public."HBS-HMS questions" OWNER TO health_builders;

--
-- Name: HC_list; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."HC_list" AS
 SELECT districts.district,
    health_centers.name AS "HC",
    health_centers.longitude,
    health_centers.latitude
   FROM (public.districts
     JOIN public.health_centers ON ((health_centers.district_id = districts.id)));


ALTER VIEW public."HC_list" OWNER TO health_builders;

--
-- Name: ncd_community_screening_old; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_screening_old (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    id integer NOT NULL,
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean
);


ALTER TABLE public.ncd_community_screening_old OWNER TO health_builders;

--
-- Name: NCD check duplicates screening summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."NCD check duplicates screening summary" AS
 SELECT ncd_community_screening_old.health_center,
    ncd_community_screening_old.village,
    ncd_community_screening_old.full_name,
    ncd_community_screening_old.date_of_birth,
    ncd_community_screening_old.sex,
    count(*) AS duplicate_count
   FROM public.ncd_community_screening_old
  GROUP BY ncd_community_screening_old.health_center, ncd_community_screening_old.village, ncd_community_screening_old.full_name, ncd_community_screening_old.date_of_birth, ncd_community_screening_old.sex
 HAVING (count(*) > 1);


ALTER VIEW public."NCD check duplicates screening summary" OWNER TO health_builders;

--
-- Name: NCD ckeck duplicated screening_details; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."NCD ckeck duplicated screening_details" AS
 SELECT ncd_community_screening_old.screening_period,
    ncd_community_screening_old.health_center,
    ncd_community_screening_old.sector,
    ncd_community_screening_old.cell,
    ncd_community_screening_old.village,
    ncd_community_screening_old.full_name,
    ncd_community_screening_old.national_id,
    ncd_community_screening_old.date_of_birth,
    ncd_community_screening_old.age,
    ncd_community_screening_old.sex,
    ncd_community_screening_old.drinks_alcohol,
    ncd_community_screening_old.smokes,
    ncd_community_screening_old.works_out_for_alteast_30_minutes,
    ncd_community_screening_old.weight,
    ncd_community_screening_old.height,
    ncd_community_screening_old.blood_sugar,
    ncd_community_screening_old.blood_pressure,
    ncd_community_screening_old."District",
    ncd_community_screening_old.id,
    ncd_community_screening_old.page,
    ncd_community_screening_old.hard_copy_number,
    ncd_community_screening_old.verify_bp_value
   FROM public.ncd_community_screening_old
  WHERE (((ncd_community_screening_old.health_center)::text, (ncd_community_screening_old.village)::text, (ncd_community_screening_old.full_name)::text, (ncd_community_screening_old.date_of_birth)::text, (ncd_community_screening_old.sex)::text) IN ( SELECT ncd_community_screening_old_1.health_center,
            ncd_community_screening_old_1.village,
            ncd_community_screening_old_1.full_name,
            ncd_community_screening_old_1.date_of_birth,
            ncd_community_screening_old_1.sex
           FROM public.ncd_community_screening_old ncd_community_screening_old_1
          GROUP BY ncd_community_screening_old_1.health_center, ncd_community_screening_old_1.village, ncd_community_screening_old_1.full_name, ncd_community_screening_old_1.date_of_birth, ncd_community_screening_old_1.sex
         HAVING (count(*) > 1)));


ALTER VIEW public."NCD ckeck duplicated screening_details" OWNER TO health_builders;

--
-- Name: ncd_community_screening; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_screening (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean,
    id integer NOT NULL
);


ALTER TABLE public.ncd_community_screening OWNER TO health_builders;

--
-- Name: NCD_community_screening_number_hc; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."NCD_community_screening_number_hc" AS
 SELECT ncd_community_screening.health_center,
    count(ncd_community_screening.health_center) AS number_screened
   FROM public.ncd_community_screening
  GROUP BY ncd_community_screening.health_center
  ORDER BY ncd_community_screening.health_center;


ALTER VIEW public."NCD_community_screening_number_hc" OWNER TO health_builders;

--
-- Name: NCD_community_screening_number_village; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."NCD_community_screening_number_village" AS
 SELECT ncd_community_screening.health_center,
    ncd_community_screening.village,
    count(ncd_community_screening.village) AS number_screened
   FROM public.ncd_community_screening
  GROUP BY ncd_community_screening.health_center, ncd_community_screening.village
  ORDER BY ncd_community_screening.health_center, ncd_community_screening.village;


ALTER VIEW public."NCD_community_screening_number_village" OWNER TO health_builders;

--
-- Name: treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    treatment_guideline text NOT NULL,
    available boolean DEFAULT false NOT NULL,
    up_to_date boolean DEFAULT false NOT NULL,
    service_informed boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.treatment_guidelines OWNER TO health_builders;

--
-- Name: V_Maternity (BEmoNc)_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_Maternity (BEmoNc)_treatment_guidelines" AS
 SELECT treatment_guidelines.treatment_guideline,
    treatment_guidelines.available,
    treatment_guidelines.up_to_date,
    treatment_guidelines.service_informed,
    treatment_guidelines.survey_id
   FROM public.treatment_guidelines
  WHERE (treatment_guidelines.treatment_guideline = 'Maternity (BEmoNc)'::text);


ALTER VIEW public."V_Maternity (BEmoNc)_treatment_guidelines" OWNER TO health_builders;

--
-- Name: dyslipidemia_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.dyslipidemia_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    physical_assessment_complete boolean DEFAULT false NOT NULL,
    physical_assesment_justification text,
    ldl_test_done_last_three_visits boolean DEFAULT false NOT NULL,
    ldl_test_justification text,
    current_correct_treatment boolean DEFAULT false NOT NULL,
    current_correct_treatment_justification text,
    nutritional_advice_on_each_visit boolean DEFAULT false NOT NULL,
    nutritional_advice_justification text,
    physical_activity_education_on_each_visit boolean DEFAULT false NOT NULL,
    physical_activity_education_justification text
);


ALTER TABLE public.dyslipidemia_treatment_guidelines OWNER TO health_builders;

--
-- Name: V_dyslipidemia_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_dyslipidemia_treatment_guidelines" AS
 SELECT districts.district,
    health_centers.name AS "HF",
    qr_codes.survey_year,
    dyslipidemia_treatment_guidelines.physical_assessment_complete,
    dyslipidemia_treatment_guidelines.physical_assesment_justification,
    dyslipidemia_treatment_guidelines.ldl_test_done_last_three_visits,
    dyslipidemia_treatment_guidelines.ldl_test_justification,
    dyslipidemia_treatment_guidelines.current_correct_treatment,
    dyslipidemia_treatment_guidelines.current_correct_treatment_justification,
    dyslipidemia_treatment_guidelines.nutritional_advice_on_each_visit,
    dyslipidemia_treatment_guidelines.nutritional_advice_justification,
    dyslipidemia_treatment_guidelines.physical_activity_education_on_each_visit,
    dyslipidemia_treatment_guidelines.physical_activity_education_justification
   FROM (((public.dyslipidemia_treatment_guidelines
     JOIN public.qr_codes ON ((qr_codes.id = dyslipidemia_treatment_guidelines.survey_id)))
     JOIN public.districts ON ((districts.id = qr_codes.district_id)))
     JOIN public.health_centers ON (((health_centers.district_id = districts.id) AND (health_centers.id = qr_codes.health_center_id))));


ALTER VIEW public."V_dyslipidemia_treatment_guidelines" OWNER TO health_builders;

--
-- Name: ncd_community_screening_august_4_no_duplicates; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_screening_august_4_no_duplicates (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean,
    id integer
);


ALTER TABLE public.ncd_community_screening_august_4_no_duplicates OWNER TO health_builders;

--
-- Name: V_ncd_community_screening_august_4_no_duplicates; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_ncd_community_screening_august_4_no_duplicates" AS
 WITH parsed_screening AS (
         SELECT ncd_community_screening_august_4_no_duplicates.screening_period,
            ncd_community_screening_august_4_no_duplicates.id,
            ncd_community_screening_august_4_no_duplicates.full_name,
            ncd_community_screening_august_4_no_duplicates.sector,
            ncd_community_screening_august_4_no_duplicates.cell,
            ncd_community_screening_august_4_no_duplicates.village,
            ncd_community_screening_august_4_no_duplicates.health_center,
            ncd_community_screening_august_4_no_duplicates.sex,
            ncd_community_screening_august_4_no_duplicates.smokes,
            ncd_community_screening_august_4_no_duplicates.drinks_alcohol,
            ncd_community_screening_august_4_no_duplicates.blood_pressure,
            ncd_community_screening_august_4_no_duplicates.blood_sugar,
            (split_part((ncd_community_screening_august_4_no_duplicates.blood_pressure)::text, '/'::text, 1))::integer AS systolic,
            (split_part((ncd_community_screening_august_4_no_duplicates.blood_pressure)::text, '/'::text, 2))::integer AS diastolic
           FROM public.ncd_community_screening_august_4_no_duplicates
          WHERE (((ncd_community_screening_august_4_no_duplicates.blood_pressure)::text ~~ '%/%'::text) AND (split_part((ncd_community_screening_august_4_no_duplicates.blood_pressure)::text, '/'::text, 1) ~ '^[0-9]+$'::text) AND (split_part((ncd_community_screening_august_4_no_duplicates.blood_pressure)::text, '/'::text, 2) ~ '^[0-9]+$'::text))
        ), classified_screening AS (
         SELECT parsed_screening.screening_period,
            parsed_screening.id,
            parsed_screening.full_name,
            parsed_screening.sector,
            parsed_screening.cell,
            parsed_screening.village,
            parsed_screening.health_center,
            parsed_screening.sex,
            parsed_screening.smokes,
            parsed_screening.drinks_alcohol,
            parsed_screening.blood_pressure,
            parsed_screening.blood_sugar,
            parsed_screening.systolic,
            parsed_screening.diastolic,
            GREATEST(
                CASE
                    WHEN (parsed_screening.systolic < 130) THEN 1
                    WHEN ((parsed_screening.systolic >= 130) AND (parsed_screening.systolic <= 139)) THEN 2
                    WHEN ((parsed_screening.systolic >= 140) AND (parsed_screening.systolic <= 159)) THEN 3
                    WHEN ((parsed_screening.systolic >= 160) AND (parsed_screening.systolic <= 179)) THEN 4
                    WHEN (parsed_screening.systolic >= 180) THEN 5
                    ELSE 0
                END,
                CASE
                    WHEN (parsed_screening.diastolic < 85) THEN 1
                    WHEN ((parsed_screening.diastolic >= 85) AND (parsed_screening.diastolic <= 89)) THEN 2
                    WHEN ((parsed_screening.diastolic >= 90) AND (parsed_screening.diastolic <= 99)) THEN 3
                    WHEN ((parsed_screening.diastolic >= 100) AND (parsed_screening.diastolic <= 109)) THEN 4
                    WHEN (parsed_screening.diastolic >= 110) THEN 5
                    ELSE 0
                END) AS bp_level
           FROM parsed_screening
        ), final_screening AS (
         SELECT classified_screening.screening_period,
            classified_screening.id,
            classified_screening.full_name,
            classified_screening.sector,
            classified_screening.cell,
            classified_screening.village,
            classified_screening.health_center,
            classified_screening.sex,
            classified_screening.smokes,
            classified_screening.drinks_alcohol,
            classified_screening.blood_pressure,
            classified_screening.blood_sugar,
            classified_screening.systolic,
            classified_screening.diastolic,
            classified_screening.bp_level,
                CASE classified_screening.bp_level
                    WHEN 1 THEN 'normal'::text
                    WHEN 2 THEN 'pre_high'::text
                    WHEN 3 THEN 'grade_1'::text
                    WHEN 4 THEN 'grade_2'::text
                    WHEN 5 THEN 'grade_3'::text
                    ELSE 'unclassified'::text
                END AS bp_category,
                CASE
                    WHEN (classified_screening.bp_level >= 3) THEN 'high_bp'::text
                    ELSE NULL::text
                END AS high_bp_category
           FROM classified_screening
        )
 SELECT final_screening.screening_period AS screening_date,
    final_screening.id,
    final_screening.full_name,
    final_screening.sector,
    final_screening.cell,
    final_screening.sex,
    final_screening.village,
    final_screening.health_center,
    final_screening.blood_pressure,
    final_screening.blood_sugar,
    final_screening.bp_category,
        CASE
            WHEN ((final_screening.blood_sugar IS NOT NULL) AND ((final_screening.blood_sugar)::text <> ''::text)) THEN 1
            ELSE 0
        END AS screened_for_blood_sugar,
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric <= (100)::numeric))) AS "blood_sugar_Normal",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric > (100)::numeric) AND ((final_screening.blood_sugar)::numeric < (126)::numeric))) AS "blood_sugar_>100_<126",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (126)::numeric))) AS "blood_sugar_>=126",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (180)::numeric))) AS "blood_sugar_>=180",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (200)::numeric))) AS "blood_sugar_>=200",
    count(*) AS total_people,
    count(*) FILTER (WHERE (final_screening.blood_pressure IS NOT NULL)) AS screened_for_htn,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'M'::text)) AS htn_screened_male,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'F'::text)) AS htn_screened_female,
    count(*) FILTER (WHERE final_screening.smokes) AS htn_screened_tobacco_users,
    count(*) FILTER (WHERE final_screening.drinks_alcohol) AS htn_screened_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.high_bp_category = 'high_bp'::text)) AS total_high_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.smokes)) AS tobacco_users_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_high_bp_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'normal'::text)) AS total_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.smokes)) AS tobacco_users_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_normal_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'pre_high'::text)) AS total_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.smokes)) AS tobacco_users_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_pre_high_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_1'::text)) AS grade_1_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_1_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_1_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.smokes)) AS grade_1_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.drinks_alcohol)) AS grade_1_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_2'::text)) AS grade_2_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_2_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_2_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.smokes)) AS grade_2_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.drinks_alcohol)) AS grade_2_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_3'::text)) AS grade_3_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_3_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_3_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.smokes)) AS grade_3_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.drinks_alcohol)) AS grade_3_alcohol_consumers
   FROM final_screening
  GROUP BY final_screening.id, final_screening.screening_period, final_screening.sector, final_screening.cell, final_screening.village, final_screening.health_center, final_screening.blood_pressure, final_screening.bp_category, final_screening.sex, final_screening.blood_sugar, final_screening.full_name
  ORDER BY final_screening.screening_period;


ALTER VIEW public."V_ncd_community_screening_august_4_no_duplicates" OWNER TO health_builders;

--
-- Name: output_32_final; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.output_32_final (
    district_name character varying(255),
    healthcenter_name character varying(255),
    "MPS_Quarter" character varying(255),
    "Survey_year" numeric,
    "An annual malaria prevention plan has been established" numeric,
    "Malaria protocols and treatment guidelines are readily availabl" numeric,
    "Majority of the reviewed patient records reveal that Malaria pr" numeric,
    "Majority of the reviewed patient records reveal that NCD  treat" numeric,
    "Treatment guidelines, protocols, and/or algorithms have been ad" numeric,
    "Assessment forms (in patient) are collecting the information re" numeric,
    "More than 70%  of patients clinician assessment forms(in patien" numeric,
    "All ambulance referral cases from the last two months have an a" numeric,
    "Transfer sheet is standardized( all nine(9) elements are shown)" numeric,
    "All 5 detailed-reviewed drugs have consumption register totaled" numeric,
    "All 5 essential drugs are available and have a stock card" numeric,
    "All 5 essential drugs were not expired" numeric,
    "Majority of reviewed patient files shows that treatment plan is" numeric,
    "There is standardized assessment check list" numeric,
    "There is a suggestions box" numeric,
    "There is a customer care program" numeric,
    "QA committee is reviewing incidences" numeric,
    "The incident reporting form is in different languages" numeric,
    "Patient stisfaction data have been aggregated, analyzed and gra" numeric,
    "The patient satisfaction tool has been tested and revised." numeric,
    "The quality improvement plan is tracked" numeric,
    "There is a QI focal person" numeric,
    "Staff satisfaction data has been aggregated, analyzed and graph" numeric,
    "Staff satisfaction tool has been developed and tested." numeric,
    "Patients' and familys' rights are posted for public view" numeric,
    "70% of facility services  has an updated list of required, exis" numeric,
    "All account reconciliations are done monthly, payables and rece" numeric,
    "The names, photos, and phone numbers of management staff are di" numeric,
    "More than 80% of service have One hand washing/hygiene facility" numeric,
    "80% of service have hand hygiene procedures based on current pr" numeric,
    "Risks of infection have been identified for patients, staff and" numeric,
    "There is an IPC focal person that actively guides the IPC progr" numeric
);


ALTER TABLE public.output_32_final OWNER TO health_builders;

--
-- Name: output_32_final_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.output_32_final_view AS
 SELECT output_32_final.district_name,
    output_32_final.healthcenter_name,
    output_32_final."MPS_Quarter",
    output_32_final."Survey_year",
    output_32_final."An annual malaria prevention plan has been established",
    output_32_final."Malaria protocols and treatment guidelines are readily availabl",
    output_32_final."Majority of the reviewed patient records reveal that Malaria pr",
    output_32_final."Majority of the reviewed patient records reveal that NCD  treat",
    output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad",
    output_32_final."Assessment forms (in patient) are collecting the information re",
    output_32_final."More than 70%  of patients clinician assessment forms(in patien",
    output_32_final."All ambulance referral cases from the last two months have an a",
    output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)",
    output_32_final."All 5 detailed-reviewed drugs have consumption register totaled",
    output_32_final."All 5 essential drugs are available and have a stock card",
    output_32_final."All 5 essential drugs were not expired",
    output_32_final."Majority of reviewed patient files shows that treatment plan is",
    output_32_final."There is standardized assessment check list",
    output_32_final."There is a suggestions box",
    output_32_final."There is a customer care program",
    output_32_final."QA committee is reviewing incidences",
    output_32_final."The incident reporting form is in different languages",
    output_32_final."Patient stisfaction data have been aggregated, analyzed and gra",
    output_32_final."The patient satisfaction tool has been tested and revised.",
    output_32_final."The quality improvement plan is tracked",
    output_32_final."There is a QI focal person",
    output_32_final."Staff satisfaction data has been aggregated, analyzed and graph",
    output_32_final."Staff satisfaction tool has been developed and tested.",
    output_32_final."Patients' and familys' rights are posted for public view",
    output_32_final."70% of facility services  has an updated list of required, exis",
    output_32_final."All account reconciliations are done monthly, payables and rece",
    output_32_final."The names, photos, and phone numbers of management staff are di",
    output_32_final."More than 80% of service have One hand washing/hygiene facility",
    output_32_final."80% of service have hand hygiene procedures based on current pr",
    output_32_final."Risks of infection have been identified for patients, staff and",
    output_32_final."There is an IPC focal person that actively guides the IPC progr"
   FROM public.output_32_final;


ALTER VIEW public.output_32_final_view OWNER TO health_builders;

--
-- Name: output_41_final; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.output_41_final (
    district_name character varying(255),
    healthcenter_name character varying(255),
    "MPS_Quarter" character varying(255),
    survey_year numeric(6,0),
    "Measurements" character varying(255),
    "All 5 detailed-reviewed drugs have accurate tally sheets" numeric,
    "All 5 detailed-reviewed drugs have an updated consumption regis" numeric,
    "All 5 drug stock cards matched the quantity found on the shelf" numeric,
    "All requisitions are signed and stamped" numeric,
    "An essential drug list is available and used to order medicatio" numeric,
    "Drugs are well organized, labeled and protected from direct sun" numeric,
    "Pharmacy delivery notes are filed" numeric,
    "Refrigerator is monitored for temperature twice daily" numeric,
    "Stock room is dry and clean" numeric,
    "Tally sheets are used to track consumption" numeric,
    "There is a drug consumption register" numeric,
    "There is a pharmacy monthly inventory" numeric,
    "There is a separate room for expired drugs" numeric,
    "Monthly staff minutes shows that meetings are happening" numeric,
    "There is an implemented in-service training plan" numeric,
    "There is an up-to-date register/report of external trainings" numeric,
    "There is an updated work schedule" numeric,
    "Theres is an updated attendance register(actively used)" numeric,
    "QA is meeting on a monthly basis" numeric,
    "There is clear, visible internal signage that includes the name" numeric,
    "All 3 incomes recorded in the receipt book and journal matched" numeric,
    "All 3 transactions had required supporting documents" numeric,
    "The budget plan includes capital & maintenance" numeric,
    "The budget plan is approved by the titulaire and tracked" numeric,
    "There is an up to date individual bank book for each bank accou" numeric,
    "There is an up to date petty cash book and cash register" numeric,
    "Transactions are numbered and ordered sequentially" numeric,
    "COGE minutes show that the committee is meeting at least once p" numeric,
    "COSA minutes show that the committee is meeting at least once p" numeric,
    "Current job descriptions are written for each facility leader a" numeric,
    "The action plan is approved by the titulaire and tracked" numeric,
    "There is an updated organization chart" numeric,
    "All 15 randomly reviewed lines of the register were >80% comple" numeric,
    "Data displayed in services is current & relevant(at least in ma" numeric,
    "Data reports are >95% accurate across sources" numeric,
    "The monthly data report is signed and submitted on time" numeric,
    "There is an SOP for data management" numeric,
    "CHW minutes show that at least meetings are being held once per" numeric,
    "The business plan is approved by the titulaire and tracked" numeric,
    "All functional latrines are clean" numeric,
    "All functional latrines are equipped with hand washing stations" numeric
);


ALTER TABLE public.output_41_final OWNER TO health_builders;

--
-- Name: output_41_final_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.output_41_final_view AS
 SELECT output_41_final.district_name,
    output_41_final.healthcenter_name,
    output_41_final."MPS_Quarter",
    output_41_final.survey_year,
    output_41_final."Measurements",
    output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis",
    output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets",
    output_41_final."All 5 drug stock cards matched the quantity found on the shelf",
    output_41_final."All requisitions are signed and stamped",
    output_41_final."An essential drug list is available and used to order medicatio",
    output_41_final."Drugs are well organized, labeled and protected from direct sun",
    output_41_final."Pharmacy delivery notes are filed",
    output_41_final."Refrigerator is monitored for temperature twice daily",
    output_41_final."Stock room is dry and clean",
    output_41_final."Tally sheets are used to track consumption",
    output_41_final."There is a drug consumption register",
    output_41_final."There is a pharmacy monthly inventory",
    output_41_final."There is a separate room for expired drugs",
    output_41_final."Monthly staff minutes shows that meetings are happening",
    output_41_final."There is an implemented in-service training plan",
    output_41_final."There is an up-to-date register/report of external trainings",
    output_41_final."There is an updated work schedule",
    output_41_final."Theres is an updated attendance register(actively used)",
    output_41_final."QA is meeting on a monthly basis",
    output_41_final."All 3 incomes recorded in the receipt book and journal matched",
    output_41_final."There is clear, visible internal signage that includes the name",
    output_41_final."All 3 transactions had required supporting documents",
    output_41_final."The budget plan includes capital & maintenance",
    output_41_final."The budget plan is approved by the titulaire and tracked",
    output_41_final."There is an up to date individual bank book for each bank accou",
    output_41_final."There is an up to date petty cash book and cash register",
    output_41_final."Transactions are numbered and ordered sequentially",
    output_41_final."COGE minutes show that the committee is meeting at least once p",
    output_41_final."COSA minutes show that the committee is meeting at least once p",
    output_41_final."Current job descriptions are written for each facility leader a",
    output_41_final."The action plan is approved by the titulaire and tracked",
    output_41_final."There is an updated organization chart",
    output_41_final."All 15 randomly reviewed lines of the register were >80% comple",
    output_41_final."Data displayed in services is current & relevant(at least in ma",
    output_41_final."Data reports are >95% accurate across sources",
    output_41_final."The monthly data report is signed and submitted on time",
    output_41_final."There is an SOP for data management",
    output_41_final."CHW minutes show that at least meetings are being held once per",
    output_41_final."The business plan is approved by the titulaire and tracked",
    output_41_final."All functional latrines are clean",
    output_41_final."All functional latrines are equipped with hand washing stations"
   FROM public.output_41_final;


ALTER VIEW public.output_41_final_view OWNER TO health_builders;

--
-- Name: V_output_Finance; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_output_Finance" AS
 SELECT DISTINCT o41.district_name,
    o41.healthcenter_name,
    o41."MPS_Quarter",
    o32."MPS_Quarter" AS "MPS_Qurter_32",
    o41.survey_year,
    o32."Survey_year" AS "Survey_Year_32",
    o41."All 3 incomes recorded in the receipt book and journal matched",
    o41."All 3 transactions had required supporting documents",
    o41."The budget plan includes capital & maintenance",
    o41."The budget plan is approved by the titulaire and tracked",
    o41."There is an up to date individual bank book for each bank accou",
    o41."There is an up to date petty cash book and cash register",
    o41."Transactions are numbered and ordered sequentially",
    o32."All account reconciliations are done monthly, payables and rece",
    round(( SELECT ((sum(COALESCE(val.val, (0)::numeric)) / (NULLIF(count(val.val), 0))::numeric) * (100)::numeric)
           FROM unnest(ARRAY[o41."All 3 incomes recorded in the receipt book and journal matched", o41."All 3 transactions had required supporting documents", o41."The budget plan includes capital & maintenance", o41."The budget plan is approved by the titulaire and tracked", o41."There is an up to date individual bank book for each bank accou", o41."There is an up to date petty cash book and cash register", o41."Transactions are numbered and ordered sequentially", o32."All account reconciliations are done monthly, payables and rece"]) val(val)), 2) AS score_percentage
   FROM (public.output_32_final_view o32
     JOIN public.output_41_final_view o41 ON ((((o32.district_name)::text = (o41.district_name)::text) AND ((o32.healthcenter_name)::text = (o41.healthcenter_name)::text) AND ((o32."MPS_Quarter")::text = (o41."MPS_Quarter")::text) AND (o32."Survey_year" = o41.survey_year))));


ALTER VIEW public."V_output_Finance" OWNER TO health_builders;

--
-- Name: customer_care_programs; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.customer_care_programs (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.customer_care_programs OWNER TO health_builders;

--
-- Name: safety_managements; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.safety_managements (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_family_rights_posted boolean,
    patient_staff_and_visitors_risk_of_infection_assessment_report boolean,
    patient_satisfaction_tool_tested_and_revised boolean,
    suggestion_box_available boolean,
    suggestion_box_assessment_report_available boolean,
    qi_committe_reviewing_incidents boolean,
    incident_reporting_form_in_different_langauges boolean,
    staff_satisfaction_data_has_been_aggregated_and_graphed boolean,
    staff_satisfaction_toold_developed_and_tested boolean,
    asrh_focal_person_available boolean,
    annual_list_of_safety_hazards_available boolean,
    pp_es_available boolean,
    staff_use_pp_es boolean,
    asrh_registers_available boolean,
    dedicated_as_rhspace_available boolean,
    room_for_group_iec_and_consultation_room_available boolean,
    number_of_patient_safety_incidents_reported bigint,
    number_of_incidents_analysed bigint,
    number_of_hazards_identified bigint,
    number_of_hazards_fixed bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.safety_managements OWNER TO health_builders;

--
-- Name: staff_informations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.staff_informations (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    number_of_staff bigint,
    number_of_nurses bigint,
    total_paid_by_hc bigint,
    total_tested_for_covid bigint,
    total_evaluated_for_perfomance bigint,
    number_of_staff_illnesses bigint,
    number_of_staff_injuries bigint,
    total_hepatitis_b_vaccinated bigint,
    number_of_other_clinical_staff bigint,
    total_trained_on_infection_control bigint,
    total_screened_for_tb bigint,
    patient_satisfaction_rate numeric,
    staff_satisfaction_rate numeric,
    qi_committe_functional boolean,
    pharmacy_manager_trained_on_sop boolean,
    evidence_of_pharmacy_manager_training boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.staff_informations OWNER TO health_builders;

--
-- Name: v_customer_care_safety_managements; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_customer_care_safety_managements AS
 SELECT q.id AS survey_id,
    split_part(btrim((q.survey_year)::text), '-'::text, 2) AS survey_year_c,
    d.district AS district_name,
    hc.name AS healthcenter_name,
    hc.type AS facility_type,
        CASE
            WHEN sm.suggestion_box_available THEN 1
            ELSE 0
        END AS _32_17_suggestion_box_available,
        CASE
            WHEN (ccp.available AND ccp.tracked AND ccp.titualaire_approved) THEN 1
            ELSE 0
        END AS _32_18_customer_care_program_tracked_approved,
        CASE
            WHEN sm.qi_committe_reviewing_incidents THEN 1
            ELSE 0
        END AS _32_19_qi_committe_reviewing_incidents,
        CASE
            WHEN sm.incident_reporting_form_in_different_langauges THEN 1
            ELSE 0
        END AS _32_20_incident_reporting_form_in_different_langauges,
        CASE
            WHEN sm.patient_family_rights_posted THEN 1
            ELSE 0
        END AS _32_21_patient_family_rights_posted,
        CASE
            WHEN sm.patient_satisfaction_tool_tested_and_revised THEN 1
            ELSE 0
        END AS _32_22_patient_satisfaction_tool_tested_and_revised,
        CASE
            WHEN (si.patient_satisfaction_rate > (1)::numeric) THEN 1
            ELSE 0
        END AS _32_23_patient_satisfaction_data_aggregated_and_graphed,
        CASE
            WHEN sm.staff_satisfaction_toold_developed_and_tested THEN 1
            ELSE 0
        END AS _32_24_staff_satisfaction_toold_developed_and_tested,
        CASE
            WHEN sm.staff_satisfaction_data_has_been_aggregated_and_graphed THEN 1
            ELSE 0
        END AS _32_25_staff_satisfaction_data_has_been_aggregated_and_graphed,
        CASE
            WHEN sm.patient_staff_and_visitors_risk_of_infection_assessment_report THEN 1
            ELSE 0
        END AS _32_26_patient_staff_and_visitors_risk_of_infection_identified,
        CASE
            WHEN sm.pp_es_available THEN 1
            ELSE 0
        END AS ppes_available,
        CASE
            WHEN sm.staff_use_pp_es THEN 1
            ELSE 0
        END AS ppes_used
   FROM (((((public.qr_codes q
     LEFT JOIN public.safety_managements sm ON ((q.id = sm.survey_id)))
     LEFT JOIN public.customer_care_programs ccp ON ((q.id = ccp.survey_id)))
     LEFT JOIN public.staff_informations si ON ((q.id = si.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public.v_customer_care_safety_managements OWNER TO health_builders;

--
-- Name: V_output_IPC; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_output_IPC" AS
 SELECT DISTINCT o41.district_name,
    o41.healthcenter_name,
    o41."MPS_Quarter",
    o32."MPS_Quarter" AS "MPS_Qurter_32",
    o41.survey_year,
    o32."Survey_year" AS "Survey_Year_32",
    o41."All functional latrines are clean",
    o41."All functional latrines are equipped with hand washing stations",
    o32."There is an IPC focal person that actively guides the IPC progr",
    o32."Risks of infection have been identified for patients, staff and",
    o32."80% of service have hand hygiene procedures based on current pr",
    o32."More than 80% of service have One hand washing/hygiene facility",
    cc.ppes_available,
    cc.ppes_used,
    cc.survey_year_c,
    round(( SELECT ((sum(COALESCE(val.val, (0)::numeric)) / (NULLIF(count(val.val), 0))::numeric) * (100)::numeric)
           FROM unnest(ARRAY[o41."All functional latrines are clean", o41."All functional latrines are equipped with hand washing stations", o32."There is an IPC focal person that actively guides the IPC progr", o32."Risks of infection have been identified for patients, staff and", o32."80% of service have hand hygiene procedures based on current pr", o32."More than 80% of service have One hand washing/hygiene facility", (cc.ppes_available)::numeric, (cc.ppes_used)::numeric]) val(val)), 2) AS score_percentage
   FROM ((public.output_32_final_view o32
     JOIN public.output_41_final_view o41 ON ((((o32.district_name)::text = (o41.district_name)::text) AND ((o32.healthcenter_name)::text = (o41.healthcenter_name)::text) AND ((o32."MPS_Quarter")::text = (o41."MPS_Quarter")::text) AND (o32."Survey_year" = o41.survey_year))))
     JOIN public.v_customer_care_safety_managements cc ON (((cc.district_name = (o41.district_name)::text) AND (cc.healthcenter_name = (o41.healthcenter_name)::text) AND (((cc.survey_year_c)::integer)::numeric = o41.survey_year))));


ALTER VIEW public."V_output_IPC" OWNER TO health_builders;

--
-- Name: V_output_Pharmacy; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_output_Pharmacy" AS
 SELECT DISTINCT o41.district_name,
    o41.healthcenter_name,
    o41."MPS_Quarter",
    o32."MPS_Quarter" AS "MPS_Qurter_32",
    o41.survey_year,
    o32."Survey_year" AS "Survey_Year_32",
    o41."All 5 detailed-reviewed drugs have an updated consumption regis",
    o41."All 5 detailed-reviewed drugs have accurate tally sheets",
    o41."All 5 drug stock cards matched the quantity found on the shelf",
    o41."All requisitions are signed and stamped",
    o41."An essential drug list is available and used to order medicatio",
    o41."Drugs are well organized, labeled and protected from direct sun",
    o41."Pharmacy delivery notes are filed",
    o41."Refrigerator is monitored for temperature twice daily",
    o41."Stock room is dry and clean",
    o41."Tally sheets are used to track consumption",
    o41."There is a drug consumption register",
    o41."There is a pharmacy monthly inventory",
    o41."There is a separate room for expired drugs",
    o32."All 5 detailed-reviewed drugs have consumption register totaled",
    o32."All 5 essential drugs are available and have a stock card",
    o32."All 5 essential drugs were not expired",
    round(( SELECT ((sum(COALESCE(val.val, (0)::numeric)) / (NULLIF(count(val.val), 0))::numeric) * (100)::numeric)
           FROM unnest(ARRAY[o41."All 5 detailed-reviewed drugs have an updated consumption regis", o41."All 5 detailed-reviewed drugs have accurate tally sheets", o41."All 5 drug stock cards matched the quantity found on the shelf", o41."All requisitions are signed and stamped", o41."An essential drug list is available and used to order medicatio", o41."Drugs are well organized, labeled and protected from direct sun", o41."Pharmacy delivery notes are filed", o41."Refrigerator is monitored for temperature twice daily", o41."Stock room is dry and clean", o41."Tally sheets are used to track consumption", o41."There is a drug consumption register", o41."There is a pharmacy monthly inventory", o41."There is a separate room for expired drugs", o32."All 5 detailed-reviewed drugs have consumption register totaled", o32."All 5 essential drugs are available and have a stock card", o32."All 5 essential drugs were not expired"]) val(val)), 2) AS score_percentage
   FROM (public.output_32_final_view o32
     JOIN public.output_41_final_view o41 ON ((((o32.district_name)::text = (o41.district_name)::text) AND ((o32.healthcenter_name)::text = (o41.healthcenter_name)::text) AND ((o32."MPS_Quarter")::text = (o41."MPS_Quarter")::text) AND (o32."Survey_year" = o41.survey_year))));


ALTER VIEW public."V_output_Pharmacy" OWNER TO health_builders;

--
-- Name: anc_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.anc_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    patient_history_complete boolean DEFAULT false NOT NULL,
    bp_checked_each_visit boolean DEFAULT false NOT NULL,
    urine_albimune_tested_initial_visit boolean DEFAULT false NOT NULL,
    hemoglobin_tested_initial_visit boolean DEFAULT false NOT NULL,
    rpr_test_done_for_syphilis_initial_visit boolean DEFAULT false NOT NULL,
    first_trimister_ultrasound_scan_done boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.anc_treatment_guidelines OWNER TO health_builders;

--
-- Name: maternity_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.maternity_treatment_guidelines (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    essential_supplies_available boolean DEFAULT false NOT NULL,
    privacy_provided_to_women_in_maternity boolean DEFAULT false NOT NULL,
    adequate_supply_of_ppes boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.maternity_treatment_guidelines OWNER TO health_builders;

--
-- Name: V_output_maternity; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_output_maternity" AS
 SELECT hc.name,
    d.district,
    mtg.survey_id,
    q.survey_year AS survey_year_1,
    split_part((q.survey_year)::text, '-'::text, 2) AS survey_year,
    (mtg.essential_supplies_available)::integer AS essential_supplies_available_num,
    (mtg.privacy_provided_to_women_in_maternity)::integer AS privacy_provided_num,
    (mtg.adequate_supply_of_ppes)::integer AS adequate_ppes_num,
    (vtg.available)::integer AS "BEMOC_treatment_g_available_num",
    (vtg.up_to_date)::integer AS "BEMOC_treatment_g_uptodate_num",
    (vtg.service_informed)::integer AS "BEMOC_treatment_g_service_informed_num",
    (atg.patient_history_complete)::integer AS "ANC_patient_history_complete",
    (atg.bp_checked_each_visit)::integer AS bp_checked_each_visit,
    (atg.urine_albimune_tested_initial_visit)::integer AS "ANC_urine_albimune_tested_initial_visit",
    (atg.hemoglobin_tested_initial_visit)::integer AS "ANC_hemoglobin_tested_initial_visit",
    (atg.rpr_test_done_for_syphilis_initial_visit)::integer AS "ANC_rpr_test_done_for_syphilis_initial_visit",
    (atg.first_trimister_ultrasound_scan_done)::integer AS "ANC_first_trimister_ultrasound_scan_done",
    round(( SELECT (((sum(val.val))::numeric / (NULLIF(count(val.val), 0))::numeric) * (100)::numeric)
           FROM unnest(ARRAY[COALESCE((mtg.essential_supplies_available)::integer, 0), COALESCE((mtg.privacy_provided_to_women_in_maternity)::integer, 0), COALESCE((mtg.adequate_supply_of_ppes)::integer, 0), COALESCE((vtg.available)::integer, 0), COALESCE((vtg.up_to_date)::integer, 0), COALESCE((vtg.service_informed)::integer, 0), COALESCE((atg.patient_history_complete)::integer, 0), COALESCE((atg.bp_checked_each_visit)::integer, 0), COALESCE((atg.urine_albimune_tested_initial_visit)::integer, 0), COALESCE((atg.hemoglobin_tested_initial_visit)::integer, 0), COALESCE((atg.rpr_test_done_for_syphilis_initial_visit)::integer, 0), COALESCE((atg.first_trimister_ultrasound_scan_done)::integer, 0)]) val(val)), 2) AS score_percentage
   FROM (((((public.maternity_treatment_guidelines mtg
     JOIN public.qr_codes q ON ((mtg.survey_id = q.id)))
     JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
     JOIN public.districts d ON (((hc.district_id = d.id) AND (q.district_id = d.id))))
     JOIN public."V_Maternity (BEmoNc)_treatment_guidelines" vtg ON ((mtg.survey_id = vtg.survey_id)))
     JOIN public.anc_treatment_guidelines atg ON ((q.id = atg.survey_id)));


ALTER VIEW public."V_output_maternity" OWNER TO health_builders;

--
-- Name: V_output_maternity_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."V_output_maternity_copy1" AS
 SELECT hc.name,
    d.district,
    mtg.survey_id,
    q.survey_year,
    (mtg.essential_supplies_available)::integer AS essential_supplies_available_num,
    (mtg.privacy_provided_to_women_in_maternity)::integer AS privacy_provided_num,
    (mtg.adequate_supply_of_ppes)::integer AS adequate_ppes_num,
    (vtg.available)::integer AS "BEMOC_treatment_g_available_num",
    (vtg.up_to_date)::integer AS "BEMOC_treatment_g_uptodate_num",
    (vtg.service_informed)::integer AS "BEMOC_treatment_g_service_informed_num",
    round(( SELECT (((sum(val.val))::numeric / (NULLIF(count(val.val), 0))::numeric) * (100)::numeric)
           FROM unnest(ARRAY[COALESCE((mtg.essential_supplies_available)::integer, 0), COALESCE((mtg.privacy_provided_to_women_in_maternity)::integer, 0), COALESCE((mtg.adequate_supply_of_ppes)::integer, 0), COALESCE((vtg.available)::integer, 0), COALESCE((vtg.up_to_date)::integer, 0), COALESCE((vtg.service_informed)::integer, 0)]) val(val)), 2) AS score_percentage
   FROM ((((public.maternity_treatment_guidelines mtg
     JOIN public.qr_codes q ON ((mtg.survey_id = q.id)))
     JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
     JOIN public.districts d ON (((hc.district_id = d.id) AND (q.district_id = d.id))))
     JOIN public."V_Maternity (BEmoNc)_treatment_guidelines" vtg ON ((mtg.survey_id = vtg.survey_id)));


ALTER VIEW public."V_output_maternity_copy1" OWNER TO health_builders;

--
-- Name: check_list_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.check_list_treatment_guidelines (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    referral_process_transfer_form_standardized boolean,
    in_patient_care_standardized_assessment_check_list_available boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.check_list_treatment_guidelines OWNER TO health_builders;

--
-- Name: _32_10_to11_checklist_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_10_to11_checklist_treatment_guidelines AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = true) THEN 1
            ELSE 0
        END AS _32_10_there_is_standardized_checklist,
        CASE
            WHEN (cltg.referral_process_transfer_form_standardized = true) THEN 1
            ELSE 0
        END AS _32_11_transfer_sheet_standardized
   FROM (((public.qr_codes q
     LEFT JOIN public.check_list_treatment_guidelines cltg ON ((q.id = cltg.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_10_to11_checklist_treatment_guidelines OWNER TO health_builders;

--
-- Name: inpatients_care_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.inpatients_care_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    biographical_data_complete boolean DEFAULT false NOT NULL,
    relevant_history_complete boolean DEFAULT false NOT NULL,
    chief_complaints boolean DEFAULT false NOT NULL,
    rapid_survey boolean DEFAULT false NOT NULL,
    vital_signs_and_anthropometrics boolean DEFAULT false NOT NULL,
    exam_of_systems boolean DEFAULT false NOT NULL,
    diagnosis boolean DEFAULT false NOT NULL,
    nursing_care_plan boolean DEFAULT false NOT NULL,
    soap_note boolean DEFAULT false NOT NULL,
    treatment_plan_revised_according_to_reassesment_results boolean DEFAULT false NOT NULL,
    complete boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.inpatients_care_treatment_guidelines OWNER TO health_builders;

--
-- Name: _32_12_inpatients_care_treatment_guidelines_new; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_12_inpatients_care_treatment_guidelines_new AS
 WITH completeness_data AS (
         SELECT ictg.survey_id,
            ictg.id,
            (((((((((
                CASE
                    WHEN ictg.biographical_data_complete THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN ictg.relevant_history_complete THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.chief_complaints THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.rapid_survey THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.vital_signs_and_anthropometrics THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.exam_of_systems THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.diagnosis THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.nursing_care_plan THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.soap_note THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN ictg.treatment_plan_revised_according_to_reassesment_results THEN 1
                    ELSE 0
                END) AS completeness_count
           FROM public.inpatients_care_treatment_guidelines ictg
        ), percentage_calculations AS (
         SELECT completeness_data.survey_id,
            completeness_data.id,
            completeness_data.completeness_count,
            (((completeness_data.completeness_count)::numeric / (10)::numeric) * (100)::numeric) AS completeness_percentage,
                CASE
                    WHEN ((((completeness_data.completeness_count)::numeric / (10)::numeric) * (100)::numeric) >= (90)::numeric) THEN 1
                    ELSE 0
                END AS meets_90_percent
           FROM completeness_data
        ), health_center_calculations AS (
         SELECT q.id AS survey_id,
            q.survey_year,
            d.district,
            hcs.name AS health_facility,
            hcs.type AS facility_type,
            count(pc.id) AS total_patients,
            sum(pc.meets_90_percent) AS total_patients_90_percentage_completeness,
            round((((sum(pc.meets_90_percent))::numeric / (count(pc.id))::numeric) * (100)::numeric), 2) AS health_center_percentage,
                CASE
                    WHEN (round((((sum(pc.meets_90_percent))::numeric / (count(pc.id))::numeric) * (100)::numeric), 2) >= (70)::numeric) THEN 1
                    ELSE 0
                END AS _32_12_70_percent_reviewed_clinicians_have_completeness
           FROM (((public.qr_codes q
             LEFT JOIN percentage_calculations pc ON ((q.id = pc.survey_id)))
             LEFT JOIN public.districts d ON ((q.district_id = d.id)))
             LEFT JOIN public.health_centers hcs ON ((q.health_center_id = hcs.id)))
          GROUP BY q.id, d.district, hcs.name, hcs.type, q.survey_year, q.district_id, q.health_center_id
        )
 SELECT hc.survey_id,
    hc.survey_year,
    hc.district,
    hc.health_facility,
    hc.facility_type,
    COALESCE(hc.total_patients, (0)::bigint) AS total_patients,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = true) THEN 1
            ELSE 0
        END AS standardized_assessment_check_list_available,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = true) THEN COALESCE(hc.health_center_percentage, NULL::numeric)
            ELSE NULL::numeric
        END AS health_center_percentage,
    COALESCE(hc.total_patients_90_percentage_completeness, (0)::bigint) AS total_patients_90_percentage_completeness,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = true) THEN hc._32_12_70_percent_reviewed_clinicians_have_completeness
            ELSE 0
        END AS _32_12_70_percent_reviewed_clinicians_have_completeness
   FROM (health_center_calculations hc
     LEFT JOIN public.check_list_treatment_guidelines cltg ON ((hc.survey_id = cltg.survey_id)));


ALTER VIEW public._32_12_inpatients_care_treatment_guidelines_new OWNER TO health_builders;

--
-- Name: _32_12_inpatients_care_treatment_guidelines_new22; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_12_inpatients_care_treatment_guidelines_new22 AS
 WITH completeness_data AS (
         SELECT ictg.survey_id,
            ictg.patient_number,
            ictg.complete
           FROM public.inpatients_care_treatment_guidelines ictg
        ), summary_data AS (
         SELECT completeness_data.survey_id,
            count(*) AS total_patients,
            sum(
                CASE
                    WHEN completeness_data.complete THEN 1
                    ELSE 0
                END) AS total_with_completeness
           FROM completeness_data
          GROUP BY completeness_data.survey_id
        )
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    COALESCE(sd.total_patients, (0)::bigint) AS total_patients,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = true) THEN 1
            ELSE 0
        END AS standardized_assessment_check_list_available,
    COALESCE(sd.total_with_completeness, (0)::bigint) AS total_with_completeness,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = false) THEN NULL::numeric
            ELSE round(((COALESCE((sd.total_with_completeness)::numeric, (0)::numeric) / COALESCE((sd.total_patients)::numeric, (1)::numeric)) * (100)::numeric), 2)
        END AS percentage,
        CASE
            WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = false) THEN 0
            WHEN (round(((COALESCE((sd.total_with_completeness)::numeric, (0)::numeric) / COALESCE((sd.total_patients)::numeric, (1)::numeric)) * (100)::numeric), 2) >= (70)::numeric) THEN 1
            ELSE 0
        END AS _32_12_70_percent_reviewed_clinicians_have_completeness
   FROM ((((public.qr_codes q
     LEFT JOIN public.check_list_treatment_guidelines cltg ON ((q.id = cltg.survey_id)))
     LEFT JOIN summary_data sd ON ((q.id = sd.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_12_inpatients_care_treatment_guidelines_new22 OWNER TO health_builders;

--
-- Name: _32_13_to14_essential_drugs_have_stockcard_and_notexpired; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_13_to14_essential_drugs_have_stockcard_and_notexpired AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    20 AS expected_drugs,
    count(sm.drug_name) AS drugs_recorded,
    sum(
        CASE
            WHEN sm.available THEN 1
            ELSE 0
        END) AS total_available,
    sum(
        CASE
            WHEN (sm.available = false) THEN 0
            WHEN sm.stock_card_available THEN 1
            ELSE 0
        END) AS total_stock_card_available,
        CASE
            WHEN (count(sm.drug_name) = 0) THEN NULL::integer
            WHEN (((sum(
            CASE
                WHEN sm.available THEN 1
                ELSE 0
            END))::numeric >= (0.85 * (20)::numeric)) AND (sum(
            CASE
                WHEN (sm.available = false) THEN 0
                WHEN sm.stock_card_available THEN 1
                ELSE 0
            END) = sum(
            CASE
                WHEN sm.available THEN 1
                ELSE 0
            END))) THEN 1
            ELSE 0
        END AS _32_13_essential_drugs_available_have_stock_card,
    (sum(
        CASE
            WHEN sm.available THEN 1
            ELSE 0
        END) - sum(
        CASE
            WHEN (sm.available = false) THEN 0
            WHEN sm.not_expired THEN 1
            ELSE 0
        END)) AS total_expired,
        CASE
            WHEN (count(sm.drug_name) = 0) THEN NULL::integer
            WHEN ((sum(
            CASE
                WHEN sm.available THEN 1
                ELSE 0
            END) - sum(
            CASE
                WHEN (sm.available = false) THEN 0
                WHEN sm.not_expired THEN 1
                ELSE 0
            END)) = 0) THEN 1
            ELSE 0
        END AS _32_14_essential_drugs_not_expired
   FROM (((public.qr_codes q
     LEFT JOIN public.stock_managements sm ON ((q.id = sm.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, d.district, hc.name, hc.type, q.survey_year, q.district_id, q.health_center_id;


ALTER VIEW public._32_13_to14_essential_drugs_have_stockcard_and_notexpired OWNER TO health_builders;

--
-- Name: _32_15_reviewed_drugs_consumption_reg_totalled; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_15_reviewed_drugs_consumption_reg_totalled AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS amitriptyline_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS metformin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS methyldopa_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS nifedipine_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS amilodipine_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS hydrochlorothiazide_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS beclomethasone_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS amoxicillin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS atenolol_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS captopril_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS ciprofloxacin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS cotrimoxazole_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS dexamethasone_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS diazepam_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS diclofenac_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS glibenclamide_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS oxyctocin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS paracetamol_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS salbutamol_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) AS vitamin_consumption_reg,
    (((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) AS totalled_consumption_reg_count,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS total_available_drugs,
    20 AS expected_drugs,
    round((((((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_totalled) THEN 1
            ELSE 0
        END)))::numeric / (NULLIF(sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END), 0))::numeric), 2) AS updated_consumption_reg_ratio,
        CASE
            WHEN (round((((((((((((((((((((((max(
            CASE
                WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_totalled) THEN 1
                ELSE 0
            END)))::numeric / (NULLIF(sum(
            CASE
                WHEN d.available THEN 1
                ELSE 0
            END), 0))::numeric), 2) > 0.85) THEN 1
            ELSE 0
        END AS _32_15_drugs_have_consumption_register_totalled_monthly
   FROM (((public.qr_codes q
     LEFT JOIN public.dispensary_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, ds.district, hc.name, hc.type, q.survey_year, q.district_id, q.health_center_id;


ALTER VIEW public._32_15_reviewed_drugs_consumption_reg_totalled OWNER TO health_builders;

--
-- Name: _32_16_treatment_plan_revised_according_to_reassement; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_16_treatment_plan_revised_according_to_reassement AS
 WITH patient_data AS (
         SELECT ictg.survey_id,
            count(*) AS total_patients,
            sum((ictg.treatment_plan_revised_according_to_reassesment_results)::integer) AS total_treatment_plans_revised
           FROM public.inpatients_care_treatment_guidelines ictg
          GROUP BY ictg.survey_id
        ), assessment_checklist AS (
         SELECT cltg.survey_id,
                CASE
                    WHEN (cltg.in_patient_care_standardized_assessment_check_list_available = true) THEN 1
                    ELSE 0
                END AS in_patient_care_standardized_assessment_check_list_available
           FROM public.check_list_treatment_guidelines cltg
        )
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    COALESCE(pd.total_patients, (0)::bigint) AS total_patients,
    ac.in_patient_care_standardized_assessment_check_list_available,
        CASE
            WHEN ((COALESCE(pd.total_patients, (0)::bigint) > 0) AND (COALESCE(pd.total_treatment_plans_revised, (0)::bigint) = COALESCE(pd.total_patients, (0)::bigint))) THEN 1
            ELSE 0
        END AS all_treatment_plans_revised_according_to_reassesment_results,
        CASE
            WHEN ((
            CASE
                WHEN ((COALESCE(pd.total_patients, (0)::bigint) > 0) AND (COALESCE(pd.total_treatment_plans_revised, (0)::bigint) = COALESCE(pd.total_patients, (0)::bigint))) THEN 1
                ELSE 0
            END = 1) AND (ac.in_patient_care_standardized_assessment_check_list_available = 1)) THEN 1
            ELSE 0
        END AS _32_16_treatment_plan_revised_from_reassesment_results
   FROM ((((public.qr_codes q
     LEFT JOIN patient_data pd ON ((q.id = pd.survey_id)))
     LEFT JOIN assessment_checklist ac ON ((q.id = ac.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_16_treatment_plan_revised_according_to_reassement OWNER TO health_builders;

--
-- Name: _32_17_to26_customer_care_safety_managements; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_17_to26_customer_care_safety_managements AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN sm.suggestion_box_available THEN 1
            ELSE 0
        END AS _32_17_suggestion_box_available,
        CASE
            WHEN (ccp.available AND ccp.tracked AND ccp.titualaire_approved) THEN 1
            ELSE 0
        END AS _32_18_customer_care_program_tracked_approved,
        CASE
            WHEN sm.qi_committe_reviewing_incidents THEN 1
            ELSE 0
        END AS _32_19_qi_committe_reviewing_incidents,
        CASE
            WHEN sm.incident_reporting_form_in_different_langauges THEN 1
            ELSE 0
        END AS _32_20_incident_reporting_form_in_different_langauges,
        CASE
            WHEN sm.patient_family_rights_posted THEN 1
            ELSE 0
        END AS _32_21_patient_family_rights_posted,
        CASE
            WHEN sm.patient_satisfaction_tool_tested_and_revised THEN 1
            ELSE 0
        END AS _32_22_patient_satisfaction_tool_tested_and_revised,
        CASE
            WHEN (si.patient_satisfaction_rate > (1)::numeric) THEN 1
            ELSE 0
        END AS _32_23_patient_satisfaction_data_aggregated_and_graphed,
        CASE
            WHEN sm.staff_satisfaction_toold_developed_and_tested THEN 1
            ELSE 0
        END AS _32_24_staff_satisfaction_toold_developed_and_tested,
        CASE
            WHEN sm.staff_satisfaction_data_has_been_aggregated_and_graphed THEN 1
            ELSE 0
        END AS _32_25_staff_satisfaction_data_has_been_aggregated_and_graphed,
        CASE
            WHEN sm.patient_staff_and_visitors_risk_of_infection_assessment_report THEN 1
            ELSE 0
        END AS _32_26_patient_staff_and_visitors_risk_of_infection_identified
   FROM (((((public.qr_codes q
     LEFT JOIN public.safety_managements sm ON ((q.id = sm.survey_id)))
     LEFT JOIN public.customer_care_programs ccp ON ((q.id = ccp.survey_id)))
     LEFT JOIN public.staff_informations si ON ((q.id = si.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_17_to26_customer_care_safety_managements OWNER TO health_builders;

--
-- Name: referral_process_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.referral_process_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    patient_identification boolean DEFAULT false NOT NULL,
    reason_for_referral boolean DEFAULT false NOT NULL,
    significant_findings boolean DEFAULT false NOT NULL,
    procedures_and_treatments boolean DEFAULT false NOT NULL,
    patient_immediate_condition boolean DEFAULT false NOT NULL,
    where_patient_is_being_transfered boolean DEFAULT false NOT NULL,
    transport_mode_and_monitoring_required boolean DEFAULT false NOT NULL,
    counter_referral_section_and_feeback boolean DEFAULT false NOT NULL,
    all_referral_cases_have_referral_sheet_copy boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.referral_process_treatment_guidelines OWNER TO health_builders;

--
-- Name: _32_1_ambulance_referral_cases_referral_sheet_copy; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_1_ambulance_referral_cases_referral_sheet_copy AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    count(rptg.patient_number) AS total_patients,
        CASE
            WHEN (count(rptg.patient_number) = 0) THEN NULL::integer
            WHEN (sum(
            CASE
                WHEN rptg.all_referral_cases_have_referral_sheet_copy THEN 1
                ELSE 0
            END) = count(rptg.patient_number)) THEN 1
            ELSE 0
        END AS _32_1_all_referral_cases_have_referral_sheet_copy
   FROM (((public.qr_codes q
     LEFT JOIN public.referral_process_treatment_guidelines rptg ON ((q.id = rptg.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, d.district, hc.name, hc.type, q.survey_year, q.district_id, q.health_center_id;


ALTER VIEW public._32_1_ambulance_referral_cases_referral_sheet_copy OWNER TO health_builders;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.accounts (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    reconciliation_done_monthly boolean DEFAULT false,
    each_account_has_separate_book boolean DEFAULT false,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.accounts OWNER TO health_builders;

--
-- Name: payables_registers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.payables_registers (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.payables_registers OWNER TO health_builders;

--
-- Name: receivables_registers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.receivables_registers (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.receivables_registers OWNER TO health_builders;

--
-- Name: _32_27_monthly_reconciliation_payables_receivables_monitored; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_27_monthly_reconciliation_payables_receivables_monitored AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN a.reconciliation_done_monthly THEN 1
            ELSE 0
        END AS reconciliation_done_monthly,
        CASE
            WHEN (pr.available AND pr.tracked) THEN 1
            ELSE 0
        END AS payables_monitored,
        CASE
            WHEN (rr.available AND rr.tracked) THEN 1
            ELSE 0
        END AS receivables_monitored,
        CASE
            WHEN (a.reconciliation_done_monthly AND pr.available AND pr.tracked AND rr.available AND rr.tracked) THEN 1
            ELSE 0
        END AS _32_27_reconciliation_done_payables_receivables_monitored
   FROM (((((public.qr_codes q
     LEFT JOIN public.accounts a ON ((q.id = a.survey_id)))
     LEFT JOIN public.payables_registers pr ON ((q.id = pr.survey_id)))
     LEFT JOIN public.receivables_registers rr ON ((q.id = rr.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_27_monthly_reconciliation_payables_receivables_monitored OWNER TO health_builders;

--
-- Name: accountings; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.accountings (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.accountings OWNER TO health_builders;

--
-- Name: ancs; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ancs (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.ancs OWNER TO health_builders;

--
-- Name: arvs; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.arvs (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.arvs OWNER TO health_builders;

--
-- Name: cashiers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.cashiers (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.cashiers OWNER TO health_builders;

--
-- Name: cehos; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.cehos (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.cehos OWNER TO health_builders;

--
-- Name: consultation_rooms; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.consultation_rooms (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.consultation_rooms OWNER TO health_builders;

--
-- Name: data_managers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.data_managers (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.data_managers OWNER TO health_builders;

--
-- Name: dispensing_pharmacies; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.dispensing_pharmacies (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.dispensing_pharmacies OWNER TO health_builders;

--
-- Name: family_plannings; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.family_plannings (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.family_plannings OWNER TO health_builders;

--
-- Name: hospitalizations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hospitalizations (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.hospitalizations OWNER TO health_builders;

--
-- Name: laboratories; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.laboratories (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.laboratories OWNER TO health_builders;

--
-- Name: matenities; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.matenities (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.matenities OWNER TO health_builders;

--
-- Name: ncds; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncds (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.ncds OWNER TO health_builders;

--
-- Name: pharmacy_stocks; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pharmacy_stocks (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.pharmacy_stocks OWNER TO health_builders;

--
-- Name: receptionists; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.receptionists (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.receptionists OWNER TO health_builders;

--
-- Name: titualaires; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.titualaires (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.titualaires OWNER TO health_builders;

--
-- Name: vaccinations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.vaccinations (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    service_labelling boolean,
    responsible_name boolean,
    responsible_photo boolean,
    current_data_displayed boolean,
    area_well_maintained boolean,
    updated_list_of_required_supplies boolean,
    updated_list_of_existing_supplies boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.vaccinations OWNER TO health_builders;

--
-- Name: _32_28_facility_services_has_required_existing_supplies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_28_facility_services_has_required_existing_supplies AS
 WITH services AS (
         SELECT q.id AS survey_id,
            q.survey_year,
            d.district,
            hc.name AS health_facility,
            hc.type AS facility_type,
                CASE
                    WHEN ancs.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS anc_required_supplies,
                CASE
                    WHEN ancs.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS anc_existing_supplies,
                CASE
                    WHEN vaccinations.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS vaccinations_required_supplies,
                CASE
                    WHEN vaccinations.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS vaccinations_existing_supplies,
                CASE
                    WHEN family_plannings.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS family_plannings_required_supplies,
                CASE
                    WHEN family_plannings.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS family_plannings_existing_supplies,
                CASE
                    WHEN pharmacy_stocks.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS pharmacy_stocks_required_supplies,
                CASE
                    WHEN pharmacy_stocks.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS pharmacy_stocks_existing_supplies,
                CASE
                    WHEN dispensing_pharmacies.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS dispensing_pharmacies_required_supplies,
                CASE
                    WHEN dispensing_pharmacies.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS dispensing_pharmacies_existing_supplies,
                CASE
                    WHEN ncds.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS ncds_required_supplies,
                CASE
                    WHEN ncds.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS ncds_existing_supplies,
                CASE
                    WHEN cehos.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS cehos_required_supplies,
                CASE
                    WHEN cehos.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS cehos_existing_supplies,
                CASE
                    WHEN cashiers.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS cashiers_required_supplies,
                CASE
                    WHEN cashiers.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS cashiers_existing_supplies,
                CASE
                    WHEN accountings.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS accountings_required_supplies,
                CASE
                    WHEN accountings.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS accountings_existing_supplies,
                CASE
                    WHEN laboratories.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS laboratories_required_supplies,
                CASE
                    WHEN laboratories.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS laboratories_existing_supplies,
                CASE
                    WHEN titualaires.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS titualaires_required_supplies,
                CASE
                    WHEN titualaires.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS titualaires_existing_supplies,
                CASE
                    WHEN data_managers.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS data_managers_required_supplies,
                CASE
                    WHEN data_managers.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS data_managers_existing_supplies,
                CASE
                    WHEN arvs.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS arvs_required_supplies,
                CASE
                    WHEN arvs.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS arvs_existing_supplies,
                CASE
                    WHEN receptionists.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS receptionists_required_supplies,
                CASE
                    WHEN receptionists.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS receptionists_existing_supplies,
                CASE
                    WHEN consultation_rooms.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS consultation_rooms_required_supplies,
                CASE
                    WHEN consultation_rooms.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS consultation_rooms_existing_supplies,
                CASE
                    WHEN matenities.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS matenities_required_supplies,
                CASE
                    WHEN matenities.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS matenities_existing_supplies,
                CASE
                    WHEN hospitalizations.updated_list_of_required_supplies THEN 1
                    ELSE 0
                END AS hospitalizations_required_supplies,
                CASE
                    WHEN hospitalizations.updated_list_of_existing_supplies THEN 1
                    ELSE 0
                END AS hospitalizations_existing_supplies
           FROM (((((((((((((((((((public.qr_codes q
             LEFT JOIN public.districts d ON ((q.district_id = d.id)))
             LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
             LEFT JOIN public.ancs ON ((q.id = ancs.survey_id)))
             LEFT JOIN public.vaccinations ON ((q.id = vaccinations.survey_id)))
             LEFT JOIN public.family_plannings ON ((q.id = family_plannings.survey_id)))
             LEFT JOIN public.pharmacy_stocks ON ((q.id = pharmacy_stocks.survey_id)))
             LEFT JOIN public.dispensing_pharmacies ON ((q.id = dispensing_pharmacies.survey_id)))
             LEFT JOIN public.ncds ON ((q.id = ncds.survey_id)))
             LEFT JOIN public.cehos ON ((q.id = cehos.survey_id)))
             LEFT JOIN public.cashiers ON ((q.id = cashiers.survey_id)))
             LEFT JOIN public.accountings ON ((q.id = accountings.survey_id)))
             LEFT JOIN public.laboratories ON ((q.id = laboratories.survey_id)))
             LEFT JOIN public.titualaires ON ((q.id = titualaires.survey_id)))
             LEFT JOIN public.data_managers ON ((q.id = data_managers.survey_id)))
             LEFT JOIN public.arvs ON ((q.id = arvs.survey_id)))
             LEFT JOIN public.receptionists ON ((q.id = receptionists.survey_id)))
             LEFT JOIN public.consultation_rooms ON ((q.id = consultation_rooms.survey_id)))
             LEFT JOIN public.matenities ON ((q.id = matenities.survey_id)))
             LEFT JOIN public.hospitalizations ON ((q.id = hospitalizations.survey_id)))
        )
 SELECT services.survey_id,
    services.survey_year,
    services.district,
    services.health_facility,
    services.facility_type,
    services.anc_required_supplies,
    services.anc_existing_supplies,
    services.vaccinations_required_supplies,
    services.vaccinations_existing_supplies,
    services.family_plannings_required_supplies,
    services.family_plannings_existing_supplies,
    services.pharmacy_stocks_required_supplies,
    services.pharmacy_stocks_existing_supplies,
    services.dispensing_pharmacies_required_supplies,
    services.dispensing_pharmacies_existing_supplies,
    services.ncds_required_supplies,
    services.ncds_existing_supplies,
    services.cehos_required_supplies,
    services.cehos_existing_supplies,
    services.cashiers_required_supplies,
    services.cashiers_existing_supplies,
    services.accountings_required_supplies,
    services.accountings_existing_supplies,
    services.laboratories_required_supplies,
    services.laboratories_existing_supplies,
    services.titualaires_required_supplies,
    services.titualaires_existing_supplies,
    services.data_managers_required_supplies,
    services.data_managers_existing_supplies,
    services.arvs_required_supplies,
    services.arvs_existing_supplies,
    services.receptionists_required_supplies,
    services.receptionists_existing_supplies,
    services.consultation_rooms_required_supplies,
    services.consultation_rooms_existing_supplies,
    services.matenities_required_supplies,
    services.matenities_existing_supplies,
    services.hospitalizations_required_supplies,
    services.hospitalizations_existing_supplies,
    (round((((((((((((((((((((services.anc_required_supplies + services.anc_existing_supplies) + (services.vaccinations_required_supplies + services.vaccinations_existing_supplies)) + (services.family_plannings_required_supplies + services.family_plannings_existing_supplies)) + (services.pharmacy_stocks_required_supplies + services.pharmacy_stocks_existing_supplies)) + (services.dispensing_pharmacies_required_supplies + services.dispensing_pharmacies_existing_supplies)) + (services.ncds_required_supplies + services.ncds_existing_supplies)) + (services.cehos_required_supplies + services.cehos_existing_supplies)) + (services.cashiers_required_supplies + services.cashiers_existing_supplies)) + (services.accountings_required_supplies + services.accountings_existing_supplies)) + (services.laboratories_required_supplies + services.laboratories_existing_supplies)) + (services.titualaires_required_supplies + services.titualaires_existing_supplies)) + (services.data_managers_required_supplies + services.data_managers_existing_supplies)) + (services.arvs_required_supplies + services.arvs_existing_supplies)) + (services.receptionists_required_supplies + services.receptionists_existing_supplies)) + (services.consultation_rooms_required_supplies + services.consultation_rooms_existing_supplies)) + (services.matenities_required_supplies + services.matenities_existing_supplies)) + (services.hospitalizations_required_supplies + services.hospitalizations_existing_supplies)))::numeric / (34)::numeric), 2) * (100)::numeric) AS percentage,
        CASE
            WHEN ((((((((((((((((((((((((((((((((((((services.anc_required_supplies + services.anc_existing_supplies) + services.vaccinations_required_supplies) + services.vaccinations_existing_supplies) + services.family_plannings_required_supplies) + services.family_plannings_existing_supplies) + services.pharmacy_stocks_required_supplies) + services.pharmacy_stocks_existing_supplies) + services.dispensing_pharmacies_required_supplies) + services.dispensing_pharmacies_existing_supplies) + services.ncds_required_supplies) + services.ncds_existing_supplies) + services.cehos_required_supplies) + services.cehos_existing_supplies) + services.cashiers_required_supplies) + services.cashiers_existing_supplies) + services.accountings_required_supplies) + services.accountings_existing_supplies) + services.laboratories_required_supplies) + services.laboratories_existing_supplies) + services.titualaires_required_supplies) + services.titualaires_existing_supplies) + services.data_managers_required_supplies) + services.data_managers_existing_supplies) + services.arvs_required_supplies) + services.arvs_existing_supplies) + services.receptionists_required_supplies) + services.receptionists_existing_supplies) + services.consultation_rooms_required_supplies) + services.consultation_rooms_existing_supplies) + services.matenities_required_supplies) + services.matenities_existing_supplies) + services.hospitalizations_required_supplies) + services.hospitalizations_existing_supplies))::numeric / NULLIF(((2)::numeric * (17)::numeric), (0)::numeric)) >= 0.7) THEN 1
            ELSE 0
        END AS _32_28_70_percent_of_services_have_required_existing_supplies
   FROM services;


ALTER VIEW public._32_28_facility_services_has_required_existing_supplies OWNER TO health_builders;

--
-- Name: _32_29_staff_names_photos_on_each_service_door; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_29_staff_names_photos_on_each_service_door AS
 WITH services AS (
         SELECT q.id AS survey_id,
            q.survey_year,
            d.district,
            hc.name AS health_facility,
            hc.type AS facility_type,
                CASE
                    WHEN ancs.responsible_photo THEN 1
                    ELSE 0
                END AS anc_responsible_photo,
                CASE
                    WHEN ancs.responsible_name THEN 1
                    ELSE 0
                END AS anc_responsible_name,
                CASE
                    WHEN vaccinations.responsible_photo THEN 1
                    ELSE 0
                END AS vaccinations_responsible_photo,
                CASE
                    WHEN vaccinations.responsible_name THEN 1
                    ELSE 0
                END AS vaccinations_responsible_name,
                CASE
                    WHEN family_plannings.responsible_photo THEN 1
                    ELSE 0
                END AS family_plannings_responsible_photo,
                CASE
                    WHEN family_plannings.responsible_name THEN 1
                    ELSE 0
                END AS family_plannings_responsible_name,
                CASE
                    WHEN pharmacy_stocks.responsible_photo THEN 1
                    ELSE 0
                END AS pharmacy_stocks_responsible_photo,
                CASE
                    WHEN pharmacy_stocks.responsible_name THEN 1
                    ELSE 0
                END AS pharmacy_stocks_responsible_name,
                CASE
                    WHEN dispensing_pharmacies.responsible_photo THEN 1
                    ELSE 0
                END AS dispensing_pharmacies_responsible_photo,
                CASE
                    WHEN dispensing_pharmacies.responsible_name THEN 1
                    ELSE 0
                END AS dispensing_pharmacies_responsible_name,
                CASE
                    WHEN ncds.responsible_photo THEN 1
                    ELSE 0
                END AS ncds_responsible_photo,
                CASE
                    WHEN ncds.responsible_name THEN 1
                    ELSE 0
                END AS ncds_responsible_name,
                CASE
                    WHEN cehos.responsible_photo THEN 1
                    ELSE 0
                END AS cehos_responsible_photo,
                CASE
                    WHEN cehos.responsible_name THEN 1
                    ELSE 0
                END AS cehos_responsible_name,
                CASE
                    WHEN cashiers.responsible_photo THEN 1
                    ELSE 0
                END AS cashiers_responsible_photo,
                CASE
                    WHEN cashiers.responsible_name THEN 1
                    ELSE 0
                END AS cashiers_responsible_name,
                CASE
                    WHEN accountings.responsible_photo THEN 1
                    ELSE 0
                END AS accountings_responsible_photo,
                CASE
                    WHEN accountings.responsible_name THEN 1
                    ELSE 0
                END AS accountings_responsible_name,
                CASE
                    WHEN laboratories.responsible_photo THEN 1
                    ELSE 0
                END AS laboratories_responsible_photo,
                CASE
                    WHEN laboratories.responsible_name THEN 1
                    ELSE 0
                END AS laboratories_responsible_name,
                CASE
                    WHEN titualaires.responsible_photo THEN 1
                    ELSE 0
                END AS titualaires_responsible_photo,
                CASE
                    WHEN titualaires.responsible_name THEN 1
                    ELSE 0
                END AS titualaires_responsible_name,
                CASE
                    WHEN data_managers.responsible_photo THEN 1
                    ELSE 0
                END AS data_managers_responsible_photo,
                CASE
                    WHEN data_managers.responsible_name THEN 1
                    ELSE 0
                END AS data_managers_responsible_name,
                CASE
                    WHEN arvs.responsible_photo THEN 1
                    ELSE 0
                END AS arvs_responsible_photo,
                CASE
                    WHEN arvs.responsible_name THEN 1
                    ELSE 0
                END AS arvs_responsible_name,
                CASE
                    WHEN receptionists.responsible_photo THEN 1
                    ELSE 0
                END AS receptionists_responsible_photo,
                CASE
                    WHEN receptionists.responsible_name THEN 1
                    ELSE 0
                END AS receptionists_responsible_name,
                CASE
                    WHEN consultation_rooms.responsible_photo THEN 1
                    ELSE 0
                END AS consultation_rooms_responsible_photo,
                CASE
                    WHEN consultation_rooms.responsible_name THEN 1
                    ELSE 0
                END AS consultation_rooms_responsible_name,
                CASE
                    WHEN matenities.responsible_photo THEN 1
                    ELSE 0
                END AS matenities_responsible_photo,
                CASE
                    WHEN matenities.responsible_name THEN 1
                    ELSE 0
                END AS matenities_responsible_name
           FROM ((((((((((((((((((public.qr_codes q
             LEFT JOIN public.districts d ON ((q.district_id = d.id)))
             LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
             LEFT JOIN public.ancs ON ((q.id = ancs.survey_id)))
             LEFT JOIN public.vaccinations ON ((q.id = vaccinations.survey_id)))
             LEFT JOIN public.family_plannings ON ((q.id = family_plannings.survey_id)))
             LEFT JOIN public.pharmacy_stocks ON ((q.id = pharmacy_stocks.survey_id)))
             LEFT JOIN public.dispensing_pharmacies ON ((q.id = dispensing_pharmacies.survey_id)))
             LEFT JOIN public.ncds ON ((q.id = ncds.survey_id)))
             LEFT JOIN public.cehos ON ((q.id = cehos.survey_id)))
             LEFT JOIN public.cashiers ON ((q.id = cashiers.survey_id)))
             LEFT JOIN public.accountings ON ((q.id = accountings.survey_id)))
             LEFT JOIN public.laboratories ON ((q.id = laboratories.survey_id)))
             LEFT JOIN public.titualaires ON ((q.id = titualaires.survey_id)))
             LEFT JOIN public.data_managers ON ((q.id = data_managers.survey_id)))
             LEFT JOIN public.arvs ON ((q.id = arvs.survey_id)))
             LEFT JOIN public.receptionists ON ((q.id = receptionists.survey_id)))
             LEFT JOIN public.consultation_rooms ON ((q.id = consultation_rooms.survey_id)))
             LEFT JOIN public.matenities ON ((q.id = matenities.survey_id)))
        )
 SELECT services.survey_id,
    services.survey_year,
    services.district,
    services.health_facility,
    services.facility_type,
    services.anc_responsible_photo,
    services.anc_responsible_name,
    services.vaccinations_responsible_photo,
    services.vaccinations_responsible_name,
    services.family_plannings_responsible_photo,
    services.family_plannings_responsible_name,
    services.pharmacy_stocks_responsible_photo,
    services.pharmacy_stocks_responsible_name,
    services.dispensing_pharmacies_responsible_photo,
    services.dispensing_pharmacies_responsible_name,
    services.ncds_responsible_photo,
    services.ncds_responsible_name,
    services.cehos_responsible_photo,
    services.cehos_responsible_name,
    services.cashiers_responsible_photo,
    services.cashiers_responsible_name,
    services.accountings_responsible_photo,
    services.accountings_responsible_name,
    services.laboratories_responsible_photo,
    services.laboratories_responsible_name,
    services.titualaires_responsible_photo,
    services.titualaires_responsible_name,
    services.data_managers_responsible_photo,
    services.data_managers_responsible_name,
    services.arvs_responsible_photo,
    services.arvs_responsible_name,
    services.receptionists_responsible_photo,
    services.receptionists_responsible_name,
    services.consultation_rooms_responsible_photo,
    services.consultation_rooms_responsible_name,
    services.matenities_responsible_photo,
    services.matenities_responsible_name,
    (round(((((((((((((((((((services.anc_responsible_photo + services.anc_responsible_name) + (services.vaccinations_responsible_photo + services.vaccinations_responsible_name)) + (services.family_plannings_responsible_photo + services.family_plannings_responsible_name)) + (services.pharmacy_stocks_responsible_photo + services.pharmacy_stocks_responsible_name)) + (services.dispensing_pharmacies_responsible_photo + services.dispensing_pharmacies_responsible_name)) + (services.ncds_responsible_photo + services.ncds_responsible_name)) + (services.cehos_responsible_photo + services.cehos_responsible_name)) + (services.cashiers_responsible_photo + services.cashiers_responsible_name)) + (services.accountings_responsible_photo + services.accountings_responsible_name)) + (services.laboratories_responsible_photo + services.laboratories_responsible_name)) + (services.titualaires_responsible_photo + services.titualaires_responsible_name)) + (services.data_managers_responsible_photo + services.data_managers_responsible_name)) + (services.arvs_responsible_photo + services.arvs_responsible_name)) + (services.receptionists_responsible_photo + services.receptionists_responsible_name)) + (services.consultation_rooms_responsible_photo + services.consultation_rooms_responsible_name)) + (services.matenities_responsible_photo + services.matenities_responsible_name)))::numeric / (32)::numeric), 2) * (100)::numeric) AS percentage,
        CASE
            WHEN (((((((((((((((((((((((((((((((((((services.anc_responsible_photo + services.anc_responsible_name) + services.vaccinations_responsible_photo) + services.vaccinations_responsible_name) + services.family_plannings_responsible_photo) + services.family_plannings_responsible_name) + services.pharmacy_stocks_responsible_photo) + services.pharmacy_stocks_responsible_name) + services.dispensing_pharmacies_responsible_photo) + services.dispensing_pharmacies_responsible_name) + services.ncds_responsible_photo) + services.ncds_responsible_name) + services.cehos_responsible_photo) + services.cehos_responsible_name) + services.cashiers_responsible_photo) + services.cashiers_responsible_name) + services.accountings_responsible_photo) + services.accountings_responsible_name) + services.laboratories_responsible_photo) + services.laboratories_responsible_name) + services.titualaires_responsible_photo) + services.titualaires_responsible_name) + services.data_managers_responsible_photo) + services.data_managers_responsible_name) + services.arvs_responsible_photo) + services.arvs_responsible_name) + services.receptionists_responsible_photo) + services.receptionists_responsible_name) + services.consultation_rooms_responsible_photo) + services.consultation_rooms_responsible_name) + services.matenities_responsible_photo) + services.matenities_responsible_name))::numeric / (32)::numeric) * (100)::numeric) >= (75)::numeric) THEN 1
            ELSE 0
        END AS _32_29_staff_names_photos_on_each_service_door
   FROM services;


ALTER VIEW public._32_29_staff_names_photos_on_each_service_door OWNER TO health_builders;

--
-- Name: qi_plans; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.qi_plans (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    communicated_to_staff boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.qi_plans OWNER TO health_builders;

--
-- Name: _32_2_qi_plan; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_2_qi_plan AS
 SELECT qc.id AS survey_id,
    qc.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (qp.available = true) THEN 1
            ELSE 0
        END AS plan_available,
        CASE
            WHEN (qp.tracked = true) THEN 1
            ELSE 0
        END AS plan_tracked,
        CASE
            WHEN (qp.titualaire_approved = true) THEN 1
            ELSE 0
        END AS plan_approved,
        CASE
            WHEN ((qp.available = true) AND (qp.tracked = true) AND (qp.titualaire_approved = true)) THEN 1
            ELSE 0
        END AS _32_2_qi_plan_tacked_and_approved
   FROM (((public.qr_codes qc
     LEFT JOIN public.qi_plans qp ON ((qc.id = qp.survey_id)))
     LEFT JOIN public.districts d ON ((qc.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qc.health_center_id = hc.id)));


ALTER VIEW public._32_2_qi_plan OWNER TO health_builders;

--
-- Name: toilets; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.toilets (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    area_well_maintained boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.toilets OWNER TO health_builders;

--
-- Name: _32_30_facility_services_have_hand_hygiene_procedures; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_30_facility_services_have_hand_hygiene_procedures AS
 WITH services AS (
         SELECT q.id AS survey_id,
            q.survey_year,
            d.district,
            hc.name AS health_facility,
            hc.type AS facility_type,
                CASE
                    WHEN ancs.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS anc_hand_hygiene_procedures_evidence,
                CASE
                    WHEN vaccinations.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS vaccinations_hand_hygiene_procedures_evidence,
                CASE
                    WHEN dispensing_pharmacies.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS dispensing_pharmacies_hand_hygiene_procedures_evidence,
                CASE
                    WHEN ncds.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS ncds_hand_hygiene_procedures_evidence,
                CASE
                    WHEN laboratories.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS laboratories_hand_hygiene_procedures_evidence,
                CASE
                    WHEN receptionists.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS receptionists_hand_hygiene_procedures_evidence,
                CASE
                    WHEN consultation_rooms.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS consultation_rooms_hand_hygiene_procedures_evidence,
                CASE
                    WHEN matenities.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS matenities_hand_hygiene_procedures_evidence,
                CASE
                    WHEN hospitalizations.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS hospitalizations_hand_hygiene_procedures_evidence,
                CASE
                    WHEN toilets.hand_hygiene_procedures_based_on_current_evidence THEN 1
                    ELSE 0
                END AS toilets_hand_hygiene_procedures_evidence
           FROM ((((((((((((public.qr_codes q
             LEFT JOIN public.districts d ON ((q.district_id = d.id)))
             LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
             LEFT JOIN public.ancs ON ((q.id = ancs.survey_id)))
             LEFT JOIN public.vaccinations ON ((q.id = vaccinations.survey_id)))
             LEFT JOIN public.dispensing_pharmacies ON ((q.id = dispensing_pharmacies.survey_id)))
             LEFT JOIN public.ncds ON ((q.id = ncds.survey_id)))
             LEFT JOIN public.laboratories ON ((q.id = laboratories.survey_id)))
             LEFT JOIN public.receptionists ON ((q.id = receptionists.survey_id)))
             LEFT JOIN public.consultation_rooms ON ((q.id = consultation_rooms.survey_id)))
             LEFT JOIN public.matenities ON ((q.id = matenities.survey_id)))
             LEFT JOIN public.hospitalizations ON ((q.id = hospitalizations.survey_id)))
             LEFT JOIN public.toilets ON ((q.id = toilets.survey_id)))
        )
 SELECT services.survey_id,
    services.survey_year,
    services.district,
    services.health_facility,
    services.facility_type,
    services.anc_hand_hygiene_procedures_evidence,
    services.vaccinations_hand_hygiene_procedures_evidence,
    services.dispensing_pharmacies_hand_hygiene_procedures_evidence,
    services.ncds_hand_hygiene_procedures_evidence,
    services.laboratories_hand_hygiene_procedures_evidence,
    services.receptionists_hand_hygiene_procedures_evidence,
    services.consultation_rooms_hand_hygiene_procedures_evidence,
    services.matenities_hand_hygiene_procedures_evidence,
    services.hospitalizations_hand_hygiene_procedures_evidence,
    services.toilets_hand_hygiene_procedures_evidence,
    (round((((((((((((services.anc_hand_hygiene_procedures_evidence + services.vaccinations_hand_hygiene_procedures_evidence) + services.dispensing_pharmacies_hand_hygiene_procedures_evidence) + services.ncds_hand_hygiene_procedures_evidence) + services.laboratories_hand_hygiene_procedures_evidence) + services.receptionists_hand_hygiene_procedures_evidence) + services.consultation_rooms_hand_hygiene_procedures_evidence) + services.matenities_hand_hygiene_procedures_evidence) + services.hospitalizations_hand_hygiene_procedures_evidence) + services.toilets_hand_hygiene_procedures_evidence))::numeric / (10)::numeric), 2) * (100)::numeric) AS percentage,
        CASE
            WHEN ((((((((((((services.anc_hand_hygiene_procedures_evidence + services.vaccinations_hand_hygiene_procedures_evidence) + services.dispensing_pharmacies_hand_hygiene_procedures_evidence) + services.ncds_hand_hygiene_procedures_evidence) + services.laboratories_hand_hygiene_procedures_evidence) + services.receptionists_hand_hygiene_procedures_evidence) + services.consultation_rooms_hand_hygiene_procedures_evidence) + services.matenities_hand_hygiene_procedures_evidence) + services.hospitalizations_hand_hygiene_procedures_evidence) + services.toilets_hand_hygiene_procedures_evidence))::numeric / NULLIF(((2)::numeric * (5)::numeric), (0)::numeric)) >= 0.75) THEN 1
            ELSE 0
        END AS _32_30_80_percent_of_services_have_hand_hygiene_procedures
   FROM services;


ALTER VIEW public._32_30_facility_services_have_hand_hygiene_procedures OWNER TO health_builders;

--
-- Name: focal_persons; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.focal_persons (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    quality_improvement_focal_person boolean,
    ip_c_focal_person boolean,
    customer_care_focal_person boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.focal_persons OWNER TO health_builders;

--
-- Name: _32_31_to32_focal_persons; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_31_to32_focal_persons AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (fp.quality_improvement_focal_person = true) THEN 1
            ELSE 0
        END AS _32_31_qi_focal_person_available,
        CASE
            WHEN (fp.ip_c_focal_person = true) THEN 1
            ELSE 0
        END AS _32_32_ipc_focal_person_available
   FROM (((public.qr_codes q
     LEFT JOIN public.focal_persons fp ON ((q.id = fp.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_31_to32_focal_persons OWNER TO health_builders;

--
-- Name: _32_3_inpatient_assessment_forms_collect_required_info; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_3_inpatient_assessment_forms_collect_required_info AS
 WITH patient_data AS (
         SELECT ictg.survey_id,
            count(*) AS total_patients,
            sum((ictg.biographical_data_complete)::integer) AS total_biographical_data_complete,
            sum((ictg.relevant_history_complete)::integer) AS total_relevant_history_complete,
            sum((ictg.chief_complaints)::integer) AS total_chief_complaints,
            sum((ictg.rapid_survey)::integer) AS total_rapid_survey,
            sum((ictg.vital_signs_and_anthropometrics)::integer) AS total_vital_signs_and_anthropometrics,
            sum((ictg.exam_of_systems)::integer) AS total_exam_of_systems,
            sum((ictg.diagnosis)::integer) AS total_diagnosis,
            sum((ictg.nursing_care_plan)::integer) AS total_nursing_care_plan,
            sum((ictg.soap_note)::integer) AS total_soap_note,
            sum((ictg.treatment_plan_revised_according_to_reassesment_results)::integer) AS total_treatment_plan_revised_according_to_reassesment_results
           FROM public.inpatients_care_treatment_guidelines ictg
          GROUP BY ictg.survey_id
        )
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    COALESCE(pd.total_patients, (0)::bigint) AS total_patients,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_biographical_data_complete
        END AS total_biographical_data_complete,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_relevant_history_complete
        END AS total_relevant_history_complete,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_chief_complaints
        END AS total_chief_complaints,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_rapid_survey
        END AS total_rapid_survey,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_vital_signs_and_anthropometrics
        END AS total_vital_signs_and_anthropometrics,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_exam_of_systems
        END AS total_exam_of_systems,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_diagnosis
        END AS total_diagnosis,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_nursing_care_plan
        END AS total_nursing_care_plan,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_soap_note
        END AS total_soap_note,
        CASE
            WHEN (pd.total_patients = 0) THEN NULL::bigint
            ELSE pd.total_treatment_plan_revised_according_to_reassesment_results
        END AS total_treatment_plan_revised_according_to_reassesment_results,
        CASE
            WHEN ((pd.total_patients > 0) AND (pd.total_biographical_data_complete = pd.total_patients) AND (pd.total_relevant_history_complete = pd.total_patients) AND (pd.total_chief_complaints = pd.total_patients) AND (pd.total_rapid_survey = pd.total_patients) AND (pd.total_vital_signs_and_anthropometrics = pd.total_patients) AND (pd.total_exam_of_systems = pd.total_patients) AND (pd.total_diagnosis = pd.total_patients) AND (pd.total_nursing_care_plan = pd.total_patients) AND (pd.total_soap_note = pd.total_patients) AND (pd.total_treatment_plan_revised_according_to_reassesment_results = pd.total_patients)) THEN 1
            ELSE 0
        END AS _32_3_inpatient_assessment_forms_collect_required_info
   FROM (((public.qr_codes q
     LEFT JOIN patient_data pd ON ((q.id = pd.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_3_inpatient_assessment_forms_collect_required_info OWNER TO health_builders;

--
-- Name: _32_4_facility_services_have_hand_hygiene_supplies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_4_facility_services_have_hand_hygiene_supplies AS
 WITH services AS (
         SELECT q.id AS survey_id,
            q.survey_year,
            d.district,
            hc.name AS health_facility,
            hc.type AS facility_type,
                CASE
                    WHEN ancs.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS anc_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN vaccinations.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS vaccinations_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN dispensing_pharmacies.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS dispensing_pharmacies_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN ncds.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS ncds_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN laboratories.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS laboratories_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN receptionists.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS receptionists_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN consultation_rooms.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS consultation_rooms_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN matenities.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS matenities_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN hospitalizations.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS hospitalizations_supplies_located_in_each_hygiene_facility,
                CASE
                    WHEN toilets.supplies_located_in_each_hygiene_facility THEN 1
                    ELSE 0
                END AS toilets_supplies_located_in_each_hygiene_facility
           FROM ((((((((((((public.qr_codes q
             LEFT JOIN public.districts d ON ((q.district_id = d.id)))
             LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
             LEFT JOIN public.ancs ON ((q.id = ancs.survey_id)))
             LEFT JOIN public.vaccinations ON ((q.id = vaccinations.survey_id)))
             LEFT JOIN public.dispensing_pharmacies ON ((q.id = dispensing_pharmacies.survey_id)))
             LEFT JOIN public.ncds ON ((q.id = ncds.survey_id)))
             LEFT JOIN public.laboratories ON ((q.id = laboratories.survey_id)))
             LEFT JOIN public.receptionists ON ((q.id = receptionists.survey_id)))
             LEFT JOIN public.consultation_rooms ON ((q.id = consultation_rooms.survey_id)))
             LEFT JOIN public.matenities ON ((q.id = matenities.survey_id)))
             LEFT JOIN public.hospitalizations ON ((q.id = hospitalizations.survey_id)))
             LEFT JOIN public.toilets ON ((q.id = toilets.survey_id)))
        )
 SELECT services.survey_id,
    services.survey_year,
    services.district,
    services.health_facility,
    services.facility_type,
    services.anc_supplies_located_in_each_hygiene_facility,
    services.vaccinations_supplies_located_in_each_hygiene_facility,
    services.dispensing_pharmacies_supplies_located_in_each_hygiene_facility,
    services.ncds_supplies_located_in_each_hygiene_facility,
    services.laboratories_supplies_located_in_each_hygiene_facility,
    services.receptionists_supplies_located_in_each_hygiene_facility,
    services.consultation_rooms_supplies_located_in_each_hygiene_facility,
    services.matenities_supplies_located_in_each_hygiene_facility,
    services.hospitalizations_supplies_located_in_each_hygiene_facility,
    services.toilets_supplies_located_in_each_hygiene_facility,
    (round((((((((((((services.anc_supplies_located_in_each_hygiene_facility + services.vaccinations_supplies_located_in_each_hygiene_facility) + services.dispensing_pharmacies_supplies_located_in_each_hygiene_facility) + services.ncds_supplies_located_in_each_hygiene_facility) + services.laboratories_supplies_located_in_each_hygiene_facility) + services.receptionists_supplies_located_in_each_hygiene_facility) + services.consultation_rooms_supplies_located_in_each_hygiene_facility) + services.matenities_supplies_located_in_each_hygiene_facility) + services.hospitalizations_supplies_located_in_each_hygiene_facility) + services.toilets_supplies_located_in_each_hygiene_facility))::numeric / (10)::numeric), 2) * (100)::numeric) AS percentage,
        CASE
            WHEN ((((((((((((services.anc_supplies_located_in_each_hygiene_facility + services.vaccinations_supplies_located_in_each_hygiene_facility) + services.dispensing_pharmacies_supplies_located_in_each_hygiene_facility) + services.ncds_supplies_located_in_each_hygiene_facility) + services.laboratories_supplies_located_in_each_hygiene_facility) + services.receptionists_supplies_located_in_each_hygiene_facility) + services.consultation_rooms_supplies_located_in_each_hygiene_facility) + services.matenities_supplies_located_in_each_hygiene_facility) + services.hospitalizations_supplies_located_in_each_hygiene_facility) + services.toilets_supplies_located_in_each_hygiene_facility))::numeric / NULLIF(((2)::numeric * (5)::numeric), (0)::numeric)) >= 0.8) THEN 1
            ELSE 0
        END AS _32_4_80_percent_of_services_have_hand_hygiene_supplies
   FROM services;


ALTER VIEW public._32_4_facility_services_have_hand_hygiene_supplies OWNER TO health_builders;

--
-- Name: annual_malaria_prevention_plans; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.annual_malaria_prevention_plans (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.annual_malaria_prevention_plans OWNER TO health_builders;

--
-- Name: _32_5_annual_malaria_prevention_plan_est; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_5_annual_malaria_prevention_plan_est AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    COALESCE((mpp.available)::integer, 0) AS malaria_plan_available,
    COALESCE((mpp.tracked)::integer, 0) AS malaria_plan_tracked,
    COALESCE((mpp.titualaire_approved)::integer, 0) AS malaria_plan_titualaire_approved,
        CASE
            WHEN ((mpp.available = true) AND (mpp.tracked = true) AND (mpp.titualaire_approved = true)) THEN 1
            ELSE 0
        END AS _32_5_annual_malaria_prevention_plan_established
   FROM (((public.qr_codes qr
     LEFT JOIN public.annual_malaria_prevention_plans mpp ON ((qr.id = mpp.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._32_5_annual_malaria_prevention_plan_est OWNER TO health_builders;

--
-- Name: _32_6_malaria_protocols_treatment_guidelines_available; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_6_malaria_protocols_treatment_guidelines_available AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN tg.available THEN 1
            ELSE 0
        END AS malaria_available,
        CASE
            WHEN tg.up_to_date THEN 1
            ELSE 0
        END AS malaria_uptodate,
        CASE
            WHEN tg.service_informed THEN 1
            ELSE 0
        END AS malaria_informed,
        CASE
            WHEN (tg.available AND tg.up_to_date AND tg.service_informed) THEN 1
            ELSE 0
        END AS _32_6_malaria_protocols_treatment_guidelines_available
   FROM (((public.qr_codes q
     JOIN public.treatment_guidelines tg ON ((q.id = tg.survey_id)))
     JOIN public.districts d ON ((q.district_id = d.id)))
     JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  WHERE (tg.treatment_guideline = 'Malaria'::text);


ALTER VIEW public._32_6_malaria_protocols_treatment_guidelines_available OWNER TO health_builders;

--
-- Name: malaria_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.malaria_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    assessment_is_complete boolean DEFAULT false NOT NULL,
    classification_is_accurate boolean DEFAULT false NOT NULL,
    correct_anti_malaria_treatment_provided boolean DEFAULT false NOT NULL,
    patient_educated boolean DEFAULT false NOT NULL,
    follow_up_appointment_given boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.malaria_treatment_guidelines OWNER TO health_builders;

--
-- Name: _32_7_malaria_protocols_implemented; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_7_malaria_protocols_implemented AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    count(mtg.id) AS total_patients,
    sum(
        CASE
            WHEN mtg.assessment_is_complete THEN 1
            ELSE 0
        END) AS total_assessment_is_complete,
    sum(
        CASE
            WHEN mtg.classification_is_accurate THEN 1
            ELSE 0
        END) AS total_classification_is_accurate,
    sum(
        CASE
            WHEN mtg.correct_anti_malaria_treatment_provided THEN 1
            ELSE 0
        END) AS total_correct_anti_malaria_treatment_provided,
    sum(
        CASE
            WHEN mtg.patient_educated THEN 1
            ELSE 0
        END) AS total_patient_educated,
    sum(
        CASE
            WHEN mtg.follow_up_appointment_given THEN 1
            ELSE 0
        END) AS total_follow_up_appointment_given,
    round((((((((sum(
        CASE
            WHEN mtg.assessment_is_complete THEN 1
            ELSE 0
        END) + sum(
        CASE
            WHEN mtg.classification_is_accurate THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.correct_anti_malaria_treatment_provided THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.patient_educated THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.follow_up_appointment_given THEN 1
            ELSE 0
        END)))::numeric / NULLIF(((count(mtg.id) * 5))::numeric, (0)::numeric)) * (100)::numeric), 2) AS percentage,
        CASE
            WHEN (((((((sum(
            CASE
                WHEN mtg.assessment_is_complete THEN 1
                ELSE 0
            END) + sum(
            CASE
                WHEN mtg.classification_is_accurate THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.correct_anti_malaria_treatment_provided THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.patient_educated THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.follow_up_appointment_given THEN 1
                ELSE 0
            END)))::numeric / NULLIF(((count(mtg.id) * 5))::numeric, (0)::numeric)) >= 0.70) THEN 1
            ELSE 0
        END AS _32_7_malaria_protocols_implemented
   FROM (((public.qr_codes q
     LEFT JOIN public.malaria_treatment_guidelines mtg ON ((q.id = mtg.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, d.district, hc.name, hc.type, q.survey_year, q.district_id, q.health_center_id;


ALTER VIEW public._32_7_malaria_protocols_implemented OWNER TO health_builders;

--
-- Name: diabetes_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint,
    current_protocol_available boolean DEFAULT false,
    hbalc_checked boolean DEFAULT false,
    bg_checked_each_visit boolean DEFAULT false NOT NULL,
    eye_checked_last12_months boolean DEFAULT false,
    foot_checked_last12_months boolean DEFAULT false NOT NULL,
    urine_protein_checked_last6_months boolean DEFAULT false NOT NULL,
    creatinine_checked_last12_months boolean DEFAULT false NOT NULL,
    correct_treatment_provided boolean DEFAULT false,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diabetes_treatment_guidelines OWNER TO health_builders;

--
-- Name: _32_diabetes_protocols_implemented; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_diabetes_protocols_implemented AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    count(mtg.id) AS total_patients,
    sum(
        CASE
            WHEN mtg.foot_checked_last12_months THEN 1
            ELSE 0
        END) AS total_foot_checked_last12_months,
    sum(
        CASE
            WHEN mtg.bg_checked_each_visit THEN 1
            ELSE 0
        END) AS total_bp_checked_each_visit,
    sum(
        CASE
            WHEN mtg.urine_protein_checked_last6_months THEN 1
            ELSE 0
        END) AS total_urine_protein_checked_last6_months,
    sum(
        CASE
            WHEN mtg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END) AS total_creatinine_checked_last12_months,
    round(((((((sum(
        CASE
            WHEN mtg.foot_checked_last12_months THEN 1
            ELSE 0
        END) + sum(
        CASE
            WHEN mtg.bg_checked_each_visit THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.urine_protein_checked_last6_months THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END)))::numeric / NULLIF(((count(mtg.id) * 4))::numeric, (0)::numeric)) * (100)::numeric), 2) AS percentage,
        CASE
            WHEN ((((((sum(
            CASE
                WHEN mtg.foot_checked_last12_months THEN 1
                ELSE 0
            END) + sum(
            CASE
                WHEN mtg.bg_checked_each_visit THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.urine_protein_checked_last6_months THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.creatinine_checked_last12_months THEN 1
                ELSE 0
            END)))::numeric / NULLIF(((count(mtg.id) * 4))::numeric, (0)::numeric)) >= 0.70) THEN 1
            ELSE 0
        END AS _32_diabetes_protocols_implemented
   FROM (((public.qr_codes q
     LEFT JOIN public.diabetes_treatment_guidelines mtg ON ((q.id = mtg.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, d.district, hc.name, hc.type, q.survey_year, q.district_id, q.health_center_id;


ALTER VIEW public._32_diabetes_protocols_implemented OWNER TO health_builders;

--
-- Name: hypertension_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hypertension_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint,
    weight_checked_each_visit boolean DEFAULT false NOT NULL,
    bp_checked_each_visit boolean DEFAULT false NOT NULL,
    eye_checked_last12_months boolean DEFAULT false,
    proteinuria_checked_last6_months boolean DEFAULT false NOT NULL,
    creatinine_checked_last12_months boolean DEFAULT false NOT NULL,
    correct_treatment_provided boolean DEFAULT false,
    last_synced_at timestamp with time zone,
    echocardiography_done_last12_months boolean
);


ALTER TABLE public.hypertension_treatment_guidelines OWNER TO health_builders;

--
-- Name: _32_hypertension_protocols_implemented; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_hypertension_protocols_implemented AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    count(mtg.id) AS total_patients,
    sum(
        CASE
            WHEN mtg.weight_checked_each_visit THEN 1
            ELSE 0
        END) AS total_weight_checked_each_visit,
    sum(
        CASE
            WHEN mtg.bp_checked_each_visit THEN 1
            ELSE 0
        END) AS total_bp_checked_each_visit,
    sum(
        CASE
            WHEN mtg.proteinuria_checked_last6_months THEN 1
            ELSE 0
        END) AS total_proteinuria_checked_last6_months,
    sum(
        CASE
            WHEN mtg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END) AS total_creatinine_checked_last12_months,
    round(((((((sum(
        CASE
            WHEN mtg.weight_checked_each_visit THEN 1
            ELSE 0
        END) + sum(
        CASE
            WHEN mtg.bp_checked_each_visit THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.proteinuria_checked_last6_months THEN 1
            ELSE 0
        END)) + sum(
        CASE
            WHEN mtg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END)))::numeric / NULLIF(((count(mtg.id) * 4))::numeric, (0)::numeric)) * (100)::numeric), 2) AS percentage,
        CASE
            WHEN ((((((sum(
            CASE
                WHEN mtg.weight_checked_each_visit THEN 1
                ELSE 0
            END) + sum(
            CASE
                WHEN mtg.bp_checked_each_visit THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.proteinuria_checked_last6_months THEN 1
                ELSE 0
            END)) + sum(
            CASE
                WHEN mtg.creatinine_checked_last12_months THEN 1
                ELSE 0
            END)))::numeric / NULLIF(((count(mtg.id) * 4))::numeric, (0)::numeric)) >= 0.70) THEN 1
            ELSE 0
        END AS _32_hypertension_protocols_implemented
   FROM (((public.qr_codes q
     LEFT JOIN public.hypertension_treatment_guidelines mtg ON ((q.id = mtg.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, d.district, hc.name, hc.type, q.survey_year, q.district_id, q.health_center_id;


ALTER VIEW public._32_hypertension_protocols_implemented OWNER TO health_builders;

--
-- Name: _32_8_ncd_protocols_implemented; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_8_ncd_protocols_implemented AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    dp._32_diabetes_protocols_implemented,
    dp.percentage AS diabetes_percentage,
    hp._32_hypertension_protocols_implemented,
    hp.percentage AS hypertension_percentage,
        CASE
            WHEN ((dp._32_diabetes_protocols_implemented = 1) AND (hp._32_hypertension_protocols_implemented = 1)) THEN 1
            ELSE 0
        END AS _32_8_ncd_protocols_implemented
   FROM ((((public.qr_codes q
     LEFT JOIN public._32_diabetes_protocols_implemented dp ON ((q.id = dp.survey_id)))
     LEFT JOIN public._32_hypertension_protocols_implemented hp ON ((q.id = hp.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._32_8_ncd_protocols_implemented OWNER TO health_builders;

--
-- Name: _32_9_ncd_respiratory_diseases_treatment_guidelines_adopted; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_9_ncd_respiratory_diseases_treatment_guidelines_adopted AS
 SELECT DISTINCT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN tg_hypertension.available THEN 1
            ELSE 0
        END AS hypertension_available,
        CASE
            WHEN tg_hypertension.up_to_date THEN 1
            ELSE 0
        END AS hypertension_uptodate,
        CASE
            WHEN tg_hypertension.service_informed THEN 1
            ELSE 0
        END AS hypertension_informed,
        CASE
            WHEN tg_diabetes.available THEN 1
            ELSE 0
        END AS diabetes_available,
        CASE
            WHEN tg_diabetes.up_to_date THEN 1
            ELSE 0
        END AS diabetes_uptodate,
        CASE
            WHEN tg_diabetes.service_informed THEN 1
            ELSE 0
        END AS diabetes_informed,
        CASE
            WHEN tg_respiratory.available THEN 1
            ELSE 0
        END AS respiratory_available,
        CASE
            WHEN tg_respiratory.up_to_date THEN 1
            ELSE 0
        END AS respiratory_uptodate,
        CASE
            WHEN tg_respiratory.service_informed THEN 1
            ELSE 0
        END AS respiratory_informed,
        CASE
            WHEN (tg_hypertension.available AND tg_hypertension.up_to_date AND tg_hypertension.service_informed AND tg_diabetes.available AND tg_diabetes.up_to_date AND tg_diabetes.service_informed AND tg_respiratory.available AND tg_respiratory.up_to_date AND tg_respiratory.service_informed) THEN 1
            ELSE 0
        END AS _32_9_ncd_respiratory_diseases_treatment_guidelines_adopted
   FROM (((((public.qr_codes q
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
     LEFT JOIN public.treatment_guidelines tg_hypertension ON (((q.id = tg_hypertension.survey_id) AND (tg_hypertension.treatment_guideline = 'Hypertension'::text))))
     LEFT JOIN public.treatment_guidelines tg_diabetes ON (((q.id = tg_diabetes.survey_id) AND (tg_diabetes.treatment_guideline = 'Diabetes'::text))))
     LEFT JOIN public.treatment_guidelines tg_respiratory ON (((q.id = tg_respiratory.survey_id) AND (tg_respiratory.treatment_guideline = 'Chronic Respiratory Disease'::text))));


ALTER VIEW public._32_9_ncd_respiratory_diseases_treatment_guidelines_adopted OWNER TO health_builders;

--
-- Name: _32_indicators_merged; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_indicators_merged AS
 SELECT qc.id AS survey_id,
    qc.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    _32_1._32_1_all_referral_cases_have_referral_sheet_copy,
    _32_2._32_2_qi_plan_tacked_and_approved,
    _32_3._32_3_inpatient_assessment_forms_collect_required_info,
    _32_4._32_4_80_percent_of_services_have_hand_hygiene_supplies,
    _32_5._32_5_annual_malaria_prevention_plan_established,
    _32_6._32_6_malaria_protocols_treatment_guidelines_available,
    _32_7._32_7_malaria_protocols_implemented,
    _32_8._32_8_ncd_protocols_implemented,
    _32_9._32_9_ncd_respiratory_diseases_treatment_guidelines_adopted,
    _32_10to11._32_10_there_is_standardized_checklist,
    _32_10to11._32_11_transfer_sheet_standardized,
    _32_12._32_12_70_percent_reviewed_clinicians_have_completeness,
    _32_13to14._32_13_essential_drugs_available_have_stock_card,
    _32_13to14._32_14_essential_drugs_not_expired,
    _32_15._32_15_drugs_have_consumption_register_totalled_monthly,
    _32_16._32_16_treatment_plan_revised_from_reassesment_results,
    _32_17to26._32_17_suggestion_box_available,
    _32_17to26._32_18_customer_care_program_tracked_approved,
    _32_17to26._32_19_qi_committe_reviewing_incidents,
    _32_17to26._32_20_incident_reporting_form_in_different_langauges,
    _32_17to26._32_21_patient_family_rights_posted,
    _32_17to26._32_22_patient_satisfaction_tool_tested_and_revised,
    _32_17to26._32_23_patient_satisfaction_data_aggregated_and_graphed,
    _32_17to26._32_24_staff_satisfaction_toold_developed_and_tested,
    _32_17to26._32_25_staff_satisfaction_data_has_been_aggregated_and_graphed,
    _32_17to26._32_26_patient_staff_and_visitors_risk_of_infection_identified,
    _32_27._32_27_reconciliation_done_payables_receivables_monitored,
    _32_28._32_28_70_percent_of_services_have_required_existing_supplies,
    _32_29._32_29_staff_names_photos_on_each_service_door,
    _32_30._32_30_80_percent_of_services_have_hand_hygiene_procedures,
    _32_31to32._32_31_qi_focal_person_available,
    _32_31to32._32_32_ipc_focal_person_available
   FROM ((((((((((((((((((((((public.qr_codes qc
     LEFT JOIN public.districts d ON ((qc.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qc.health_center_id = hc.id)))
     LEFT JOIN public._32_1_ambulance_referral_cases_referral_sheet_copy _32_1 ON ((qc.id = _32_1.survey_id)))
     LEFT JOIN public._32_2_qi_plan _32_2 ON ((qc.id = _32_2.survey_id)))
     LEFT JOIN public._32_3_inpatient_assessment_forms_collect_required_info _32_3 ON ((qc.id = _32_3.survey_id)))
     LEFT JOIN public._32_4_facility_services_have_hand_hygiene_supplies _32_4 ON ((qc.id = _32_4.survey_id)))
     LEFT JOIN public._32_5_annual_malaria_prevention_plan_est _32_5 ON ((qc.id = _32_5.survey_id)))
     LEFT JOIN public._32_6_malaria_protocols_treatment_guidelines_available _32_6 ON ((qc.id = _32_6.survey_id)))
     LEFT JOIN public._32_7_malaria_protocols_implemented _32_7 ON ((qc.id = _32_7.survey_id)))
     LEFT JOIN public._32_8_ncd_protocols_implemented _32_8 ON ((qc.id = _32_8.survey_id)))
     LEFT JOIN public._32_9_ncd_respiratory_diseases_treatment_guidelines_adopted _32_9 ON ((qc.id = _32_9.survey_id)))
     LEFT JOIN public._32_10_to11_checklist_treatment_guidelines _32_10to11 ON ((qc.id = _32_10to11.survey_id)))
     LEFT JOIN public._32_12_inpatients_care_treatment_guidelines_new _32_12 ON ((qc.id = _32_12.survey_id)))
     LEFT JOIN public._32_13_to14_essential_drugs_have_stockcard_and_notexpired _32_13to14 ON ((qc.id = _32_13to14.survey_id)))
     LEFT JOIN public._32_15_reviewed_drugs_consumption_reg_totalled _32_15 ON ((qc.id = _32_15.survey_id)))
     LEFT JOIN public._32_16_treatment_plan_revised_according_to_reassement _32_16 ON ((qc.id = _32_16.survey_id)))
     LEFT JOIN public._32_17_to26_customer_care_safety_managements _32_17to26 ON ((qc.id = _32_17to26.survey_id)))
     LEFT JOIN public._32_27_monthly_reconciliation_payables_receivables_monitored _32_27 ON ((qc.id = _32_27.survey_id)))
     LEFT JOIN public._32_28_facility_services_has_required_existing_supplies _32_28 ON ((qc.id = _32_28.survey_id)))
     LEFT JOIN public._32_29_staff_names_photos_on_each_service_door _32_29 ON ((qc.id = _32_29.survey_id)))
     LEFT JOIN public._32_30_facility_services_have_hand_hygiene_procedures _32_30 ON ((qc.id = _32_30.survey_id)))
     LEFT JOIN public._32_31_to32_focal_persons _32_31to32 ON ((qc.id = _32_31to32.survey_id)));


ALTER VIEW public._32_indicators_merged OWNER TO health_builders;

--
-- Name: _32_indicators_merged_ordered; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._32_indicators_merged_ordered AS
 SELECT DISTINCT qc.id AS survey_id,
    qc.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    _32_5._32_5_annual_malaria_prevention_plan_established,
    _32_6._32_6_malaria_protocols_treatment_guidelines_available,
    _32_7._32_7_malaria_protocols_implemented,
    _32_8._32_8_ncd_protocols_implemented,
    _32_9._32_9_ncd_respiratory_diseases_treatment_guidelines_adopted,
    _32_3._32_3_inpatient_assessment_forms_collect_required_info,
    _32_12._32_12_70_percent_reviewed_clinicians_have_completeness,
    _32_1._32_1_all_referral_cases_have_referral_sheet_copy,
    _32_10to11._32_11_transfer_sheet_standardized,
    _32_15._32_15_drugs_have_consumption_register_totalled_monthly,
    _32_13to14._32_13_essential_drugs_available_have_stock_card,
    _32_13to14._32_14_essential_drugs_not_expired,
    _32_16._32_16_treatment_plan_revised_from_reassesment_results,
    _32_10to11._32_10_there_is_standardized_checklist,
    _32_17to26._32_17_suggestion_box_available,
    _32_17to26._32_18_customer_care_program_tracked_approved,
    _32_17to26._32_19_qi_committe_reviewing_incidents,
    _32_17to26._32_20_incident_reporting_form_in_different_langauges,
    _32_17to26._32_23_patient_satisfaction_data_aggregated_and_graphed,
    _32_17to26._32_22_patient_satisfaction_tool_tested_and_revised,
    _32_2._32_2_qi_plan_tacked_and_approved,
    _32_31to32._32_31_qi_focal_person_available,
    _32_17to26._32_25_staff_satisfaction_data_has_been_aggregated_and_graphed,
    _32_17to26._32_24_staff_satisfaction_toold_developed_and_tested,
    _32_17to26._32_21_patient_family_rights_posted,
    _32_28._32_28_70_percent_of_services_have_required_existing_supplies,
    _32_27._32_27_reconciliation_done_payables_receivables_monitored,
    _32_29._32_29_staff_names_photos_on_each_service_door,
    _32_4._32_4_80_percent_of_services_have_hand_hygiene_supplies,
    _32_30._32_30_80_percent_of_services_have_hand_hygiene_procedures,
    _32_17to26._32_26_patient_staff_and_visitors_risk_of_infection_identified,
    _32_31to32._32_32_ipc_focal_person_available
   FROM ((((((((((((((((((((((public.qr_codes qc
     LEFT JOIN public.districts d ON ((qc.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qc.health_center_id = hc.id)))
     LEFT JOIN public._32_1_ambulance_referral_cases_referral_sheet_copy _32_1 ON ((qc.id = _32_1.survey_id)))
     LEFT JOIN public._32_2_qi_plan _32_2 ON ((qc.id = _32_2.survey_id)))
     LEFT JOIN public._32_3_inpatient_assessment_forms_collect_required_info _32_3 ON ((qc.id = _32_3.survey_id)))
     LEFT JOIN public._32_4_facility_services_have_hand_hygiene_supplies _32_4 ON ((qc.id = _32_4.survey_id)))
     LEFT JOIN public._32_5_annual_malaria_prevention_plan_est _32_5 ON ((qc.id = _32_5.survey_id)))
     LEFT JOIN public._32_6_malaria_protocols_treatment_guidelines_available _32_6 ON ((qc.id = _32_6.survey_id)))
     LEFT JOIN public._32_7_malaria_protocols_implemented _32_7 ON ((qc.id = _32_7.survey_id)))
     LEFT JOIN public._32_8_ncd_protocols_implemented _32_8 ON ((qc.id = _32_8.survey_id)))
     LEFT JOIN public._32_9_ncd_respiratory_diseases_treatment_guidelines_adopted _32_9 ON ((qc.id = _32_9.survey_id)))
     LEFT JOIN public._32_10_to11_checklist_treatment_guidelines _32_10to11 ON ((qc.id = _32_10to11.survey_id)))
     LEFT JOIN public._32_12_inpatients_care_treatment_guidelines_new _32_12 ON ((qc.id = _32_12.survey_id)))
     LEFT JOIN public._32_13_to14_essential_drugs_have_stockcard_and_notexpired _32_13to14 ON ((qc.id = _32_13to14.survey_id)))
     LEFT JOIN public._32_15_reviewed_drugs_consumption_reg_totalled _32_15 ON ((qc.id = _32_15.survey_id)))
     LEFT JOIN public._32_16_treatment_plan_revised_according_to_reassement _32_16 ON ((qc.id = _32_16.survey_id)))
     LEFT JOIN public._32_17_to26_customer_care_safety_managements _32_17to26 ON ((qc.id = _32_17to26.survey_id)))
     LEFT JOIN public._32_27_monthly_reconciliation_payables_receivables_monitored _32_27 ON ((qc.id = _32_27.survey_id)))
     LEFT JOIN public._32_28_facility_services_has_required_existing_supplies _32_28 ON ((qc.id = _32_28.survey_id)))
     LEFT JOIN public._32_29_staff_names_photos_on_each_service_door _32_29 ON ((qc.id = _32_29.survey_id)))
     LEFT JOIN public._32_30_facility_services_have_hand_hygiene_procedures _32_30 ON ((qc.id = _32_30.survey_id)))
     LEFT JOIN public._32_31_to32_focal_persons _32_31to32 ON ((qc.id = _32_31to32.survey_id)));


ALTER VIEW public._32_indicators_merged_ordered OWNER TO health_builders;

--
-- Name: frequency_of_committee_meetings; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.frequency_of_committee_meetings (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    meeting_id bigint,
    frequency_id bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.frequency_of_committee_meetings OWNER TO health_builders;

--
-- Name: in_service_training_plans; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.in_service_training_plans (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    communicated_to_staff boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.in_service_training_plans OWNER TO health_builders;

--
-- Name: _41_13_to14_staff_meetings_inservice_training_plan; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_13_to14_staff_meetings_inservice_training_plan AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (fcm.frequency_id = 1) THEN 1
            ELSE 0
        END AS _41_13_staff_meetings,
        CASE
            WHEN (istp.available IS TRUE) THEN 1
            ELSE 0
        END AS inservice_training_plan_available,
        CASE
            WHEN (istp.tracked IS TRUE) THEN 1
            ELSE 0
        END AS inservice_training_plan_tracked,
        CASE
            WHEN (istp.titualaire_approved IS TRUE) THEN 1
            ELSE 0
        END AS inservice_training_plan_approved,
        CASE
            WHEN (istp.communicated_to_staff IS TRUE) THEN 1
            ELSE 0
        END AS inservice_training_plan_communicated_to_staff,
        CASE
            WHEN ((istp.available IS TRUE) AND (istp.tracked IS TRUE) AND (istp.titualaire_approved IS TRUE) AND (istp.communicated_to_staff IS TRUE)) THEN 1
            ELSE 0
        END AS _41_14_implemented_inservice_training_plan
   FROM ((((public.qr_codes qr
     LEFT JOIN public.frequency_of_committee_meetings fcm ON (((qr.id = fcm.survey_id) AND (fcm.meeting_id = 1))))
     LEFT JOIN public.in_service_training_plans istp ON ((qr.id = istp.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_13_to14_staff_meetings_inservice_training_plan OWNER TO health_builders;

--
-- Name: attendance_registers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.attendance_registers (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.attendance_registers OWNER TO health_builders;

--
-- Name: external_trainings_reports; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.external_trainings_reports (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.external_trainings_reports OWNER TO health_builders;

--
-- Name: work_schedules; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.work_schedules (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    updated boolean,
    titualaire_approved boolean,
    communicated_to_staff boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.work_schedules OWNER TO health_builders;

--
-- Name: _41_15_to17_external_training_work_schedules; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_15_to17_external_training_work_schedules AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (etr.available IS TRUE) THEN 1
            ELSE 0
        END AS external_trainings_register_available,
        CASE
            WHEN (etr.tracked IS TRUE) THEN 1
            ELSE 0
        END AS external_trainings_register_tracked,
        CASE
            WHEN ((etr.available IS TRUE) AND (etr.tracked IS TRUE)) THEN 1
            ELSE 0
        END AS _41_15_uptodate_external_training_register,
        CASE
            WHEN (ws.available IS TRUE) THEN 1
            ELSE 0
        END AS work_schedule_available,
        CASE
            WHEN (ws.titualaire_approved IS TRUE) THEN 1
            ELSE 0
        END AS work_schedule_titualaire_approved,
        CASE
            WHEN (ws.communicated_to_staff IS TRUE) THEN 1
            ELSE 0
        END AS work_schedule_communicated_to_staff,
        CASE
            WHEN (ws.updated IS TRUE) THEN 1
            ELSE 0
        END AS work_schedule_updated,
        CASE
            WHEN ((ws.available IS TRUE) AND (ws.titualaire_approved IS TRUE) AND (ws.communicated_to_staff IS TRUE) AND (ws.updated IS TRUE)) THEN 1
            ELSE 0
        END AS _41_16_uptodate_work_schedule,
        CASE
            WHEN (ar.available IS TRUE) THEN 1
            ELSE 0
        END AS attendance_register_available,
        CASE
            WHEN (ar.tracked IS TRUE) THEN 1
            ELSE 0
        END AS attendance_register_tracked,
        CASE
            WHEN ((ar.available IS TRUE) AND (ar.tracked IS TRUE)) THEN 1
            ELSE 0
        END AS _41_17_uptodate_attendance_register
   FROM (((((public.qr_codes qr
     LEFT JOIN public.external_trainings_reports etr ON ((qr.id = etr.survey_id)))
     LEFT JOIN public.work_schedules ws ON ((qr.id = ws.survey_id)))
     LEFT JOIN public.attendance_registers ar ON ((qr.id = ar.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_15_to17_external_training_work_schedules OWNER TO health_builders;

--
-- Name: _41_18_service_area_description; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_18_service_area_description AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (ts.directions IS TRUE) THEN 1
            ELSE 0
        END AS toilets_directions,
        CASE
            WHEN (dp.directions IS TRUE) THEN 1
            ELSE 0
        END AS dispensing_pharmacy_directions,
        CASE
            WHEN (dp.service_labelling IS TRUE) THEN 1
            ELSE 0
        END AS dispensing_pharmacy_service_labelling,
        CASE
            WHEN (cs.directions IS TRUE) THEN 1
            ELSE 0
        END AS cashier_directions,
        CASE
            WHEN (cs.service_labelling IS TRUE) THEN 1
            ELSE 0
        END AS cashier_service_labelling,
        CASE
            WHEN (lab.directions IS TRUE) THEN 1
            ELSE 0
        END AS laboratory_directions,
        CASE
            WHEN (lab.service_labelling IS TRUE) THEN 1
            ELSE 0
        END AS laboratory_service_labelling,
        CASE
            WHEN (ti.directions IS TRUE) THEN 1
            ELSE 0
        END AS titualaire_directions,
        CASE
            WHEN (ti.service_labelling IS TRUE) THEN 1
            ELSE 0
        END AS titualaire_service_labelling,
        CASE
            WHEN (cr.directions IS TRUE) THEN 1
            ELSE 0
        END AS consultation_room_directions,
        CASE
            WHEN (cr.service_labelling IS TRUE) THEN 1
            ELSE 0
        END AS consultation_room_service_labelling,
        CASE
            WHEN (ma.directions IS TRUE) THEN 1
            ELSE 0
        END AS maternity_directions,
        CASE
            WHEN (ma.service_labelling IS TRUE) THEN 1
            ELSE 0
        END AS maternity_service_labelling,
    round((((((((((((((((
        CASE
            WHEN (ts.directions IS TRUE) THEN 1
            ELSE 0
        END +
        CASE
            WHEN (dp.directions IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (dp.service_labelling IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (cs.directions IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (cs.service_labelling IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (lab.directions IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (lab.service_labelling IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (ti.directions IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (ti.service_labelling IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (cr.directions IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (cr.service_labelling IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (ma.directions IS TRUE) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (ma.service_labelling IS TRUE) THEN 1
            ELSE 0
        END))::numeric * 100.0) / (13)::numeric), 2) AS percentage,
        CASE
            WHEN (round((((((((((((((((
            CASE
                WHEN (ts.directions IS TRUE) THEN 1
                ELSE 0
            END +
            CASE
                WHEN (dp.directions IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (dp.service_labelling IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (cs.directions IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (cs.service_labelling IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (lab.directions IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (lab.service_labelling IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (ti.directions IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (ti.service_labelling IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (cr.directions IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (cr.service_labelling IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (ma.directions IS TRUE) THEN 1
                ELSE 0
            END) +
            CASE
                WHEN (ma.service_labelling IS TRUE) THEN 1
                ELSE 0
            END))::numeric * 100.0) / (13)::numeric), 2) >= (75)::numeric) THEN 1
            ELSE 0
        END AS _41_18_there_are_clear_visible_signage
   FROM (((((((((public.qr_codes qr
     LEFT JOIN public.toilets ts ON ((qr.id = ts.survey_id)))
     LEFT JOIN public.dispensing_pharmacies dp ON ((qr.id = dp.survey_id)))
     LEFT JOIN public.cashiers cs ON ((qr.id = cs.survey_id)))
     LEFT JOIN public.laboratories lab ON ((qr.id = lab.survey_id)))
     LEFT JOIN public.titualaires ti ON ((qr.id = ti.survey_id)))
     LEFT JOIN public.consultation_rooms cr ON ((qr.id = cr.survey_id)))
     LEFT JOIN public.matenities ma ON ((qr.id = ma.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_18_service_area_description OWNER TO health_builders;

--
-- Name: budgets; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.budgets (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    cosa_approved boolean,
    includes_capital_and_maintenance boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.budgets OWNER TO health_builders;

--
-- Name: income_reviews; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.income_reviews (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    receipt_book_daily_total_income numeric(15,2),
    jornal_dail_total_income numeric(15,2),
    match boolean DEFAULT false,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.income_reviews OWNER TO health_builders;

--
-- Name: transaction_expense_reviews; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.transaction_expense_reviews (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    reference_number character varying(255),
    supported_voucher boolean DEFAULT false,
    invoice boolean DEFAULT false,
    numbered boolean DEFAULT false,
    ordered_sequentially boolean DEFAULT false,
    transaction_recorded_in_books boolean DEFAULT false,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.transaction_expense_reviews OWNER TO health_builders;

--
-- Name: _41_19_to24_financial_review_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_19_to24_financial_review_summary AS
 WITH income_match AS (
         SELECT sub.survey_id,
            max(
                CASE
                    WHEN (sub.rn = 1) THEN
                    CASE
                        WHEN (sub.receipt_book_daily_total_income = sub.jornal_dail_total_income) THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_matched_day_1,
            max(
                CASE
                    WHEN (sub.rn = 2) THEN
                    CASE
                        WHEN (sub.receipt_book_daily_total_income = sub.jornal_dail_total_income) THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_matched_day_2,
            max(
                CASE
                    WHEN (sub.rn = 3) THEN
                    CASE
                        WHEN (sub.receipt_book_daily_total_income = sub.jornal_dail_total_income) THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_matched_day_3
           FROM ( SELECT income_reviews.survey_id,
                    income_reviews.receipt_book_daily_total_income,
                    income_reviews.jornal_dail_total_income,
                    row_number() OVER (PARTITION BY income_reviews.survey_id ORDER BY income_reviews.date DESC) AS rn
                   FROM public.income_reviews) sub
          GROUP BY sub.survey_id
        ), budget_status AS (
         SELECT budgets.survey_id,
            max(
                CASE
                    WHEN budgets.available THEN 1
                    ELSE 0
                END) AS budget_available,
            max(
                CASE
                    WHEN budgets.tracked THEN 1
                    ELSE 0
                END) AS budget_tracked,
            max(
                CASE
                    WHEN budgets.titualaire_approved THEN 1
                    ELSE 0
                END) AS budget_titualaire_approved
           FROM public.budgets
          GROUP BY budgets.survey_id
        ), account_status AS (
         SELECT accounts.survey_id,
            max(
                CASE
                    WHEN accounts.each_account_has_separate_book THEN 1
                    ELSE 0
                END) AS each_account_has_separate_book
           FROM public.accounts
          GROUP BY accounts.survey_id
        ), expense_review AS (
         SELECT sub.survey_id,
            max(
                CASE
                    WHEN (sub.rn = 1) THEN
                    CASE
                        WHEN sub.supported_voucher THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_signed_and_supported_vourcher1,
            max(
                CASE
                    WHEN (sub.rn = 2) THEN
                    CASE
                        WHEN sub.supported_voucher THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_signed_and_supported_vourcher2,
            max(
                CASE
                    WHEN (sub.rn = 3) THEN
                    CASE
                        WHEN sub.supported_voucher THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_signed_and_supported_vourcher3,
            max(
                CASE
                    WHEN (sub.rn = 1) THEN
                    CASE
                        WHEN sub.invoice THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_invoice1,
            max(
                CASE
                    WHEN (sub.rn = 2) THEN
                    CASE
                        WHEN sub.invoice THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_invoice2,
            max(
                CASE
                    WHEN (sub.rn = 3) THEN
                    CASE
                        WHEN sub.invoice THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_invoice3,
            max(
                CASE
                    WHEN (sub.rn = 1) THEN
                    CASE
                        WHEN sub.transaction_recorded_in_books THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_recorded1,
            max(
                CASE
                    WHEN (sub.rn = 2) THEN
                    CASE
                        WHEN sub.transaction_recorded_in_books THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_recorded2,
            max(
                CASE
                    WHEN (sub.rn = 3) THEN
                    CASE
                        WHEN sub.transaction_recorded_in_books THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_review_recorded3,
            max(
                CASE
                    WHEN (sub.rn = 1) THEN
                    CASE
                        WHEN (sub.ordered_sequentially AND sub.numbered) THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_ordered_sequentially1,
            max(
                CASE
                    WHEN (sub.rn = 2) THEN
                    CASE
                        WHEN (sub.ordered_sequentially AND sub.numbered) THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_ordered_sequentially2,
            max(
                CASE
                    WHEN (sub.rn = 3) THEN
                    CASE
                        WHEN (sub.ordered_sequentially AND sub.numbered) THEN 1
                        ELSE 0
                    END
                    ELSE 0
                END) AS transaction_expense_ordered_sequentially3
           FROM ( SELECT transaction_expense_reviews.survey_id,
                    transaction_expense_reviews.supported_voucher,
                    transaction_expense_reviews.invoice,
                    transaction_expense_reviews.transaction_recorded_in_books,
                    transaction_expense_reviews.ordered_sequentially,
                    transaction_expense_reviews.numbered,
                    row_number() OVER (PARTITION BY transaction_expense_reviews.survey_id ORDER BY transaction_expense_reviews.updated_at DESC) AS rn
                   FROM public.transaction_expense_reviews) sub
          GROUP BY sub.survey_id
        )
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    COALESCE(im.transaction_matched_day_1, 0) AS transaction_matched_day_1,
    COALESCE(im.transaction_matched_day_2, 0) AS transaction_matched_day_2,
    COALESCE(im.transaction_matched_day_3, 0) AS transaction_matched_day_3,
        CASE
            WHEN ((COALESCE(im.transaction_matched_day_1, 0) = 1) AND (COALESCE(im.transaction_matched_day_2, 0) = 1) AND (COALESCE(im.transaction_matched_day_3, 0) = 1)) THEN 1
            ELSE 0
        END AS _41_19_incomes_in_book_and_journal_matched,
    COALESCE(er.transaction_expense_review_signed_and_supported_vourcher1, 0) AS transaction_expense_review_signed_and_supported_vourcher1,
    COALESCE(er.transaction_expense_review_signed_and_supported_vourcher2, 0) AS transaction_expense_review_signed_and_supported_vourcher2,
    COALESCE(er.transaction_expense_review_signed_and_supported_vourcher3, 0) AS transaction_expense_review_signed_and_supported_vourcher3,
    COALESCE(er.transaction_expense_review_invoice1, 0) AS transaction_expense_review_invoice1,
    COALESCE(er.transaction_expense_review_invoice2, 0) AS transaction_expense_review_invoice2,
    COALESCE(er.transaction_expense_review_invoice3, 0) AS transaction_expense_review_invoice3,
        CASE
            WHEN ((COALESCE(er.transaction_expense_review_invoice1, 0) = 1) AND (COALESCE(er.transaction_expense_review_invoice2, 0) = 1) AND (COALESCE(er.transaction_expense_review_invoice3, 0) = 1)) THEN 1
            ELSE 0
        END AS _41_20_all_three_transactions_had_required_supporting,
    COALESCE(bs.budget_available, 0) AS budget_available,
    COALESCE(bs.budget_tracked, 0) AS budget_tracked,
    COALESCE(bs.budget_titualaire_approved, 0) AS budget_titualaire_approved,
        CASE
            WHEN ((COALESCE(bs.budget_available, 0) = 1) AND (COALESCE(bs.budget_tracked, 0) = 1) AND (COALESCE(bs.budget_titualaire_approved, 0) = 1)) THEN 1
            ELSE 0
        END AS _41_21_budget_is_approved_and_tracked,
    COALESCE(acc.each_account_has_separate_book, 0) AS _41_22_each_account_has_separate_book,
    COALESCE(er.transaction_expense_review_recorded1, 0) AS transaction_expense_review_recorded1,
    COALESCE(er.transaction_expense_review_recorded2, 0) AS transaction_expense_review_recorded2,
    COALESCE(er.transaction_expense_review_recorded3, 0) AS transaction_expense_review_recorded3,
        CASE
            WHEN ((COALESCE(er.transaction_expense_review_recorded1, 0) = 1) AND (COALESCE(er.transaction_expense_review_recorded2, 0) = 1) AND (COALESCE(er.transaction_expense_review_recorded3, 0) = 1)) THEN 1
            ELSE 0
        END AS _41_23_updated_petty_cash_book_and_cash_register_available,
    COALESCE(er.transaction_expense_ordered_sequentially1, 0) AS transaction_expense_ordered_sequentially1,
    COALESCE(er.transaction_expense_ordered_sequentially2, 0) AS transaction_expense_ordered_sequentially2,
    COALESCE(er.transaction_expense_ordered_sequentially3, 0) AS transaction_expense_ordered_sequentially3,
        CASE
            WHEN ((COALESCE(er.transaction_expense_ordered_sequentially1, 0) = 1) AND (COALESCE(er.transaction_expense_ordered_sequentially2, 0) = 1) AND (COALESCE(er.transaction_expense_ordered_sequentially3, 0) = 1)) THEN 1
            ELSE 0
        END AS _41_24_transactions_numbered_and_ordered_sequentially
   FROM ((((((public.qr_codes qr
     LEFT JOIN income_match im ON ((qr.id = im.survey_id)))
     LEFT JOIN budget_status bs ON ((qr.id = bs.survey_id)))
     LEFT JOIN account_status acc ON ((qr.id = acc.survey_id)))
     LEFT JOIN expense_review er ON ((qr.id = er.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_19_to24_financial_review_summary OWNER TO health_builders;

--
-- Name: _41_1_dispensary_tallysheet_tracking; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_1_dispensary_tallysheet_tracking AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::integer AS amitriptyline_tallysheet,
    NULL::integer AS metformin_tallysheet,
    NULL::integer AS methyldopa_tallysheet,
    NULL::integer AS nifedipine_tallysheet,
    NULL::integer AS amilodipine_tallysheet,
    NULL::integer AS hydrochlorothiazide_tallysheet,
    NULL::integer AS beclomethasone_tallysheet,
    NULL::integer AS amoxicillin_tallysheet,
    NULL::integer AS atenolol_tallysheet,
    NULL::integer AS captopril_tallysheet,
    NULL::integer AS ciprofloxacin_tallysheet,
    NULL::integer AS cotrimoxazole_tallysheet,
    NULL::integer AS dexamethasone_tallysheet,
    NULL::integer AS diazepam_tallysheet,
    NULL::integer AS diclofenac_tallysheet,
    NULL::integer AS glibenclamide_tallysheet,
    NULL::integer AS oxyctocin_tallysheet,
    NULL::integer AS paracetamol_tallysheet,
    NULL::integer AS salbutamol_tallysheet,
    NULL::integer AS vitamin_tallysheet,
    NULL::integer AS expected_drugs,
    NULL::bigint AS total_available_drugs,
    NULL::integer AS tracking_consumption_count,
    NULL::numeric AS consumption_ratio,
    NULL::integer AS _41_1_tallysheets_used_to_track_consumption;


ALTER VIEW public._41_1_dispensary_tallysheet_tracking OWNER TO health_builders;

--
-- Name: _41_25_to26_committee_meetings; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_25_to26_committee_meetings AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::integer AS _41_25_coge_meeting,
    NULL::integer AS _41_26_cosa_meeting;


ALTER VIEW public._41_25_to26_committee_meetings OWNER TO health_builders;

--
-- Name: job_descriptions; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.job_descriptions (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    "position" text,
    file_available boolean,
    file_signed_by_employee boolean,
    file_signed_by_employer boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.job_descriptions OWNER TO health_builders;

--
-- Name: _41_27_job_description_altenative; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_27_job_description_altenative AS
 SELECT job_descriptions.survey_id,
        CASE
            WHEN ((count(DISTINCT job_descriptions.file_available) = 1) AND (sum((job_descriptions.file_available)::integer) = count(job_descriptions.file_available))) THEN 1
            ELSE 0
        END AS job_file_available,
        CASE
            WHEN ((count(DISTINCT job_descriptions.file_signed_by_employee) = 1) AND (sum((job_descriptions.file_signed_by_employee)::integer) = count(job_descriptions.file_signed_by_employee))) THEN 1
            ELSE 0
        END AS job_file_signed_by_employee,
        CASE
            WHEN ((count(DISTINCT job_descriptions.file_signed_by_employer) = 1) AND (sum((job_descriptions.file_signed_by_employer)::integer) = count(job_descriptions.file_signed_by_employer))) THEN 1
            ELSE 0
        END AS job_file_signed_by_employer,
        CASE
            WHEN ((count(DISTINCT job_descriptions.file_available) = 1) AND (count(DISTINCT job_descriptions.file_signed_by_employee) = 1) AND (count(DISTINCT job_descriptions.file_signed_by_employer) = 1) AND (sum((job_descriptions.file_available)::integer) = count(job_descriptions.file_available)) AND (sum((job_descriptions.file_signed_by_employee)::integer) = count(job_descriptions.file_signed_by_employee)) AND (sum((job_descriptions.file_signed_by_employer)::integer) = count(job_descriptions.file_signed_by_employer))) THEN 1
            ELSE 0
        END AS _41_27_current_job_descriptions_written_for_each_leader
   FROM public.job_descriptions
  GROUP BY job_descriptions.survey_id;


ALTER VIEW public._41_27_job_description_altenative OWNER TO health_builders;

--
-- Name: _41_27_job_description_main; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_27_job_description_main AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::bigint AS available_count,
    NULL::bigint AS available_sum,
    NULL::bigint AS signed_by_employer_count,
    NULL::bigint AS signed_by_employee_count,
    NULL::integer AS _41_27_current_job_descriptions_written_for_each_leader;


ALTER VIEW public._41_27_job_description_main OWNER TO health_builders;

--
-- Name: action_plans; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.action_plans (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    cosa_approved boolean,
    communicated_to_staff boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.action_plans OWNER TO health_builders;

--
-- Name: _41_28_action_plans; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_28_action_plans AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN ap.available THEN 1
            ELSE 0
        END AS action_plan_available,
        CASE
            WHEN ap.tracked THEN 1
            ELSE 0
        END AS action_plan_tracked,
        CASE
            WHEN ap.titualaire_approved THEN 1
            ELSE 0
        END AS action_plan_approved,
        CASE
            WHEN (ap.available AND ap.tracked AND ap.titualaire_approved) THEN 1
            ELSE 0
        END AS _41_28_action_plan_titualire_approved_and_tracked
   FROM (((public.qr_codes qr
     LEFT JOIN public.action_plans ap ON ((qr.id = ap.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_28_action_plans OWNER TO health_builders;

--
-- Name: organization_charts; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.organization_charts (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    up_to_date boolean,
    accessible_by_staff boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.organization_charts OWNER TO health_builders;

--
-- Name: _41_29_organization_charts; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_29_organization_charts AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN oc.available THEN 1
            ELSE 0
        END AS chart_available,
        CASE
            WHEN oc.up_to_date THEN 1
            ELSE 0
        END AS chart_uptodate,
        CASE
            WHEN (oc.available AND oc.up_to_date) THEN 1
            ELSE 0
        END AS _41_29_available_updated_org_chart
   FROM (((public.qr_codes qr
     LEFT JOIN public.organization_charts oc ON ((qr.id = oc.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_29_organization_charts OWNER TO health_builders;

--
-- Name: _41_2_to3_dispensary_consumption_tracking; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_2_to3_dispensary_consumption_tracking AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::integer AS amitriptyline_consumption_reg,
    NULL::integer AS metformin_consumption_reg,
    NULL::integer AS methyldopa_consumption_reg,
    NULL::integer AS nifedipine_consumption_reg,
    NULL::integer AS amilodipine_consumption_reg,
    NULL::integer AS hydrochlorothiazide_consumption_reg,
    NULL::integer AS beclomethasone_consumption_reg,
    NULL::integer AS amoxicillin_consumption_reg,
    NULL::integer AS atenolol_consumption_reg,
    NULL::integer AS captopril_consumption_reg,
    NULL::integer AS ciprofloxacin_consumption_reg,
    NULL::integer AS cotrimoxazole_consumption_reg,
    NULL::integer AS dexamethasone_consumption_reg,
    NULL::integer AS diazepam_consumption_reg,
    NULL::integer AS diclofenac_consumption_reg,
    NULL::integer AS glibenclamide_consumption_reg,
    NULL::integer AS oxyctocin_consumption_reg,
    NULL::integer AS paracetamol_consumption_reg,
    NULL::integer AS salbutamol_consumption_reg,
    NULL::integer AS vitamin_consumption_reg,
    NULL::integer AS updated_consumption_reg_count,
    NULL::bigint AS total_available_drugs,
    NULL::integer AS expected_drugs,
    NULL::numeric AS updated_consumption_reg_ratio,
    NULL::integer AS _41_2_drugs_have_an_updated_consumption_register,
    NULL::integer AS _41_3_consumption_register_available_in_dispensary;


ALTER VIEW public._41_2_to3_dispensary_consumption_tracking OWNER TO health_builders;

--
-- Name: _41_30_opd_registers_completeness; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_30_opd_registers_completeness AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::bigint AS total_count_of_records,
    NULL::numeric AS number_of_fields,
    NULL::numeric AS number_of_blanks,
    NULL::numeric AS number_of_completed,
    NULL::numeric AS completed_ratio,
    NULL::integer AS _41_30_lines_of_register_80_percent_complete;


ALTER VIEW public._41_30_opd_registers_completeness OWNER TO health_builders;

--
-- Name: _41_31_curent_data_displayed; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_31_curent_data_displayed AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN vac.current_data_displayed THEN 1
            ELSE 0
        END AS data_displayed_vaccination,
        CASE
            WHEN fam.current_data_displayed THEN 1
            ELSE 0
        END AS data_displayed_family_planning,
        CASE
            WHEN tit.current_data_displayed THEN 1
            ELSE 0
        END AS data_displayed_titualaires,
        CASE
            WHEN con.current_data_displayed THEN 1
            ELSE 0
        END AS data_displayed_opd,
        CASE
            WHEN (vac.current_data_displayed AND fam.current_data_displayed AND tit.current_data_displayed AND con.current_data_displayed) THEN 1
            ELSE 0
        END AS _41_31_current_and_relevant_data_displayed
   FROM ((((((public.qr_codes qr
     LEFT JOIN public.vaccinations vac ON ((qr.id = vac.survey_id)))
     LEFT JOIN public.family_plannings fam ON ((qr.id = fam.survey_id)))
     LEFT JOIN public.titualaires tit ON ((qr.id = tit.survey_id)))
     LEFT JOIN public.consultation_rooms con ON ((qr.id = con.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_31_curent_data_displayed OWNER TO health_builders;

--
-- Name: data_accuracies; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.data_accuracies (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    source text NOT NULL,
    patient_file bigint,
    register bigint NOT NULL,
    lab_register bigint,
    tally_sheet bigint,
    pharmacy bigint,
    hmis_report bigint NOT NULL,
    hmis_database bigint NOT NULL,
    accurate boolean NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.data_accuracies OWNER TO health_builders;

--
-- Name: merged_bcg_data_accurancies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_bcg_data_accurancies AS
 SELECT qr.id AS survey_id,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
    da.register,
    da.patient_file AS patient_files,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / NULLIF(da.hmis_database, 0)))
        END AS hmis,
        CASE
            WHEN (da.hmis_database = 0) THEN NULL::bigint
            ELSE ((da.hmis_report - da.hmis_database) / NULLIF(da.hmis_database, 0))
        END AS hmis_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0) OR (da.patient_file = 0) OR (da.hmis_database = 0)) THEN 0
            ELSE
            CASE
                WHEN (round(((LEAST(da.patient_file, da.register, da.hmis_report, da.hmis_database))::numeric / (GREATEST(da.patient_file, da.register, da.hmis_report, da.hmis_database))::numeric), 2) >= 0.95) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'BCG, 0-11 Months'::text);


ALTER VIEW public.merged_bcg_data_accurancies OWNER TO health_builders;

--
-- Name: merged_deliveries_data_accurancies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_deliveries_data_accurancies AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
    da.register,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / NULLIF(da.hmis_database, 0)))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE ((da.hmis_report - da.register) / NULLIF(da.register, 0))
        END AS hmis_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0)) THEN 0
            ELSE
            CASE
                WHEN (((abs(((da.hmis_report - da.hmis_database) / NULLIF(da.hmis_database, 0))))::numeric < 0.05) AND ((((da.hmis_report - da.register) / NULLIF(da.register, 0)))::numeric < 0.05)) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Deliveries'::text);


ALTER VIEW public.merged_deliveries_data_accurancies OWNER TO health_builders;

--
-- Name: merged_hypertension_data_accurancies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_hypertension_data_accurancies AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.register,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / da.hmis_report))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE ((da.register - da.hmis_database) / da.register)
        END AS hmis_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0)) THEN 0
            ELSE
            CASE
                WHEN (((abs(((da.hmis_report - da.hmis_database) / da.hmis_report)))::numeric < 0.05) AND ((((da.register - da.hmis_database) / da.register))::numeric < 0.05)) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Hypertension, Old Cases, 40+, Female'::text);


ALTER VIEW public.merged_hypertension_data_accurancies OWNER TO health_builders;

--
-- Name: merged_malaria_cases_data_accuracies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_malaria_cases_data_accuracies AS
 SELECT qr.id AS survey_id,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
    da.register,
    da.lab_register,
    da.pharmacy,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / NULLIF(da.hmis_database, 0)))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_database - da.register) / NULLIF(da.register, 0)))
        END AS hmis_over_register,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE abs(((da.register - da.lab_register) / NULLIF(da.register, 0)))
        END AS patientfiles_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0) OR (da.patient_file = 0) OR (da.hmis_database = 0)) THEN 0
            ELSE
            CASE
                WHEN (round(((LEAST(da.lab_register, da.register, da.hmis_report, da.hmis_database))::numeric / (GREATEST(da.patient_file, da.register, da.hmis_report, da.hmis_database))::numeric), 2) >= 0.95) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Malaria Cases (All)'::text);


ALTER VIEW public.merged_malaria_cases_data_accuracies OWNER TO health_builders;

--
-- Name: _41_32_data_accuracies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_32_data_accuracies AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    hypertension.reports_are_95_percent_accurate AS hypertension_report_accuracy,
    deliveries.reports_are_95_percent_accurate AS deliveries_report_accuracy,
    bcg.reports_are_95_percent_accurate AS bcg_report_accuracy,
    malaria.reports_are_95_percent_accurate AS malaria_report_accuracy,
        CASE
            WHEN ((hypertension.reports_are_95_percent_accurate = 1) AND (deliveries.reports_are_95_percent_accurate = 1) AND (bcg.reports_are_95_percent_accurate = 1) AND (malaria.reports_are_95_percent_accurate = 1)) THEN 1
            ELSE 0
        END AS _41_32_reports_95_percent_accurate_across_sources
   FROM ((((((public.qr_codes qr
     LEFT JOIN public.merged_hypertension_data_accurancies hypertension ON ((qr.id = hypertension.survey_id)))
     LEFT JOIN public.merged_deliveries_data_accurancies deliveries ON ((qr.id = deliveries.survey_id)))
     LEFT JOIN public.merged_bcg_data_accurancies bcg ON ((qr.id = bcg.survey_id)))
     LEFT JOIN public.merged_malaria_cases_data_accuracies malaria ON ((qr.id = malaria.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_32_data_accuracies OWNER TO health_builders;

--
-- Name: data_management_sops; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.data_management_sops (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.data_management_sops OWNER TO health_builders;

--
-- Name: monthly_data_reports; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.monthly_data_reports (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    signed boolean,
    submitted_on_time boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.monthly_data_reports OWNER TO health_builders;

--
-- Name: _41_33_to35_monthly_data; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_33_to35_monthly_data AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN mdr.available THEN 1
            ELSE 0
        END AS monthly_data_report_available,
        CASE
            WHEN mdr.signed THEN 1
            ELSE 0
        END AS monthly_data_report_signed,
        CASE
            WHEN mdr.submitted_on_time THEN 1
            ELSE 0
        END AS monthly_data_report_submited_on_time,
        CASE
            WHEN ((mdr.available = true) AND (mdr.signed = true) AND (mdr.submitted_on_time = true)) THEN 1
            ELSE 0
        END AS _41_33_report_signed_and_submited_on_time,
        CASE
            WHEN dms.available THEN 1
            ELSE 0
        END AS _41_34_sop_for_datamanagement_available,
        CASE
            WHEN ((fcm.meeting_id = 4) AND (fcm.frequency_id = 1)) THEN 1
            ELSE 0
        END AS _41_35_chw_meetings
   FROM (((((public.qr_codes qr
     LEFT JOIN public.monthly_data_reports mdr ON ((qr.id = mdr.survey_id)))
     LEFT JOIN public.data_management_sops dms ON ((qr.id = dms.survey_id)))
     LEFT JOIN public.frequency_of_committee_meetings fcm ON ((qr.id = fcm.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (fcm.meeting_id = 4);


ALTER VIEW public._41_33_to35_monthly_data OWNER TO health_builders;

--
-- Name: business_plans; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.business_plans (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    available boolean,
    tracked boolean,
    titualaire_approved boolean,
    communicated_to_staff boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.business_plans OWNER TO health_builders;

--
-- Name: _41_36_business_plan; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_36_business_plan AS
 SELECT bp.survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    COALESCE((bp.available)::integer, 0) AS business_plan_available,
    COALESCE((bp.tracked)::integer, 0) AS business_plan_tracked,
    COALESCE((bp.titualaire_approved)::integer, 0) AS business_plan_titualaire_approved,
        CASE
            WHEN ((bp.available = true) AND (bp.tracked = true) AND (bp.titualaire_approved = true)) THEN 1
            ELSE 0
        END AS _41_36_business_plan_approved_and_tracked
   FROM (((public.business_plans bp
     LEFT JOIN public.qr_codes qr ON ((bp.survey_id = qr.id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_36_business_plan OWNER TO health_builders;

--
-- Name: sanitations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.sanitations (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    functional_latrines bigint,
    functional_patient_latrines bigint,
    functional_staff_latrines bigint,
    broken_latrines bigint,
    clean_latrines bigint,
    latrines_with_cleaning_schedules_posted bigint,
    latrines_with_privacy bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.sanitations OWNER TO health_builders;

--
-- Name: _41_37_to38_sanitation_and_toilet; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_37_to38_sanitation_and_toilet AS
 SELECT s.survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    (COALESCE(s.functional_patient_latrines, (0)::bigint) + COALESCE(s.functional_staff_latrines, (0)::bigint)) AS total_functional_latrines,
    COALESCE(s.clean_latrines, (0)::bigint) AS clean_latrines,
        CASE
            WHEN ((COALESCE(s.functional_patient_latrines, (0)::bigint) + COALESCE(s.functional_staff_latrines, (0)::bigint)) = COALESCE(s.clean_latrines, (0)::bigint)) THEN 1
            ELSE 0
        END AS _41_37_all_functional_latrines_are_clean,
        CASE
            WHEN ((t.supplies_located_in_each_hygiene_facility = true) AND (t.hand_hygiene_procedures_based_on_current_evidence = true)) THEN 1
            ELSE 0
        END AS _41_38_handwashing_with_suplies_toilet
   FROM ((((public.sanitations s
     JOIN public.qr_codes q ON ((s.survey_id = q.id)))
     LEFT JOIN public.toilets t ON ((s.survey_id = t.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._41_37_to38_sanitation_and_toilet OWNER TO health_builders;

--
-- Name: pharmacy_reviews; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pharmacy_reviews (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    stock_room_dry boolean,
    stock_room_clean boolean,
    drugs_protected_from_direct_sunlight boolean,
    drugs_well_organized boolean,
    stock_room_thermometer_available boolean,
    stock_room_temperature numeric,
    refrigerator_thermometer_available boolean,
    refrigerator_inside_temperature numeric,
    refrigerator_monitored_twice_daily boolean,
    requisitions_signed_and_stamped boolean,
    monthly_inventory_report_available boolean,
    essential_drugscurrent_book_available boolean,
    drugs_delivery_notes_filed boolean,
    dispensary_consumption_register_available boolean,
    dispensary_consumption_tallies_available boolean,
    dispensary_requisition_book_available boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.pharmacy_reviews OWNER TO health_builders;

--
-- Name: _41_39_to41_financial_management; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_39_to41_financial_management AS
 SELECT a.survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (a.reconciliation_done_monthly = true) THEN 1
            ELSE 0
        END AS account_reconciliation_done_monthly,
        CASE
            WHEN (pr.essential_drugscurrent_book_available = true) THEN 1
            ELSE 0
        END AS _41_39_essential_drugs_current_book_available,
        CASE
            WHEN (fcm.frequency_id = 1) THEN 1
            ELSE 0
        END AS _41_40_qi_committe_meetings,
        CASE
            WHEN (b.includes_capital_and_maintenance = true) THEN 1
            ELSE 0
        END AS _41_41_budget_includes_capital_and_maintenance
   FROM ((((((public.accounts a
     JOIN public.qr_codes q ON ((a.survey_id = q.id)))
     LEFT JOIN public.pharmacy_reviews pr ON ((a.survey_id = pr.survey_id)))
     LEFT JOIN ( SELECT frequency_of_committee_meetings.survey_id,
            frequency_of_committee_meetings.frequency_id
           FROM public.frequency_of_committee_meetings
          WHERE (frequency_of_committee_meetings.meeting_id = 5)) fcm ON ((a.survey_id = fcm.survey_id)))
     LEFT JOIN public.budgets b ON ((a.survey_id = b.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public._41_39_to41_financial_management OWNER TO health_builders;

--
-- Name: _41_4_dispensary_tallysheet_match_consumption; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_4_dispensary_tallysheet_match_consumption AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::integer AS amitriptyline_tallysheet_match_consumption,
    NULL::integer AS metformin_tallysheet_match_consumption,
    NULL::integer AS methyldopa_tallysheet_match_consumption,
    NULL::integer AS nifedipine_tallysheet_match_consumption,
    NULL::integer AS amilodipine_tallysheet_match_consumption,
    NULL::integer AS hydrochlorothiazide_tallysheet_match_consumption,
    NULL::integer AS beclomethasone_tallysheet_match_consumption,
    NULL::integer AS amoxicillin_tallysheet_match_consumption,
    NULL::integer AS atenolol_tallysheet_match_consumption,
    NULL::integer AS captopril_tallysheet_match_consumption,
    NULL::integer AS ciprofloxacin_tallysheet_match_consumption,
    NULL::integer AS cotrimoxazole_tallysheet_match_consumption,
    NULL::integer AS dexamethasone_tallysheet_match_consumption,
    NULL::integer AS diazepam_tallysheet_match_consumption,
    NULL::integer AS diclofenac_tallysheet_match_consumption,
    NULL::integer AS glibenclamide_tallysheet_match_consumption,
    NULL::integer AS oxyctocin_tallysheet_match_consumption,
    NULL::integer AS paracetamol_tallysheet_match_consumption,
    NULL::integer AS salbutamol_tallysheet_match_consumption,
    NULL::integer AS vitamin_tallysheet_match_consumption,
    NULL::integer AS expected_drugs,
    NULL::bigint AS total_available_drugs,
    NULL::integer AS accurate_tallysheet_count,
    NULL::numeric AS acurate_tallysheet_ratio,
    NULL::integer AS _41_4_drugs_have_accurate_tallysheets;


ALTER VIEW public._41_4_dispensary_tallysheet_match_consumption OWNER TO health_builders;

--
-- Name: _41_5_to6_stockcard_shelf_quantity; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_5_to6_stockcard_shelf_quantity AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::integer AS amitriptyline_card_matches_shelf,
    NULL::integer AS metformin_card_matches_shelf,
    NULL::integer AS methyldopa_card_matches_shelf,
    NULL::integer AS nifedipine_card_matches_shelf,
    NULL::integer AS amilodipine_card_matches_shelf,
    NULL::integer AS hydrochlorothiazide_card_matches_shelf,
    NULL::integer AS beclomethasone_card_matches_shelf,
    NULL::integer AS amoxicillin_card_matches_shelf,
    NULL::integer AS atenolol_card_matches_shelf,
    NULL::integer AS captopril_card_matches_shelf,
    NULL::integer AS ciprofloxacin_card_matches_shelf,
    NULL::integer AS cotrimoxazole_card_matches_shelf,
    NULL::integer AS dexamethasone_card_matches_shelf,
    NULL::integer AS diazepam_card_matches_shelf,
    NULL::integer AS diclofenac_card_matches_shelf,
    NULL::integer AS glibenclamide_card_matches_shelf,
    NULL::integer AS oxyctocin_card_matches_shelf,
    NULL::integer AS paracetamol_card_matches_shelf,
    NULL::integer AS salbutamol_card_matches_shelf,
    NULL::integer AS vitamin_card_matches_shelf,
    NULL::integer AS expected_drugs,
    NULL::bigint AS total_available_drugs,
    NULL::integer AS matched_quantity_count,
    NULL::numeric AS matched_quantity_ratio,
    NULL::integer AS _41_5_drugs_on_card_matched_shelf_quantity,
    NULL::integer AS _41_6_requisitions_signed_and_stamped;


ALTER VIEW public._41_5_to6_stockcard_shelf_quantity OWNER TO health_builders;

--
-- Name: _41_7_stock_management_drugs_care; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_7_stock_management_drugs_care AS
SELECT
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS district,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::integer AS amitriptyline_labeled,
    NULL::integer AS metformin_labeled,
    NULL::integer AS methyldopa_labeled,
    NULL::integer AS nifedipine_labeled,
    NULL::integer AS amilodipine_labeled,
    NULL::integer AS hydrochlorothiazide_labeled,
    NULL::integer AS beclomethasone_labeled,
    NULL::integer AS amoxicillin_labeled,
    NULL::integer AS atenolol_labeled,
    NULL::integer AS captopril_labeled,
    NULL::integer AS ciprofloxacin_labeled,
    NULL::integer AS cotrimoxazole_labeled,
    NULL::integer AS dexamethasone_labeled,
    NULL::integer AS diazepam_labeled,
    NULL::integer AS diclofenac_labeled,
    NULL::integer AS glibenclamide_labeled,
    NULL::integer AS oxyctocin_labeled,
    NULL::integer AS paracetamol_labeled,
    NULL::integer AS salbutamol_labeled,
    NULL::integer AS vitamin_labeled,
    NULL::integer AS drugs_protected_from_direct_sunlight,
    NULL::integer AS drugs_well_organized,
    NULL::integer AS drugs_labeled_organized_protected_count,
    NULL::bigint AS drugs_labeled_organized_protected,
    NULL::integer AS expected_drugs,
    NULL::bigint AS total_available_drugs,
    NULL::numeric AS labeled_organized_protected_ratio,
    NULL::integer AS _41_7_drugs_are_labeled_organized_protected;


ALTER VIEW public._41_7_stock_management_drugs_care OWNER TO health_builders;

--
-- Name: expired_drugs_managements; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.expired_drugs_managements (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    expired_drugs_stored_in_separate_room boolean,
    forms_signed_by_health_center_and_district_pharmacy boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.expired_drugs_managements OWNER TO health_builders;

--
-- Name: _41_8_to12_pharmacy_review_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_8_to12_pharmacy_review_summary AS
 SELECT pr.survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (pr.drugs_delivery_notes_filed IS TRUE) THEN 1
            ELSE 0
        END AS _41_8_drugs_delivery_notes_filed,
        CASE
            WHEN (pr.refrigerator_monitored_twice_daily IS TRUE) THEN 1
            ELSE 0
        END AS _41_9_refrigerator_monitored_twice_daily,
        CASE
            WHEN (pr.stock_room_dry IS TRUE) THEN 1
            ELSE 0
        END AS stock_room_dry,
        CASE
            WHEN (pr.stock_room_clean IS TRUE) THEN 1
            ELSE 0
        END AS stock_room_clean,
        CASE
            WHEN ((pr.stock_room_dry IS TRUE) AND (pr.stock_room_clean IS TRUE)) THEN 1
            ELSE 0
        END AS _41_10_stock_room_clean_and_dry,
        CASE
            WHEN (pr.monthly_inventory_report_available IS TRUE) THEN 1
            ELSE 0
        END AS _41_11_monthly_inventory_report_available,
        CASE
            WHEN (edm.expired_drugs_stored_in_separate_room IS TRUE) THEN 1
            ELSE 0
        END AS _41_12_expired_drugs_stored_in_separate_room
   FROM ((((public.pharmacy_reviews pr
     JOIN public.qr_codes qr ON ((pr.survey_id = qr.id)))
     JOIN public.expired_drugs_managements edm ON ((pr.survey_id = edm.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public._41_8_to12_pharmacy_review_summary OWNER TO health_builders;

--
-- Name: _41_indicators_merged; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_indicators_merged AS
 SELECT _41_1.survey_id,
    _41_1.survey_year,
    _41_1.district,
    _41_1.health_facility,
    _41_1.facility_type,
    _41_1._41_1_tallysheets_used_to_track_consumption,
    _41_2to3._41_2_drugs_have_an_updated_consumption_register,
    _41_2to3._41_3_consumption_register_available_in_dispensary,
    _41_4._41_4_drugs_have_accurate_tallysheets,
    _41_5to6._41_5_drugs_on_card_matched_shelf_quantity,
    _41_5to6._41_6_requisitions_signed_and_stamped,
    _41_7._41_7_drugs_are_labeled_organized_protected,
    _41_8to12._41_8_drugs_delivery_notes_filed,
    _41_8to12._41_9_refrigerator_monitored_twice_daily,
    _41_8to12._41_10_stock_room_clean_and_dry,
    _41_8to12._41_11_monthly_inventory_report_available,
    _41_8to12._41_12_expired_drugs_stored_in_separate_room,
    _41_13to14._41_13_staff_meetings,
    _41_13to14._41_14_implemented_inservice_training_plan,
    _41_15to17._41_15_uptodate_external_training_register,
    _41_15to17._41_16_uptodate_work_schedule,
    _41_15to17._41_17_uptodate_attendance_register,
    _41_18._41_18_there_are_clear_visible_signage,
    _41_19to24._41_19_incomes_in_book_and_journal_matched,
    _41_19to24._41_20_all_three_transactions_had_required_supporting,
    _41_19to24._41_21_budget_is_approved_and_tracked,
    _41_19to24._41_22_each_account_has_separate_book AS _22_each_account_has_separate_book,
    _41_19to24._41_23_updated_petty_cash_book_and_cash_register_available,
    _41_19to24._41_24_transactions_numbered_and_ordered_sequentially,
    _41_25to26._41_25_coge_meeting,
    _41_25to26._41_26_cosa_meeting,
    _41_27._41_27_current_job_descriptions_written_for_each_leader,
    _41_28._41_28_action_plan_titualire_approved_and_tracked,
    _41_29._41_29_available_updated_org_chart,
    _41_30._41_30_lines_of_register_80_percent_complete,
    _41_31._41_31_current_and_relevant_data_displayed,
    _41_32._41_32_reports_95_percent_accurate_across_sources,
    _41_33to35._41_33_report_signed_and_submited_on_time,
    _41_33to35._41_34_sop_for_datamanagement_available,
    _41_33to35._41_35_chw_meetings,
    _41_36._41_36_business_plan_approved_and_tracked,
    _41_37to38._41_37_all_functional_latrines_are_clean,
    _41_37to38._41_38_handwashing_with_suplies_toilet,
    _41_39to41._41_39_essential_drugs_current_book_available,
    _41_39to41._41_40_qi_committe_meetings,
    _41_39to41._41_41_budget_includes_capital_and_maintenance
   FROM ((((((((((((((((((((public._41_1_dispensary_tallysheet_tracking _41_1
     LEFT JOIN public._41_2_to3_dispensary_consumption_tracking _41_2to3 ON ((_41_1.survey_id = _41_2to3.survey_id)))
     LEFT JOIN public._41_4_dispensary_tallysheet_match_consumption _41_4 ON ((_41_1.survey_id = _41_4.survey_id)))
     LEFT JOIN public._41_5_to6_stockcard_shelf_quantity _41_5to6 ON ((_41_1.survey_id = _41_5to6.survey_id)))
     LEFT JOIN public._41_7_stock_management_drugs_care _41_7 ON ((_41_1.survey_id = _41_7.survey_id)))
     LEFT JOIN public._41_8_to12_pharmacy_review_summary _41_8to12 ON ((_41_1.survey_id = _41_8to12.survey_id)))
     LEFT JOIN public._41_13_to14_staff_meetings_inservice_training_plan _41_13to14 ON ((_41_1.survey_id = _41_13to14.survey_id)))
     LEFT JOIN public._41_15_to17_external_training_work_schedules _41_15to17 ON ((_41_1.survey_id = _41_15to17.survey_id)))
     LEFT JOIN public._41_18_service_area_description _41_18 ON ((_41_1.survey_id = _41_18.survey_id)))
     LEFT JOIN public._41_19_to24_financial_review_summary _41_19to24 ON ((_41_1.survey_id = _41_19to24.survey_id)))
     LEFT JOIN public._41_25_to26_committee_meetings _41_25to26 ON ((_41_1.survey_id = _41_25to26.survey_id)))
     LEFT JOIN public._41_27_job_description_main _41_27 ON ((_41_1.survey_id = _41_27.survey_id)))
     LEFT JOIN public._41_28_action_plans _41_28 ON ((_41_1.survey_id = _41_28.survey_id)))
     LEFT JOIN public._41_29_organization_charts _41_29 ON ((_41_1.survey_id = _41_29.survey_id)))
     LEFT JOIN public._41_30_opd_registers_completeness _41_30 ON ((_41_1.survey_id = _41_30.survey_id)))
     LEFT JOIN public._41_31_curent_data_displayed _41_31 ON ((_41_1.survey_id = _41_31.survey_id)))
     LEFT JOIN public._41_32_data_accuracies _41_32 ON ((_41_1.survey_id = _41_32.survey_id)))
     LEFT JOIN public._41_33_to35_monthly_data _41_33to35 ON ((_41_1.survey_id = _41_33to35.survey_id)))
     LEFT JOIN public._41_36_business_plan _41_36 ON ((_41_1.survey_id = _41_36.survey_id)))
     LEFT JOIN public._41_37_to38_sanitation_and_toilet _41_37to38 ON ((_41_1.survey_id = _41_37to38.survey_id)))
     LEFT JOIN public._41_39_to41_financial_management _41_39to41 ON ((_41_1.survey_id = _41_39to41.survey_id)));


ALTER VIEW public._41_indicators_merged OWNER TO health_builders;

--
-- Name: _41_indicators_merged_ordered; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public._41_indicators_merged_ordered AS
 SELECT DISTINCT _41_1.survey_id,
    _41_1.survey_year,
    _41_1.district,
    _41_1.health_facility,
    _41_1.facility_type,
    _41_4._41_4_drugs_have_accurate_tallysheets,
    _41_2to3._41_2_drugs_have_an_updated_consumption_register,
    _41_5to6._41_5_drugs_on_card_matched_shelf_quantity,
    _41_5to6._41_6_requisitions_signed_and_stamped,
    _41_39to41._41_39_essential_drugs_current_book_available,
    _41_7._41_7_drugs_are_labeled_organized_protected,
    _41_8to12._41_8_drugs_delivery_notes_filed,
    _41_8to12._41_9_refrigerator_monitored_twice_daily,
    _41_8to12._41_10_stock_room_clean_and_dry,
    _41_1._41_1_tallysheets_used_to_track_consumption,
    _41_2to3._41_3_consumption_register_available_in_dispensary,
    _41_8to12._41_11_monthly_inventory_report_available,
    _41_8to12._41_12_expired_drugs_stored_in_separate_room,
    _41_13to14._41_13_staff_meetings,
    _41_13to14._41_14_implemented_inservice_training_plan,
    _41_15to17._41_15_uptodate_external_training_register,
    _41_15to17._41_16_uptodate_work_schedule,
    _41_15to17._41_17_uptodate_attendance_register,
    _41_39to41._41_40_qi_committe_meetings,
    _41_18._41_18_there_are_clear_visible_signage,
    _41_19to24._41_19_incomes_in_book_and_journal_matched,
    _41_19to24._41_20_all_three_transactions_had_required_supporting,
    _41_39to41._41_41_budget_includes_capital_and_maintenance,
    _41_19to24._41_21_budget_is_approved_and_tracked,
    _41_19to24._41_22_each_account_has_separate_book AS _22_each_account_has_separate_book,
    _41_19to24._41_23_updated_petty_cash_book_and_cash_register_available,
    _41_19to24._41_24_transactions_numbered_and_ordered_sequentially,
    _41_25to26._41_25_coge_meeting,
    _41_25to26._41_26_cosa_meeting,
    _41_27._41_27_current_job_descriptions_written_for_each_leader,
    _41_28._41_28_action_plan_titualire_approved_and_tracked,
    _41_29._41_29_available_updated_org_chart,
    _41_30._41_30_lines_of_register_80_percent_complete,
    _41_31._41_31_current_and_relevant_data_displayed,
    _41_32._41_32_reports_95_percent_accurate_across_sources,
    _41_33to35._41_33_report_signed_and_submited_on_time,
    _41_33to35._41_34_sop_for_datamanagement_available,
    _41_33to35._41_35_chw_meetings,
    _41_36._41_36_business_plan_approved_and_tracked,
    _41_37to38._41_37_all_functional_latrines_are_clean,
    _41_37to38._41_38_handwashing_with_suplies_toilet
   FROM ((((((((((((((((((((public._41_1_dispensary_tallysheet_tracking _41_1
     LEFT JOIN public._41_2_to3_dispensary_consumption_tracking _41_2to3 ON ((_41_1.survey_id = _41_2to3.survey_id)))
     LEFT JOIN public._41_4_dispensary_tallysheet_match_consumption _41_4 ON ((_41_1.survey_id = _41_4.survey_id)))
     LEFT JOIN public._41_5_to6_stockcard_shelf_quantity _41_5to6 ON ((_41_1.survey_id = _41_5to6.survey_id)))
     LEFT JOIN public._41_7_stock_management_drugs_care _41_7 ON ((_41_1.survey_id = _41_7.survey_id)))
     LEFT JOIN public._41_8_to12_pharmacy_review_summary _41_8to12 ON ((_41_1.survey_id = _41_8to12.survey_id)))
     LEFT JOIN public._41_13_to14_staff_meetings_inservice_training_plan _41_13to14 ON ((_41_1.survey_id = _41_13to14.survey_id)))
     LEFT JOIN public._41_15_to17_external_training_work_schedules _41_15to17 ON ((_41_1.survey_id = _41_15to17.survey_id)))
     LEFT JOIN public._41_18_service_area_description _41_18 ON ((_41_1.survey_id = _41_18.survey_id)))
     LEFT JOIN public._41_19_to24_financial_review_summary _41_19to24 ON ((_41_1.survey_id = _41_19to24.survey_id)))
     LEFT JOIN public._41_25_to26_committee_meetings _41_25to26 ON ((_41_1.survey_id = _41_25to26.survey_id)))
     LEFT JOIN public._41_27_job_description_main _41_27 ON ((_41_1.survey_id = _41_27.survey_id)))
     LEFT JOIN public._41_28_action_plans _41_28 ON ((_41_1.survey_id = _41_28.survey_id)))
     LEFT JOIN public._41_29_organization_charts _41_29 ON ((_41_1.survey_id = _41_29.survey_id)))
     LEFT JOIN public._41_30_opd_registers_completeness _41_30 ON ((_41_1.survey_id = _41_30.survey_id)))
     LEFT JOIN public._41_31_curent_data_displayed _41_31 ON ((_41_1.survey_id = _41_31.survey_id)))
     LEFT JOIN public._41_32_data_accuracies _41_32 ON ((_41_1.survey_id = _41_32.survey_id)))
     LEFT JOIN public._41_33_to35_monthly_data _41_33to35 ON ((_41_1.survey_id = _41_33to35.survey_id)))
     LEFT JOIN public._41_36_business_plan _41_36 ON ((_41_1.survey_id = _41_36.survey_id)))
     LEFT JOIN public._41_37_to38_sanitation_and_toilet _41_37to38 ON ((_41_1.survey_id = _41_37to38.survey_id)))
     LEFT JOIN public._41_39_to41_financial_management _41_39to41 ON ((_41_1.survey_id = _41_39to41.survey_id)));


ALTER VIEW public._41_indicators_merged_ordered OWNER TO health_builders;

--
-- Name: accuracy_BCG; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."accuracy_BCG" AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.register,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / da.hmis_report))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE ((da.register - da.hmis_database) / da.register)
        END AS hmis_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0)) THEN 0
            ELSE
            CASE
                WHEN (((abs(((da.hmis_report - da.hmis_database) / da.hmis_report)))::numeric < 0.05) AND ((((da.register - da.hmis_database) / da.register))::numeric < 0.05)) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Hypertension, Old Cases, 40+, Female'::text);


ALTER VIEW public."accuracy_BCG" OWNER TO health_builders;

--
-- Name: additional_pharmacy_informations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.additional_pharmacy_informations (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    frequency_of_internal_requisitions text,
    drugs_organization text,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.additional_pharmacy_informations OWNER TO health_builders;

--
-- Name: additional_suggestions; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.additional_suggestions (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_id uuid,
    suggestion text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.additional_suggestions OWNER TO health_builders;

--
-- Name: admitted_patients_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.admitted_patients_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    admission_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    discharge_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    outcome text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.admitted_patients_outcomes OWNER TO health_builders;

--
-- Name: asthma_classifications; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.asthma_classifications (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    month_one_classification text NOT NULL,
    month_two_classification text NOT NULL,
    month_three_classification text NOT NULL,
    month_four_classification text NOT NULL,
    month_five_classification text NOT NULL,
    month_six_classification text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.asthma_classifications OWNER TO health_builders;

--
-- Name: asthma_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.asthma_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    bp_checked_each_visit boolean DEFAULT false NOT NULL,
    asthma_severity_classfied boolean DEFAULT false NOT NULL,
    appropriate_antiasthmatic_treatment boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.asthma_treatment_guidelines OWNER TO health_builders;

--
-- Name: survey_basic_informations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.survey_basic_informations (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    sector text,
    number_of_cells bigint,
    number_of_villages bigint,
    number_of_public_health_posts bigint,
    number_of_private_health_posts bigint,
    population bigint,
    number_of_patients_per_day bigint,
    number_of_beds bigint,
    number_of_consultation_rooms bigint,
    number_of_hospitalization_rooms bigint,
    number_of_chw bigint,
    number_of_a0_nurses bigint,
    number_of_a1_nurses bigint,
    number_of_a2_nurses bigint,
    number_of_midwives bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.survey_basic_informations OWNER TO health_builders;

--
-- Name: basicinformation_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.basicinformation_view AS
 SELECT d.district AS district_name,
    hc.name AS health_facility,
    qr.survey_year,
    qr.health_center,
    hc.type AS facility_type,
    sbi.survey_id,
    sbi.sector,
    sbi.number_of_cells,
    sbi.number_of_villages,
    sbi.number_of_public_health_posts,
    sbi.number_of_private_health_posts,
    sbi.population,
    sbi.number_of_patients_per_day,
    sbi.number_of_beds,
    sbi.number_of_consultation_rooms,
    sbi.number_of_hospitalization_rooms,
    sbi.number_of_chw,
    sbi.number_of_a0_nurses,
    sbi.number_of_a1_nurses,
    sbi.number_of_a2_nurses,
    sbi.number_of_midwives
   FROM (((public.survey_basic_informations sbi
     LEFT JOIN public.qr_codes qr ON ((sbi.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.basicinformation_view OWNER TO health_builders;

--
-- Name: cardiomyopathy_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.cardiomyopathy_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    echocardiography_done_last12_months boolean DEFAULT false NOT NULL,
    echocardiography_justification text,
    complete_physical_assessment boolean DEFAULT false NOT NULL,
    physical_assesment_justification text,
    correct_treatment_provided boolean DEFAULT false NOT NULL,
    correct_treatment_justification text,
    nutrional_education_provided boolean DEFAULT false NOT NULL,
    nutrional_education_justification text,
    serum_electrolytes_on_last_three_visits boolean DEFAULT false NOT NULL,
    serum_electrolytes_justification text
);


ALTER TABLE public.cardiomyopathy_treatment_guidelines OWNER TO health_builders;

--
-- Name: cardiomyopathy_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.cardiomyopathy_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    nyha_initial_value bigint NOT NULL,
    nyha_latest_month_value bigint NOT NULL,
    nyha_previous_month_value bigint NOT NULL,
    nyha_before_previous_month_value bigint NOT NULL,
    ef_latest_value numeric NOT NULL,
    ef_six_months_ago_value numeric NOT NULL,
    ef_one_year_ago_value numeric NOT NULL
);


ALTER TABLE public.cardiomyopathy_treatment_outcomes OWNER TO health_builders;

--
-- Name: cough_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.cough_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    assessment_is_complete boolean DEFAULT false NOT NULL,
    classification_is_accurate boolean DEFAULT false NOT NULL,
    no_anti_biotic_given boolean DEFAULT false NOT NULL,
    education_given boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.cough_treatment_guidelines OWNER TO health_builders;

--
-- Name: check_Cough_treatment; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."check_Cough_treatment" AS
 SELECT districts.district,
    qr_codes.survey_year,
    health_centers.name AS "HC",
    cough_treatment_guidelines.survey_id,
    health_centers.type,
    cough_treatment_guidelines.created_by,
    cough_treatment_guidelines.assessment_is_complete,
    cough_treatment_guidelines.classification_is_accurate,
    cough_treatment_guidelines.no_anti_biotic_given,
    cough_treatment_guidelines.education_given,
    qr_codes.health_center AS hc2
   FROM (((public.qr_codes
     JOIN public.cough_treatment_guidelines ON ((qr_codes.id = cough_treatment_guidelines.survey_id)))
     JOIN public.health_centers ON ((qr_codes.health_center_id = health_centers.id)))
     JOIN public.districts ON (((health_centers.district_id = districts.id) AND (qr_codes.district_id = districts.id))));


ALTER VIEW public."check_Cough_treatment" OWNER TO health_builders;

--
-- Name: closing_balances; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.closing_balances (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    financial_year character varying(255),
    bank numeric(15,2),
    petty_cash numeric(15,2),
    receivables numeric(15,2),
    payables numeric(15,2),
    pharmacy_debt numeric(15,2),
    hc_total_revenue numeric(15,2),
    hc_income numeric(15,2),
    medicine_sales numeric(15,2),
    hc_total_expenses numeric(15,2),
    hr_expenses numeric(15,2),
    hc_staff_salary_expenditure numeric(15,2),
    purchased_medicine numeric(15,2),
    medical_equipment numeric(15,2),
    travel numeric(15,2),
    actual_budget numeric(15,2),
    planned_budget numeric(15,2),
    last_synced_at timestamp with time zone
);


ALTER TABLE public.closing_balances OWNER TO health_builders;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.comments (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    comment text NOT NULL,
    section text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.comments OWNER TO health_builders;

--
-- Name: completeness_of_opd_registers; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.completeness_of_opd_registers (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    line_number bigint,
    number_of_fields bigint,
    number_of_blanks bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.completeness_of_opd_registers OWNER TO health_builders;

--
-- Name: data accuracies_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."data accuracies_view" AS
 SELECT da.survey_id,
    qr.survey_year,
    d.district AS district_name,
    hc.name AS health_center_name,
    hc.type AS facility_type,
    da.created_at,
    date_part('year'::text, da.created_at) AS record_year,
    date_part('month'::text, da.created_at) AS record_month,
    da.source,
    da.patient_file,
    da.register,
    da.lab_register,
    da.tally_sheet,
    da.pharmacy,
    da.hmis_report,
    da.hmis_database,
    da.accurate
   FROM (((public.data_accuracies da
     LEFT JOIN public.qr_codes qr ON ((da.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public."data accuracies_view" OWNER TO health_builders;

--
-- Name: diabetes_clearances; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_clearances (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    age text NOT NULL,
    weight numeric NOT NULL,
    gender text NOT NULL,
    creatinine_unit text,
    creatinine_value text
);


ALTER TABLE public.diabetes_clearances OWNER TO health_builders;

--
-- Name: new_diabetes_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.new_diabetes_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    assessment_type text NOT NULL,
    hba1c_quarterlast numeric,
    hba1c_quarterbefore numeric,
    glycemia_initial numeric,
    glycemia_previous numeric,
    glycemia_latest numeric,
    proteinuria text,
    peripheral_neuropathy text
);


ALTER TABLE public.new_diabetes_treatment_outcomes OWNER TO health_builders;

--
-- Name: merged_diabetes_treatment_outcomes_new; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diabetes_treatment_outcomes_new AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.assessment_type,
    a.hba1c_quarterlast,
    a.hba1c_quarterbefore,
    a.glycemia_initial,
    a.glycemia_previous,
    a.glycemia_latest,
    a.proteinuria,
    a.peripheral_neuropathy
   FROM (((public.new_diabetes_treatment_outcomes a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_diabetes_treatment_outcomes_new OWNER TO health_builders;

--
-- Name: diabetes_controlled_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.diabetes_controlled_view AS
 SELECT merged_diabetes_treatment_outcomes_new.survey_year,
    merged_diabetes_treatment_outcomes_new.district,
    merged_diabetes_treatment_outcomes_new.health_facility,
    merged_diabetes_treatment_outcomes_new.facility_type,
    merged_diabetes_treatment_outcomes_new.patient_id,
    merged_diabetes_treatment_outcomes_new.glycemia_initial,
    merged_diabetes_treatment_outcomes_new.glycemia_previous,
    merged_diabetes_treatment_outcomes_new.glycemia_latest,
        CASE
            WHEN ((merged_diabetes_treatment_outcomes_new.glycemia_initial IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_previous IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_latest IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_initial <= (126)::numeric) AND (merged_diabetes_treatment_outcomes_new.glycemia_previous <= (126)::numeric) AND (merged_diabetes_treatment_outcomes_new.glycemia_latest <= (126)::numeric)) THEN 1
            ELSE 0
        END AS controlled
   FROM public.merged_diabetes_treatment_outcomes_new;


ALTER VIEW public.diabetes_controlled_view OWNER TO health_builders;

--
-- Name: diabetes_glycemia_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_glycemia_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint,
    month_one_value numeric,
    month_two_value numeric,
    month_three_value numeric,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diabetes_glycemia_treatment_outcomes OWNER TO health_builders;

--
-- Name: diabetes_hba1c_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_hba1c_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    previous_quarter_value numeric,
    before_previous_quarter_value numeric,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diabetes_hba1c_treatment_outcomes OWNER TO health_builders;

--
-- Name: diabetes_knowledge_on_home_self_managements; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_knowledge_on_home_self_managements (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    age_id bigint NOT NULL,
    gender_id bigint NOT NULL,
    education_level_id bigint NOT NULL,
    illness_duration_id bigint NOT NULL,
    condition_awareness boolean NOT NULL,
    low_suger_diet_awareness boolean NOT NULL,
    knows_dose_timing boolean NOT NULL,
    knows_dose_amount boolean NOT NULL,
    aware_bg_check_at_chws boolean NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diabetes_knowledge_on_home_self_managements OWNER TO health_builders;

--
-- Name: ncd_patient_age_ranges; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_patient_age_ranges (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.ncd_patient_age_ranges OWNER TO health_builders;

--
-- Name: ncd_patient_education_levels; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_patient_education_levels (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.ncd_patient_education_levels OWNER TO health_builders;

--
-- Name: ncd_patient_genders; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_patient_genders (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.ncd_patient_genders OWNER TO health_builders;

--
-- Name: ncd_patient_illness_durations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_patient_illness_durations (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.ncd_patient_illness_durations OWNER TO health_builders;

--
-- Name: diabetes_knowledge_on_self_management_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.diabetes_knowledge_on_self_management_view AS
 SELECT dkohsm.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    dkohsm.id AS patient_id,
    npar.value AS age_range,
    npg.value AS gender,
    npel.value AS education_level,
    npid.value AS illness_duration,
    dkohsm.condition_awareness,
    dkohsm.low_suger_diet_awareness,
    dkohsm.knows_dose_timing,
    dkohsm.knows_dose_amount,
    dkohsm.aware_bg_check_at_chws
   FROM (((((((public.diabetes_knowledge_on_home_self_managements dkohsm
     LEFT JOIN public.qr_codes qr ON ((dkohsm.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
     LEFT JOIN public.ncd_patient_age_ranges npar ON ((dkohsm.age_id = npar.id)))
     LEFT JOIN public.ncd_patient_genders npg ON ((dkohsm.gender_id = npg.id)))
     LEFT JOIN public.ncd_patient_education_levels npel ON ((dkohsm.education_level_id = npel.id)))
     LEFT JOIN public.ncd_patient_illness_durations npid ON ((dkohsm.illness_duration_id = npid.id)));


ALTER VIEW public.diabetes_knowledge_on_self_management_view OWNER TO health_builders;

--
-- Name: diabetes_nephropathy_prevalences; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_nephropathy_prevalences (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    follow_up_patients_number bigint NOT NULL
);


ALTER TABLE public.diabetes_nephropathy_prevalences OWNER TO health_builders;

--
-- Name: diabetes_treatment_guidelines_copy; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_treatment_guidelines_copy (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    current_protocol_available boolean DEFAULT false,
    hbalc_checked boolean DEFAULT false,
    bp_checked_each_visit boolean DEFAULT false NOT NULL,
    eye_checked_last12_months boolean DEFAULT false,
    foot_checked_last12_months boolean DEFAULT false NOT NULL,
    urine_protein_checked_last6_months boolean DEFAULT false NOT NULL,
    creatinine_checked_last12_months boolean DEFAULT false NOT NULL,
    correct_treatment_provided boolean DEFAULT false,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diabetes_treatment_guidelines_copy OWNER TO health_builders;

--
-- Name: diabetes_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diabetes_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    month_one_value numeric NOT NULL,
    month_two_value numeric NOT NULL,
    month_three_value numeric NOT NULL,
    month_four_value numeric NOT NULL,
    month_five_value numeric NOT NULL,
    month_six_value numeric NOT NULL
);


ALTER TABLE public.diabetes_treatment_outcomes OWNER TO health_builders;

--
-- Name: diarrhoea_key_performance_indicators; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diarrhoea_key_performance_indicators (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    cases bigint NOT NULL,
    deaths bigint NOT NULL,
    review_year text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diarrhoea_key_performance_indicators OWNER TO health_builders;

--
-- Name: diarrhoea_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.diarrhoea_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    assessment_is_complete boolean NOT NULL,
    classification_is_accurate boolean NOT NULL,
    zinc_given boolean NOT NULL,
    ors_given boolean NOT NULL,
    education_given boolean NOT NULL,
    follow_up_appointment_given boolean NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.diarrhoea_treatment_guidelines OWNER TO health_builders;

--
-- Name: dyslipidemia_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.dyslipidemia_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    units_used text NOT NULL,
    initial_value text NOT NULL,
    latest_quarter_value text NOT NULL,
    previous_quarter_value text NOT NULL,
    before_previous_quarter_value text NOT NULL
);


ALTER TABLE public.dyslipidemia_treatment_outcomes OWNER TO health_builders;

--
-- Name: expected_questions; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.expected_questions (
    question_id text NOT NULL
);


ALTER TABLE public.expected_questions OWNER TO health_builders;

--
-- Name: facility_perfomance_observations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.facility_perfomance_observations (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    section_key character varying(255) NOT NULL,
    section_label character varying(255) NOT NULL,
    strengths text NOT NULL,
    areas_of_improvement text NOT NULL,
    recommendations text NOT NULL,
    team_leader_name character varying(255) NOT NULL,
    health_center_representative_name character varying(255),
    head_of_facility_feedback text,
    date_of_assessment timestamp without time zone NOT NULL
);


ALTER TABLE public.facility_perfomance_observations OWNER TO health_builders;

--
-- Name: failed_syncs; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.failed_syncs (
    id uuid NOT NULL,
    feature text NOT NULL,
    entity_id text NOT NULL,
    error_message text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_attempt_at timestamp without time zone NOT NULL,
    operation text NOT NULL,
    end_point text NOT NULL,
    error_code text NOT NULL,
    attempt bigint,
    payload_snapshot jsonb NOT NULL,
    is_synced boolean DEFAULT false NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.failed_syncs OWNER TO health_builders;

--
-- Name: fever_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.fever_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    assessment_is_complete boolean DEFAULT false NOT NULL,
    classification_is_accurate boolean DEFAULT false NOT NULL,
    malaria_test_done boolean DEFAULT false NOT NULL,
    correct_anti_pyretic_given boolean DEFAULT false NOT NULL,
    follow_up_appointment_given boolean DEFAULT false NOT NULL,
    education_given boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.fever_treatment_guidelines OWNER TO health_builders;

--
-- Name: health_educations; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.health_educations (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp with time zone,
    education_session text,
    beneficiaries bigint,
    screened bigint
);


ALTER TABLE public.health_educations OWNER TO health_builders;

--
-- Name: healthcenter_quality_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.healthcenter_quality_summary AS
 WITH calculated AS (
         SELECT output_41_final.district_name,
            output_41_final.healthcenter_name,
            output_41_final."MPS_Quarter",
            output_41_final.survey_year,
            ((((((((((((((((((((((((((((((((((((((((output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets" + output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis") + output_41_final."All 5 drug stock cards matched the quantity found on the shelf") + output_41_final."All requisitions are signed and stamped") + output_41_final."An essential drug list is available and used to order medicatio") + output_41_final."Drugs are well organized, labeled and protected from direct sun") + output_41_final."Pharmacy delivery notes are filed") + output_41_final."Refrigerator is monitored for temperature twice daily") + output_41_final."Stock room is dry and clean") + output_41_final."Tally sheets are used to track consumption") + output_41_final."There is a drug consumption register") + output_41_final."There is a pharmacy monthly inventory") + output_41_final."There is a separate room for expired drugs") + output_41_final."Monthly staff minutes shows that meetings are happening") + output_41_final."There is an implemented in-service training plan") + output_41_final."There is an up-to-date register/report of external trainings") + output_41_final."There is an updated work schedule") + output_41_final."Theres is an updated attendance register(actively used)") + output_41_final."QA is meeting on a monthly basis") + output_41_final."There is clear, visible internal signage that includes the name") + output_41_final."All 3 incomes recorded in the receipt book and journal matched") + output_41_final."All 3 transactions had required supporting documents") + output_41_final."The budget plan includes capital & maintenance") + output_41_final."The budget plan is approved by the titulaire and tracked") + output_41_final."There is an up to date individual bank book for each bank accou") + output_41_final."There is an up to date petty cash book and cash register") + output_41_final."Transactions are numbered and ordered sequentially") + output_41_final."COGE minutes show that the committee is meeting at least once p") + output_41_final."COSA minutes show that the committee is meeting at least once p") + output_41_final."Current job descriptions are written for each facility leader a") + output_41_final."The action plan is approved by the titulaire and tracked") + output_41_final."There is an updated organization chart") + output_41_final."All 15 randomly reviewed lines of the register were >80% comple") + output_41_final."Data displayed in services is current & relevant(at least in ma") + output_41_final."Data reports are >95% accurate across sources") + output_41_final."The monthly data report is signed and submitted on time") + output_41_final."There is an SOP for data management") + output_41_final."CHW minutes show that at least meetings are being held once per") + output_41_final."The business plan is approved by the titulaire and tracked") + output_41_final."All functional latrines are clean") + output_41_final."All functional latrines are equipped with hand washing stations") AS total_sum,
            ((((((((((((((((((((((((((((((((((((((((COALESCE(output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets", (0)::numeric) + COALESCE(output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis", (0)::numeric)) + COALESCE(output_41_final."All 5 drug stock cards matched the quantity found on the shelf", (0)::numeric)) + COALESCE(output_41_final."All requisitions are signed and stamped", (0)::numeric)) + COALESCE(output_41_final."An essential drug list is available and used to order medicatio", (0)::numeric)) + COALESCE(output_41_final."Drugs are well organized, labeled and protected from direct sun", (0)::numeric)) + COALESCE(output_41_final."Pharmacy delivery notes are filed", (0)::numeric)) + COALESCE(output_41_final."Refrigerator is monitored for temperature twice daily", (0)::numeric)) + COALESCE(output_41_final."Stock room is dry and clean", (0)::numeric)) + COALESCE(output_41_final."Tally sheets are used to track consumption", (0)::numeric)) + COALESCE(output_41_final."There is a drug consumption register", (0)::numeric)) + COALESCE(output_41_final."There is a pharmacy monthly inventory", (0)::numeric)) + COALESCE(output_41_final."There is a separate room for expired drugs", (0)::numeric)) + COALESCE(output_41_final."Monthly staff minutes shows that meetings are happening", (0)::numeric)) + COALESCE(output_41_final."There is an implemented in-service training plan", (0)::numeric)) + COALESCE(output_41_final."There is an up-to-date register/report of external trainings", (0)::numeric)) + COALESCE(output_41_final."There is an updated work schedule", (0)::numeric)) + COALESCE(output_41_final."Theres is an updated attendance register(actively used)", (0)::numeric)) + COALESCE(output_41_final."QA is meeting on a monthly basis", (0)::numeric)) + COALESCE(output_41_final."There is clear, visible internal signage that includes the name", (0)::numeric)) + COALESCE(output_41_final."All 3 incomes recorded in the receipt book and journal matched", (0)::numeric)) + COALESCE(output_41_final."All 3 transactions had required supporting documents", (0)::numeric)) + COALESCE(output_41_final."The budget plan includes capital & maintenance", (0)::numeric)) + COALESCE(output_41_final."The budget plan is approved by the titulaire and tracked", (0)::numeric)) + COALESCE(output_41_final."There is an up to date individual bank book for each bank accou", (0)::numeric)) + COALESCE(output_41_final."There is an up to date petty cash book and cash register", (0)::numeric)) + COALESCE(output_41_final."Transactions are numbered and ordered sequentially", (0)::numeric)) + COALESCE(output_41_final."COGE minutes show that the committee is meeting at least once p", (0)::numeric)) + COALESCE(output_41_final."COSA minutes show that the committee is meeting at least once p", (0)::numeric)) + COALESCE(output_41_final."Current job descriptions are written for each facility leader a", (0)::numeric)) + COALESCE(output_41_final."The action plan is approved by the titulaire and tracked", (0)::numeric)) + COALESCE(output_41_final."There is an updated organization chart", (0)::numeric)) + COALESCE(output_41_final."All 15 randomly reviewed lines of the register were >80% comple", (0)::numeric)) + COALESCE(output_41_final."Data displayed in services is current & relevant(at least in ma", (0)::numeric)) + COALESCE(output_41_final."Data reports are >95% accurate across sources", (0)::numeric)) + COALESCE(output_41_final."The monthly data report is signed and submitted on time", (0)::numeric)) + COALESCE(output_41_final."There is an SOP for data management", (0)::numeric)) + COALESCE(output_41_final."CHW minutes show that at least meetings are being held once per", (0)::numeric)) + COALESCE(output_41_final."The business plan is approved by the titulaire and tracked", (0)::numeric)) + COALESCE(output_41_final."All functional latrines are clean", (0)::numeric)) + COALESCE(output_41_final."All functional latrines are equipped with hand washing stations", (0)::numeric)) AS total_count
           FROM public.output_41_final
        )
 SELECT calculated.district_name,
    calculated.healthcenter_name,
    calculated."MPS_Quarter",
    calculated.survey_year,
    calculated.total_sum,
    calculated.total_count,
        CASE
            WHEN (calculated.total_count > (0)::numeric) THEN ((calculated.total_sum * 100.0) / calculated.total_count)
            ELSE (0)::numeric
        END AS percentage
   FROM calculated;


ALTER VIEW public.healthcenter_quality_summary OWNER TO health_builders;

--
-- Name: merged_diabetes_total_data_accurancies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diabetes_total_data_accurancies AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.register,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / da.hmis_report))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE ((da.register - da.hmis_database) / da.register)
        END AS hmis_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0)) THEN 0
            ELSE
            CASE
                WHEN (((abs(((da.hmis_report - da.hmis_database) / da.hmis_report)))::numeric < 0.05) AND ((((da.register - da.hmis_database) / da.register))::numeric < 0.05)) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Diabetes, Total Cases'::text);


ALTER VIEW public.merged_diabetes_total_data_accurancies OWNER TO health_builders;

--
-- Name: merged_hypertension_total_data_accurancies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_hypertension_total_data_accurancies AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.register,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / da.hmis_report))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE ((da.register - da.hmis_database) / da.register)
        END AS hmis_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0)) THEN 0
            ELSE
            CASE
                WHEN (((abs(((da.hmis_report - da.hmis_database) / da.hmis_report)))::numeric < 0.05) AND ((((da.register - da.hmis_database) / da.register))::numeric < 0.05)) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Hypertension, Total Cases'::text);


ALTER VIEW public.merged_hypertension_total_data_accurancies OWNER TO health_builders;

--
-- Name: hmis_db_over_register_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.hmis_db_over_register_view AS
 SELECT hypertension.survey_id,
    hypertension.district,
    hypertension.health_facility,
    hypertension.facility_type,
    hypertension.hmis_database AS hmis_database_hypertension_old_cases,
    hypertension.register AS register_hypertension_old_cases,
        CASE
            WHEN (GREATEST(hypertension.hmis_database, hypertension.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(hypertension.hmis_database, hypertension.register) - (GREATEST(hypertension.hmis_database, hypertension.register) - LEAST(hypertension.hmis_database, hypertension.register)))))::numeric / (GREATEST(hypertension.hmis_database, hypertension.register))::numeric) * (100)::numeric), 2)
        END AS percentage_hypertension_old_cases,
    deliveries.hmis_database AS hmis_database_deliveries,
    deliveries.register AS register_deliveries,
        CASE
            WHEN (GREATEST(deliveries.hmis_database, deliveries.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(deliveries.hmis_database, deliveries.register) - (GREATEST(deliveries.hmis_database, deliveries.register) - LEAST(deliveries.hmis_database, deliveries.register)))))::numeric / (GREATEST(deliveries.hmis_database, deliveries.register))::numeric) * (100)::numeric), 2)
        END AS percentage_deliveries,
    bcg.hmis_database AS hmis_database_bcg,
    bcg.register AS register_bcg,
        CASE
            WHEN (GREATEST(bcg.hmis_database, bcg.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(bcg.hmis_database, bcg.register) - (GREATEST(bcg.hmis_database, bcg.register) - LEAST(bcg.hmis_database, bcg.register)))))::numeric / (GREATEST(bcg.hmis_database, bcg.register))::numeric) * (100)::numeric), 2)
        END AS percentage_bcg,
    malaria.hmis_database AS hmis_database_malaria,
    malaria.register AS register_malaria,
        CASE
            WHEN (GREATEST(malaria.hmis_database, malaria.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(malaria.hmis_database, malaria.register) - (GREATEST(malaria.hmis_database, malaria.register) - LEAST(malaria.hmis_database, malaria.register)))))::numeric / (GREATEST(malaria.hmis_database, malaria.register))::numeric) * (100)::numeric), 2)
        END AS percentage_malaria,
    hypertension.survey_year,
    hypertension_total.hmis_database AS hmis_database_hypertension_total_cases,
    hypertension_total.register AS register_hypertension_total_cases,
        CASE
            WHEN (GREATEST(hypertension_total.hmis_database, hypertension_total.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(hypertension_total.hmis_database, hypertension_total.register) - (GREATEST(hypertension_total.hmis_database, hypertension_total.register) - LEAST(hypertension_total.hmis_database, hypertension_total.register)))))::numeric / (GREATEST(hypertension_total.hmis_database, hypertension_total.register))::numeric) * (100)::numeric), 2)
        END AS percentage_hypertension_total_cases,
    diabetes_total.hmis_database AS hmis_database_diabetes_total_cases,
    diabetes_total.register AS register_diabetes_total_cases,
        CASE
            WHEN (GREATEST(diabetes_total.hmis_database, diabetes_total.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(diabetes_total.hmis_database, diabetes_total.register) - (GREATEST(diabetes_total.hmis_database, diabetes_total.register) - LEAST(diabetes_total.hmis_database, diabetes_total.register)))))::numeric / (GREATEST(diabetes_total.hmis_database, diabetes_total.register))::numeric) * (100)::numeric), 2)
        END AS percentage_diabetes_total_cases
   FROM (((((public.merged_hypertension_data_accurancies hypertension
     LEFT JOIN public.merged_hypertension_total_data_accurancies hypertension_total ON ((hypertension.survey_id = hypertension_total.survey_id)))
     LEFT JOIN public.merged_diabetes_total_data_accurancies diabetes_total ON ((hypertension.survey_id = diabetes_total.survey_id)))
     LEFT JOIN public.merged_deliveries_data_accurancies deliveries ON ((hypertension.survey_id = deliveries.survey_id)))
     LEFT JOIN public.merged_bcg_data_accurancies bcg ON ((hypertension.survey_id = bcg.survey_id)))
     LEFT JOIN public.merged_malaria_cases_data_accuracies malaria ON ((hypertension.survey_id = malaria.survey_id)));


ALTER VIEW public.hmis_db_over_register_view OWNER TO health_builders;

--
-- Name: hmis_db_over_register_view_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.hmis_db_over_register_view_copy1 AS
 SELECT hypertension.survey_id,
    hypertension.district,
    hypertension.health_facility,
    hypertension.facility_type,
    hypertension.hmis_database AS hmis_database_hypertension,
    hypertension.register AS register_hypertension,
        CASE
            WHEN (GREATEST(hypertension.hmis_database, hypertension.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(hypertension.hmis_database, hypertension.register) - (GREATEST(hypertension.hmis_database, hypertension.register) - LEAST(hypertension.hmis_database, hypertension.register)))))::numeric / (GREATEST(hypertension.hmis_database, hypertension.register))::numeric) * (100)::numeric), 2)
        END AS percentage_hypertension,
    deliveries.hmis_database AS hmis_database_deliveries,
    deliveries.register AS register_deliveries,
        CASE
            WHEN (GREATEST(deliveries.hmis_database, deliveries.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(deliveries.hmis_database, deliveries.register) - (GREATEST(deliveries.hmis_database, deliveries.register) - LEAST(deliveries.hmis_database, deliveries.register)))))::numeric / (GREATEST(deliveries.hmis_database, deliveries.register))::numeric) * (100)::numeric), 2)
        END AS percentage_deliveries,
    bcg.hmis_database AS hmis_database_bcg,
    bcg.register AS register_bcg,
        CASE
            WHEN (GREATEST(bcg.hmis_database, bcg.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(bcg.hmis_database, bcg.register) - (GREATEST(bcg.hmis_database, bcg.register) - LEAST(bcg.hmis_database, bcg.register)))))::numeric / (GREATEST(bcg.hmis_database, bcg.register))::numeric) * (100)::numeric), 2)
        END AS percentage_bcg,
    malaria.hmis_database AS hmis_database_malaria,
    malaria.register AS register_malaria,
        CASE
            WHEN (GREATEST(malaria.hmis_database, malaria.register) = 0) THEN (0)::numeric
            ELSE round((((abs((GREATEST(malaria.hmis_database, malaria.register) - (GREATEST(malaria.hmis_database, malaria.register) - LEAST(malaria.hmis_database, malaria.register)))))::numeric / (GREATEST(malaria.hmis_database, malaria.register))::numeric) * (100)::numeric), 2)
        END AS percentage_malaria,
    hypertension.survey_year
   FROM (((public.merged_hypertension_data_accurancies hypertension
     LEFT JOIN public.merged_deliveries_data_accurancies deliveries ON ((hypertension.survey_id = deliveries.survey_id)))
     LEFT JOIN public.merged_bcg_data_accurancies bcg ON ((hypertension.survey_id = bcg.survey_id)))
     LEFT JOIN public.merged_malaria_cases_data_accuracies malaria ON ((hypertension.survey_id = malaria.survey_id)));


ALTER VIEW public.hmis_db_over_register_view_copy1 OWNER TO health_builders;

--
-- Name: hypertension_clearances; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hypertension_clearances (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    age text NOT NULL,
    weight numeric NOT NULL,
    gender text NOT NULL,
    creatinine_unit text,
    creatinine_value text
);


ALTER TABLE public.hypertension_clearances OWNER TO health_builders;

--
-- Name: hypertension_knowledge_on_home_self_managements; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hypertension_knowledge_on_home_self_managements (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    age_id bigint NOT NULL,
    gender_id bigint NOT NULL,
    education_level_id bigint NOT NULL,
    illness_duration_id bigint NOT NULL,
    condition_awareness boolean NOT NULL,
    low_salt_diet_awareness boolean NOT NULL,
    knows_dose_timing boolean NOT NULL,
    knows_dose_amount boolean NOT NULL,
    aware_bp_check_at_chws boolean NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.hypertension_knowledge_on_home_self_managements OWNER TO health_builders;

--
-- Name: hypertension_knowledge_on_self_management_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.hypertension_knowledge_on_self_management_view AS
 SELECT hkohsm.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    hkohsm.id AS patient_id,
    npar.value AS age_range,
    npg.value AS gender,
    npel.value AS education_level,
    npid.value AS illness_duration,
    hkohsm.condition_awareness,
    hkohsm.low_salt_diet_awareness,
    hkohsm.knows_dose_timing,
    hkohsm.knows_dose_amount,
    hkohsm.aware_bp_check_at_chws
   FROM (((((((public.hypertension_knowledge_on_home_self_managements hkohsm
     LEFT JOIN public.qr_codes qr ON ((hkohsm.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
     LEFT JOIN public.ncd_patient_age_ranges npar ON ((hkohsm.age_id = npar.id)))
     LEFT JOIN public.ncd_patient_genders npg ON ((hkohsm.gender_id = npg.id)))
     LEFT JOIN public.ncd_patient_education_levels npel ON ((hkohsm.education_level_id = npel.id)))
     LEFT JOIN public.ncd_patient_illness_durations npid ON ((hkohsm.illness_duration_id = npid.id)));


ALTER VIEW public.hypertension_knowledge_on_self_management_view OWNER TO health_builders;

--
-- Name: hypertension_kpi; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.hypertension_kpi AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN htg.weight_checked_each_visit THEN 1
            ELSE 0
        END AS weight_checked,
        CASE
            WHEN htg.bp_checked_each_visit THEN 1
            ELSE 0
        END AS bp_checked,
        CASE
            WHEN htg.proteinuria_checked_last6_months THEN 1
            ELSE 0
        END AS proteinuria_checked,
        CASE
            WHEN htg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END AS creatinine_checked,
        CASE
            WHEN htg.correct_treatment_provided THEN 1
            ELSE 0
        END AS correct_treatment_provided,
    ((((
        CASE
            WHEN htg.weight_checked_each_visit THEN 1
            ELSE 0
        END +
        CASE
            WHEN htg.bp_checked_each_visit THEN 1
            ELSE 0
        END) +
        CASE
            WHEN htg.proteinuria_checked_last6_months THEN 1
            ELSE 0
        END) +
        CASE
            WHEN htg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END) +
        CASE
            WHEN htg.correct_treatment_provided THEN 1
            ELSE 0
        END) AS sum,
    5 AS expected,
    (5 - ((((
        CASE
            WHEN htg.weight_checked_each_visit THEN 1
            ELSE 0
        END +
        CASE
            WHEN htg.bp_checked_each_visit THEN 1
            ELSE 0
        END) +
        CASE
            WHEN htg.proteinuria_checked_last6_months THEN 1
            ELSE 0
        END) +
        CASE
            WHEN htg.correct_treatment_provided THEN 1
            ELSE 0
        END) +
        CASE
            WHEN htg.creatinine_checked_last12_months THEN 1
            ELSE 0
        END)) AS difference,
        CASE
            WHEN ((5 - ((((
            CASE
                WHEN htg.weight_checked_each_visit THEN 1
                ELSE 0
            END +
            CASE
                WHEN htg.bp_checked_each_visit THEN 1
                ELSE 0
            END) +
            CASE
                WHEN htg.proteinuria_checked_last6_months THEN 1
                ELSE 0
            END) +
            CASE
                WHEN htg.correct_treatment_provided THEN 1
                ELSE 0
            END) +
            CASE
                WHEN htg.creatinine_checked_last12_months THEN 1
                ELSE 0
            END)) = 0) THEN 1
            ELSE 0
        END AS status
   FROM (((public.qr_codes qr
     JOIN public.hypertension_treatment_guidelines htg ON ((qr.id = htg.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.hypertension_kpi OWNER TO health_builders;

--
-- Name: hypertension_nephropathy_prevalences; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hypertension_nephropathy_prevalences (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    follow_up_patients_number bigint NOT NULL
);


ALTER TABLE public.hypertension_nephropathy_prevalences OWNER TO health_builders;

--
-- Name: hypertension_treatment_guidelines_copy; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hypertension_treatment_guidelines_copy (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    weight_checked_each_visit boolean DEFAULT false NOT NULL,
    bp_checked_each_visit boolean DEFAULT false NOT NULL,
    eye_checked_last12_months boolean DEFAULT false NOT NULL,
    proteinuria_checked_last6_months boolean DEFAULT false NOT NULL,
    creatinine_checked_last12_months boolean DEFAULT false NOT NULL,
    correct_treatment_provided boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone,
    echocardiography_done_last12_months boolean
);


ALTER TABLE public.hypertension_treatment_guidelines_copy OWNER TO health_builders;

--
-- Name: hypertension_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.hypertension_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    month_one_value text NOT NULL,
    month_two_value text NOT NULL,
    month_three_value text NOT NULL,
    month_four_value text NOT NULL,
    month_five_value text NOT NULL,
    month_six_value text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.hypertension_treatment_outcomes OWNER TO health_builders;

--
-- Name: imci_merged; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.imci_merged (
    patient_id uuid NOT NULL,
    survey_id uuid NOT NULL,
    survey_year character varying(10) NOT NULL,
    district_id text NOT NULL,
    district character varying(255) NOT NULL,
    health_center_id text NOT NULL,
    health_center character varying(255) NOT NULL,
    condition character varying(255) NOT NULL,
    assessment_is_complete boolean,
    classification_is_accurate boolean,
    malaria_test_done boolean,
    no_anti_biotic_given boolean,
    correct_treatment boolean,
    follow_up_appointment_given boolean,
    education_given boolean,
    ors_given boolean,
    zinc_given boolean,
    correct_anti_pyretic_given boolean,
    correct_anti_malaria_treatment_provided boolean,
    correct_anti_biotic_treatment_provided boolean,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    correct_treatment_calc boolean
);


ALTER TABLE public.imci_merged OWNER TO health_builders;

--
-- Name: COLUMN imci_merged.patient_id; Type: COMMENT; Schema: public; Owner: health_builders
--

COMMENT ON COLUMN public.imci_merged.patient_id IS 'used to reference the record from the data source tables (e.g. cough_treatment_guidelines, etc)';


--
-- Name: imci_merged_copy1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.imci_merged_copy1 (
    patient_id uuid NOT NULL,
    survey_id uuid NOT NULL,
    survey_year character varying(10) NOT NULL,
    district_id text NOT NULL,
    district character varying(255) NOT NULL,
    health_center_id text NOT NULL,
    health_center character varying(255) NOT NULL,
    condition character varying(255) NOT NULL,
    assessment_is_complete boolean,
    classification_is_accurate boolean,
    malaria_test_done boolean,
    no_anti_biotic_given boolean,
    correct_treatment boolean,
    follow_up_appointment_given boolean,
    education_given boolean,
    ors_given boolean,
    zinc_given boolean,
    correct_anti_pyretic_given boolean,
    correct_anti_malaria_treatment_provided boolean,
    correct_anti_biotic_treatment_provided boolean,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    correct_treatment_calc boolean
);


ALTER TABLE public.imci_merged_copy1 OWNER TO health_builders;

--
-- Name: COLUMN imci_merged_copy1.patient_id; Type: COMMENT; Schema: public; Owner: health_builders
--

COMMENT ON COLUMN public.imci_merged_copy1.patient_id IS 'used to reference the record from the data source tables (e.g. cough_treatment_guidelines, etc)';


--
-- Name: information_delivery_and_support_satisfactions; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.information_delivery_and_support_satisfactions (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_id uuid,
    cashier_respect_satisfaction bigint,
    treating_nurse_respect_satisfaction bigint,
    lab_technician_respect_satisfaction bigint,
    dispensing_nurse_respect_satisfaction bigint,
    medical_insurance_agent_respect_satisfaction bigint,
    medical_courtesy_satisfaction bigint,
    facility_safety_satisfaction bigint,
    medical_attention_satisfaction bigint,
    health_status_explanation_satisfaction bigint,
    lab_results_explanation_satisfaction bigint,
    medicine_use_explanation_satisfaction bigint,
    next_given_appointment_satisfaction bigint,
    orientation_satisfaction bigint,
    health_education_satisfaction bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.information_delivery_and_support_satisfactions OWNER TO health_builders;

--
-- Name: insurances; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.insurances (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    insurer character varying(255),
    period timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    invoice_submission_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    invoice_returned_date_to_hc timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    invoice_submission_date_after_verification timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    amount_before_verification numeric(15,2),
    amount_after_verification numeric(15,2),
    last_synced_at timestamp with time zone
);


ALTER TABLE public.insurances OWNER TO health_builders;

--
-- Name: malaria_key_performance_indicators; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.malaria_key_performance_indicators (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    cases bigint NOT NULL,
    deaths bigint NOT NULL,
    review_year text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.malaria_key_performance_indicators OWNER TO health_builders;

--
-- Name: malnutrition_key_performance_indicators; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.malnutrition_key_performance_indicators (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    cases bigint NOT NULL,
    deaths bigint NOT NULL,
    review_year text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.malnutrition_key_performance_indicators OWNER TO health_builders;

--
-- Name: maternal_and_neonatal_healths; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.maternal_and_neonatal_healths (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    year text NOT NULL,
    obstetrical_complications_identified_from_anc bigint,
    obstetrical_complications_identified_referred_from_anc bigint,
    obstetrical_complications_identified_in_matenity bigint,
    deliveries bigint,
    live_births bigint,
    maternal_deaths bigint,
    neonatal_deaths bigint,
    still_births bigint,
    post_partum_infections bigint,
    anc4_standard_visits bigint,
    anc_first_standard_visits bigint,
    under_five_deaths bigint,
    number_of_chidlren_consulted_within24_hours bigint,
    morden_contraceptive_users bigint,
    children_receiving_mr2_vaccine bigint,
    number_of_obstetrical_ultrasound_scans_done bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.maternal_and_neonatal_healths OWNER TO health_builders;

--
-- Name: maternity_treatment_guidelines_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.maternity_treatment_guidelines_view AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    mtg.essential_supplies_available,
    mtg.privacy_provided_to_women_in_maternity,
    mtg.adequate_supply_of_ppes
   FROM (((public.qr_codes q
     LEFT JOIN public.maternity_treatment_guidelines mtg ON ((q.id = mtg.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public.maternity_treatment_guidelines_view OWNER TO health_builders;

--
-- Name: meeting_frequencies; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.meeting_frequencies (
    id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_synced boolean DEFAULT true,
    frequency text
);


ALTER TABLE public.meeting_frequencies OWNER TO health_builders;

--
-- Name: meeting_frequencies_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.meeting_frequencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meeting_frequencies_id_seq OWNER TO health_builders;

--
-- Name: meeting_frequencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.meeting_frequencies_id_seq OWNED BY public.meeting_frequencies.id;


--
-- Name: meetings; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.meetings (
    id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_synced boolean DEFAULT true,
    meeting text
);


ALTER TABLE public.meetings OWNER TO health_builders;

--
-- Name: meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meetings_id_seq OWNER TO health_builders;

--
-- Name: meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.meetings_id_seq OWNED BY public.meetings.id;


--
-- Name: merged_anc_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_anc_treatment_guidelines AS
 SELECT a.survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.patient_history_complete,
    a.bp_checked_each_visit,
    a.urine_albimune_tested_initial_visit,
    a.hemoglobin_tested_initial_visit,
    a.rpr_test_done_for_syphilis_initial_visit,
    a.first_trimister_ultrasound_scan_done
   FROM (((public.anc_treatment_guidelines a
     LEFT JOIN public.qr_codes q ON ((a.survey_id = q.id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public.merged_anc_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_asthma_classifications_data; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_asthma_classifications_data AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS classification_id,
    a.patient_number,
    a.month_one_classification,
    a.month_two_classification,
    a.month_three_classification,
    a.month_four_classification,
    a.month_five_classification,
    a.month_six_classification
   FROM (((public.asthma_classifications a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_asthma_classifications_data OWNER TO health_builders;

--
-- Name: merged_asthma_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_asthma_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.patient_number,
    a.bp_checked_each_visit,
    a.asthma_severity_classfied,
    a.appropriate_antiasthmatic_treatment
   FROM (((public.asthma_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_asthma_treatment_guidelines OWNER TO health_builders;

--
-- Name: users; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    first_name text NOT NULL,
    surname text NOT NULL,
    password text NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    is_synced boolean DEFAULT false NOT NULL,
    using_default_password boolean DEFAULT true NOT NULL,
    is_hma boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO health_builders;

--
-- Name: merged_cough_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_cough_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.patient_number,
    a.assessment_is_complete,
    a.classification_is_accurate,
    a.no_anti_biotic_given,
    a.education_given,
    users.first_name,
    users.surname
   FROM ((((public.cough_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
     JOIN public.users ON (((a.created_by = users.id) AND (qr.created_by = users.id))));


ALTER VIEW public.merged_cough_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_diabetes_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diabetes_treatment_guidelines AS
 SELECT d.survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    d.id AS patient_id,
    d.patient_number,
    d.current_protocol_available,
    d.hbalc_checked,
    d.bg_checked_each_visit AS bp_checked_each_visit,
    d.eye_checked_last12_months,
    d.foot_checked_last12_months,
    d.urine_protein_checked_last6_months,
    d.creatinine_checked_last12_months,
    d.correct_treatment_provided
   FROM (((public.diabetes_treatment_guidelines d
     LEFT JOIN public.qr_codes qr ON ((d.survey_id = qr.id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_diabetes_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_diabetes_treatment_outcomes_glycemia; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diabetes_treatment_outcomes_glycemia AS
 SELECT dgto.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    dgto.id AS patient_id,
    dgto.patient_number,
    dgto.month_one_value,
    dgto.month_two_value,
    dgto.month_three_value
   FROM (((public.diabetes_glycemia_treatment_outcomes dgto
     LEFT JOIN public.qr_codes qr ON ((dgto.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_diabetes_treatment_outcomes_glycemia OWNER TO health_builders;

--
-- Name: merged_diabetes_treatment_outcomes_hba1c; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diabetes_treatment_outcomes_hba1c AS
 SELECT dhcto.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    dhcto.id AS patient_id,
    dhcto.id AS patient_number,
    dhcto.hba1c_quarterlast AS previous_quarter_value,
    dhcto.hba1c_quarterbefore AS before_previous_quarter_value
   FROM (((public.new_diabetes_treatment_outcomes dhcto
     LEFT JOIN public.qr_codes qr ON ((dhcto.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_diabetes_treatment_outcomes_hba1c OWNER TO health_builders;

--
-- Name: merged_diabetes_treatment_outcomes_old; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diabetes_treatment_outcomes_old AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.month_one_value,
    a.month_two_value,
    a.month_three_value,
    a.month_four_value,
    a.month_five_value,
    a.month_six_value
   FROM (((public.diabetes_treatment_outcomes a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_diabetes_treatment_outcomes_old OWNER TO health_builders;

--
-- Name: merged_diarrhoea_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_diarrhoea_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.assessment_is_complete,
    a.classification_is_accurate,
    a.zinc_given,
    a.ors_given,
    a.education_given,
    a.follow_up_appointment_given
   FROM (((public.diarrhoea_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_diarrhoea_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_fever_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_fever_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.assessment_is_complete,
    a.classification_is_accurate,
    a.malaria_test_done,
    a.correct_anti_pyretic_given,
    a.follow_up_appointment_given,
    a.education_given
   FROM (((public.fever_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_fever_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_hypertension_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_hypertension_treatment_guidelines AS
 SELECT h.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    h.id AS patient_id,
    h.weight_checked_each_visit,
    h.bp_checked_each_visit,
    h.eye_checked_last12_months,
    h.proteinuria_checked_last6_months,
    h.creatinine_checked_last12_months,
    h.correct_treatment_provided
   FROM (((public.hypertension_treatment_guidelines h
     LEFT JOIN public.qr_codes qr ON ((h.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_hypertension_treatment_guidelines OWNER TO health_builders;

--
-- Name: new_hypertension_treatment_outcomes; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.new_hypertension_treatment_outcomes (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    patient_number bigint,
    initial_value text,
    previous_value text,
    latest_value text,
    proteinuria text,
    cardiomyopathy text
);


ALTER TABLE public.new_hypertension_treatment_outcomes OWNER TO health_builders;

--
-- Name: merged_hypertension_treatment_outcomes_new; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_hypertension_treatment_outcomes_new AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.initial_value,
    a.previous_value,
    a.latest_value,
    a.proteinuria,
    a.cardiomyopathy
   FROM (((public.new_hypertension_treatment_outcomes a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_hypertension_treatment_outcomes_new OWNER TO health_builders;

--
-- Name: merged_inpatients_care_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_inpatients_care_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.biographical_data_complete,
    a.relevant_history_complete,
    a.chief_complaints,
    a.rapid_survey,
    a.vital_signs_and_anthropometrics,
    a.exam_of_systems,
    a.diagnosis,
    a.nursing_care_plan,
    a.soap_note,
    a.treatment_plan_revised_according_to_reassesment_results,
    a.complete
   FROM (((public.inpatients_care_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_inpatients_care_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_malaria_cases_data_accuracies2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_malaria_cases_data_accuracies2 AS
 SELECT qr.id AS survey_id,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    da.hmis_report AS hmis_hardcopy,
    da.hmis_database,
    da.register,
    da.lab_register,
    da.pharmacy,
        CASE
            WHEN (da.hmis_report = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_report - da.hmis_database) / NULLIF(da.hmis_database, 0)))
        END AS hmis,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE abs(((da.hmis_database - da.register) / NULLIF(da.register, 0)))
        END AS hmis_over_register,
        CASE
            WHEN (da.register = 0) THEN NULL::bigint
            ELSE abs(((da.register - da.lab_register) / NULLIF(da.register, 0)))
        END AS patientfiles_over_register,
        CASE
            WHEN ((da.hmis_report = 0) OR (da.register = 0) OR (da.patient_file = 0) OR (da.hmis_database = 0)) THEN 0
            ELSE
            CASE
                WHEN (round(((LEAST(da.lab_register, da.register, da.hmis_report, da.hmis_database))::numeric / (GREATEST(da.patient_file, da.register, da.hmis_report, da.hmis_database))::numeric), 2) >= 0.95) THEN 1
                ELSE 0
            END
        END AS reports_are_95_percent_accurate,
    qr.survey_year
   FROM (((public.qr_codes qr
     LEFT JOIN public.data_accuracies da ON ((qr.id = da.survey_id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  WHERE (da.source = 'Malaria Cases (All)'::text);


ALTER VIEW public.merged_malaria_cases_data_accuracies2 OWNER TO health_builders;

--
-- Name: merged_malaria_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_malaria_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS guideline_id,
    a.patient_number,
    a.assessment_is_complete,
    a.classification_is_accurate,
    a.correct_anti_malaria_treatment_provided,
    a.patient_educated,
    a.follow_up_appointment_given
   FROM (((public.malaria_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_malaria_treatment_guidelines OWNER TO health_builders;

--
-- Name: patient_age_ranges; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_age_ranges (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.patient_age_ranges OWNER TO health_builders;

--
-- Name: patient_arrival_perceptions; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_arrival_perceptions (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_id uuid,
    customer_care_satisfaction bigint,
    reception_waiting_time bigint,
    cashier_waiting_time bigint,
    consultation_wiating_area_waiting_time bigint,
    laboratory_waiting_time bigint,
    laboratory_results_waiting_time bigint,
    pharmacy_waiting_time bigint,
    billing_station_waiting_time bigint,
    info_about_delays_satisfaction bigint,
    communicated_language_satisfaction bigint,
    differentiates_staff bigint,
    department_signages_helpful bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.patient_arrival_perceptions OWNER TO health_builders;

--
-- Name: patient_education_levels; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_education_levels (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.patient_education_levels OWNER TO health_builders;

--
-- Name: patient_genders; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_genders (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.patient_genders OWNER TO health_builders;

--
-- Name: patient_rights_and_responsibilitiesses; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_rights_and_responsibilitiesses (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_id uuid,
    opinions_about_quality_of_service bigint NOT NULL,
    knowledge_on_rights_and_responsibilities bigint,
    privacy_and_confidentiality_respected bigint,
    payment_process_satisfaction bigint,
    water_facilitation_on_firt_dose bigint,
    facility_hygiene_satisfaction bigint,
    likely_to_recommend_relatives_to_the_facility bigint,
    overral_satisfaction_for_delivered_services bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.patient_rights_and_responsibilitiesses OWNER TO health_builders;

--
-- Name: patient_satisfaction_basic_infos; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_satisfaction_basic_infos (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    service bigint NOT NULL,
    gender bigint,
    age bigint,
    education_level bigint,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.patient_satisfaction_basic_infos OWNER TO health_builders;

--
-- Name: patient_satisfaction_services; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_satisfaction_services (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.patient_satisfaction_services OWNER TO health_builders;

--
-- Name: merged_patient_satisfaction_data; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_patient_satisfaction_data AS
 SELECT b.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    b.id AS patient_id,
    ps.value AS service,
    pg.value AS gender,
    par.value AS age,
    pel.value AS education_level,
    a.customer_care_satisfaction,
    a.reception_waiting_time,
    a.cashier_waiting_time,
    a.consultation_wiating_area_waiting_time,
    a.laboratory_waiting_time,
    a.laboratory_results_waiting_time,
    a.pharmacy_waiting_time,
    a.billing_station_waiting_time,
    a.info_about_delays_satisfaction,
    a.communicated_language_satisfaction,
    a.differentiates_staff,
    a.department_signages_helpful,
    r.opinions_about_quality_of_service,
    r.knowledge_on_rights_and_responsibilities,
    r.privacy_and_confidentiality_respected,
    r.payment_process_satisfaction,
    r.water_facilitation_on_firt_dose,
    r.facility_hygiene_satisfaction,
    r.likely_to_recommend_relatives_to_the_facility,
    r.overral_satisfaction_for_delivered_services,
    i.cashier_respect_satisfaction,
    i.treating_nurse_respect_satisfaction,
    i.lab_technician_respect_satisfaction,
    i.dispensing_nurse_respect_satisfaction,
    i.medical_insurance_agent_respect_satisfaction,
    i.medical_courtesy_satisfaction,
    i.facility_safety_satisfaction,
    i.medical_attention_satisfaction,
    i.health_status_explanation_satisfaction,
    i.lab_results_explanation_satisfaction,
    i.medicine_use_explanation_satisfaction,
    i.next_given_appointment_satisfaction,
    i.orientation_satisfaction,
    i.health_education_satisfaction,
    s.suggestion
   FROM (((((((((((public.patient_satisfaction_basic_infos b
     LEFT JOIN public.qr_codes qr ON ((b.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
     LEFT JOIN public.patient_arrival_perceptions a ON ((b.id = a.patient_id)))
     LEFT JOIN public.patient_rights_and_responsibilitiesses r ON ((b.id = r.patient_id)))
     LEFT JOIN public.information_delivery_and_support_satisfactions i ON ((b.id = i.patient_id)))
     LEFT JOIN public.additional_suggestions s ON ((b.id = s.patient_id)))
     LEFT JOIN public.patient_satisfaction_services ps ON ((b.service = ps.id)))
     LEFT JOIN public.patient_genders pg ON ((b.gender = pg.id)))
     LEFT JOIN public.patient_age_ranges par ON ((b.age = par.id)))
     LEFT JOIN public.patient_education_levels pel ON ((b.education_level = pel.id)));


ALTER VIEW public.merged_patient_satisfaction_data OWNER TO health_builders;

--
-- Name: pneumonia_treatment_guidelines; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pneumonia_treatment_guidelines (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    patient_number bigint NOT NULL,
    assessment_is_complete boolean DEFAULT false NOT NULL,
    classification_is_accurate boolean DEFAULT false NOT NULL,
    correct_anti_biotic_treatment_provided boolean DEFAULT false NOT NULL,
    education_given boolean DEFAULT false NOT NULL,
    follow_up_appointment_given boolean DEFAULT false NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.pneumonia_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_pneumonia_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_pneumonia_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.patient_number,
    a.assessment_is_complete,
    a.classification_is_accurate,
    a.correct_anti_biotic_treatment_provided,
    a.education_given,
    a.follow_up_appointment_given,
    users.first_name,
    users.surname
   FROM ((((public.pneumonia_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
     JOIN public.users ON (((a.created_by = users.id) AND (qr.created_by = users.id))));


ALTER VIEW public.merged_pneumonia_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_referral_process_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_referral_process_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.patient_number,
    a.patient_identification,
    a.reason_for_referral,
    a.significant_findings,
    a.procedures_and_treatments,
    a.patient_immediate_condition,
    a.where_patient_is_being_transfered,
    a.transport_mode_and_monitoring_required,
    a.counter_referral_section_and_feeback,
    a.all_referral_cases_have_referral_sheet_copy
   FROM (((public.referral_process_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_referral_process_treatment_guidelines OWNER TO health_builders;

--
-- Name: merged_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.merged_treatment_guidelines AS
 SELECT a.survey_id,
    qr.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    a.id AS patient_id,
    a.patient_number,
    a.assessment_is_complete,
    a.classification_is_accurate,
    a.no_anti_biotic_given,
    a.education_given
   FROM (((public.cough_treatment_guidelines a
     LEFT JOIN public.qr_codes qr ON ((a.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.merged_treatment_guidelines OWNER TO health_builders;

--
-- Name: ncd_community_removed_rows_november_14; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_removed_rows_november_14 (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean,
    id integer,
    removal_reason text
);


ALTER TABLE public.ncd_community_removed_rows_november_14 OWNER TO health_builders;

--
-- Name: ncd_community_screening_august_4_with_duplicates; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_screening_august_4_with_duplicates (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean,
    id integer NOT NULL
);


ALTER TABLE public.ncd_community_screening_august_4_with_duplicates OWNER TO health_builders;

--
-- Name: ncd_community_screening_august_4_with_duplicates_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_community_screening_august_4_with_duplicates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_community_screening_august_4_with_duplicates_id_seq OWNER TO health_builders;

--
-- Name: ncd_community_screening_august_4_with_duplicates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_community_screening_august_4_with_duplicates_id_seq OWNED BY public.ncd_community_screening_august_4_with_duplicates.id;


--
-- Name: ncd_community_screening_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_community_screening_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_community_screening_id_seq OWNER TO health_builders;

--
-- Name: ncd_community_screening_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_community_screening_id_seq OWNED BY public.ncd_community_screening.id;


--
-- Name: ncd_community_screening_copy1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_screening_copy1 (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean,
    id integer DEFAULT nextval('public.ncd_community_screening_id_seq'::regclass) NOT NULL
);


ALTER TABLE public.ncd_community_screening_copy1 OWNER TO health_builders;

--
-- Name: ncd_community_screening_full_with_duplicates; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.ncd_community_screening_full_with_duplicates (
    screening_period character varying(150),
    health_center character varying(100),
    sector character varying(100),
    cell character varying(100),
    village character varying(100),
    full_name character varying(255),
    national_id character varying(255),
    date_of_birth character varying(30),
    age character varying(32),
    sex character varying(10),
    drinks_alcohol boolean,
    smokes boolean,
    works_out_for_alteast_30_minutes boolean,
    weight character varying(10),
    height character varying(10),
    blood_sugar character varying(10),
    blood_pressure character varying(20),
    "District" character varying(255),
    page integer,
    hard_copy_number integer,
    verify_bp_value boolean,
    id integer NOT NULL
);


ALTER TABLE public.ncd_community_screening_full_with_duplicates OWNER TO health_builders;

--
-- Name: ncd_community_screening_full_with_duplicates_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_community_screening_full_with_duplicates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_community_screening_full_with_duplicates_id_seq OWNER TO health_builders;

--
-- Name: ncd_community_screening_full_with_duplicates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_community_screening_full_with_duplicates_id_seq OWNED BY public.ncd_community_screening_full_with_duplicates.id;


--
-- Name: ncd_community_screening_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.ncd_community_screening_summary AS
 WITH parsed_screening AS (
         SELECT ncd_community_screening.screening_period,
            ncd_community_screening.id,
            ncd_community_screening.full_name,
            ncd_community_screening.sector,
            ncd_community_screening.cell,
            ncd_community_screening.village,
            ncd_community_screening.health_center,
            ncd_community_screening.sex,
            ncd_community_screening.smokes,
            ncd_community_screening.drinks_alcohol,
            ncd_community_screening.blood_pressure,
            ncd_community_screening.blood_sugar,
            (split_part((ncd_community_screening.blood_pressure)::text, '/'::text, 1))::integer AS systolic,
            (split_part((ncd_community_screening.blood_pressure)::text, '/'::text, 2))::integer AS diastolic
           FROM public.ncd_community_screening
          WHERE (((ncd_community_screening.blood_pressure)::text ~~ '%/%'::text) AND (split_part((ncd_community_screening.blood_pressure)::text, '/'::text, 1) ~ '^[0-9]+$'::text) AND (split_part((ncd_community_screening.blood_pressure)::text, '/'::text, 2) ~ '^[0-9]+$'::text))
        ), classified_screening AS (
         SELECT parsed_screening.screening_period,
            parsed_screening.id,
            parsed_screening.full_name,
            parsed_screening.sector,
            parsed_screening.cell,
            parsed_screening.village,
            parsed_screening.health_center,
            parsed_screening.sex,
            parsed_screening.smokes,
            parsed_screening.drinks_alcohol,
            parsed_screening.blood_pressure,
            parsed_screening.blood_sugar,
            parsed_screening.systolic,
            parsed_screening.diastolic,
            GREATEST(
                CASE
                    WHEN (parsed_screening.systolic < 130) THEN 1
                    WHEN ((parsed_screening.systolic >= 130) AND (parsed_screening.systolic <= 139)) THEN 2
                    WHEN ((parsed_screening.systolic >= 140) AND (parsed_screening.systolic <= 159)) THEN 3
                    WHEN ((parsed_screening.systolic >= 160) AND (parsed_screening.systolic <= 179)) THEN 4
                    WHEN (parsed_screening.systolic >= 180) THEN 5
                    ELSE 0
                END,
                CASE
                    WHEN (parsed_screening.diastolic < 85) THEN 1
                    WHEN ((parsed_screening.diastolic >= 85) AND (parsed_screening.diastolic <= 89)) THEN 2
                    WHEN ((parsed_screening.diastolic >= 90) AND (parsed_screening.diastolic <= 99)) THEN 3
                    WHEN ((parsed_screening.diastolic >= 100) AND (parsed_screening.diastolic <= 109)) THEN 4
                    WHEN (parsed_screening.diastolic >= 110) THEN 5
                    ELSE 0
                END) AS bp_level
           FROM parsed_screening
        ), final_screening AS (
         SELECT classified_screening.screening_period,
            classified_screening.id,
            classified_screening.full_name,
            classified_screening.sector,
            classified_screening.cell,
            classified_screening.village,
            classified_screening.health_center,
            classified_screening.sex,
            classified_screening.smokes,
            classified_screening.drinks_alcohol,
            classified_screening.blood_pressure,
            classified_screening.blood_sugar,
            classified_screening.systolic,
            classified_screening.diastolic,
            classified_screening.bp_level,
                CASE classified_screening.bp_level
                    WHEN 1 THEN 'normal'::text
                    WHEN 2 THEN 'pre_high'::text
                    WHEN 3 THEN 'grade_1'::text
                    WHEN 4 THEN 'grade_2'::text
                    WHEN 5 THEN 'grade_3'::text
                    ELSE 'unclassified'::text
                END AS bp_category,
                CASE
                    WHEN (classified_screening.bp_level >= 3) THEN 'high_bp'::text
                    ELSE NULL::text
                END AS high_bp_category
           FROM classified_screening
        )
 SELECT final_screening.screening_period AS screening_date,
    final_screening.id,
    final_screening.full_name,
    final_screening.sector,
    final_screening.cell,
    final_screening.sex,
    final_screening.village,
    final_screening.health_center,
    final_screening.blood_pressure,
    final_screening.blood_sugar,
    final_screening.bp_category,
        CASE
            WHEN ((final_screening.blood_sugar IS NOT NULL) AND ((final_screening.blood_sugar)::text <> ''::text)) THEN 1
            ELSE 0
        END AS screened_for_blood_sugar,
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric <= (100)::numeric))) AS "blood_sugar_Normal",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric > (100)::numeric) AND ((final_screening.blood_sugar)::numeric < (126)::numeric))) AS "blood_sugar_>100_<126",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (126)::numeric))) AS "blood_sugar_>=126",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (180)::numeric))) AS "blood_sugar_>=180",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (200)::numeric))) AS "blood_sugar_>=200",
    count(*) AS total_people,
    count(*) FILTER (WHERE (final_screening.blood_pressure IS NOT NULL)) AS screened_for_htn,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'M'::text)) AS htn_screened_male,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'F'::text)) AS htn_screened_female,
    count(*) FILTER (WHERE final_screening.smokes) AS htn_screened_tobacco_users,
    count(*) FILTER (WHERE final_screening.drinks_alcohol) AS htn_screened_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.high_bp_category = 'high_bp'::text)) AS total_high_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.smokes)) AS tobacco_users_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_high_bp_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'normal'::text)) AS total_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.smokes)) AS tobacco_users_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_normal_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'pre_high'::text)) AS total_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.smokes)) AS tobacco_users_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_pre_high_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_1'::text)) AS grade_1_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_1_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_1_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.smokes)) AS grade_1_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.drinks_alcohol)) AS grade_1_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_2'::text)) AS grade_2_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_2_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_2_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.smokes)) AS grade_2_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.drinks_alcohol)) AS grade_2_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_3'::text)) AS grade_3_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_3_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_3_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.smokes)) AS grade_3_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.drinks_alcohol)) AS grade_3_alcohol_consumers
   FROM final_screening
  GROUP BY final_screening.id, final_screening.screening_period, final_screening.sector, final_screening.cell, final_screening.village, final_screening.health_center, final_screening.blood_pressure, final_screening.bp_category, final_screening.sex, final_screening.blood_sugar, final_screening.full_name
  ORDER BY final_screening.screening_period;


ALTER VIEW public.ncd_community_screening_summary OWNER TO health_builders;

--
-- Name: ncd_community_screening_summary_HC; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."ncd_community_screening_summary_HC" AS
 WITH parsed_screening AS (
         SELECT ncd_community_screening_old.screening_period,
            ncd_community_screening_old.id,
            ncd_community_screening_old.sector,
            ncd_community_screening_old.cell,
            ncd_community_screening_old.village,
            ncd_community_screening_old.health_center,
            ncd_community_screening_old.sex,
            ncd_community_screening_old.smokes,
            ncd_community_screening_old.drinks_alcohol,
            ncd_community_screening_old.blood_pressure,
            (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 1))::integer AS systolic,
            (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 2))::integer AS diastolic
           FROM public.ncd_community_screening_old
          WHERE (((ncd_community_screening_old.blood_pressure)::text ~~ '%/%'::text) AND (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 1) ~ '^[0-9]+$'::text) AND (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 2) ~ '^[0-9]+$'::text))
        ), classified_screening AS (
         SELECT parsed_screening.screening_period,
            parsed_screening.id,
            parsed_screening.sector,
            parsed_screening.cell,
            parsed_screening.village,
            parsed_screening.health_center,
            parsed_screening.sex,
            parsed_screening.smokes,
            parsed_screening.drinks_alcohol,
            parsed_screening.blood_pressure,
            parsed_screening.systolic,
            parsed_screening.diastolic,
            GREATEST(
                CASE
                    WHEN (parsed_screening.systolic < 130) THEN 1
                    WHEN ((parsed_screening.systolic >= 130) AND (parsed_screening.systolic <= 139)) THEN 2
                    WHEN ((parsed_screening.systolic >= 140) AND (parsed_screening.systolic <= 159)) THEN 3
                    WHEN ((parsed_screening.systolic >= 160) AND (parsed_screening.systolic <= 179)) THEN 4
                    WHEN (parsed_screening.systolic >= 180) THEN 5
                    ELSE 0
                END,
                CASE
                    WHEN (parsed_screening.diastolic < 90) THEN 1
                    WHEN ((parsed_screening.diastolic >= 85) AND (parsed_screening.diastolic <= 89)) THEN 2
                    WHEN ((parsed_screening.diastolic >= 90) AND (parsed_screening.diastolic <= 99)) THEN 3
                    WHEN ((parsed_screening.diastolic >= 100) AND (parsed_screening.diastolic <= 109)) THEN 4
                    WHEN (parsed_screening.diastolic >= 110) THEN 5
                    ELSE 0
                END) AS bp_level
           FROM parsed_screening
        ), final_screening AS (
         SELECT classified_screening.screening_period,
            classified_screening.id,
            classified_screening.sector,
            classified_screening.cell,
            classified_screening.village,
            classified_screening.health_center,
            classified_screening.sex,
            classified_screening.smokes,
            classified_screening.drinks_alcohol,
            classified_screening.blood_pressure,
            classified_screening.systolic,
            classified_screening.diastolic,
            classified_screening.bp_level,
                CASE classified_screening.bp_level
                    WHEN 1 THEN 'normal'::text
                    WHEN 2 THEN 'pre_high'::text
                    WHEN 3 THEN 'grade_1'::text
                    WHEN 4 THEN 'grade_2'::text
                    WHEN 5 THEN 'grade_3'::text
                    ELSE 'unclassified'::text
                END AS bp_category,
                CASE
                    WHEN (classified_screening.bp_level >= 3) THEN 'high_bp'::text
                    ELSE NULL::text
                END AS high_bp_category
           FROM classified_screening
        )
 SELECT final_screening.health_center,
    count(*) AS total_people,
    count(*) FILTER (WHERE (final_screening.blood_pressure IS NOT NULL)) AS screened_for_htn,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'M'::text)) AS htn_screened_male,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'F'::text)) AS htn_screened_female,
    count(*) FILTER (WHERE (final_screening.smokes = true)) AS htn_screened_tobacco_users,
    count(*) FILTER (WHERE (final_screening.drinks_alcohol = true)) AS htn_screened_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.high_bp_category = 'high_bp'::text)) AS total_high_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.smokes)) AS tobacco_users_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_high_bp_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'normal'::text)) AS total_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.smokes)) AS tobacco_users_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_normal_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'pre_high'::text)) AS total_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.smokes)) AS tobacco_users_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_pre_high_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_1'::text)) AS grade_1_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_1_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_1_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.smokes)) AS grade_1_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.drinks_alcohol)) AS grade_1_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_2'::text)) AS grade_2_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_2_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_2_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.smokes)) AS grade_2_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.drinks_alcohol)) AS grade_2_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_3'::text)) AS grade_3_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_3_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_3_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.smokes)) AS grade_3_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.drinks_alcohol)) AS grade_3_alcohol_consumers
   FROM final_screening
  GROUP BY final_screening.health_center, final_screening.sex
  ORDER BY final_screening.health_center;


ALTER VIEW public."ncd_community_screening_summary_HC" OWNER TO health_builders;

--
-- Name: ncd_community_screening_summary_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.ncd_community_screening_summary_copy1 AS
 WITH parsed_screening AS (
         SELECT ncd_community_screening_old.screening_period,
            ncd_community_screening_old.id,
            ncd_community_screening_old.full_name,
            ncd_community_screening_old.sector,
            ncd_community_screening_old.cell,
            ncd_community_screening_old.village,
            ncd_community_screening_old.health_center,
            ncd_community_screening_old.sex,
            ncd_community_screening_old.smokes,
            ncd_community_screening_old.drinks_alcohol,
            ncd_community_screening_old.blood_pressure,
            ncd_community_screening_old.blood_sugar,
            (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 1))::integer AS systolic,
            (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 2))::integer AS diastolic
           FROM public.ncd_community_screening_old
          WHERE (((ncd_community_screening_old.blood_pressure)::text ~~ '%/%'::text) AND (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 1) ~ '^[0-9]+$'::text) AND (split_part((ncd_community_screening_old.blood_pressure)::text, '/'::text, 2) ~ '^[0-9]+$'::text))
        ), classified_screening AS (
         SELECT parsed_screening.screening_period,
            parsed_screening.id,
            parsed_screening.full_name,
            parsed_screening.sector,
            parsed_screening.cell,
            parsed_screening.village,
            parsed_screening.health_center,
            parsed_screening.sex,
            parsed_screening.smokes,
            parsed_screening.drinks_alcohol,
            parsed_screening.blood_pressure,
            parsed_screening.blood_sugar,
            parsed_screening.systolic,
            parsed_screening.diastolic,
            GREATEST(
                CASE
                    WHEN (parsed_screening.systolic < 130) THEN 1
                    WHEN ((parsed_screening.systolic >= 130) AND (parsed_screening.systolic <= 139)) THEN 2
                    WHEN ((parsed_screening.systolic >= 140) AND (parsed_screening.systolic <= 159)) THEN 3
                    WHEN ((parsed_screening.systolic >= 160) AND (parsed_screening.systolic <= 179)) THEN 4
                    WHEN (parsed_screening.systolic >= 180) THEN 5
                    ELSE 0
                END,
                CASE
                    WHEN (parsed_screening.diastolic < 85) THEN 1
                    WHEN ((parsed_screening.diastolic >= 85) AND (parsed_screening.diastolic <= 89)) THEN 2
                    WHEN ((parsed_screening.diastolic >= 90) AND (parsed_screening.diastolic <= 99)) THEN 3
                    WHEN ((parsed_screening.diastolic >= 100) AND (parsed_screening.diastolic <= 109)) THEN 4
                    WHEN (parsed_screening.diastolic >= 110) THEN 5
                    ELSE 0
                END) AS bp_level
           FROM parsed_screening
        ), final_screening AS (
         SELECT classified_screening.screening_period,
            classified_screening.id,
            classified_screening.full_name,
            classified_screening.sector,
            classified_screening.cell,
            classified_screening.village,
            classified_screening.health_center,
            classified_screening.sex,
            classified_screening.smokes,
            classified_screening.drinks_alcohol,
            classified_screening.blood_pressure,
            classified_screening.blood_sugar,
            classified_screening.systolic,
            classified_screening.diastolic,
            classified_screening.bp_level,
                CASE classified_screening.bp_level
                    WHEN 1 THEN 'normal'::text
                    WHEN 2 THEN 'pre_high'::text
                    WHEN 3 THEN 'grade_1'::text
                    WHEN 4 THEN 'grade_2'::text
                    WHEN 5 THEN 'grade_3'::text
                    ELSE 'unclassified'::text
                END AS bp_category,
                CASE
                    WHEN (classified_screening.bp_level >= 3) THEN 'high_bp'::text
                    ELSE NULL::text
                END AS high_bp_category
           FROM classified_screening
        )
 SELECT final_screening.screening_period AS screening_date,
    final_screening.id,
    final_screening.full_name,
    final_screening.sector,
    final_screening.cell,
    final_screening.sex,
    final_screening.village,
    final_screening.health_center,
    final_screening.blood_pressure,
    final_screening.blood_sugar,
    final_screening.bp_category,
        CASE
            WHEN ((final_screening.blood_sugar IS NOT NULL) AND ((final_screening.blood_sugar)::text <> ''::text)) THEN 1
            ELSE 0
        END AS screened_for_blood_sugar,
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric <= (100)::numeric))) AS "blood_sugar_Normal",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric > (100)::numeric) AND ((final_screening.blood_sugar)::numeric < (126)::numeric))) AS "blood_sugar_>100_<126",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (126)::numeric))) AS "blood_sugar_>=126",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (180)::numeric))) AS "blood_sugar_>=180",
    count(*) FILTER (WHERE (((final_screening.blood_sugar)::text ~ '^[0-9]+(\.[0-9]+)?$'::text) AND ((final_screening.blood_sugar)::numeric >= (200)::numeric))) AS "blood_sugar_>=200",
    count(*) AS total_people,
    count(*) FILTER (WHERE (final_screening.blood_pressure IS NOT NULL)) AS screened_for_htn,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'M'::text)) AS htn_screened_male,
    count(*) FILTER (WHERE ((final_screening.sex)::text = 'F'::text)) AS htn_screened_female,
    count(*) FILTER (WHERE final_screening.smokes) AS htn_screened_tobacco_users,
    count(*) FILTER (WHERE final_screening.drinks_alcohol) AS htn_screened_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.high_bp_category = 'high_bp'::text)) AS total_high_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.smokes)) AS tobacco_users_high_bp_bp,
    count(*) FILTER (WHERE ((final_screening.high_bp_category = 'high_bp'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_high_bp_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'normal'::text)) AS total_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.smokes)) AS tobacco_users_normal_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'normal'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_normal_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'pre_high'::text)) AS total_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'M'::text))) AS male_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND ((final_screening.sex)::text = 'F'::text))) AS female_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.smokes)) AS tobacco_users_pre_high_bp,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'pre_high'::text) AND final_screening.drinks_alcohol)) AS alcohol_consumers_pre_high_bp,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_1'::text)) AS grade_1_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_1_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_1_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.smokes)) AS grade_1_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_1'::text) AND final_screening.drinks_alcohol)) AS grade_1_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_2'::text)) AS grade_2_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_2_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_2_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.smokes)) AS grade_2_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_2'::text) AND final_screening.drinks_alcohol)) AS grade_2_alcohol_consumers,
    count(*) FILTER (WHERE (final_screening.bp_category = 'grade_3'::text)) AS grade_3_total,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'M'::text))) AS grade_3_male,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND ((final_screening.sex)::text = 'F'::text))) AS grade_3_female,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.smokes)) AS grade_3_tobacco_users,
    count(*) FILTER (WHERE ((final_screening.bp_category = 'grade_3'::text) AND final_screening.drinks_alcohol)) AS grade_3_alcohol_consumers
   FROM final_screening
  GROUP BY final_screening.id, final_screening.screening_period, final_screening.sector, final_screening.cell, final_screening.village, final_screening.health_center, final_screening.blood_pressure, final_screening.bp_category, final_screening.sex, final_screening.blood_sugar, final_screening.full_name
  ORDER BY final_screening.screening_period;


ALTER VIEW public.ncd_community_screening_summary_copy1 OWNER TO health_builders;

--
-- Name: ncd_patient_age_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_patient_age_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_patient_age_ranges_id_seq OWNER TO health_builders;

--
-- Name: ncd_patient_age_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_patient_age_ranges_id_seq OWNED BY public.ncd_patient_age_ranges.id;


--
-- Name: ncd_patient_education_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_patient_education_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_patient_education_levels_id_seq OWNER TO health_builders;

--
-- Name: ncd_patient_education_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_patient_education_levels_id_seq OWNED BY public.ncd_patient_education_levels.id;


--
-- Name: ncd_patient_genders_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_patient_genders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_patient_genders_id_seq OWNER TO health_builders;

--
-- Name: ncd_patient_genders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_patient_genders_id_seq OWNED BY public.ncd_patient_genders.id;


--
-- Name: ncd_patient_illness_durations_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.ncd_patient_illness_durations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncd_patient_illness_durations_id_seq OWNER TO health_builders;

--
-- Name: ncd_patient_illness_durations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.ncd_patient_illness_durations_id_seq OWNED BY public.ncd_patient_illness_durations.id;


--
-- Name: new_closing_balances; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.new_closing_balances (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    financial_year character varying(255),
    bank numeric(15,2),
    petty_cash numeric(15,2),
    receivables numeric(15,2),
    payables_start_of_year numeric(15,2),
    payables_end_of_year numeric(15,2),
    pharmacy_debt numeric(15,2),
    hc_total_revenue numeric(15,2),
    hc_income numeric(15,2),
    medicine_sales_fmis numeric(15,2),
    medicine_sales_invoice numeric(15,2),
    hc_total_expenses numeric(15,2),
    hr_expenses numeric(15,2),
    hc_staff_salary_expenditure numeric(15,2),
    purchased_medicine_fmis numeric(15,2),
    purchased_medicine_invoice numeric(15,2),
    medical_equipment numeric(15,2),
    travel numeric(15,2),
    actual_budget numeric(15,2),
    planned_budget numeric(15,2)
);


ALTER TABLE public.new_closing_balances OWNER TO health_builders;

--
-- Name: new_hypertension_treatment_outcomes_copy1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.new_hypertension_treatment_outcomes_copy1 (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp(6) with time zone,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp(6) with time zone,
    deleted_at timestamp(6) with time zone,
    patient_number bigint NOT NULL,
    initial_value text,
    previous_value text NOT NULL,
    latest_value text NOT NULL,
    proteinuria text,
    cardiomyopathy text
);


ALTER TABLE public.new_hypertension_treatment_outcomes_copy1 OWNER TO health_builders;

--
-- Name: new_pharmacy_stock_values; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.new_pharmacy_stock_values (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    last_synced_at timestamp with time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    review_year timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cost_of_expired_medicine numeric(15,2),
    opening_pharmacy_stock_value numeric(15,2),
    closing_pharmacy_stock_value numeric(15,2)
);


ALTER TABLE public.new_pharmacy_stock_values OWNER TO health_builders;

--
-- Name: notice_boards; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.notice_boards (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    current_data_displayed boolean,
    area_well_maintained boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.notice_boards OWNER TO health_builders;

--
-- Name: output_32_final_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.output_32_final_summary AS
 WITH calculated AS (
         SELECT output_32_final.district_name,
            output_32_final.healthcenter_name,
            output_32_final."MPS_Quarter",
            output_32_final."Survey_year",
            (((((((((((((((((((((((((((((((COALESCE(output_32_final."An annual malaria prevention plan has been established", (0)::numeric) + COALESCE(output_32_final."Malaria protocols and treatment guidelines are readily availabl", (0)::numeric)) + COALESCE(output_32_final."Majority of the reviewed patient records reveal that Malaria pr", (0)::numeric)) + COALESCE(output_32_final."Majority of the reviewed patient records reveal that NCD  treat", (0)::numeric)) + COALESCE(output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad", (0)::numeric)) + COALESCE(output_32_final."Assessment forms (in patient) are collecting the information re", (0)::numeric)) + COALESCE(output_32_final."More than 70%  of patients clinician assessment forms(in patien", (0)::numeric)) + COALESCE(output_32_final."All ambulance referral cases from the last two months have an a", (0)::numeric)) + COALESCE(output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)", (0)::numeric)) + COALESCE(output_32_final."All 5 detailed-reviewed drugs have consumption register totaled", (0)::numeric)) + COALESCE(output_32_final."All 5 essential drugs are available and have a stock card", (0)::numeric)) + COALESCE(output_32_final."All 5 essential drugs were not expired", (0)::numeric)) + COALESCE(output_32_final."Majority of reviewed patient files shows that treatment plan is", (0)::numeric)) + COALESCE(output_32_final."There is standardized assessment check list", (0)::numeric)) + COALESCE(output_32_final."There is a suggestions box", (0)::numeric)) + COALESCE(output_32_final."There is a customer care program", (0)::numeric)) + COALESCE(output_32_final."QA committee is reviewing incidences", (0)::numeric)) + COALESCE(output_32_final."The incident reporting form is in different languages", (0)::numeric)) + COALESCE(output_32_final."Patient stisfaction data have been aggregated, analyzed and gra", (0)::numeric)) + COALESCE(output_32_final."The patient satisfaction tool has been tested and revised.", (0)::numeric)) + COALESCE(output_32_final."The quality improvement plan is tracked", (0)::numeric)) + COALESCE(output_32_final."There is a QI focal person", (0)::numeric)) + COALESCE(output_32_final."Staff satisfaction data has been aggregated, analyzed and graph", (0)::numeric)) + COALESCE(output_32_final."Staff satisfaction tool has been developed and tested.", (0)::numeric)) + COALESCE(output_32_final."Patients' and familys' rights are posted for public view", (0)::numeric)) + COALESCE(output_32_final."70% of facility services  has an updated list of required, exis", (0)::numeric)) + COALESCE(output_32_final."All account reconciliations are done monthly, payables and rece", (0)::numeric)) + COALESCE(output_32_final."The names, photos, and phone numbers of management staff are di", (0)::numeric)) + COALESCE(output_32_final."More than 80% of service have One hand washing/hygiene facility", (0)::numeric)) + COALESCE(output_32_final."80% of service have hand hygiene procedures based on current pr", (0)::numeric)) + COALESCE(output_32_final."Risks of infection have been identified for patients, staff and", (0)::numeric)) + COALESCE(output_32_final."There is an IPC focal person that actively guides the IPC progr", (0)::numeric)) AS total_sum,
            (((((((((((((((((((((((((((((((
                CASE
                    WHEN (output_32_final."An annual malaria prevention plan has been established" IS NOT NULL) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (output_32_final."Malaria protocols and treatment guidelines are readily availabl" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Majority of the reviewed patient records reveal that Malaria pr" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Majority of the reviewed patient records reveal that NCD  treat" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Assessment forms (in patient) are collecting the information re" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."More than 70%  of patients clinician assessment forms(in patien" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."All ambulance referral cases from the last two months have an a" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."All 5 detailed-reviewed drugs have consumption register totaled" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."All 5 essential drugs are available and have a stock card" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."All 5 essential drugs were not expired" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Majority of reviewed patient files shows that treatment plan is" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."There is standardized assessment check list" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."There is a suggestions box" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."There is a customer care program" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."QA committee is reviewing incidences" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."The incident reporting form is in different languages" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Patient stisfaction data have been aggregated, analyzed and gra" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."The patient satisfaction tool has been tested and revised." IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."The quality improvement plan is tracked" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."There is a QI focal person" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Staff satisfaction data has been aggregated, analyzed and graph" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Staff satisfaction tool has been developed and tested." IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Patients' and familys' rights are posted for public view" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."70% of facility services  has an updated list of required, exis" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."All account reconciliations are done monthly, payables and rece" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."The names, photos, and phone numbers of management staff are di" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."More than 80% of service have One hand washing/hygiene facility" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."80% of service have hand hygiene procedures based on current pr" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."Risks of infection have been identified for patients, staff and" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_32_final."There is an IPC focal person that actively guides the IPC progr" IS NOT NULL) THEN 1
                    ELSE 0
                END) AS total_count
           FROM public.output_32_final
        )
 SELECT calculated.district_name,
    calculated.healthcenter_name,
    calculated."MPS_Quarter",
    calculated."Survey_year",
    calculated.total_sum,
    calculated.total_count,
        CASE
            WHEN (calculated.total_count > 0) THEN round(((calculated.total_sum * (100)::numeric) / (calculated.total_count)::numeric), 1)
            ELSE (0)::numeric
        END AS percentage
   FROM calculated;


ALTER VIEW public.output_32_final_summary OWNER TO health_builders;

--
-- Name: output_32_final_view_precentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.output_32_final_view_precentage AS
 SELECT output_32_final.district_name,
    output_32_final.healthcenter_name,
    output_32_final."MPS_Quarter",
    output_32_final."Survey_year",
    count(*) AS measurements,
    count(output_32_final."An annual malaria prevention plan has been established") AS expected_an_annual_malaria_prevention_plan_has_been_established,
    sum(output_32_final."An annual malaria prevention plan has been established") AS score_an_annual_malaria_prevention_plan_has_been_established,
    round(((100.0 * sum(output_32_final."An annual malaria prevention plan has been established")) / (NULLIF(count(output_32_final."An annual malaria prevention plan has been established"), 0))::numeric), 2) AS achievement_an_annual_malaria_prevention_plan_has_been_establis,
    count(output_32_final."Malaria protocols and treatment guidelines are readily availabl") AS expected_malaria_protocols_and_treatment_guidelines_are_readily,
    sum(output_32_final."Malaria protocols and treatment guidelines are readily availabl") AS score_malaria_protocols_and_treatment_guidelines_are_readily_av,
    round(((100.0 * sum(output_32_final."Malaria protocols and treatment guidelines are readily availabl")) / (NULLIF(count(output_32_final."Malaria protocols and treatment guidelines are readily availabl"), 0))::numeric), 2) AS achievement_malaria_protocols_and_treatment_guidelines_are_read,
    count(output_32_final."Majority of the reviewed patient records reveal that Malaria pr") AS expected_majority_of_the_reviewed_patient_records_reveal_that_m,
    sum(output_32_final."Majority of the reviewed patient records reveal that Malaria pr") AS score_majority_of_the_reviewed_patient_records_reveal_that_mala,
    round(((100.0 * sum(output_32_final."Majority of the reviewed patient records reveal that Malaria pr")) / (NULLIF(count(output_32_final."Majority of the reviewed patient records reveal that Malaria pr"), 0))::numeric), 2) AS achievement_majority_of_the_reviewed_records_reveal_that_malari,
    count(output_32_final."Majority of the reviewed patient records reveal that NCD  treat") AS expected_majority_of_the_reviewed_patient_records_reveal_that_n,
    sum(output_32_final."Majority of the reviewed patient records reveal that NCD  treat") AS score_majority_of_the_reviewed_patient_records_reveal_that_ncd_,
    round(((100.0 * sum(output_32_final."Majority of the reviewed patient records reveal that NCD  treat")) / (NULLIF(count(output_32_final."Majority of the reviewed patient records reveal that NCD  treat"), 0))::numeric), 2) AS achievement_majority_of_the_reviewed_p_records_reveal_that_ncd_,
    count(output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad") AS expected_treatment_guidelines_protocols_and_or_algorithms_have_,
    sum(output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad") AS score_treatment_guidelines_protocols_and_or_algorithms_have_bee,
    round(((100.0 * sum(output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad")) / (NULLIF(count(output_32_final."Treatment guidelines, protocols, and/or algorithms have been ad"), 0))::numeric), 2) AS achievement_treatment_guidelines_protocols_and_or_algorithms_ha,
    count(output_32_final."Assessment forms (in patient) are collecting the information re") AS expected_assessment_forms_in_patient_are_collecting_the_informa,
    sum(output_32_final."Assessment forms (in patient) are collecting the information re") AS score_assessment_forms_in_patient_are_collecting_the_informatio,
    round(((100.0 * sum(output_32_final."Assessment forms (in patient) are collecting the information re")) / (NULLIF(count(output_32_final."Assessment forms (in patient) are collecting the information re"), 0))::numeric), 2) AS achievement_assessment_forms_in_patient_are_collecting_the_info,
    count(output_32_final."More than 70%  of patients clinician assessment forms(in patien") AS expected_more_than_70_of_patients_clinician_assessment_forms_in,
    sum(output_32_final."More than 70%  of patients clinician assessment forms(in patien") AS score_more_than_70_of_patients_clinician_assessment_forms_in_pa,
    round(((100.0 * sum(output_32_final."More than 70%  of patients clinician assessment forms(in patien")) / (NULLIF(count(output_32_final."More than 70%  of patients clinician assessment forms(in patien"), 0))::numeric), 2) AS achievement_more_than_70_of_patients_clinician_assessment_forms,
    count(output_32_final."All ambulance referral cases from the last two months have an a") AS expected_all_ambulance_referral_cases_from_the_last_two_months_,
    sum(output_32_final."All ambulance referral cases from the last two months have an a") AS score_all_ambulance_referral_cases_from_the_last_two_months_hav,
    round(((100.0 * sum(output_32_final."All ambulance referral cases from the last two months have an a")) / (NULLIF(count(output_32_final."All ambulance referral cases from the last two months have an a"), 0))::numeric), 2) AS achievement_all_ambulance_referral_cases_from_the_last_two_mont,
    count(output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)") AS expected_transfer_sheet_is_standardized_all_nine_9_elements_are,
    sum(output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)") AS score_transfer_sheet_is_standardized_all_nine_9_elements_are_sh,
    round(((100.0 * sum(output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)")) / (NULLIF(count(output_32_final."Transfer sheet is standardized( all nine(9) elements are shown)"), 0))::numeric), 2) AS achievement_transfer_sheet_is_standardized_all_nine_9_elements_,
    count(output_32_final."All 5 detailed-reviewed drugs have consumption register totaled") AS expected_all_5_detailed_reviewed_drugs_have_consumption_registe,
    sum(output_32_final."All 5 detailed-reviewed drugs have consumption register totaled") AS score_all_5_detailed_reviewed_drugs_have_consumption_register_t,
    round(((100.0 * sum(output_32_final."All 5 detailed-reviewed drugs have consumption register totaled")) / (NULLIF(count(output_32_final."All 5 detailed-reviewed drugs have consumption register totaled"), 0))::numeric), 2) AS achievement_all_5_detailed_reviewed_drugs_have_consumption_regi,
    count(output_32_final."All 5 essential drugs are available and have a stock card") AS expected_all_5_essential_drugs_are_available_and_have_a_stock_c,
    sum(output_32_final."All 5 essential drugs are available and have a stock card") AS score_all_5_essential_drugs_are_available_and_have_a_stock_card,
    round(((100.0 * sum(output_32_final."All 5 essential drugs are available and have a stock card")) / (NULLIF(count(output_32_final."All 5 essential drugs are available and have a stock card"), 0))::numeric), 2) AS achievement_all_5_essential_drugs_are_available_and_have_a_stoc,
    count(output_32_final."All 5 essential drugs were not expired") AS expected_all_5_essential_drugs_were_not_expired,
    sum(output_32_final."All 5 essential drugs were not expired") AS score_all_5_essential_drugs_were_not_expired,
    round(((100.0 * sum(output_32_final."All 5 essential drugs were not expired")) / (NULLIF(count(output_32_final."All 5 essential drugs were not expired"), 0))::numeric), 2) AS achievement_all_5_essential_drugs_were_not_expired,
    count(output_32_final."Majority of reviewed patient files shows that treatment plan is") AS expected_majority_of_reviewed_patient_files_shows_that_treatmen,
    sum(output_32_final."Majority of reviewed patient files shows that treatment plan is") AS score_majority_of_reviewed_patient_files_shows_that_treatment_p,
    round(((100.0 * sum(output_32_final."Majority of reviewed patient files shows that treatment plan is")) / (NULLIF(count(output_32_final."Majority of reviewed patient files shows that treatment plan is"), 0))::numeric), 2) AS achievement_majority_of_reviewed_patient_files_shows_that_treat,
    count(output_32_final."There is standardized assessment check list") AS expected_there_is_standardized_assessment_check_list,
    sum(output_32_final."There is standardized assessment check list") AS score_there_is_standardized_assessment_check_list,
    round(((100.0 * sum(output_32_final."There is standardized assessment check list")) / (NULLIF(count(output_32_final."There is standardized assessment check list"), 0))::numeric), 2) AS achievement_there_is_standardized_assessment_check_list,
    count(output_32_final."There is a suggestions box") AS expected_there_is_a_suggestions_box,
    sum(output_32_final."There is a suggestions box") AS score_there_is_a_suggestions_box,
    round(((100.0 * sum(output_32_final."There is a suggestions box")) / (NULLIF(count(output_32_final."There is a suggestions box"), 0))::numeric), 2) AS achievement_there_is_a_suggestions_box,
    count(output_32_final."There is a customer care program") AS expected_there_is_a_customer_care_program,
    sum(output_32_final."There is a customer care program") AS score_there_is_a_customer_care_program,
    round(((100.0 * sum(output_32_final."There is a customer care program")) / (NULLIF(count(output_32_final."There is a customer care program"), 0))::numeric), 2) AS achievement_there_is_a_customer_care_program,
    count(output_32_final."QA committee is reviewing incidences") AS expected_qa_committee_is_reviewing_incidences,
    sum(output_32_final."QA committee is reviewing incidences") AS score_qa_committee_is_reviewing_incidences,
    round(((100.0 * sum(output_32_final."QA committee is reviewing incidences")) / (NULLIF(count(output_32_final."QA committee is reviewing incidences"), 0))::numeric), 2) AS achievement_qa_committee_is_reviewing_incidences,
    count(output_32_final."The incident reporting form is in different languages") AS expected_the_incident_reporting_form_is_in_different_languages,
    sum(output_32_final."The incident reporting form is in different languages") AS score_the_incident_reporting_form_is_in_different_languages,
    round(((100.0 * sum(output_32_final."The incident reporting form is in different languages")) / (NULLIF(count(output_32_final."The incident reporting form is in different languages"), 0))::numeric), 2) AS achievement_the_incident_reporting_form_is_in_different_languag,
    count(output_32_final."Patient stisfaction data have been aggregated, analyzed and gra") AS expected_patient_stisfaction_data_have_been_aggregated_analyzed,
    sum(output_32_final."Patient stisfaction data have been aggregated, analyzed and gra") AS score_patient_stisfaction_data_have_been_aggregated_analyzed_an,
    round(((100.0 * sum(output_32_final."Patient stisfaction data have been aggregated, analyzed and gra")) / (NULLIF(count(output_32_final."Patient stisfaction data have been aggregated, analyzed and gra"), 0))::numeric), 2) AS achievement_patient_stisfaction_data_have_been_aggregated_analy,
    count(output_32_final."The patient satisfaction tool has been tested and revised.") AS expected_the_patient_satisfaction_tool_has_been_tested_and_revi,
    sum(output_32_final."The patient satisfaction tool has been tested and revised.") AS score_the_patient_satisfaction_tool_has_been_tested_and_revised,
    round(((100.0 * sum(output_32_final."The patient satisfaction tool has been tested and revised.")) / (NULLIF(count(output_32_final."The patient satisfaction tool has been tested and revised."), 0))::numeric), 2) AS achievement_the_patient_satisfaction_tool_has_been_tested_and_r,
    count(output_32_final."The quality improvement plan is tracked") AS expected_the_quality_improvement_plan_is_tracked,
    sum(output_32_final."The quality improvement plan is tracked") AS score_the_quality_improvement_plan_is_tracked,
    round(((100.0 * sum(output_32_final."The quality improvement plan is tracked")) / (NULLIF(count(output_32_final."The quality improvement plan is tracked"), 0))::numeric), 2) AS achievement_the_quality_improvement_plan_is_tracked,
    count(output_32_final."There is a QI focal person") AS expected_there_is_a_qi_focal_person,
    sum(output_32_final."There is a QI focal person") AS score_there_is_a_qi_focal_person,
    round(((100.0 * sum(output_32_final."There is a QI focal person")) / (NULLIF(count(output_32_final."There is a QI focal person"), 0))::numeric), 2) AS achievement_there_is_a_qi_focal_person,
    count(output_32_final."Staff satisfaction data has been aggregated, analyzed and graph") AS expected_staff_satisfaction_data_has_been_aggregated_analyzed_a,
    sum(output_32_final."Staff satisfaction data has been aggregated, analyzed and graph") AS score_staff_satisfaction_data_has_been_aggregated_analyzed_and_,
    round(((100.0 * sum(output_32_final."Staff satisfaction data has been aggregated, analyzed and graph")) / (NULLIF(count(output_32_final."Staff satisfaction data has been aggregated, analyzed and graph"), 0))::numeric), 2) AS achievement_staff_satisfaction_data_has_been_aggregated_analyze,
    count(output_32_final."Staff satisfaction tool has been developed and tested.") AS expected_staff_satisfaction_tool_has_been_developed_and_tested,
    sum(output_32_final."Staff satisfaction tool has been developed and tested.") AS score_staff_satisfaction_tool_has_been_developed_and_tested,
    round(((100.0 * sum(output_32_final."Staff satisfaction tool has been developed and tested.")) / (NULLIF(count(output_32_final."Staff satisfaction tool has been developed and tested."), 0))::numeric), 2) AS achievement_staff_satisfaction_tool_has_been_developed_and_test,
    count(output_32_final."Patients' and familys' rights are posted for public view") AS expected_patients_and_familys_rights_are_posted_for_public_view,
    sum(output_32_final."Patients' and familys' rights are posted for public view") AS score_patients_and_familys_rights_are_posted_for_public_view,
    round(((100.0 * sum(output_32_final."Patients' and familys' rights are posted for public view")) / (NULLIF(count(output_32_final."Patients' and familys' rights are posted for public view"), 0))::numeric), 2) AS achievement_patients_and_familys_rights_are_posted_for_public_v,
    count(output_32_final."70% of facility services  has an updated list of required, exis") AS expected_70_of_facility_services_has_an_updated_list_of_require,
    sum(output_32_final."70% of facility services  has an updated list of required, exis") AS score_70_of_facility_services_has_an_updated_list_of_required_e,
    round(((100.0 * sum(output_32_final."70% of facility services  has an updated list of required, exis")) / (NULLIF(count(output_32_final."70% of facility services  has an updated list of required, exis"), 0))::numeric), 2) AS achievement_70_of_facility_services_has_an_updated_list_of_requ,
    count(output_32_final."All account reconciliations are done monthly, payables and rece") AS expected_all_account_reconciliations_are_done_monthly_payables_,
    sum(output_32_final."All account reconciliations are done monthly, payables and rece") AS score_all_account_reconciliations_are_done_monthly_payables_and,
    round(((100.0 * sum(output_32_final."All account reconciliations are done monthly, payables and rece")) / (NULLIF(count(output_32_final."All account reconciliations are done monthly, payables and rece"), 0))::numeric), 2) AS achievement_all_account_reconciliations_are_done_monthly_payabl,
    count(output_32_final."The names, photos, and phone numbers of management staff are di") AS expected_the_names_photos_and_phone_numbers_of_management_staff,
    sum(output_32_final."The names, photos, and phone numbers of management staff are di") AS score_the_names_photos_and_phone_numbers_of_management_staff_ar,
    round(((100.0 * sum(output_32_final."The names, photos, and phone numbers of management staff are di")) / (NULLIF(count(output_32_final."The names, photos, and phone numbers of management staff are di"), 0))::numeric), 2) AS achievement_the_names_photos_and_phone_numbers_of_management_st,
    count(output_32_final."More than 80% of service have One hand washing/hygiene facility") AS expected_more_than_80_of_service_have_one_hand_washing_hygiene_,
    sum(output_32_final."More than 80% of service have One hand washing/hygiene facility") AS score_more_than_80_of_service_have_one_hand_washing_hygiene_fac,
    round(((100.0 * sum(output_32_final."More than 80% of service have One hand washing/hygiene facility")) / (NULLIF(count(output_32_final."More than 80% of service have One hand washing/hygiene facility"), 0))::numeric), 2) AS achievement_more_than_80_of_service_have_one_hand_washing_hygie,
    count(output_32_final."80% of service have hand hygiene procedures based on current pr") AS expected_80_of_service_have_hand_hygiene_procedures_based_on_cu,
    sum(output_32_final."80% of service have hand hygiene procedures based on current pr") AS score_80_of_service_have_hand_hygiene_procedures_based_on_curre,
    round(((100.0 * sum(output_32_final."80% of service have hand hygiene procedures based on current pr")) / (NULLIF(count(output_32_final."80% of service have hand hygiene procedures based on current pr"), 0))::numeric), 2) AS achievement_80_of_service_have_hand_hygiene_procedures_based_on,
    count(output_32_final."Risks of infection have been identified for patients, staff and") AS expected_risks_of_infection_have_been_identified_for_patients_s,
    sum(output_32_final."Risks of infection have been identified for patients, staff and") AS score_risks_of_infection_have_been_identified_for_patients_staf,
    round(((100.0 * sum(output_32_final."Risks of infection have been identified for patients, staff and")) / (NULLIF(count(output_32_final."Risks of infection have been identified for patients, staff and"), 0))::numeric), 2) AS achievement_risks_of_infection_have_been_identified_for_patient,
    count(output_32_final."There is an IPC focal person that actively guides the IPC progr") AS expected_there_is_an_ipc_focal_person_that_actively_guides_the_,
    sum(output_32_final."There is an IPC focal person that actively guides the IPC progr") AS score_there_is_an_ipc_focal_person_that_actively_guides_the_ipc,
    round(((100.0 * sum(output_32_final."There is an IPC focal person that actively guides the IPC progr")) / (NULLIF(count(output_32_final."There is an IPC focal person that actively guides the IPC progr"), 0))::numeric), 2) AS achievement_there_is_an_ipc_focal_person_that_actively_guides_t
   FROM public.output_32_final
  GROUP BY output_32_final.district_name, output_32_final.healthcenter_name, output_32_final."MPS_Quarter", output_32_final."Survey_year";


ALTER VIEW public.output_32_final_view_precentage OWNER TO health_builders;

--
-- Name: output_41_final_copy1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.output_41_final_copy1 (
    district_name character varying(255),
    healthcenter_name character varying(255),
    "MPS_Quarter" character varying(255),
    survey_year numeric(6,0),
    "Measurements" character varying(255),
    "All 5 detailed-reviewed drugs have accurate tally sheets" numeric,
    "All 5 detailed-reviewed drugs have an updated consumption regis" numeric,
    "All 5 drug stock cards matched the quantity found on the shelf" numeric,
    "All requisitions are signed and stamped" numeric,
    "An essential drug list is available and used to order medicatio" numeric,
    "Drugs are well organized, labeled and protected from direct sun" numeric,
    "Pharmacy delivery notes are filed" numeric,
    "Refrigerator is monitored for temperature twice daily" numeric,
    "Stock room is dry and clean" numeric,
    "Tally sheets are used to track consumption" numeric,
    "There is a drug consumption register" numeric,
    "There is a pharmacy monthly inventory" numeric,
    "There is a separate room for expired drugs" numeric,
    "Monthly staff minutes shows that meetings are happening" numeric,
    "There is an implemented in-service training plan" numeric,
    "There is an up-to-date register/report of external trainings" numeric,
    "There is an updated work schedule" numeric,
    "Theres is an updated attendance register(actively used)" numeric,
    "QA is meeting on a monthly basis" numeric,
    "There is clear, visible internal signage that includes the name" numeric,
    "All 3 incomes recorded in the receipt book and journal matched" numeric,
    "All 3 transactions had required supporting documents" numeric,
    "The budget plan includes capital & maintenance" numeric,
    "The budget plan is approved by the titulaire and tracked" numeric,
    "There is an up to date individual bank book for each bank accou" numeric,
    "There is an up to date petty cash book and cash register" numeric,
    "Transactions are numbered and ordered sequentially" numeric,
    "COGE minutes show that the committee is meeting at least once p" numeric,
    "COSA minutes show that the committee is meeting at least once p" numeric,
    "Current job descriptions are written for each facility leader a" numeric,
    "The action plan is approved by the titulaire and tracked" numeric,
    "There is an updated organization chart" numeric,
    "All 15 randomly reviewed lines of the register were >80% comple" numeric,
    "Data displayed in services is current & relevant(at least in ma" numeric,
    "Data reports are >95% accurate across sources" numeric,
    "The monthly data report is signed and submitted on time" numeric,
    "There is an SOP for data management" numeric,
    "CHW minutes show that at least meetings are being held once per" numeric,
    "The business plan is approved by the titulaire and tracked" numeric,
    "All functional latrines are clean" numeric,
    "All functional latrines are equipped with hand washing stations" numeric
);


ALTER TABLE public.output_41_final_copy1 OWNER TO health_builders;

--
-- Name: output_41_final_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.output_41_final_summary AS
 WITH calculated AS (
         SELECT output_41_final.district_name,
            output_41_final.healthcenter_name,
            output_41_final."MPS_Quarter",
            output_41_final.survey_year,
            ((((((((((((((((((((((((((((((((((((((((COALESCE(output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets", (0)::numeric) + COALESCE(output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis", (0)::numeric)) + COALESCE(output_41_final."All 5 drug stock cards matched the quantity found on the shelf", (0)::numeric)) + COALESCE(output_41_final."All requisitions are signed and stamped", (0)::numeric)) + COALESCE(output_41_final."An essential drug list is available and used to order medicatio", (0)::numeric)) + COALESCE(output_41_final."Drugs are well organized, labeled and protected from direct sun", (0)::numeric)) + COALESCE(output_41_final."Pharmacy delivery notes are filed", (0)::numeric)) + COALESCE(output_41_final."Refrigerator is monitored for temperature twice daily", (0)::numeric)) + COALESCE(output_41_final."Stock room is dry and clean", (0)::numeric)) + COALESCE(output_41_final."Tally sheets are used to track consumption", (0)::numeric)) + COALESCE(output_41_final."There is a drug consumption register", (0)::numeric)) + COALESCE(output_41_final."There is a pharmacy monthly inventory", (0)::numeric)) + COALESCE(output_41_final."There is a separate room for expired drugs", (0)::numeric)) + COALESCE(output_41_final."Monthly staff minutes shows that meetings are happening", (0)::numeric)) + COALESCE(output_41_final."There is an implemented in-service training plan", (0)::numeric)) + COALESCE(output_41_final."There is an up-to-date register/report of external trainings", (0)::numeric)) + COALESCE(output_41_final."There is an updated work schedule", (0)::numeric)) + COALESCE(output_41_final."Theres is an updated attendance register(actively used)", (0)::numeric)) + COALESCE(output_41_final."QA is meeting on a monthly basis", (0)::numeric)) + COALESCE(output_41_final."There is clear, visible internal signage that includes the name", (0)::numeric)) + COALESCE(output_41_final."All 3 incomes recorded in the receipt book and journal matched", (0)::numeric)) + COALESCE(output_41_final."All 3 transactions had required supporting documents", (0)::numeric)) + COALESCE(output_41_final."The budget plan includes capital & maintenance", (0)::numeric)) + COALESCE(output_41_final."The budget plan is approved by the titulaire and tracked", (0)::numeric)) + COALESCE(output_41_final."There is an up to date individual bank book for each bank accou", (0)::numeric)) + COALESCE(output_41_final."There is an up to date petty cash book and cash register", (0)::numeric)) + COALESCE(output_41_final."Transactions are numbered and ordered sequentially", (0)::numeric)) + COALESCE(output_41_final."COGE minutes show that the committee is meeting at least once p", (0)::numeric)) + COALESCE(output_41_final."COSA minutes show that the committee is meeting at least once p", (0)::numeric)) + COALESCE(output_41_final."Current job descriptions are written for each facility leader a", (0)::numeric)) + COALESCE(output_41_final."The action plan is approved by the titulaire and tracked", (0)::numeric)) + COALESCE(output_41_final."There is an updated organization chart", (0)::numeric)) + COALESCE(output_41_final."All 15 randomly reviewed lines of the register were >80% comple", (0)::numeric)) + COALESCE(output_41_final."Data displayed in services is current & relevant(at least in ma", (0)::numeric)) + COALESCE(output_41_final."Data reports are >95% accurate across sources", (0)::numeric)) + COALESCE(output_41_final."The monthly data report is signed and submitted on time", (0)::numeric)) + COALESCE(output_41_final."There is an SOP for data management", (0)::numeric)) + COALESCE(output_41_final."CHW minutes show that at least meetings are being held once per", (0)::numeric)) + COALESCE(output_41_final."The business plan is approved by the titulaire and tracked", (0)::numeric)) + COALESCE(output_41_final."All functional latrines are clean", (0)::numeric)) + COALESCE(output_41_final."All functional latrines are equipped with hand washing stations", (0)::numeric)) AS total_sum,
            ((((((((((((((((((((((((((((((((((((((((
                CASE
                    WHEN (output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets" IS NOT NULL) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All 5 drug stock cards matched the quantity found on the shelf" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All requisitions are signed and stamped" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."An essential drug list is available and used to order medicatio" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Drugs are well organized, labeled and protected from direct sun" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Pharmacy delivery notes are filed" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Refrigerator is monitored for temperature twice daily" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Stock room is dry and clean" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Tally sheets are used to track consumption" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is a drug consumption register" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is a pharmacy monthly inventory" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is a separate room for expired drugs" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Monthly staff minutes shows that meetings are happening" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an implemented in-service training plan" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an up-to-date register/report of external trainings" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an updated work schedule" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Theres is an updated attendance register(actively used)" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."QA is meeting on a monthly basis" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is clear, visible internal signage that includes the name" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All 3 transactions had required supporting documents" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All 3 transactions had required supporting documents" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."The budget plan includes capital & maintenance" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."The budget plan is approved by the titulaire and tracked" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an up to date individual bank book for each bank accou" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an up to date petty cash book and cash register" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Transactions are numbered and ordered sequentially" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."COGE minutes show that the committee is meeting at least once p" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."COSA minutes show that the committee is meeting at least once p" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Current job descriptions are written for each facility leader a" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."The action plan is approved by the titulaire and tracked" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an updated organization chart" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All 15 randomly reviewed lines of the register were >80% comple" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Data displayed in services is current & relevant(at least in ma" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."Data reports are >95% accurate across sources" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."The monthly data report is signed and submitted on time" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."There is an SOP for data management" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."CHW minutes show that at least meetings are being held once per" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."The business plan is approved by the titulaire and tracked" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All functional latrines are clean" IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (output_41_final."All functional latrines are equipped with hand washing stations" IS NOT NULL) THEN 1
                    ELSE 0
                END) AS total_count
           FROM public.output_41_final
        )
 SELECT calculated.district_name,
    calculated.healthcenter_name,
    calculated."MPS_Quarter",
    calculated.survey_year,
    calculated.total_sum,
    calculated.total_count,
        CASE
            WHEN (calculated.total_count > 0) THEN round(((calculated.total_sum * (100)::numeric) / (calculated.total_count)::numeric), 1)
            ELSE (0)::numeric
        END AS percentage
   FROM calculated;


ALTER VIEW public.output_41_final_summary OWNER TO health_builders;

--
-- Name: output_41_final_view_Percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."output_41_final_view_Percentage" AS
 SELECT output_41_final.district_name,
    output_41_final.healthcenter_name,
    output_41_final."MPS_Quarter",
    output_41_final.survey_year,
    count(*) AS measurements,
    count(output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis") AS expected_all_5_detailed_reviewed_drugs_have_an_updated_consumpt,
    sum(output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis") AS score_all_5_detailed_reviewed_drugs_have_an_updated_consumption,
    round(((100.0 * sum(output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis")) / (NULLIF(count(output_41_final."All 5 detailed-reviewed drugs have an updated consumption regis"), 0))::numeric), 2) AS achievement_all_5_detailed_reviewed_drugs_have_an_updated_consu,
    count(output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets") AS expected_all_5_detailed_reviewed_drugs_have_accurate_tally_shee,
    sum(output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets") AS score_all_5_detailed_reviewed_drugs_have_accurate_tally_sheets,
    round(((100.0 * sum(output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets")) / (NULLIF(count(output_41_final."All 5 detailed-reviewed drugs have accurate tally sheets"), 0))::numeric), 2) AS achievement_all_5_detailed_reviewed_drugs_have_accurate_tally_s,
    count(output_41_final."All 5 drug stock cards matched the quantity found on the shelf") AS expected_all_5_drug_stock_cards_matched_the_quantity_found_on_t,
    sum(output_41_final."All 5 drug stock cards matched the quantity found on the shelf") AS score_all_5_drug_stock_cards_matched_the_quantity_found_on_the_,
    round(((100.0 * sum(output_41_final."All 5 drug stock cards matched the quantity found on the shelf")) / (NULLIF(count(output_41_final."All 5 drug stock cards matched the quantity found on the shelf"), 0))::numeric), 2) AS achievement_all_5_drug_stock_cards_matched_the_quantity_found_o,
    count(output_41_final."All requisitions are signed and stamped") AS expected_all_requisitions_are_signed_and_stamped,
    sum(output_41_final."All requisitions are signed and stamped") AS score_all_requisitions_are_signed_and_stamped,
    round(((100.0 * sum(output_41_final."All requisitions are signed and stamped")) / (NULLIF(count(output_41_final."All requisitions are signed and stamped"), 0))::numeric), 2) AS achievement_all_requisitions_are_signed_and_stamped,
    count(output_41_final."An essential drug list is available and used to order medicatio") AS expected_an_essential_drug_list_is_available_and_used_to_order_,
    sum(output_41_final."An essential drug list is available and used to order medicatio") AS score_an_essential_drug_list_is_available_and_used_to_order_med,
    round(((100.0 * sum(output_41_final."An essential drug list is available and used to order medicatio")) / (NULLIF(count(output_41_final."An essential drug list is available and used to order medicatio"), 0))::numeric), 2) AS achievement_an_essential_drug_list_is_available_and_used_to_ord,
    count(output_41_final."Drugs are well organized, labeled and protected from direct sun") AS expected_drugs_are_well_organized_labeled_and_protected_from_di,
    sum(output_41_final."Drugs are well organized, labeled and protected from direct sun") AS score_drugs_are_well_organized_labeled_and_protected_from_direc,
    round(((100.0 * sum(output_41_final."Drugs are well organized, labeled and protected from direct sun")) / (NULLIF(count(output_41_final."Drugs are well organized, labeled and protected from direct sun"), 0))::numeric), 2) AS achievement_drugs_are_well_organized_labeled_and_protected_from,
    count(output_41_final."Pharmacy delivery notes are filed") AS expected_pharmacy_delivery_notes_are_filed,
    sum(output_41_final."Pharmacy delivery notes are filed") AS score_pharmacy_delivery_notes_are_filed,
    round(((100.0 * sum(output_41_final."Pharmacy delivery notes are filed")) / (NULLIF(count(output_41_final."Pharmacy delivery notes are filed"), 0))::numeric), 2) AS achievement_pharmacy_delivery_notes_are_filed,
    count(output_41_final."Refrigerator is monitored for temperature twice daily") AS expected_refrigerator_is_monitored_for_temperature_twice_daily,
    sum(output_41_final."Refrigerator is monitored for temperature twice daily") AS score_refrigerator_is_monitored_for_temperature_twice_daily,
    round(((100.0 * sum(output_41_final."Refrigerator is monitored for temperature twice daily")) / (NULLIF(count(output_41_final."Refrigerator is monitored for temperature twice daily"), 0))::numeric), 2) AS achievement_refrigerator_is_monitored_for_temperature_twice_dai,
    count(output_41_final."Stock room is dry and clean") AS expected_stock_room_is_dry_and_clean,
    sum(output_41_final."Stock room is dry and clean") AS score_stock_room_is_dry_and_clean,
    round(((100.0 * sum(output_41_final."Stock room is dry and clean")) / (NULLIF(count(output_41_final."Stock room is dry and clean"), 0))::numeric), 2) AS achievement_stock_room_is_dry_and_clean,
    count(output_41_final."Tally sheets are used to track consumption") AS expected_tally_sheets_are_used_to_track_consumption,
    sum(output_41_final."Tally sheets are used to track consumption") AS score_tally_sheets_are_used_to_track_consumption,
    round(((100.0 * sum(output_41_final."Tally sheets are used to track consumption")) / (NULLIF(count(output_41_final."Tally sheets are used to track consumption"), 0))::numeric), 2) AS achievement_tally_sheets_are_used_to_track_consumption,
    count(output_41_final."There is a drug consumption register") AS expected_there_is_a_drug_consumption_register,
    sum(output_41_final."There is a drug consumption register") AS score_there_is_a_drug_consumption_register,
    round(((100.0 * sum(output_41_final."There is a drug consumption register")) / (NULLIF(count(output_41_final."There is a drug consumption register"), 0))::numeric), 2) AS achievement_there_is_a_drug_consumption_register,
    count(output_41_final."There is a pharmacy monthly inventory") AS expected_there_is_a_pharmacy_monthly_inventory,
    sum(output_41_final."There is a pharmacy monthly inventory") AS score_there_is_a_pharmacy_monthly_inventory,
    round(((100.0 * sum(output_41_final."There is a pharmacy monthly inventory")) / (NULLIF(count(output_41_final."There is a pharmacy monthly inventory"), 0))::numeric), 2) AS achievement_there_is_a_pharmacy_monthly_inventory,
    count(output_41_final."There is a separate room for expired drugs") AS expected_there_is_a_separate_room_for_expired_drugs,
    sum(output_41_final."There is a separate room for expired drugs") AS score_there_is_a_separate_room_for_expired_drugs,
    round(((100.0 * sum(output_41_final."There is a separate room for expired drugs")) / (NULLIF(count(output_41_final."There is a separate room for expired drugs"), 0))::numeric), 2) AS achievement_there_is_a_separate_room_for_expired_drugs,
    count(output_41_final."Monthly staff minutes shows that meetings are happening") AS expected_monthly_staff_minutes_shows_that_meetings_are_happenin,
    sum(output_41_final."Monthly staff minutes shows that meetings are happening") AS score_monthly_staff_minutes_shows_that_meetings_are_happening,
    round(((100.0 * sum(output_41_final."Monthly staff minutes shows that meetings are happening")) / (NULLIF(count(output_41_final."Monthly staff minutes shows that meetings are happening"), 0))::numeric), 2) AS achievement_monthly_staff_minutes_shows_that_meetings_are_happe,
    count(output_41_final."There is an implemented in-service training plan") AS expected_there_is_an_implemented_in_service_training_plan,
    sum(output_41_final."There is an implemented in-service training plan") AS score_there_is_an_implemented_in_service_training_plan,
    round(((100.0 * sum(output_41_final."There is an implemented in-service training plan")) / (NULLIF(count(output_41_final."There is an implemented in-service training plan"), 0))::numeric), 2) AS achievement_there_is_an_implemented_in_service_training_plan,
    count(output_41_final."There is an up-to-date register/report of external trainings") AS expected_there_is_an_up_to_date_register_report_of_external_tra,
    sum(output_41_final."There is an up-to-date register/report of external trainings") AS score_there_is_an_up_to_date_register_report_of_external_traini,
    round(((100.0 * sum(output_41_final."There is an up-to-date register/report of external trainings")) / (NULLIF(count(output_41_final."There is an up-to-date register/report of external trainings"), 0))::numeric), 2) AS achievement_there_is_an_up_to_date_register_report_of_external_,
    count(output_41_final."There is an updated work schedule") AS expected_there_is_an_updated_work_schedule,
    sum(output_41_final."There is an updated work schedule") AS score_there_is_an_updated_work_schedule,
    round(((100.0 * sum(output_41_final."There is an updated work schedule")) / (NULLIF(count(output_41_final."There is an updated work schedule"), 0))::numeric), 2) AS achievement_there_is_an_updated_work_schedule,
    count(output_41_final."Theres is an updated attendance register(actively used)") AS expected_theres_is_an_updated_attendance_registeractively_used,
    sum(output_41_final."Theres is an updated attendance register(actively used)") AS score_theres_is_an_updated_attendance_registeractively_used,
    round(((100.0 * sum(output_41_final."Theres is an updated attendance register(actively used)")) / (NULLIF(count(output_41_final."Theres is an updated attendance register(actively used)"), 0))::numeric), 2) AS achievement_theres_is_an_updated_attendance_registeractively_us,
    count(output_41_final."QA is meeting on a monthly basis") AS expected_qa_is_meeting_on_a_monthly_basis,
    sum(output_41_final."QA is meeting on a monthly basis") AS score_qa_is_meeting_on_a_monthly_basis,
    round(((100.0 * sum(output_41_final."QA is meeting on a monthly basis")) / (NULLIF(count(output_41_final."QA is meeting on a monthly basis"), 0))::numeric), 2) AS achievement_qa_is_meeting_on_a_monthly_basis,
    count(output_41_final."All 3 incomes recorded in the receipt book and journal matched") AS expected_all_3_incomes_recorded_in_the_receipt_book_and_journal,
    sum(output_41_final."All 3 incomes recorded in the receipt book and journal matched") AS score_all_3_incomes_recorded_in_the_receipt_book_and_journal_ma,
    round(((100.0 * sum(output_41_final."All 3 incomes recorded in the receipt book and journal matched")) / (NULLIF(count(output_41_final."All 3 incomes recorded in the receipt book and journal matched"), 0))::numeric), 2) AS achievement_all_3_incomes_recorded_in_the_receipt_book_and_jour,
    count(output_41_final."There is clear, visible internal signage that includes the name") AS expected_there_is_clear_visible_internal_signage_that_includes_,
    sum(output_41_final."There is clear, visible internal signage that includes the name") AS score_there_is_clear_visible_internal_signage_that_includes_the,
    round(((100.0 * sum(output_41_final."There is clear, visible internal signage that includes the name")) / (NULLIF(count(output_41_final."There is clear, visible internal signage that includes the name"), 0))::numeric), 2) AS achievement_there_is_clear_visible_internal_signage_that_includ,
    count(output_41_final."All 3 transactions had required supporting documents") AS expected_all_3_transactions_had_required_supporting_documents,
    sum(output_41_final."All 3 transactions had required supporting documents") AS score_all_3_transactions_had_required_supporting_documents,
    round(((100.0 * sum(output_41_final."All 3 transactions had required supporting documents")) / (NULLIF(count(output_41_final."All 3 transactions had required supporting documents"), 0))::numeric), 2) AS achievement_all_3_transactions_had_required_supporting_document,
    count(output_41_final."The budget plan includes capital & maintenance") AS expected_the_budget_plan_includes_capital_and_maintenance,
    sum(output_41_final."The budget plan includes capital & maintenance") AS score_the_budget_plan_includes_capital_and_maintenance,
    round(((100.0 * sum(output_41_final."The budget plan includes capital & maintenance")) / (NULLIF(count(output_41_final."The budget plan includes capital & maintenance"), 0))::numeric), 2) AS achievement_the_budget_plan_includes_capital_and_maintenance,
    count(output_41_final."The budget plan is approved by the titulaire and tracked") AS expected_the_budget_plan_is_approved_by_the_titulaire_and_track,
    sum(output_41_final."The budget plan is approved by the titulaire and tracked") AS score_the_budget_plan_is_approved_by_the_titulaire_and_tracked,
    round(((100.0 * sum(output_41_final."The budget plan is approved by the titulaire and tracked")) / (NULLIF(count(output_41_final."The budget plan is approved by the titulaire and tracked"), 0))::numeric), 2) AS achievement_the_budget_plan_is_approved_by_the_titulaire_and_tr,
    count(output_41_final."There is an up to date individual bank book for each bank accou") AS expected_there_is_an_up_to_date_individual_bank_book_for_each_b,
    sum(output_41_final."There is an up to date individual bank book for each bank accou") AS score_there_is_an_up_to_date_individual_bank_book_for_each_bank,
    round(((100.0 * sum(output_41_final."There is an up to date individual bank book for each bank accou")) / (NULLIF(count(output_41_final."There is an up to date individual bank book for each bank accou"), 0))::numeric), 2) AS achievement_there_is_an_up_to_date_individual_bank_book_for_eac,
    count(output_41_final."There is an up to date petty cash book and cash register") AS expected_there_is_an_up_to_date_petty_cash_book_and_cash_regist,
    sum(output_41_final."There is an up to date petty cash book and cash register") AS score_there_is_an_up_to_date_petty_cash_book_and_cash_register,
    round(((100.0 * sum(output_41_final."There is an up to date petty cash book and cash register")) / (NULLIF(count(output_41_final."There is an up to date petty cash book and cash register"), 0))::numeric), 2) AS achievement_there_is_an_up_to_date_petty_cash_book_and_cash_reg,
    count(output_41_final."Transactions are numbered and ordered sequentially") AS expected_transactions_are_numbered_and_ordered_sequentially,
    sum(output_41_final."Transactions are numbered and ordered sequentially") AS score_transactions_are_numbered_and_ordered_sequentially,
    round(((100.0 * sum(output_41_final."Transactions are numbered and ordered sequentially")) / (NULLIF(count(output_41_final."Transactions are numbered and ordered sequentially"), 0))::numeric), 2) AS achievement_transactions_are_numbered_and_ordered_sequentially,
    count(output_41_final."COGE minutes show that the committee is meeting at least once p") AS expected_coge_minutes_show_that_the_committee_is_meeting_at_lea,
    sum(output_41_final."COGE minutes show that the committee is meeting at least once p") AS score_coge_minutes_show_that_the_committee_is_meeting_at_least_,
    round(((100.0 * sum(output_41_final."COGE minutes show that the committee is meeting at least once p")) / (NULLIF(count(output_41_final."COGE minutes show that the committee is meeting at least once p"), 0))::numeric), 2) AS achievement_coge_minutes_show_that_the_committee_is_meeting_at_,
    count(output_41_final."COSA minutes show that the committee is meeting at least once p") AS expected_cosa_minutes_show_that_the_committee_is_meeting_at_lea,
    sum(output_41_final."COSA minutes show that the committee is meeting at least once p") AS score_cosa_minutes_show_that_the_committee_is_meeting_at_least_,
    round(((100.0 * sum(output_41_final."COSA minutes show that the committee is meeting at least once p")) / (NULLIF(count(output_41_final."COSA minutes show that the committee is meeting at least once p"), 0))::numeric), 2) AS achievement_cosa_minutes_show_that_the_committee_is_meeting_at_,
    count(output_41_final."Current job descriptions are written for each facility leader a") AS expected_current_job_descriptions_are_written_for_each_facility,
    sum(output_41_final."Current job descriptions are written for each facility leader a") AS score_current_job_descriptions_are_written_for_each_facility_le,
    round(((100.0 * sum(output_41_final."Current job descriptions are written for each facility leader a")) / (NULLIF(count(output_41_final."Current job descriptions are written for each facility leader a"), 0))::numeric), 2) AS achievement_current_job_descriptions_are_written_for_each_facil,
    count(output_41_final."The action plan is approved by the titulaire and tracked") AS expected_the_action_plan_is_approved_by_the_titulaire_and_track,
    sum(output_41_final."The action plan is approved by the titulaire and tracked") AS score_the_action_plan_is_approved_by_the_titulaire_and_tracked,
    round(((100.0 * sum(output_41_final."The action plan is approved by the titulaire and tracked")) / (NULLIF(count(output_41_final."The action plan is approved by the titulaire and tracked"), 0))::numeric), 2) AS achievement_the_action_plan_is_approved_by_the_titulaire_and_tr,
    count(output_41_final."There is an updated organization chart") AS expected_there_is_an_updated_organization_chart,
    sum(output_41_final."There is an updated organization chart") AS score_there_is_an_updated_organization_chart,
    round(((100.0 * sum(output_41_final."There is an updated organization chart")) / (NULLIF(count(output_41_final."There is an updated organization chart"), 0))::numeric), 2) AS achievement_there_is_an_updated_organization_chart,
    count(output_41_final."All 15 randomly reviewed lines of the register were >80% comple") AS expected_all_15_randomly_reviewed_lines_of_the_register_were_gt,
    sum(output_41_final."All 15 randomly reviewed lines of the register were >80% comple") AS score_all_15_randomly_reviewed_lines_of_the_register_were_gt80p,
    round(((100.0 * sum(output_41_final."All 15 randomly reviewed lines of the register were >80% comple")) / (NULLIF(count(output_41_final."All 15 randomly reviewed lines of the register were >80% comple"), 0))::numeric), 2) AS achievement_all_15_randomly_reviewed_lines_of_the_register_were,
    count(output_41_final."Data displayed in services is current & relevant(at least in ma") AS expected_data_displayed_in_services_is_current_and_relevantat_l,
    sum(output_41_final."Data displayed in services is current & relevant(at least in ma") AS score_data_displayed_in_services_is_current_and_relevantat_leas,
    round(((100.0 * sum(output_41_final."Data displayed in services is current & relevant(at least in ma")) / (NULLIF(count(output_41_final."Data displayed in services is current & relevant(at least in ma"), 0))::numeric), 2) AS achievement_data_displayed_in_services_is_current_and_relevanta,
    count(output_41_final."Data reports are >95% accurate across sources") AS "expected_data_reports_are_gt95percent_accurate_across sources",
    sum(output_41_final."Data reports are >95% accurate across sources") AS "score_data_reports_are_gt95percent_accurate_across sources",
    round(((100.0 * sum(output_41_final."Data reports are >95% accurate across sources")) / (NULLIF(count(output_41_final."Data reports are >95% accurate across sources"), 0))::numeric), 2) AS "achievement_data_reports_are_gt95percent_accurate_across sourc",
    count(output_41_final."The monthly data report is signed and submitted on time") AS expected_the_monthly_data_report_is_signed_and_submitted_on_tim,
    sum(output_41_final."The monthly data report is signed and submitted on time") AS score_the_monthly_data_report_is_signed_and_submitted_on_time,
    round(((100.0 * sum(output_41_final."The monthly data report is signed and submitted on time")) / (NULLIF(count(output_41_final."The monthly data report is signed and submitted on time"), 0))::numeric), 2) AS achievement_the_monthly_data_report_is_signed_and_submitted_on_,
    count(output_41_final."There is an SOP for data management") AS expected_there_is_an_sop_for_data_management,
    sum(output_41_final."There is an SOP for data management") AS score_there_is_an_sop_for_data_management,
    round(((100.0 * sum(output_41_final."There is an SOP for data management")) / (NULLIF(count(output_41_final."There is an SOP for data management"), 0))::numeric), 2) AS achievement_there_is_an_sop_for_data_management,
    count(output_41_final."CHW minutes show that at least meetings are being held once per") AS expected_chw_minutes_show_that_at_least_meetings_are_being_held,
    sum(output_41_final."CHW minutes show that at least meetings are being held once per") AS score_chw_minutes_show_that_at_least_meetings_are_being_held_on,
    round(((100.0 * sum(output_41_final."CHW minutes show that at least meetings are being held once per")) / (NULLIF(count(output_41_final."CHW minutes show that at least meetings are being held once per"), 0))::numeric), 2) AS achievement_chw_minutes_show_that_at_least_meetings_are_being_h,
    count(output_41_final."The business plan is approved by the titulaire and tracked") AS expected_the_business_plan_is_approved_by_the_titulaire_and_tra,
    sum(output_41_final."The business plan is approved by the titulaire and tracked") AS score_the_business_plan_is_approved_by_the_titulaire_and_tracke,
    round(((100.0 * sum(output_41_final."The business plan is approved by the titulaire and tracked")) / (NULLIF(count(output_41_final."The business plan is approved by the titulaire and tracked"), 0))::numeric), 2) AS achievement_the_business_plan_is_approved_by_the_titulaire_and_,
    count(output_41_final."All functional latrines are clean") AS expected_all_functional_latrines_are_clean,
    sum(output_41_final."All functional latrines are clean") AS score_all_functional_latrines_are_clean,
    round(((100.0 * sum(output_41_final."All functional latrines are clean")) / (NULLIF(count(output_41_final."All functional latrines are clean"), 0))::numeric), 2) AS achievement_all_functional_latrines_are_clean,
    count(output_41_final."All functional latrines are equipped with hand washing stations") AS expected_all_functional_latrines_are_equipped_with_hand_washing,
    sum(output_41_final."All functional latrines are equipped with hand washing stations") AS score_all_functional_latrines_are_equipped_with_hand_washing_st,
    round(((100.0 * sum(output_41_final."All functional latrines are equipped with hand washing stations")) / (NULLIF(count(output_41_final."All functional latrines are equipped with hand washing stations"), 0))::numeric), 2) AS achievement_all_functional_latrines_are_equipped_with_hand_wash
   FROM public.output_41_final
  GROUP BY output_41_final.district_name, output_41_final.healthcenter_name, output_41_final."MPS_Quarter", output_41_final.survey_year;


ALTER VIEW public."output_41_final_view_Percentage" OWNER TO health_builders;

--
-- Name: patient_age_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.patient_age_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_age_ranges_id_seq OWNER TO health_builders;

--
-- Name: patient_age_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.patient_age_ranges_id_seq OWNED BY public.patient_age_ranges.id;


--
-- Name: patient_education_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.patient_education_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_education_levels_id_seq OWNER TO health_builders;

--
-- Name: patient_education_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.patient_education_levels_id_seq OWNED BY public.patient_education_levels.id;


--
-- Name: patient_genders_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.patient_genders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_genders_id_seq OWNER TO health_builders;

--
-- Name: patient_genders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.patient_genders_id_seq OWNED BY public.patient_genders.id;


--
-- Name: patient_incidents_status; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.patient_incidents_status AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    sm.patient_family_rights_posted,
    sm.patient_staff_and_visitors_risk_of_infection_assessment_report,
    sm.patient_satisfaction_tool_tested_and_revised,
    sm.suggestion_box_available,
    sm.suggestion_box_assessment_report_available,
    sm.qi_committe_reviewing_incidents,
    sm.incident_reporting_form_in_different_langauges,
    sm.staff_satisfaction_data_has_been_aggregated_and_graphed,
    sm.staff_satisfaction_toold_developed_and_tested,
    sm.asrh_focal_person_available,
    sm.annual_list_of_safety_hazards_available,
    sm.pp_es_available,
    sm.staff_use_pp_es,
    sm.asrh_registers_available,
    sm.dedicated_as_rhspace_available,
    sm.room_for_group_iec_and_consultation_room_available,
    sm.number_of_patient_safety_incidents_reported,
    sm.number_of_incidents_analysed,
        CASE
            WHEN (sm.number_of_patient_safety_incidents_reported = 0) THEN (0)::numeric
            ELSE round((((sm.number_of_incidents_analysed)::numeric / NULLIF((sm.number_of_patient_safety_incidents_reported)::numeric, (0)::numeric)) * (100)::numeric), 2)
        END AS incidents_percentage,
    sm.number_of_hazards_identified,
    sm.number_of_hazards_fixed,
        CASE
            WHEN (sm.number_of_hazards_identified = 0) THEN (0)::numeric
            ELSE round((((sm.number_of_hazards_fixed)::numeric / NULLIF((sm.number_of_hazards_identified)::numeric, (0)::numeric)) * (100)::numeric), 2)
        END AS hazards_percentage
   FROM (((public.qr_codes q
     LEFT JOIN public.safety_managements sm ON ((q.id = sm.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public.patient_incidents_status OWNER TO health_builders;

--
-- Name: patient_satisfaction_ratings; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.patient_satisfaction_ratings (
    id bigint NOT NULL,
    value character varying(255)
);


ALTER TABLE public.patient_satisfaction_ratings OWNER TO health_builders;

--
-- Name: patient_satisfaction_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.patient_satisfaction_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_satisfaction_ratings_id_seq OWNER TO health_builders;

--
-- Name: patient_satisfaction_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.patient_satisfaction_ratings_id_seq OWNED BY public.patient_satisfaction_ratings.id;


--
-- Name: patient_satisfaction_services_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.patient_satisfaction_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_satisfaction_services_id_seq OWNER TO health_builders;

--
-- Name: patient_satisfaction_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.patient_satisfaction_services_id_seq OWNED BY public.patient_satisfaction_services.id;


--
-- Name: pharmacy_drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.pharmacy_drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pharmacy_drugs_id_seq OWNER TO health_builders;

--
-- Name: pharmacy_drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.pharmacy_drugs_id_seq OWNED BY public.pharmacy_drugs.id;


--
-- Name: pharmacy_management_drug_names; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pharmacy_management_drug_names (
    id bigint NOT NULL,
    drug_names text
);


ALTER TABLE public.pharmacy_management_drug_names OWNER TO health_builders;

--
-- Name: pharmacy_management_drug_names_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.pharmacy_management_drug_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pharmacy_management_drug_names_id_seq OWNER TO health_builders;

--
-- Name: pharmacy_management_drug_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.pharmacy_management_drug_names_id_seq OWNED BY public.pharmacy_management_drug_names.id;


--
-- Name: pharmacy_stock_values; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pharmacy_stock_values (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    review_year timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cost_of_expired_medicine numeric(15,2),
    pharmacy_stock_value numeric(15,2),
    cost_of_sold_medicine numeric(15,2),
    opening_stock_value numeric(15,2),
    last_synced_at timestamp with time zone
);


ALTER TABLE public.pharmacy_stock_values OWNER TO health_builders;

--
-- Name: pharmacy_management_view; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.pharmacy_management_view AS
 SELECT qc.id AS survey_id,
    qc.survey_year,
    d.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    qc.survey_year AS fiscal_year,
    cb.medicine_sales AS total_medicine_sales,
    NULL::text AS opening_stock,
    cb.purchased_medicine AS total_medicine_purchases,
    psv.pharmacy_stock_value AS closing_stock
   FROM ((((public.qr_codes qc
     LEFT JOIN public.closing_balances cb ON ((qc.id = cb.survey_id)))
     LEFT JOIN public.pharmacy_stock_values psv ON ((qc.id = psv.survey_id)))
     LEFT JOIN public.districts d ON ((qc.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qc.health_center_id = hc.id)));


ALTER VIEW public.pharmacy_management_view OWNER TO health_builders;

--
-- Name: planning_1_qi_programme; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.planning_1_qi_programme AS
 SELECT fmv.survey_id,
    fmv.survey_year,
    fmv.district,
    fmv.health_facility,
    fmv.facility_type,
    fpv._32_31_qi_focal_person_available AS focal_person_apointed,
    fmv._41_40_qi_committe_meetings AS regular_meetings,
    qpv.plan_available,
    qpv.plan_tracked,
    qpv.plan_approved,
        CASE
            WHEN ((fpv._32_31_qi_focal_person_available = 1) AND (fmv._41_40_qi_committe_meetings = 1) AND (qpv.plan_available = 1) AND (qpv.plan_tracked = 1) AND (qpv.plan_approved = 1)) THEN 1
            ELSE 0
        END AS active_qi_programme,
    count(*) OVER () AS total_count,
    sum(
        CASE
            WHEN ((fpv._32_31_qi_focal_person_available = 1) AND (fmv._41_40_qi_committe_meetings = 1) AND (qpv.plan_available = 1) AND (qpv.plan_tracked = 1) AND (qpv.plan_approved = 1)) THEN 1
            ELSE 0
        END) OVER () AS active_sum,
    round((((sum(
        CASE
            WHEN ((fpv._32_31_qi_focal_person_available = 1) AND (fmv._41_40_qi_committe_meetings = 1) AND (qpv.plan_available = 1) AND (qpv.plan_tracked = 1) AND (qpv.plan_approved = 1)) THEN 1
            ELSE 0
        END) OVER ())::numeric / (count(*) OVER ())::numeric) * (100)::numeric), 2) AS active_percentage
   FROM ((public._41_39_to41_financial_management fmv
     LEFT JOIN public._32_31_to32_focal_persons fpv ON ((fmv.survey_id = fpv.survey_id)))
     LEFT JOIN public._32_2_qi_plan qpv ON ((fmv.survey_id = qpv.survey_id)));


ALTER VIEW public.planning_1_qi_programme OWNER TO health_builders;

--
-- Name: planning_1_qi_programme_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.planning_1_qi_programme_2 AS
 SELECT fmv.survey_id,
    fmv.survey_year,
    fmv.district,
    fmv.health_facility,
    fmv.facility_type,
    fpv._32_31_qi_focal_person_available AS focal_person_apointed,
    fmv._41_40_qi_committe_meetings AS regular_meetings,
    qpv.plan_available,
    qpv.plan_tracked,
    qpv.plan_approved,
        CASE
            WHEN ((fpv._32_31_qi_focal_person_available = 1) AND (fmv._41_40_qi_committe_meetings = 1) AND (qpv.plan_available = 1) AND (qpv.plan_tracked = 1) AND (qpv.plan_approved = 1)) THEN 1
            ELSE 0
        END AS active_qi_programme,
    (((((count(fpv._32_31_qi_focal_person_available) + count(fmv._41_40_qi_committe_meetings)) + count(qpv.plan_available)) + count(qpv.plan_tracked)) + count(qpv.plan_approved)))::numeric AS expected,
    sum((((((COALESCE(fpv._32_31_qi_focal_person_available, 0))::numeric + (COALESCE(fmv._41_40_qi_committe_meetings, 0))::numeric) + (COALESCE(qpv.plan_available, 0))::numeric) + (COALESCE(qpv.plan_tracked, 0))::numeric) + (COALESCE(qpv.plan_approved, 0))::numeric)) AS score,
    round(((sum((((((COALESCE(fpv._32_31_qi_focal_person_available, 0))::numeric + (COALESCE(fmv._41_40_qi_committe_meetings, 0))::numeric) + (COALESCE(qpv.plan_available, 0))::numeric) + (COALESCE(qpv.plan_tracked, 0))::numeric) + (COALESCE(qpv.plan_approved, 0))::numeric)) / (((((count(fpv._32_31_qi_focal_person_available))::numeric + (count(fmv._41_40_qi_committe_meetings))::numeric) + (count(qpv.plan_available))::numeric) + (count(qpv.plan_tracked))::numeric) + (count(qpv.plan_approved))::numeric)) * (100)::numeric), 2) AS score_percentage
   FROM ((public._41_39_to41_financial_management fmv
     LEFT JOIN public._32_31_to32_focal_persons fpv ON ((fmv.survey_id = fpv.survey_id)))
     LEFT JOIN public._32_2_qi_plan qpv ON ((fmv.survey_id = qpv.survey_id)))
  GROUP BY fmv.district, fmv.health_facility, fmv.survey_id, fmv.survey_year, fmv.facility_type, fpv._32_31_qi_focal_person_available, fmv._41_40_qi_committe_meetings, qpv.plan_available, qpv.plan_tracked, qpv.plan_approved;


ALTER VIEW public.planning_1_qi_programme_2 OWNER TO health_builders;

--
-- Name: planning_2_customer_care; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.planning_2_customer_care AS
 SELECT ccsm.survey_id,
    ccsm.survey_year,
    ccsm.district,
    ccsm.health_facility,
    ccsm.facility_type,
        CASE
            WHEN (fp.customer_care_focal_person = true) THEN 1
            ELSE 0
        END AS focal_person_appointed,
    ccsm._32_17_suggestion_box_available AS suggestion_box_available,
    ccsm._32_21_patient_family_rights_posted AS patient_rights_posted_for_public_view,
    ccsm._32_18_customer_care_program_tracked_approved AS written_customer_care_program_expectations,
        CASE
            WHEN ((fp.customer_care_focal_person = true) AND (ccsm._32_17_suggestion_box_available = 1) AND (ccsm._32_21_patient_family_rights_posted = 1) AND (ccsm._32_18_customer_care_program_tracked_approved = 1)) THEN 1
            ELSE 0
        END AS phc_with_active_customer_care_program
   FROM (public._32_17_to26_customer_care_safety_managements ccsm
     LEFT JOIN public.focal_persons fp ON ((ccsm.survey_id = fp.survey_id)));


ALTER VIEW public.planning_2_customer_care OWNER TO health_builders;

--
-- Name: planning_3_ipc_focal_person; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.planning_3_ipc_focal_person AS
 SELECT fpv.survey_id,
    fpv.survey_year,
    fpv.district,
    fpv.health_facility,
    fpv.facility_type,
    fpv._32_32_ipc_focal_person_available AS focal_person_appointed,
    ccsm._32_19_qi_committe_reviewing_incidents AS ipc_issues_discussed_in_monthly_qi_meetings,
    ccsm._32_26_patient_staff_and_visitors_risk_of_infection_identified AS ipc_risk_assessment_reports_mitigation_plan,
        CASE
            WHEN ((fpv._32_32_ipc_focal_person_available = 1) AND (ccsm._32_19_qi_committe_reviewing_incidents = 1) AND (ccsm._32_26_patient_staff_and_visitors_risk_of_infection_identified = 1)) THEN 1
            ELSE 0
        END AS phc_ipc_focal_person_actively_coordinating
   FROM (public._32_31_to32_focal_persons fpv
     LEFT JOIN public._32_17_to26_customer_care_safety_managements ccsm ON ((fpv.survey_id = ccsm.survey_id)));


ALTER VIEW public.planning_3_ipc_focal_person OWNER TO health_builders;

--
-- Name: pneumonia_key_performance_indicators; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.pneumonia_key_performance_indicators (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    cases bigint NOT NULL,
    deaths bigint NOT NULL,
    review_year text NOT NULL,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.pneumonia_key_performance_indicators OWNER TO health_builders;

--
-- Name: project_data; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_data (
    id text NOT NULL,
    project_id text,
    health_center_id text,
    year character varying(4),
    month character varying(20),
    question_id text,
    category_id bigint,
    answer text,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    last_synced_at timestamp with time zone,
    start_date timestamp without time zone,
    end_date timestamp without time zone
);


ALTER TABLE public.project_data OWNER TO health_builders;

--
-- Name: project_data_copy18022026; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_data_copy18022026 (
    id text NOT NULL,
    project_id text,
    health_center_id text,
    year character varying(4),
    month character varying(20),
    question_id text,
    category_id bigint,
    answer text,
    created_by uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) with time zone,
    last_synced_at timestamp(6) with time zone,
    start_date timestamp(6) without time zone,
    end_date timestamp(6) without time zone
);


ALTER TABLE public.project_data_copy18022026 OWNER TO health_builders;

--
-- Name: project_question_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.project_question_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_question_categories_id_seq OWNER TO health_builders;

--
-- Name: project_question_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.project_question_categories_id_seq OWNED BY public.project_question_categories.id;


--
-- Name: project_questions_copy1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_questions_copy1 (
    id text NOT NULL,
    question text,
    created_by uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) with time zone
);


ALTER TABLE public.project_questions_copy1 OWNER TO health_builders;

--
-- Name: project_statuses; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.project_statuses (
    id bigint NOT NULL,
    status text,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.project_statuses OWNER TO health_builders;

--
-- Name: project_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.project_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_statuses_id_seq OWNER TO health_builders;

--
-- Name: project_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.project_statuses_id_seq OWNED BY public.project_statuses.id;


--
-- Name: qr_code_types_id_seq; Type: SEQUENCE; Schema: public; Owner: health_builders
--

CREATE SEQUENCE public.qr_code_types_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.qr_code_types_id_seq OWNER TO health_builders;

--
-- Name: qr_code_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: health_builders
--

ALTER SEQUENCE public.qr_code_types_id_seq OWNED BY public.qr_code_types.id;


--
-- Name: staff_satisfaction; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.staff_satisfaction (
    "Timestamp" timestamp without time zone,
    "UMWAKA" integer,
    "Hitamo Akarere ubarizwamo" character varying(255),
    "HC" character varying(255),
    "Urwego ukoreraho" character varying(255),
    "Imyaka yawe" character varying(255),
    "Imyaka umaze ukora muri iki kigo" character varying(255),
    "Igitsina" character varying(255),
    "Nzi neza kandi numva intego zirambye z’ikigo nderabuzima" character varying(255),
    "Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki" character varying(255),
    "Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger" character varying(255),
    "Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima" character varying(255),
    "Tuvugana bihagije n’ubuyobozi" character varying(255),
    "Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige" character varying(255),
    "Imikorere inoze niyo ishyirwa imbere muri iki kigo" character varying(255),
    "Abandi bantu baha agaciro akazi nkora" character varying(255),
    "Ufitiye impamyabushobozi ibyo ukora" character varying(255),
    "Mpabwa amahirwe yo kwiyungura ubumenyi" character varying(255),
    "Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye" character varying(255),
    "Nasobanuriwe neza ibisabwa mu kazi" character varying(255),
    "Nejejwe n’akazi nkora mu rwego nkoreraho" character varying(255),
    "Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye" character varying(255),
    "Nifitiye icyizere cy’ubushobozi mfite mu kazi" character varying(255),
    "Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata" character varying(255),
    "Numva ndengerewe n’inshingano zanjye" character varying(255),
    "Numva dushyize hamwe muri iki kigo" character varying(255),
    "Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha" character varying(255),
    "Umuyobozi aha abakozi ijambo mu gufata ibyemezo" character varying(255),
    "Aho dukorera no hanze yaho haratekanye" character varying(255),
    "Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima" character varying(255),
    "Mbona ishimwe/agahimbazamusyi kubera imikorere myiza" character varying(255),
    "Nyuzwe n’uburyo duhabwa ikiruhuko/impushya" character varying(255),
    "Ubwishingizi bw’ubuzima mpabwa buranyuze" character varying(255),
    "Umushahara wanjye ujyanye n’inshingano z’akazi kanjye" character varying(255),
    "Ushobora kutubwira ikindi gitekerezo waba ufite cyatuma wishimi" text,
    "Atuma haba umwuka mwiza" character varying(255),
    "Ahora ahari" character varying(255),
    "Ashyiraho uburyo bwo gufatanya" character varying(255),
    "Ashishikariza abakozi guterimbere" character varying(255),
    "Agaragaza intego z'ingenzi zikwiriye gushyirwa imbere" character varying(255),
    "Akora gahunda y'ingamba" character varying(255),
    "Agaragaza kwiyoroshya" character varying(255),
    "Atanga akazi gakwiranye n’ubushobozi bw’umuntu" character varying(255),
    "Atenganyiriza ibihe by’ibyago cyangwa igihombo kugirango abyi" character varying(255),
    "Afite intumbero ndende" character varying(255),
    "Afata ibyemezo bitewe n'intumbero y'ikigo" character varying(255),
    "Ashobora gufata ibyemezo bikaze" character varying(255),
    "Atega amatwi abamugana" character varying(255),
    "Atanga amakuru akwiye" character varying(255),
    "Avuga ibintu bisobanutse" character varying(255),
    "Yumvikana n'abantu" character varying(255),
    "Atanga icyizere" character varying(255),
    "Atera imbaraga abakozi" character varying(255),
    "Atanga amabwiriza n'intumbero ikwiye" character varying(255),
    "Ashishikariza abantu guhanga udushya" character varying(255),
    "Izina ry'ikigo nderabuzima" character varying(50),
    "Nzi neza kandi numva intego zirambye z�ikigo nderabuzima" character varying(50),
    "Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y�iki" character varying(50),
    "Mfitiye icyizere ubuyobozi bw�iki kigo nderabuzima mu gukuger" character varying(128),
    "Ntanga umusanzu mu gutegura igenamigambi ry�ikigo nderabuzima" character varying(64),
    "Tuvugana bihagije n�ubuyobozi" character varying(64),
    "Nzi iterambere ikigo kimaze kugeraho ndetse n�aho kigeze kige" character varying(50),
    "Nzi neza kandi numva intego zirambye z'ikigo nderabuzima" character varying(50),
    "Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y'ikigo" character varying(50),
    "Mfitiye icyizere ubuyobozi bw'iki kigo nderabuzima mu gukugera " character varying(128),
    "Ntanga umusanzu mu gutegura igenamigambi ry'ikigo nderabuzima" character varying(64),
    "Tuvugana bihagije n'ubuyobozi" character varying(64),
    "Nzi iterambere ikigo kimaze kugeraho ndetse n'aho kigeze kigera" character varying(50),
    "Mfitiye icyizere ubuyobozi bw'iki kigo nderabuzima mu gukugera" character varying(50)
);


ALTER TABLE public.staff_satisfaction OWNER TO health_builders;

--
-- Name: stock_management; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.stock_management AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    d.drug_name,
    d.available,
    d.not_expired,
    d.requested,
    d.stock_card_available,
    d.bottom_of_card_filled_for_each_month,
    d.stock_monthly_inventory_available,
    d.quantity_listed_on_stock_card,
    d.quantity_on_shelf,
    d.evidence_of_excess_available,
    d.drug_properly_labeled,
    d.number_of_stock_out_days,
    d.days_with_stock_less_than_threshold
   FROM (((public.qr_codes q
     LEFT JOIN public.stock_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public.stock_management OWNER TO health_builders;

--
-- Name: stock_management_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.stock_management_2 AS
 SELECT sm.survey_id,
    qr.survey_year,
    d.district AS district_name,
    hc.name AS health_facility,
    hc.type AS facility_type,
    sm.drug_name,
        CASE
            WHEN (sm.available = true) THEN 'Yes'::text
            ELSE 'No'::text
        END AS available,
    sm.quantity_listed_on_stock_card,
    sm.quantity_on_shelf,
    sm.number_of_stock_out_days,
    sm.days_with_stock_less_than_threshold
   FROM (((public.stock_managements sm
     LEFT JOIN public.qr_codes qr ON ((sm.survey_id = qr.id)))
     LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)));


ALTER VIEW public.stock_management_2 OWNER TO health_builders;

--
-- Name: stock_management_3_days_out_stock; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.stock_management_3_days_out_stock AS
 SELECT sm2.district_name,
    sm2.health_facility,
    (TRIM(BOTH FROM split_part((sm2.survey_year)::text, '-'::text, 2)))::integer AS survey_year,
    sm2.survey_id,
    sm2.drug_name,
    sm2.number_of_stock_out_days,
    365 AS total_days,
    round((((sm2.number_of_stock_out_days)::numeric / (365)::numeric) * (100)::numeric), 2) AS proportion_stockout_per_drug_pct,
    round(((sum(sm2.number_of_stock_out_days) OVER (PARTITION BY sm2.health_facility, sm2.survey_year) / ((365 * count(sm2.drug_name) OVER (PARTITION BY sm2.health_facility, sm2.survey_year)))::numeric) * (100)::numeric), 2) AS proportion_stockout_general_pct
   FROM public.stock_management_2 sm2;


ALTER VIEW public.stock_management_3_days_out_stock OWNER TO health_builders;

--
-- Name: stock_managements_copy1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.stock_managements_copy1 (
    id uuid NOT NULL,
    survey_id uuid,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp(6) without time zone,
    deleted_at timestamp(6) with time zone,
    drug_name text,
    available boolean,
    not_expired boolean,
    requested boolean,
    stock_card_available boolean,
    bottom_of_card_filled_for_each_month boolean,
    stock_monthly_inventory_available boolean,
    quantity_listed_on_stock_card bigint,
    quantity_on_shelf bigint,
    evidence_of_excess_available boolean,
    drug_properly_labeled boolean,
    number_of_stock_out_days bigint,
    days_with_stock_less_than_threshold bigint,
    last_synced_at timestamp(6) with time zone
);


ALTER TABLE public.stock_managements_copy1 OWNER TO health_builders;

--
-- Name: stock_out_proportion; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.stock_out_proportion AS
 SELECT sm2.district_name,
    sm2.health_facility,
    sm2.survey_year,
    sm2.survey_id,
    sm2.drug_name,
    sm2.number_of_stock_out_days,
    365 AS total_days,
    ((sm2.number_of_stock_out_days)::numeric / (365)::numeric) AS proportion_stockout_per_drug,
    (sum(sm2.number_of_stock_out_days) OVER (PARTITION BY sm2.health_facility, sm2.survey_year) / ((365 * count(sm2.drug_name) OVER (PARTITION BY sm2.health_facility, sm2.survey_year)))::numeric) AS proportion_stockout_general
   FROM public.stock_management_2 sm2;


ALTER VIEW public.stock_out_proportion OWNER TO health_builders;

--
-- Name: temp_stock_values; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.temp_stock_values (
    health_center character varying(255),
    opening_stock_value numeric(15,2)
);


ALTER TABLE public.temp_stock_values OWNER TO health_builders;

--
-- Name: toilets_1; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.toilets_1 (
    survey_id uuid NOT NULL,
    is_synced boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid NOT NULL,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    directions boolean,
    area_well_maintained boolean,
    supplies_located_in_each_hygiene_facility boolean,
    hand_hygiene_procedures_based_on_current_evidence boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.toilets_1 OWNER TO health_builders;

--
-- Name: treatment_guidelines_duplicates_backup; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.treatment_guidelines_duplicates_backup (
    id uuid,
    survey_id uuid,
    is_synced boolean,
    created_at timestamp without time zone,
    created_by uuid,
    updated_by text,
    updated_at timestamp without time zone,
    deleted_at timestamp with time zone,
    treatment_guideline text,
    available boolean,
    up_to_date boolean,
    service_informed boolean,
    last_synced_at timestamp with time zone
);


ALTER TABLE public.treatment_guidelines_duplicates_backup OWNER TO health_builders;

--
-- Name: v_HB_project_questions; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HB_project_questions" AS
 SELECT projects.name AS project_name,
    project_questions.question,
    project_question_categories.category
   FROM ((((public.projects
     JOIN public.project_questions_maps ON ((project_questions_maps.project_id = projects.id)))
     JOIN public.project_questions ON ((project_questions.id = project_questions_maps.question_id)))
     JOIN public.question_categories_maps ON ((question_categories_maps.question_id = project_questions.id)))
     JOIN public.project_question_categories ON ((project_question_categories.id = question_categories_maps.category_id)));


ALTER VIEW public."v_HB_project_questions" OWNER TO health_builders;

--
-- Name: v_HTN_cases_well managed_patient; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HTN_cases_well managed_patient" AS
 SELECT h.survey_id,
    h.survey_year,
    h.district AS district_name,
    h.health_facility,
    h.facility_type,
    count(h.survey_id) AS numberofsample,
    count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS weight_checked_count,
    count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS bp_checked_count,
    count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS eye_checked_count,
    count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END) AS proteinuria_checked_count,
    count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS creatinine_checked_count,
    count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END) AS correct_treatment_count,
    round(((100.0 * (count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.weight_checked_each_visit), 0))::numeric), 2) AS weight_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.bp_checked_each_visit), 0))::numeric), 2) AS bp_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.eye_checked_last12_months), 0))::numeric), 2) AS eye_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.proteinuria_checked_last6_months), 0))::numeric), 2) AS proteinuria_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.creatinine_checked_last12_months), 0))::numeric), 2) AS creatinine_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.correct_treatment_provided), 0))::numeric), 2) AS correct_treatment_pct,
    ((((count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)))::numeric + (count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) AS score,
    ((((count(h.weight_checked_each_visit) + count(h.bp_checked_each_visit)) + count(h.proteinuria_checked_last6_months)))::numeric + (count(h.creatinine_checked_last12_months))::numeric) AS expected,
    round(((100.0 * ((((count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)))::numeric) / NULLIF(((((count(h.weight_checked_each_visit) + count(h.bp_checked_each_visit)) + count(h.proteinuria_checked_last6_months)) + count(h.creatinine_checked_last12_months)))::numeric, (0)::numeric)), 2) AS percentage_patient,
    h.patient_id
   FROM public.merged_hypertension_treatment_guidelines h
  GROUP BY h.district, h.health_facility, h.facility_type, h.survey_id, h.survey_year, h.patient_id;


ALTER VIEW public."v_HTN_cases_well managed_patient" OWNER TO health_builders;

--
-- Name: v_HTN_treatmentOutcome; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HTN_treatmentOutcome" AS
 SELECT merged_hypertension_treatment_outcomes_new.survey_id,
    merged_hypertension_treatment_outcomes_new.survey_year,
    merged_hypertension_treatment_outcomes_new.district AS district_name,
    merged_hypertension_treatment_outcomes_new.health_facility,
    merged_hypertension_treatment_outcomes_new.facility_type,
    merged_hypertension_treatment_outcomes_new.patient_id,
    merged_hypertension_treatment_outcomes_new.initial_value,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.initial_value, '/'::text, 1), ''::text))::numeric AS initial_systolic,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.initial_value, '/'::text, 2), ''::text))::numeric AS initial_diastolic,
        CASE
            WHEN ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.initial_value, '/'::text, 1), ''::text))::numeric < (140)::numeric) THEN 1
            ELSE 0
        END AS initial_systolic_normal,
        CASE
            WHEN ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.initial_value, '/'::text, 2), ''::text))::numeric < (90)::numeric) THEN 1
            ELSE 0
        END AS initial_diastolic_normal,
    merged_hypertension_treatment_outcomes_new.previous_value,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.previous_value, '/'::text, 1), ''::text))::numeric AS previous_systolic,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.previous_value, '/'::text, 2), ''::text))::numeric AS previous_diastolic,
        CASE
            WHEN ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.previous_value, '/'::text, 1), ''::text))::numeric < (140)::numeric) THEN 1
            ELSE 0
        END AS previous_systolic_normal,
        CASE
            WHEN ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.previous_value, '/'::text, 2), ''::text))::numeric < (90)::numeric) THEN 1
            ELSE 0
        END AS previous_diastolic_normal,
    merged_hypertension_treatment_outcomes_new.latest_value,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric AS latest_systolic,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric AS latest_diastolic,
        CASE
            WHEN ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric < (140)::numeric) THEN 1
            ELSE 0
        END AS latest_systolic_normal,
        CASE
            WHEN ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric < (90)::numeric) THEN 1
            ELSE 0
        END AS latest_diastolic_normal,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric AS systolic,
    (NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric AS diastolic,
        CASE
            WHEN ((((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric >= (131)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric <= (139)::numeric)) OR (((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric >= (80)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric <= (89)::numeric))) THEN 1
            ELSE 0
        END AS pre_high_bp,
        CASE
            WHEN ((((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric >= (140)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric <= (159)::numeric)) OR (((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric >= (90)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric <= (99)::numeric))) THEN 1
            ELSE 0
        END AS high_bp_grade_1,
        CASE
            WHEN ((((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric >= (160)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric <= (179)::numeric)) OR (((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric >= (100)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric <= (109)::numeric))) THEN 1
            ELSE 0
        END AS high_bp_grade_2,
        CASE
            WHEN (((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric >= (180)::numeric) OR ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric >= (110)::numeric)) THEN 1
            ELSE 0
        END AS high_bp_grade_3,
        CASE
            WHEN (((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric < (140)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric < (90)::numeric)) THEN 1
            ELSE 0
        END AS controlled,
        CASE
            WHEN (((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 1), ''::text))::numeric < (140)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.latest_value, '/'::text, 2), ''::text))::numeric < (90)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.previous_value, '/'::text, 1), ''::text))::numeric < (140)::numeric) AND ((NULLIF(split_part(merged_hypertension_treatment_outcomes_new.previous_value, '/'::text, 2), ''::text))::numeric < (90)::numeric)) THEN 1
            ELSE 0
        END AS stable,
    merged_hypertension_treatment_outcomes_new.proteinuria,
    merged_hypertension_treatment_outcomes_new.cardiomyopathy
   FROM public.merged_hypertension_treatment_outcomes_new;


ALTER VIEW public."v_HTN_treatmentOutcome" OWNER TO health_builders;

--
-- Name: v_HTN_treatmentOutcome_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HTN_treatmentOutcome_percentage" AS
 SELECT "v_HTN_treatmentOutcome".survey_id,
    "v_HTN_treatmentOutcome".survey_year,
    "v_HTN_treatmentOutcome".district_name,
    "v_HTN_treatmentOutcome".health_facility,
    "v_HTN_treatmentOutcome".facility_type,
    count(*) AS total_patients,
    sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".pre_high_bp = 1) THEN 1
            ELSE 0
        END) AS pre_high_bp_count,
    round(((100.0 * (sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".pre_high_bp = 1) THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 2) AS pre_high_bp_pct,
    sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".high_bp_grade_1 = 1) THEN 1
            ELSE 0
        END) AS high_bp_grade_1_count,
    round(((100.0 * (sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".high_bp_grade_1 = 1) THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 2) AS high_bp_grade_1_pct,
    sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".high_bp_grade_2 = 1) THEN 1
            ELSE 0
        END) AS high_bp_grade_2_count,
    round(((100.0 * (sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".high_bp_grade_2 = 1) THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 2) AS high_bp_grade_2_pct,
    sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".high_bp_grade_3 = 1) THEN 1
            ELSE 0
        END) AS high_bp_grade_3_count,
    round(((100.0 * (sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".high_bp_grade_3 = 1) THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 2) AS high_bp_grade_3_pct,
    sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".stable = 1) THEN 1
            ELSE 0
        END) AS stable_count,
    round(((100.0 * (sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".stable = 1) THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 2) AS stable_pct,
    sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".controlled = 1) THEN 1
            ELSE 0
        END) AS controlled_count,
    round(((100.0 * (sum(
        CASE
            WHEN ("v_HTN_treatmentOutcome".controlled = 1) THEN 1
            ELSE 0
        END))::numeric) / (count(*))::numeric), 2) AS controlled_pct
   FROM public."v_HTN_treatmentOutcome"
  GROUP BY "v_HTN_treatmentOutcome".survey_id, "v_HTN_treatmentOutcome".survey_year, "v_HTN_treatmentOutcome".district_name, "v_HTN_treatmentOutcome".health_facility, "v_HTN_treatmentOutcome".facility_type;


ALTER VIEW public."v_HTN_treatmentOutcome_percentage" OWNER TO health_builders;

--
-- Name: v_HTN_treatmentguidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HTN_treatmentguidelines" AS
 SELECT h.survey_id,
    h.survey_year,
    h.district AS district_name,
    h.health_facility,
    h.facility_type,
    count(h.survey_id) AS numberofsample,
    count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS weight_checked_count,
    count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS bp_checked_count,
    count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS eye_checked_count,
    count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END) AS proteinuria_checked_count,
    count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS creatinine_checked_count,
    count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END) AS correct_treatment_count,
    round(((100.0 * (count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.weight_checked_each_visit), 0))::numeric), 2) AS weight_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.bp_checked_each_visit), 0))::numeric), 2) AS bp_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.eye_checked_last12_months), 0))::numeric), 2) AS eye_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.proteinuria_checked_last6_months), 0))::numeric), 2) AS proteinuria_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.creatinine_checked_last12_months), 0))::numeric), 2) AS creatinine_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.correct_treatment_provided), 0))::numeric), 2) AS correct_treatment_pct,
    ((((count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)))::numeric + (count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) AS score,
    ((((count(h.weight_checked_each_visit) + count(h.bp_checked_each_visit)) + count(h.proteinuria_checked_last6_months)))::numeric + (count(h.creatinine_checked_last12_months))::numeric) AS expected,
    round(((100.0 * ((((count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)))::numeric) / NULLIF(((((count(h.weight_checked_each_visit) + count(h.bp_checked_each_visit)) + count(h.proteinuria_checked_last6_months)) + count(h.creatinine_checked_last12_months)))::numeric, (0)::numeric)), 2) AS percentage
   FROM public.merged_hypertension_treatment_guidelines h
  GROUP BY h.district, h.health_facility, h.facility_type, h.survey_id, h.survey_year;


ALTER VIEW public."v_HTN_treatmentguidelines" OWNER TO health_builders;

--
-- Name: v_HTN_treatmentguidelines_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HTN_treatmentguidelines_2" AS
 SELECT h.survey_id,
    h.survey_year,
    h.district AS district_name,
    h.patient_id,
    h.health_facility,
    h.facility_type,
    count(h.survey_id) AS numberofsample,
    count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS weight_checked_count,
    count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS bp_checked_count,
    count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS eye_checked_count,
    count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END) AS proteinuria_checked_count,
    count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS creatinine_checked_count,
    count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END) AS correct_treatment_count,
    round(((100.0 * (count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.weight_checked_each_visit), 0))::numeric), 2) AS weight_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.bp_checked_each_visit), 0))::numeric), 2) AS bp_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.eye_checked_last12_months), 0))::numeric), 2) AS eye_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.proteinuria_checked_last6_months), 0))::numeric), 2) AS proteinuria_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.creatinine_checked_last12_months), 0))::numeric), 2) AS creatinine_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.correct_treatment_provided), 0))::numeric), 2) AS correct_treatment_pct,
    (((count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)) AS score,
    (((count(h.weight_checked_each_visit) + count(h.bp_checked_each_visit)) + count(h.proteinuria_checked_last6_months)) + count(h.creatinine_checked_last12_months)) AS expected,
    round(((100.0 * ((((count(
        CASE
            WHEN (h.weight_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.proteinuria_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)))::numeric) / NULLIF(((((count(h.weight_checked_each_visit) + count(h.bp_checked_each_visit)) + count(h.proteinuria_checked_last6_months)) + count(h.creatinine_checked_last12_months)))::numeric, (0)::numeric)), 2) AS percentage
   FROM public.merged_hypertension_treatment_guidelines h
  GROUP BY h.district, h.health_facility, h.facility_type, h.survey_id, h.survey_year, h.patient_id;


ALTER VIEW public."v_HTN_treatmentguidelines_2" OWNER TO health_builders;

--
-- Name: v_HTN_treatmentguidelines_3; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_HTN_treatmentguidelines_3" AS
 SELECT "v_HTN_treatmentguidelines_2".survey_year,
    "v_HTN_treatmentguidelines_2".district_name,
    "v_HTN_treatmentguidelines_2".health_facility,
    "v_HTN_treatmentguidelines_2".facility_type,
    count(
        CASE
            WHEN ("v_HTN_treatmentguidelines_2".percentage = (100)::numeric) THEN 1
            ELSE NULL::integer
        END) AS score,
    count("v_HTN_treatmentguidelines_2".percentage) AS numberofsample,
    round((((100)::numeric * (count(
        CASE
            WHEN ("v_HTN_treatmentguidelines_2".percentage = (100)::numeric) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count("v_HTN_treatmentguidelines_2".percentage), 0))::numeric), 2) AS casewellmanaged
   FROM public."v_HTN_treatmentguidelines_2"
  GROUP BY "v_HTN_treatmentguidelines_2".district_name, "v_HTN_treatmentguidelines_2".health_facility, "v_HTN_treatmentguidelines_2".survey_year, "v_HTN_treatmentguidelines_2".facility_type;


ALTER VIEW public."v_HTN_treatmentguidelines_3" OWNER TO health_builders;

--
-- Name: v_IMCI; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_IMCI" AS
 SELECT imci_merged.district AS district_name,
    imci_merged.health_center,
    imci_merged.survey_year,
    imci_merged.condition,
    (imci_merged.assessment_is_complete)::integer AS assessment_is_complete,
    (imci_merged.classification_is_accurate)::integer AS classification_is_accurate,
    (imci_merged.follow_up_appointment_given)::integer AS follow_up_appointment_given,
    (imci_merged.education_given)::integer AS education_given,
    (imci_merged.malaria_test_done)::integer AS malaria_test_done,
    (imci_merged.no_anti_biotic_given)::integer AS no_anti_biotic_given,
    (imci_merged.correct_treatment)::integer AS correct_treatment,
    (imci_merged.ors_given)::integer AS ors_given,
    (imci_merged.zinc_given)::integer AS zinc_given,
    (imci_merged.correct_anti_pyretic_given)::integer AS correct_anti_pyretic_given,
    (imci_merged.correct_anti_malaria_treatment_provided)::integer AS correct_anti_malaria_treatment_provided,
    (imci_merged.correct_anti_biotic_treatment_provided)::integer AS correct_anti_biotic_treatment_provided,
    (imci_merged.correct_treatment_calc)::integer AS correct_treatment_calc,
        CASE
            WHEN ((imci_merged.assessment_is_complete IS NOT NULL) AND (imci_merged.assessment_is_complete = true) AND (imci_merged.classification_is_accurate IS NOT NULL) AND (imci_merged.classification_is_accurate = true) AND (imci_merged.follow_up_appointment_given IS NOT NULL) AND (imci_merged.follow_up_appointment_given = true) AND (imci_merged.education_given IS NOT NULL) AND (imci_merged.education_given = true) AND (imci_merged.correct_treatment_calc IS NOT NULL) AND (imci_merged.correct_treatment_calc = true)) THEN 1
            ELSE 0
        END AS treated_according_protocol,
    ((((((((((COALESCE((imci_merged.assessment_is_complete)::integer, 0) + COALESCE((imci_merged.classification_is_accurate)::integer, 0)) + COALESCE((imci_merged.follow_up_appointment_given)::integer, 0)) + COALESCE((imci_merged.education_given)::integer, 0)) + COALESCE((imci_merged.malaria_test_done)::integer, 0)) + COALESCE((imci_merged.no_anti_biotic_given)::integer, 0)) + COALESCE((imci_merged.ors_given)::integer, 0)) + COALESCE((imci_merged.zinc_given)::integer, 0)) + COALESCE((imci_merged.correct_anti_pyretic_given)::integer, 0)) + COALESCE((imci_merged.correct_anti_malaria_treatment_provided)::integer, 0)) + COALESCE((imci_merged.correct_anti_biotic_treatment_provided)::integer, 0)) AS score,
    ((((((((((
        CASE
            WHEN (imci_merged.assessment_is_complete IS NOT NULL) THEN 1
            ELSE 0
        END +
        CASE
            WHEN (imci_merged.classification_is_accurate IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.follow_up_appointment_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.education_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.malaria_test_done IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.no_anti_biotic_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.ors_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.zinc_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.correct_anti_pyretic_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.correct_anti_malaria_treatment_provided IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.correct_anti_biotic_treatment_provided IS NOT NULL) THEN 1
            ELSE 0
        END) AS total_count,
    round(((100.0 * (((((((((((COALESCE((imci_merged.assessment_is_complete)::integer, 0) + COALESCE((imci_merged.classification_is_accurate)::integer, 0)) + COALESCE((imci_merged.follow_up_appointment_given)::integer, 0)) + COALESCE((imci_merged.education_given)::integer, 0)) + COALESCE((imci_merged.malaria_test_done)::integer, 0)) + COALESCE((imci_merged.no_anti_biotic_given)::integer, 0)) + COALESCE((imci_merged.ors_given)::integer, 0)) + COALESCE((imci_merged.zinc_given)::integer, 0)) + COALESCE((imci_merged.correct_anti_pyretic_given)::integer, 0)) + COALESCE((imci_merged.correct_anti_malaria_treatment_provided)::integer, 0)) + COALESCE((imci_merged.correct_anti_biotic_treatment_provided)::integer, 0)))::numeric) / NULLIF((((((((((((
        CASE
            WHEN (imci_merged.assessment_is_complete IS NOT NULL) THEN 1
            ELSE 0
        END +
        CASE
            WHEN (imci_merged.classification_is_accurate IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.follow_up_appointment_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.education_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.malaria_test_done IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.no_anti_biotic_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.ors_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.zinc_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.correct_anti_pyretic_given IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.correct_anti_malaria_treatment_provided IS NOT NULL) THEN 1
            ELSE 0
        END) +
        CASE
            WHEN (imci_merged.correct_anti_biotic_treatment_provided IS NOT NULL) THEN 1
            ELSE 0
        END))::numeric, (0)::numeric)), 2) AS mgt_percentage,
    users.first_name,
    users.surname
   FROM (public.imci_merged
     JOIN public.users ON ((imci_merged.created_by = users.id)));


ALTER VIEW public."v_IMCI" OWNER TO health_builders;

--
-- Name: v_NCD_screening_high_BP_BS_to_link_to_care; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_NCD_screening_high_BP_BS_to_link_to_care" AS
 SELECT DISTINCT ON ((upper((ncd.health_center)::text)), (upper((ncd.full_name)::text)), (upper((ncd.sex)::text)), (upper((ncd.village)::text))) upper((ncd.health_center)::text) AS health_center,
    upper((ncd.full_name)::text) AS full_name,
    upper((ncd.sex)::text) AS sex,
    upper((ncd.village)::text) AS village,
    ncd.blood_pressure,
    COALESCE((NULLIF(regexp_replace(split_part((ncd.blood_pressure)::text, '/'::text, 1), '\D'::text, ''::text, 'g'::text), ''::text))::numeric, (0)::numeric) AS systolic,
    COALESCE((NULLIF(regexp_replace(split_part((ncd.blood_pressure)::text, '/'::text, 2), '\D'::text, ''::text, 'g'::text), ''::text))::numeric, (0)::numeric) AS diastolic,
    COALESCE((NULLIF(regexp_replace((ncd.blood_sugar)::text, '\D'::text, ''::text, 'g'::text), ''::text))::numeric, (0)::numeric) AS blood_sugar_numeric,
    ncd.bp_category
   FROM public.ncd_community_screening_summary ncd
  WHERE ((ncd.grade_1_total = 1) OR (ncd.grade_2_total = 1) OR (ncd.grade_3_total = 1) OR ((ncd.screened_for_blood_sugar = 1) AND (ncd."blood_sugar_>=126" = 1)))
  ORDER BY (upper((ncd.health_center)::text)), (upper((ncd.full_name)::text)), (upper((ncd.sex)::text)), (upper((ncd.village)::text)), COALESCE((NULLIF(regexp_replace(split_part((ncd.blood_pressure)::text, '/'::text, 1), '\D'::text, ''::text, 'g'::text), ''::text))::numeric, (0)::numeric) DESC, COALESCE((NULLIF(regexp_replace((ncd.blood_sugar)::text, '\D'::text, ''::text, 'g'::text), ''::text))::numeric, (0)::numeric) DESC;


ALTER VIEW public."v_NCD_screening_high_BP_BS_to_link_to_care" OWNER TO health_builders;

--
-- Name: v_NCD_screening_high_BP_BS_to_link_to_care_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_NCD_screening_high_BP_BS_to_link_to_care_copy1" AS
 SELECT DISTINCT ON ((upper((ncd.health_center)::text)), (upper((ncd.village)::text)), (upper((ncd.full_name)::text)), (upper((ncd.sex)::text))) upper((ncd.health_center)::text) AS health_center,
    upper((ncd.full_name)::text) AS full_name,
    upper((ncd.sex)::text) AS sex,
    upper((ncd.village)::text) AS village,
    ncd.blood_pressure,
    ncd.blood_sugar,
    ncd.bp_category
   FROM public.ncd_community_screening_summary ncd
  WHERE ((ncd.grade_1_total = 1) OR (ncd.grade_2_total = 1) OR (ncd.grade_3_total = 1) OR ((ncd.screened_for_blood_sugar = 1) AND (ncd."blood_sugar_>=126" = 1)))
  ORDER BY (upper((ncd.health_center)::text)), (upper((ncd.village)::text)), (upper((ncd.full_name)::text)), (upper((ncd.sex)::text)), ncd.blood_pressure DESC;


ALTER VIEW public."v_NCD_screening_high_BP_BS_to_link_to_care_copy1" OWNER TO health_builders;

--
-- Name: v_cardio_treatment_outcome; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_cardio_treatment_outcome AS
 SELECT cardiomyopathy_treatment_outcomes.created_at,
    cardiomyopathy_treatment_outcomes.nyha_initial_value,
    cardiomyopathy_treatment_outcomes.nyha_latest_month_value,
    cardiomyopathy_treatment_outcomes.nyha_previous_month_value,
    cardiomyopathy_treatment_outcomes.nyha_before_previous_month_value,
    cardiomyopathy_treatment_outcomes.ef_latest_value,
    cardiomyopathy_treatment_outcomes.ef_six_months_ago_value,
    cardiomyopathy_treatment_outcomes.ef_one_year_ago_value,
    qr_codes.survey_year,
    health_centers.name AS "HC",
    districts.district AS district_name
   FROM (((public.cardiomyopathy_treatment_outcomes
     JOIN public.qr_codes ON ((qr_codes.id = cardiomyopathy_treatment_outcomes.survey_id)))
     JOIN public.health_centers ON ((health_centers.id = qr_codes.health_center_id)))
     JOIN public.districts ON (((districts.id = health_centers.district_id) AND (districts.id = qr_codes.district_id))));


ALTER VIEW public.v_cardio_treatment_outcome OWNER TO health_builders;

--
-- Name: v_cardiomyopathy_treatment_guidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_cardiomyopathy_treatment_guidelines AS
 SELECT districts.district AS district_name,
    health_centers.name AS health_center,
    qr_codes.survey_year,
    cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months,
    cardiomyopathy_treatment_guidelines.complete_physical_assessment,
    cardiomyopathy_treatment_guidelines.correct_treatment_provided,
    cardiomyopathy_treatment_guidelines.nutrional_education_provided,
    cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits,
    round(((100.0 * (count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months), 0))::numeric), 2) AS echocardiography_done_last12_months_pct,
    round(((100.0 * (count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.complete_physical_assessment = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(cardiomyopathy_treatment_guidelines.complete_physical_assessment), 0))::numeric), 2) AS complete_physical_assessment_pct,
    round(((100.0 * (count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(cardiomyopathy_treatment_guidelines.correct_treatment_provided), 0))::numeric), 2) AS correct_treatment_provided_pct,
    round(((100.0 * (count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.nutrional_education_provided = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(cardiomyopathy_treatment_guidelines.nutrional_education_provided), 0))::numeric), 2) AS nutrional_education_provided_pct,
    round(((100.0 * (count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits), 0))::numeric), 2) AS serum_electrolytes_on_last_three_visits_pct,
    (((((count(cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months) + count(cardiomyopathy_treatment_guidelines.complete_physical_assessment)) + count(cardiomyopathy_treatment_guidelines.correct_treatment_provided)))::numeric + (count(cardiomyopathy_treatment_guidelines.nutrional_education_provided))::numeric) + (count(cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits))::numeric) AS expected,
    round(((100.0 * (((((count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.complete_physical_assessment = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.nutrional_education_provided = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits = true) THEN 1
            ELSE NULL::integer
        END)))::numeric) / NULLIF((((((count(cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months) + count(cardiomyopathy_treatment_guidelines.complete_physical_assessment)) + count(cardiomyopathy_treatment_guidelines.correct_treatment_provided)) + count(cardiomyopathy_treatment_guidelines.nutrional_education_provided)) + count(cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits)))::numeric, (0)::numeric)), 2) AS percentage,
    cardiomyopathy_treatment_guidelines.id
   FROM (((public.districts
     JOIN public.health_centers ON ((districts.id = health_centers.district_id)))
     JOIN public.qr_codes ON (((districts.id = qr_codes.district_id) AND (health_centers.id = qr_codes.health_center_id))))
     JOIN public.cardiomyopathy_treatment_guidelines ON ((cardiomyopathy_treatment_guidelines.survey_id = qr_codes.id)))
  GROUP BY districts.district, health_centers.name, qr_codes.survey_year, cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months, cardiomyopathy_treatment_guidelines.complete_physical_assessment, cardiomyopathy_treatment_guidelines.correct_treatment_provided, cardiomyopathy_treatment_guidelines.nutrional_education_provided, cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits, cardiomyopathy_treatment_guidelines.id;


ALTER VIEW public.v_cardiomyopathy_treatment_guidelines OWNER TO health_builders;

--
-- Name: v_cardiomyopathy_treatment_guidelines_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_cardiomyopathy_treatment_guidelines_2 AS
 SELECT cardiomyopathy_treatment_guidelines.survey_id,
    qr_codes.survey_year,
    health_centers.name,
    districts.district,
    cardiomyopathy_treatment_guidelines.echocardiography_done_last12_months,
    cardiomyopathy_treatment_guidelines.echocardiography_justification,
    cardiomyopathy_treatment_guidelines.complete_physical_assessment,
    cardiomyopathy_treatment_guidelines.physical_assesment_justification,
    cardiomyopathy_treatment_guidelines.correct_treatment_provided,
    cardiomyopathy_treatment_guidelines.correct_treatment_justification,
    cardiomyopathy_treatment_guidelines.nutrional_education_provided,
    cardiomyopathy_treatment_guidelines.nutrional_education_justification,
    cardiomyopathy_treatment_guidelines.serum_electrolytes_on_last_three_visits,
    cardiomyopathy_treatment_guidelines.serum_electrolytes_justification
   FROM (((public.cardiomyopathy_treatment_guidelines
     JOIN public.qr_codes ON ((qr_codes.id = cardiomyopathy_treatment_guidelines.survey_id)))
     JOIN public.districts ON ((districts.id = qr_codes.district_id)))
     JOIN public.health_centers ON (((health_centers.district_id = districts.id) AND (health_centers.id = qr_codes.health_center_id))));


ALTER VIEW public.v_cardiomyopathy_treatment_guidelines_2 OWNER TO health_builders;

--
-- Name: v_cardiomypathy_Outcome; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_cardiomypathy_Outcome" AS
 SELECT districts.district,
    health_centers.name,
    qr_codes.survey_year,
    cardiomyopathy_treatment_outcomes.nyha_initial_value,
    cardiomyopathy_treatment_outcomes.nyha_latest_month_value,
    cardiomyopathy_treatment_outcomes.nyha_previous_month_value,
    cardiomyopathy_treatment_outcomes.ef_latest_value,
    cardiomyopathy_treatment_outcomes.nyha_before_previous_month_value,
    cardiomyopathy_treatment_outcomes.ef_six_months_ago_value,
    cardiomyopathy_treatment_outcomes.ef_one_year_ago_value
   FROM (((public.cardiomyopathy_treatment_outcomes
     JOIN public.qr_codes ON ((qr_codes.id = cardiomyopathy_treatment_outcomes.survey_id)))
     JOIN public.districts ON ((districts.id = qr_codes.district_id)))
     JOIN public.health_centers ON (((health_centers.district_id = districts.id) AND (health_centers.id = qr_codes.health_center_id))));


ALTER VIEW public."v_cardiomypathy_Outcome" OWNER TO health_builders;

--
-- Name: v_closing_balance_values_new; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_closing_balance_values_new AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district AS district_name,
    hc.name AS health_facility,
    hc.type AS facility_type,
    cb.financial_year,
    cb.bank,
    cb.petty_cash,
    cb.receivables,
    cb.payables_start_of_year,
    cb.payables_end_of_year,
    cb.pharmacy_debt,
    cb.hc_total_revenue,
    cb.hc_income,
    cb.medicine_sales_fmis,
    cb.medicine_sales_invoice,
    cb.hc_total_expenses,
    cb.hr_expenses,
    cb.hc_staff_salary_expenditure,
    cb.purchased_medicine_fmis,
    cb.purchased_medicine_invoice,
    cb.medical_equipment,
    cb.travel,
    cb.actual_budget,
    cb.planned_budget
   FROM (((public.qr_codes q
     LEFT JOIN public.new_closing_balances cb ON ((q.id = cb.survey_id)))
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)));


ALTER VIEW public.v_closing_balance_values_new OWNER TO health_builders;

--
-- Name: v_data_accuracies; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_data_accuracies AS
 SELECT qr_codes.survey_year,
    data_accuracies.survey_id,
    districts.district AS district_name,
    health_centers.name,
    qr_codes.health_center,
    data_accuracies.source,
    data_accuracies.patient_file,
    data_accuracies.register,
    data_accuracies.lab_register,
    data_accuracies.tally_sheet,
    data_accuracies.pharmacy,
    data_accuracies.hmis_report,
    data_accuracies.hmis_database,
    data_accuracies.accurate
   FROM (((public.health_centers
     JOIN public.qr_codes ON ((health_centers.id = qr_codes.health_center_id)))
     JOIN public.data_accuracies ON ((data_accuracies.survey_id = qr_codes.id)))
     JOIN public.districts ON (((health_centers.district_id = districts.id) AND (qr_codes.district_id = districts.id))));


ALTER VIEW public.v_data_accuracies OWNER TO health_builders;

--
-- Name: v_diabetes_controlled; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_diabetes_controlled AS
 SELECT merged_diabetes_treatment_outcomes_new.survey_year,
    merged_diabetes_treatment_outcomes_new.district AS district_name,
    merged_diabetes_treatment_outcomes_new.health_facility,
    merged_diabetes_treatment_outcomes_new.facility_type,
    merged_diabetes_treatment_outcomes_new.patient_id,
    merged_diabetes_treatment_outcomes_new.glycemia_initial,
    merged_diabetes_treatment_outcomes_new.glycemia_previous,
    merged_diabetes_treatment_outcomes_new.glycemia_latest,
        CASE
            WHEN ((merged_diabetes_treatment_outcomes_new.glycemia_initial IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_previous IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_latest IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_initial <= (180)::numeric) AND (merged_diabetes_treatment_outcomes_new.glycemia_previous <= (180)::numeric) AND (merged_diabetes_treatment_outcomes_new.glycemia_latest <= (180)::numeric)) THEN 1
            ELSE 0
        END AS controlled
   FROM public.merged_diabetes_treatment_outcomes_new
  WHERE ((merged_diabetes_treatment_outcomes_new.glycemia_initial IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_previous IS NOT NULL) AND (merged_diabetes_treatment_outcomes_new.glycemia_latest IS NOT NULL));


ALTER VIEW public.v_diabetes_controlled OWNER TO health_builders;

--
-- Name: v_diabetes_controlled_hba1c; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_diabetes_controlled_hba1c AS
 SELECT d_hba1c.survey_year,
    d_hba1c.district AS district_name,
    d_hba1c.health_facility,
    d_hba1c.facility_type,
    d_hba1c.patient_id,
    d_hba1c.before_previous_quarter_value,
    d_hba1c.previous_quarter_value,
        CASE
            WHEN ((d_hba1c.before_previous_quarter_value IS NOT NULL) AND (d_hba1c.previous_quarter_value IS NOT NULL) AND (d_hba1c.previous_quarter_value < 6.5)) THEN 1
            ELSE 0
        END AS controlled_hba1c
   FROM public.merged_diabetes_treatment_outcomes_hba1c d_hba1c
  WHERE (d_hba1c.previous_quarter_value IS NOT NULL);


ALTER VIEW public.v_diabetes_controlled_hba1c OWNER TO health_builders;

--
-- Name: v_diabetes_treatmentguidelines; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_diabetes_treatmentguidelines AS
 SELECT h.survey_id,
    h.survey_year,
    h.district AS district_name,
    h.patient_id,
    h.health_facility,
    h.facility_type,
    count(h.survey_id) AS numberofsample,
    count(
        CASE
            WHEN (h.hbalc_checked = true) THEN 1
            ELSE NULL::integer
        END) AS hbalc_checked_count,
    count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) AS bp_checked_count,
    count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS eye_checked__last12_months_count,
    count(
        CASE
            WHEN (h.foot_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS foot_checked__last12_months_count,
    count(
        CASE
            WHEN (h.urine_protein_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END) AS urine_protein_checked_last6_months_count,
    count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END) AS creatinine_checked_last12_months_count,
    count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END) AS correct_treatment_provided_count,
    round(((100.0 * (count(
        CASE
            WHEN (h.hbalc_checked = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.hbalc_checked), 0))::numeric), 2) AS hbalc_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.bp_checked_each_visit), 0))::numeric), 2) AS bp_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.eye_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.eye_checked_last12_months), 0))::numeric), 2) AS eye_checked_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.foot_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.foot_checked_last12_months), 0))::numeric), 2) AS foot_checked_last12_months_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.urine_protein_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.urine_protein_checked_last6_months), 0))::numeric), 2) AS urine_protein_checked_last6_months_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.creatinine_checked_last12_months), 0))::numeric), 2) AS creatinine_checked_last12_months_pct,
    round(((100.0 * (count(
        CASE
            WHEN (h.correct_treatment_provided = true) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(h.correct_treatment_provided), 0))::numeric), 2) AS correct_treatment_pct,
    (((count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.foot_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.urine_protein_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)) AS score,
    (((count(h.bp_checked_each_visit) + count(h.foot_checked_last12_months)) + count(h.urine_protein_checked_last6_months)) + count(h.creatinine_checked_last12_months)) AS expected,
    round(((100.0 * ((((count(
        CASE
            WHEN (h.bp_checked_each_visit = true) THEN 1
            ELSE NULL::integer
        END) + count(
        CASE
            WHEN (h.foot_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.urine_protein_checked_last6_months = true) THEN 1
            ELSE NULL::integer
        END)) + count(
        CASE
            WHEN (h.creatinine_checked_last12_months = true) THEN 1
            ELSE NULL::integer
        END)))::numeric) / NULLIF(((((count(h.bp_checked_each_visit) + count(h.foot_checked_last12_months)) + count(h.urine_protein_checked_last6_months)) + count(h.creatinine_checked_last12_months)))::numeric, (0)::numeric)), 2) AS percentage
   FROM public.merged_diabetes_treatment_guidelines h
  GROUP BY h.district, h.health_facility, h.facility_type, h.survey_id, h.survey_year, h.patient_id;


ALTER VIEW public.v_diabetes_treatmentguidelines OWNER TO health_builders;

--
-- Name: v_diabetes_treatmentguidelines_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_diabetes_treatmentguidelines_2 AS
 SELECT v_diabetes_treatmentguidelines.survey_year,
    v_diabetes_treatmentguidelines.district_name,
    v_diabetes_treatmentguidelines.health_facility,
    v_diabetes_treatmentguidelines.facility_type,
    count(
        CASE
            WHEN (v_diabetes_treatmentguidelines.percentage = (100)::numeric) THEN 1
            ELSE NULL::integer
        END) AS score,
    count(v_diabetes_treatmentguidelines.percentage) AS numberofsample,
    round((((100)::numeric * (count(
        CASE
            WHEN (v_diabetes_treatmentguidelines.percentage = (100)::numeric) THEN 1
            ELSE NULL::integer
        END))::numeric) / (NULLIF(count(v_diabetes_treatmentguidelines.percentage), 0))::numeric), 2) AS casewellmanaged
   FROM public.v_diabetes_treatmentguidelines
  GROUP BY v_diabetes_treatmentguidelines.district_name, v_diabetes_treatmentguidelines.health_facility, v_diabetes_treatmentguidelines.survey_year, v_diabetes_treatmentguidelines.facility_type;


ALTER VIEW public.v_diabetes_treatmentguidelines_2 OWNER TO health_builders;

--
-- Name: v_dispensing_mgt; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_dispensing_mgt AS
 SELECT qr_codes.survey_year,
    districts.district,
    health_centers.name,
    dispensary_managements.drug_name,
    dispensary_managements.not_expired,
    dispensary_managements.request_form_signed_and_stamped,
    dispensary_managements.consumption_register_up_to_date,
    dispensary_managements.tally_sheets_used_throughout_the_day,
    dispensary_managements.tally_sheets_match_consumption_register,
    dispensary_managements.consumption_register_totalled
   FROM (((public.districts
     JOIN public.health_centers ON ((districts.id = health_centers.district_id)))
     JOIN public.qr_codes ON (((districts.id = qr_codes.district_id) AND (health_centers.id = qr_codes.health_center_id))))
     JOIN public.dispensary_managements ON ((dispensary_managements.survey_id = qr_codes.id)));


ALTER VIEW public.v_dispensing_mgt OWNER TO health_builders;

--
-- Name: v_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE (((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true)))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), available_drugs_count AS (
         SELECT hc.id AS health_center_id,
            qr.survey_year,
            count(DISTINCT
                CASE
                    WHEN (sm.available = true) THEN
                    CASE
                        WHEN (sm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                        ELSE sm.drug_name
                    END
                    ELSE NULL::text
                END) AS drugs_available
           FROM ((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.stock_managements sm ON ((sm.survey_id = qr.id)))
          WHERE ((sm.deleted_at IS NULL) AND (qr.deleted_at IS NULL))
          GROUP BY hc.id, qr.survey_year
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.district_name,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.v_drug_availability_percentage OWNER TO health_builders;

--
-- Name: v_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_drug_availability_by_district AS
 SELECT v_drug_availability_percentage.district_name,
    count(DISTINCT v_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(v_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(v_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(v_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(v_drug_availability_percentage.drugs_available) / sum(v_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.v_drug_availability_percentage
  GROUP BY v_drug_availability_percentage.district_name
  ORDER BY v_drug_availability_percentage.district_name;


ALTER VIEW public.v_drug_availability_by_district OWNER TO health_builders;

--
-- Name: v_finance; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_finance AS
 SELECT districts.district AS ditrict_name,
    health_centers.name AS "Health_facility",
    qr_codes.survey_year,
    new_closing_balances.survey_id,
    new_closing_balances.financial_year,
    new_closing_balances.bank,
    new_closing_balances.petty_cash,
    new_closing_balances.receivables,
    new_closing_balances.payables_start_of_year,
    new_closing_balances.payables_end_of_year,
    new_closing_balances.pharmacy_debt,
    new_closing_balances.hc_income,
    new_closing_balances.medicine_sales_fmis,
    new_closing_balances.medicine_sales_invoice,
    new_closing_balances.hr_expenses,
    new_closing_balances.hc_staff_salary_expenditure,
    new_closing_balances.purchased_medicine_fmis,
    new_closing_balances.purchased_medicine_invoice,
    new_closing_balances.medical_equipment,
    new_closing_balances.travel,
    new_closing_balances.actual_budget,
    new_closing_balances.planned_budget,
    new_closing_balances.hc_total_revenue,
    new_closing_balances.hc_total_expenses,
    round(((100.0 * (new_closing_balances.hc_total_revenue - new_closing_balances.hc_total_expenses)) / new_closing_balances.hc_total_revenue)) AS net_profit_margin,
    round((100.0 * (new_closing_balances.hr_expenses / new_closing_balances.hc_total_expenses))) AS hr_expenses_proportion,
        CASE
            WHEN ((new_closing_balances.payables_start_of_year IS NOT NULL) AND (new_closing_balances.payables_end_of_year IS NOT NULL) AND (new_closing_balances.payables_start_of_year <> (0)::numeric)) THEN round(((100.0 * (new_closing_balances.payables_end_of_year - new_closing_balances.payables_start_of_year)) / new_closing_balances.payables_start_of_year))
            ELSE NULL::numeric
        END AS payables_growth_rate,
        CASE
            WHEN ((new_closing_balances.purchased_medicine_fmis IS NOT NULL) AND (new_closing_balances.purchased_medicine_invoice IS NOT NULL) AND (new_closing_balances.purchased_medicine_invoice <> (0)::numeric)) THEN round(((100.0 * (new_closing_balances.purchased_medicine_invoice - new_closing_balances.purchased_medicine_fmis)) / new_closing_balances.purchased_medicine_invoice))
            ELSE NULL::numeric
        END AS purchase_drugs_report_discrepency,
        CASE
            WHEN ((new_closing_balances.medicine_sales_fmis IS NOT NULL) AND (new_closing_balances.medicine_sales_invoice IS NOT NULL) AND (new_closing_balances.medicine_sales_invoice <> (0)::numeric)) THEN round(((100.0 * (new_closing_balances.medicine_sales_invoice - new_closing_balances.medicine_sales_fmis)) / new_closing_balances.medicine_sales_invoice))
            ELSE NULL::numeric
        END AS sale_drugs_report_discrepency,
        CASE
            WHEN ((new_closing_balances.purchased_medicine_invoice IS NOT NULL) AND (new_closing_balances.purchased_medicine_invoice <> (0)::numeric) AND (new_closing_balances.medicine_sales_invoice IS NOT NULL) AND (new_closing_balances.medicine_sales_invoice <> (0)::numeric) AND (round(((100.0 * (new_closing_balances.purchased_medicine_invoice - new_closing_balances.purchased_medicine_fmis)) / new_closing_balances.purchased_medicine_invoice)) = (0)::numeric) AND (round(((100.0 * (new_closing_balances.medicine_sales_invoice - new_closing_balances.medicine_sales_fmis)) / new_closing_balances.medicine_sales_invoice)) = (0)::numeric)) THEN 1
            ELSE 0
        END AS drugs_reporting_accuracy
   FROM (((public.districts
     JOIN public.health_centers ON ((districts.id = health_centers.district_id)))
     JOIN public.qr_codes ON (((districts.id = qr_codes.district_id) AND (health_centers.id = qr_codes.health_center_id))))
     JOIN public.new_closing_balances ON ((qr_codes.id = new_closing_balances.survey_id)))
  WHERE ((qr_codes.survey_year)::text = '2023-2024'::text);


ALTER VIEW public.v_finance OWNER TO health_builders;

--
-- Name: v_finance_2_income_review; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_finance_2_income_review AS
 SELECT districts.district AS district_name,
    health_centers.name AS health_facility,
    qr_codes.survey_year,
    income_reviews.survey_id,
    count(DISTINCT income_reviews.survey_id) AS total_surveys,
    min(income_reviews.date) AS first_trans_date,
    max(income_reviews.date) AS last_trans_date,
    sum(income_reviews.receipt_book_daily_total_income) AS total_receipt_income,
    sum(income_reviews.jornal_dail_total_income) AS total_journal_income,
    round(((100.0 * (sum(income_reviews.receipt_book_daily_total_income) - sum(income_reviews.jornal_dail_total_income))) / NULLIF(sum(income_reviews.receipt_book_daily_total_income), (0)::numeric)), 2) AS income_discrepancy_percentage
   FROM (((public.health_centers
     JOIN public.districts ON ((health_centers.district_id = districts.id)))
     JOIN public.qr_codes ON (((districts.id = qr_codes.district_id) AND (health_centers.id = qr_codes.health_center_id))))
     JOIN public.income_reviews ON ((income_reviews.survey_id = qr_codes.id)))
  WHERE ((income_reviews.receipt_book_daily_total_income IS NOT NULL) AND (income_reviews.jornal_dail_total_income IS NOT NULL) AND ((qr_codes.survey_year)::text = '2023-2024'::text))
  GROUP BY districts.district, health_centers.name, income_reviews.survey_id, qr_codes.survey_year
  ORDER BY districts.district, health_centers.name, income_reviews.survey_id;


ALTER VIEW public.v_finance_2_income_review OWNER TO health_builders;

--
-- Name: v_hb_projects_data; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_hb_projects_data AS
SELECT
    NULL::text AS project_name,
    NULL::text AS description,
    NULL::bigint AS status_id,
    NULL::text AS district_name,
    NULL::text AS health_center_name,
    NULL::character varying(4) AS year,
    NULL::character varying(20) AS month,
    NULL::date AS start_date,
    NULL::date AS end_date,
    NULL::double precision AS end_date_month,
    NULL::double precision AS record_year,
    NULL::double precision AS record_month,
    NULL::text AS question_id,
    NULL::text AS question,
    NULL::text AS category,
    NULL::numeric AS response,
    NULL::text AS created_by;


ALTER VIEW public.v_hb_projects_data OWNER TO health_builders;

--
-- Name: v_hb_projects_data_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_hb_projects_data_2 AS
 SELECT p.name AS project_name,
    p.description,
    d.district AS district_name,
    hc.name AS health_center_name,
    pd.year,
    pd.month,
    date_part('year'::text, pd.created_at) AS record_year,
    date_part('month'::text, pd.created_at) AS record_month,
    pq.question,
    pqc.category,
        CASE
            WHEN (pd.answer ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (pd.answer)::numeric
            ELSE NULL::numeric
        END AS response,
    u.first_name AS created_by
   FROM ((((((public.project_data pd
     LEFT JOIN public.projects p ON ((pd.project_id = p.id)))
     LEFT JOIN public.project_questions pq ON ((pd.question_id = pq.id)))
     LEFT JOIN public.project_question_categories pqc ON ((pd.category_id = pqc.id)))
     LEFT JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     LEFT JOIN public.districts d ON ((hc.district_id = d.id)))
     LEFT JOIN public.users u ON ((pd.created_by = u.id)));


ALTER VIEW public.v_hb_projects_data_2 OWNER TO health_builders;

--
-- Name: v_hb_projects_data_HC_Performance_feedback; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_hb_projects_data_HC_Performance_feedback" AS
 SELECT p.name AS project_name,
    p.description,
    d.district AS district_name,
    hc.name AS health_center_name,
    pd.year,
    pd.month,
    pq.question,
    TRIM(BOTH FROM split_part(replace(replace(pq.question, '–'::text, '-'::text), '—'::text, '-'::text), '-'::text, 1)) AS evaluation_area,
    pqc.category,
        CASE
            WHEN (pd.answer ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN ((pd.answer)::numeric)::text
            ELSE pd.answer
        END AS response,
    u.first_name AS created_by
   FROM ((((((public.project_data pd
     LEFT JOIN public.projects p ON ((pd.project_id = p.id)))
     LEFT JOIN public.project_questions pq ON ((pd.question_id = pq.id)))
     LEFT JOIN public.project_question_categories pqc ON ((pd.category_id = pqc.id)))
     LEFT JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     LEFT JOIN public.districts d ON ((hc.district_id = d.id)))
     LEFT JOIN public.users u ON ((pd.created_by = u.id)))
  WHERE (p.id = '1356c3cc-f5a0-4445-aaa9-5eb34486e17d'::text);


ALTER VIEW public."v_hb_projects_data_HC_Performance_feedback" OWNER TO health_builders;

--
-- Name: v_hb_projects_data_HMS; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_hb_projects_data_HMS" AS
SELECT
    NULL::text AS project_name,
    NULL::text AS description,
    NULL::bigint AS status_id,
    NULL::text AS district_name,
    NULL::text AS health_center_name,
    NULL::character varying(4) AS year,
    NULL::character varying(20) AS month,
    NULL::date AS start_date,
    NULL::date AS end_date,
    NULL::double precision AS end_date_month,
    NULL::double precision AS record_year,
    NULL::double precision AS record_month,
    NULL::text AS question_id,
    NULL::text AS question,
    NULL::text AS category,
    NULL::numeric AS response,
    NULL::text AS created_by;


ALTER VIEW public."v_hb_projects_data_HMS" OWNER TO health_builders;

--
-- Name: v_hb_projects_data_two; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_hb_projects_data_two AS
 SELECT p.name AS project_name,
    p.description,
    d.district AS district_name,
    hc.name AS health_center_name,
    pd.year,
    pd.month,
    pq.question,
    pqc.category,
        CASE
            WHEN (pd.answer ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN ((pd.answer)::numeric)::text
            ELSE pd.answer
        END AS response,
    u.first_name AS created_by
   FROM ((((((public.project_data pd
     LEFT JOIN public.projects p ON ((pd.project_id = p.id)))
     LEFT JOIN public.project_questions pq ON ((pd.question_id = pq.id)))
     LEFT JOIN public.project_question_categories pqc ON ((pd.category_id = pqc.id)))
     LEFT JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     LEFT JOIN public.districts d ON ((hc.district_id = d.id)))
     LEFT JOIN public.users u ON ((pd.created_by = u.id)));


ALTER VIEW public.v_hb_projects_data_two OWNER TO health_builders;

--
-- Name: v_patient_satisfaction; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_patient_satisfaction AS
SELECT
    NULL::uuid AS "Patient_id",
    NULL::uuid AS survey_id,
    NULL::character varying(255) AS survey_year,
    NULL::text AS health_facility,
    NULL::text AS facility_type,
    NULL::text AS district_name,
    NULL::timestamp without time zone AS created_at,
    NULL::character varying(255) AS "Service",
    NULL::character varying(255) AS "Gender",
    NULL::character varying(255) AS "Age",
    NULL::character varying(255) AS "Education_level",
    NULL::integer AS good_score_count,
    NULL::integer AS total_answers,
    NULL::bigint AS opinions_about_quality_of_service,
    NULL::bigint AS knowledge_on_rights_and_responsibilities,
    NULL::bigint AS privacy_and_confidentiality_respected,
    NULL::bigint AS payment_process_satisfaction,
    NULL::bigint AS water_facilitation_on_firt_dose,
    NULL::bigint AS facility_hygiene_satisfaction,
    NULL::bigint AS likely_to_recommend_relatives_to_the_facility,
    NULL::bigint AS overral_satisfaction_for_delivered_services,
    NULL::bigint AS cashier_respect_satisfaction,
    NULL::bigint AS treating_nurse_respect_satisfaction,
    NULL::bigint AS lab_technician_respect_satisfaction,
    NULL::bigint AS dispensing_nurse_respect_satisfaction,
    NULL::bigint AS medical_insurance_agent_respect_satisfaction,
    NULL::bigint AS medical_courtesy_satisfaction,
    NULL::bigint AS facility_safety_satisfaction,
    NULL::bigint AS medical_attention_satisfaction,
    NULL::bigint AS health_status_explanation_satisfaction,
    NULL::bigint AS lab_results_explanation_satisfaction,
    NULL::bigint AS medicine_use_explanation_satisfaction,
    NULL::bigint AS next_given_appointment_satisfaction,
    NULL::bigint AS orientation_satisfaction,
    NULL::bigint AS health_education_satisfaction,
    NULL::bigint AS customer_care_satisfaction,
    NULL::bigint AS reception_waiting_time,
    NULL::bigint AS cashier_waiting_time,
    NULL::bigint AS consultation_wiating_area_waiting_time,
    NULL::bigint AS laboratory_waiting_time,
    NULL::bigint AS laboratory_results_waiting_time,
    NULL::bigint AS billing_station_waiting_time,
    NULL::bigint AS info_about_delays_satisfaction,
    NULL::bigint AS pharmacy_waiting_time,
    NULL::bigint AS communicated_language_satisfaction,
    NULL::bigint AS differentiates_staff,
    NULL::bigint AS department_signages_helpful,
    NULL::text AS suggestion,
    NULL::numeric AS good_score_percentage;


ALTER VIEW public.v_patient_satisfaction OWNER TO health_builders;

--
-- Name: v_pharmacy_dispensing_2026; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_pharmacy_dispensing_2026 AS
 SELECT districts.district AS district_name,
    health_centers.name AS "HC_name",
    qr_code_types.name AS "Qr_code_type",
    qr_codes.survey_year,
    dispensary_managements.survey_id,
    dispensary_managements.drug_name,
        CASE
            WHEN (dispensary_managements.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
            WHEN (dispensary_managements.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
            WHEN (dispensary_managements.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
            WHEN (dispensary_managements.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
            WHEN (dispensary_managements.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
            ELSE dispensary_managements.drug_name
        END AS drug_group_name,
    dispensary_managements.available,
    dispensary_managements.not_expired
   FROM ((((public.dispensary_managements
     JOIN public.qr_codes ON ((qr_codes.id = dispensary_managements.survey_id)))
     JOIN public.qr_code_types ON ((qr_code_types.id = qr_codes.type_id)))
     JOIN public.health_centers ON ((health_centers.id = qr_codes.health_center_id)))
     JOIN public.districts ON (((districts.id = health_centers.district_id) AND (districts.id = qr_codes.district_id))));


ALTER VIEW public.v_pharmacy_dispensing_2026 OWNER TO health_builders;

--
-- Name: v_pharmacy_stock_2026; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_pharmacy_stock_2026 AS
 SELECT districts.district AS district_name,
    health_centers.name AS "HC_name",
    qr_code_types.name AS "Qr_code_type",
    qr_codes.survey_year,
    stock_managements.survey_id,
    stock_managements.drug_name,
        CASE
            WHEN (stock_managements.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
            WHEN (stock_managements.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
            WHEN (stock_managements.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
            WHEN (stock_managements.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
            WHEN (stock_managements.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
            ELSE stock_managements.drug_name
        END AS drug_group_name,
    stock_managements.available,
    stock_managements.not_expired,
    stock_managements.requested,
    stock_managements.stock_card_available,
    stock_managements.bottom_of_card_filled_for_each_month,
    stock_managements.stock_monthly_inventory_available,
    stock_managements.quantity_listed_on_stock_card,
    stock_managements.quantity_on_shelf,
    stock_managements.evidence_of_excess_available,
    stock_managements.drug_properly_labeled,
    stock_managements.number_of_stock_out_days,
    stock_managements.days_with_stock_less_than_threshold
   FROM ((((public.stock_managements
     JOIN public.qr_codes ON ((qr_codes.id = stock_managements.survey_id)))
     JOIN public.qr_code_types ON ((qr_code_types.id = qr_codes.type_id)))
     JOIN public.health_centers ON ((health_centers.id = qr_codes.health_center_id)))
     JOIN public.districts ON (((districts.id = health_centers.district_id) AND (districts.id = qr_codes.district_id))));


ALTER VIEW public.v_pharmacy_stock_2026 OWNER TO health_builders;

--
-- Name: v_pharmacy_stock_values; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_pharmacy_stock_values AS
 SELECT DISTINCT districts.district AS district_name,
    health_centers.name AS "Health_facility",
    qr_codes.survey_year,
    new_pharmacy_stock_values.survey_id,
    new_pharmacy_stock_values.cost_of_expired_medicine,
    new_pharmacy_stock_values.opening_pharmacy_stock_value,
    new_pharmacy_stock_values.closing_pharmacy_stock_value,
    new_pharmacy_stock_values.review_year
   FROM (((public.qr_codes
     JOIN public.health_centers ON ((qr_codes.health_center_id = health_centers.id)))
     JOIN public.districts ON (((health_centers.district_id = districts.id) AND (qr_codes.district_id = districts.id))))
     JOIN public.new_pharmacy_stock_values ON ((qr_codes.id = new_pharmacy_stock_values.survey_id)));


ALTER VIEW public.v_pharmacy_stock_values OWNER TO health_builders;

--
-- Name: v_satety_management; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_satety_management AS
 SELECT safety_managements.survey_id,
    qr_codes.survey_year,
    districts.district AS district_name,
    health_centers.name,
    health_centers.type,
    safety_managements.dedicated_as_rhspace_available
   FROM (((public.safety_managements
     JOIN public.qr_codes ON ((safety_managements.survey_id = qr_codes.id)))
     JOIN public.health_centers ON ((qr_codes.health_center_id = health_centers.id)))
     JOIN public.districts ON (((health_centers.district_id = districts.id) AND (qr_codes.district_id = districts.id))));


ALTER VIEW public.v_satety_management OWNER TO health_builders;

--
-- Name: v_satisfaction_leadership_sample; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_satisfaction_leadership_sample AS
 SELECT staff_satisfaction."UMWAKA",
    staff_satisfaction."Hitamo Akarere ubarizwamo" AS district_name,
    staff_satisfaction."HC",
    count(staff_satisfaction."HC") AS n_respondents
   FROM public.staff_satisfaction
  WHERE ((staff_satisfaction."Atuma haba umwuka mwiza" IS NOT NULL) AND (staff_satisfaction."Ahora ahari" IS NOT NULL) AND (staff_satisfaction."Ashyiraho uburyo bwo gufatanya" IS NOT NULL) AND (staff_satisfaction."Ashishikariza abakozi guterimbere" IS NOT NULL) AND (staff_satisfaction."Akora gahunda y'ingamba" IS NOT NULL))
  GROUP BY staff_satisfaction."UMWAKA", staff_satisfaction."Hitamo Akarere ubarizwamo", staff_satisfaction."HC";


ALTER VIEW public.v_satisfaction_leadership_sample OWNER TO health_builders;

--
-- Name: v_satisfaction_sample; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_satisfaction_sample AS
 SELECT staff_satisfaction."UMWAKA",
    staff_satisfaction."Hitamo Akarere ubarizwamo" AS district_name,
    staff_satisfaction."HC",
    count(staff_satisfaction."HC") AS n_respondents
   FROM public.staff_satisfaction
  GROUP BY staff_satisfaction."UMWAKA", staff_satisfaction."Hitamo Akarere ubarizwamo", staff_satisfaction."HC";


ALTER VIEW public.v_satisfaction_sample OWNER TO health_builders;

--
-- Name: v_staff_leadership_satisfaction; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_staff_leadership_satisfaction AS
 WITH unpivoted AS (
         SELECT staff_satisfaction."UMWAKA",
            staff_satisfaction."Hitamo Akarere ubarizwamo",
            unnest(ARRAY['Atuma haba umwuka mwiza'::text, 'Ahora ahari'::text, 'Ashyiraho uburyo bwo gufatanya'::text, 'Ashishikariza abakozi guterimbere'::text, 'Agaragaza intego z''ingenzi zikwiriye gushyirwa imbere'::text, 'Akora gahunda y''ingamba'::text, 'Agaragaza kwiyoroshya'::text, 'Atanga akazi gakwiranye n’ubushobozi bw’umuntu'::text, 'Atenganyiriza ibihe by’ibyago cyangwa igihombo kugirango abyigire ibisubizo'::text, 'Afite intumbero ndende'::text, 'Afata ibyemezo bitewe n''intumbero y''ikigo'::text, 'Ashobora gufata ibyemezo bikaze'::text, 'Atega amatwi abamugana'::text, 'Atanga amakuru akwiye'::text, 'Avuga ibintu bisobanutse'::text, 'Yumvikana n''abantu'::text, 'Atanga icyizere'::text, 'Atera imbaraga abakozi'::text, 'Atanga amabwiriza n''intumbero ikwiye'::text, 'Ashishikariza abantu guhanga udushya'::text]) AS question,
            unnest(ARRAY[staff_satisfaction."Atuma haba umwuka mwiza", staff_satisfaction."Ahora ahari", staff_satisfaction."Ashyiraho uburyo bwo gufatanya", staff_satisfaction."Ashishikariza abakozi guterimbere", staff_satisfaction."Agaragaza intego z'ingenzi zikwiriye gushyirwa imbere", staff_satisfaction."Akora gahunda y'ingamba", staff_satisfaction."Agaragaza kwiyoroshya", staff_satisfaction."Atanga akazi gakwiranye n’ubushobozi bw’umuntu", staff_satisfaction."Atenganyiriza ibihe by’ibyago cyangwa igihombo kugirango abyi", staff_satisfaction."Afite intumbero ndende", staff_satisfaction."Afata ibyemezo bitewe n'intumbero y'ikigo", staff_satisfaction."Ashobora gufata ibyemezo bikaze", staff_satisfaction."Atega amatwi abamugana", staff_satisfaction."Atanga amakuru akwiye", staff_satisfaction."Avuga ibintu bisobanutse", staff_satisfaction."Yumvikana n'abantu", staff_satisfaction."Atanga icyizere", staff_satisfaction."Atera imbaraga abakozi", staff_satisfaction."Atanga amabwiriza n'intumbero ikwiye", staff_satisfaction."Ashishikariza abantu guhanga udushya"]) AS response
           FROM public.staff_satisfaction
        )
 SELECT unpivoted."UMWAKA",
    unpivoted."Hitamo Akarere ubarizwamo" AS district_name,
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Buri gihe%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Buri gihe",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Kenshi%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Kenshi",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Rimwe na rimwe%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Rimwe na rimwe",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Gake cyane%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Gake cyane",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Nta na rimwe%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Nta na rimwe",
    count(
        CASE
            WHEN ((unpivoted.response IS NULL) OR ((unpivoted.response)::text = ''::text)) THEN 1
            ELSE NULL::integer
        END) AS "R_Null",
    count(unpivoted.response) AS "Total Responses",
    round((((count(
        CASE
            WHEN ((unpivoted.response)::text ~~ ANY (ARRAY[('Buri gihe%'::character varying)::text, ('Kenshi%'::character varying)::text])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(
        CASE
            WHEN ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text)) THEN 1
            ELSE NULL::integer
        END), 0))::numeric), 2) AS "Good"
   FROM unpivoted
  WHERE ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text))
  GROUP BY unpivoted."UMWAKA", unpivoted."Hitamo Akarere ubarizwamo";


ALTER VIEW public.v_staff_leadership_satisfaction OWNER TO health_builders;

--
-- Name: v_staff_leadership_satisfaction_2; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_staff_leadership_satisfaction_2 AS
 WITH unpivoted AS (
         SELECT staff_satisfaction."Timestamp",
            staff_satisfaction."Hitamo Akarere ubarizwamo",
            staff_satisfaction."Urwego ukoreraho",
            staff_satisfaction."Imyaka yawe",
            staff_satisfaction."Imyaka umaze ukora muri iki kigo",
            staff_satisfaction."Igitsina",
            staff_satisfaction."UMWAKA",
            staff_satisfaction."HC",
            unnest(ARRAY['Atuma haba umwuka mwiza'::text, 'Ahora ahari'::text, 'Ashyiraho uburyo bwo gufatanya'::text, 'Ashishikariza abakozi guterimbere'::text, 'Agaragaza intego z''ingenzi zikwiriye gushyirwa imbere'::text, 'Akora gahunda y''ingamba'::text, 'Agaragaza kwiyoroshya'::text, 'Atanga akazi gakwiranye n’ubushobozi bw’umuntu'::text, 'Atenganyiriza ibihe by’ibyago cyangwa igihombo kugirango abyigire ibisubizo'::text, 'Afite intumbero ndende'::text, 'Afata ibyemezo bitewe n''intumbero y''ikigo'::text, 'Ashobora gufata ibyemezo bikaze'::text, 'Atega amatwi abamugana'::text, 'Atanga amakuru akwiye'::text, 'Avuga ibintu bisobanutse'::text, 'Yumvikana n''abantu'::text, 'Atanga icyizere'::text, 'Atera imbaraga abakozi'::text, 'Atanga amabwiriza n''intumbero ikwiye'::text, 'Ashishikariza abantu guhanga udushya'::text]) AS question,
            unnest(ARRAY[staff_satisfaction."Atuma haba umwuka mwiza", staff_satisfaction."Ahora ahari", staff_satisfaction."Ashyiraho uburyo bwo gufatanya", staff_satisfaction."Ashishikariza abakozi guterimbere", staff_satisfaction."Agaragaza intego z'ingenzi zikwiriye gushyirwa imbere", staff_satisfaction."Akora gahunda y'ingamba", staff_satisfaction."Agaragaza kwiyoroshya", staff_satisfaction."Atanga akazi gakwiranye n’ubushobozi bw’umuntu", staff_satisfaction."Atenganyiriza ibihe by’ibyago cyangwa igihombo kugirango abyi", staff_satisfaction."Afite intumbero ndende", staff_satisfaction."Afata ibyemezo bitewe n'intumbero y'ikigo", staff_satisfaction."Ashobora gufata ibyemezo bikaze", staff_satisfaction."Atega amatwi abamugana", staff_satisfaction."Atanga amakuru akwiye", staff_satisfaction."Avuga ibintu bisobanutse", staff_satisfaction."Yumvikana n'abantu", staff_satisfaction."Atanga icyizere", staff_satisfaction."Atera imbaraga abakozi", staff_satisfaction."Atanga amabwiriza n'intumbero ikwiye", staff_satisfaction."Ashishikariza abantu guhanga udushya"]) AS response
           FROM public.staff_satisfaction
        )
 SELECT unpivoted."Timestamp",
    unpivoted."UMWAKA",
    unpivoted."Hitamo Akarere ubarizwamo" AS district_name,
    unpivoted."HC",
    unpivoted."Urwego ukoreraho",
    unpivoted."Imyaka yawe",
    unpivoted."Imyaka umaze ukora muri iki kigo",
    unpivoted."Igitsina",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Buri gihe%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Buri gihe",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Kenshi%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Kenshi",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Rimwe na rimwe%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Rimwe na rimwe",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Gake cyane%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Gake cyane",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Nta na rimwe%'::text) THEN 1
            ELSE NULL::integer
        END) AS "Nta na rimwe",
    count(
        CASE
            WHEN ((unpivoted.response IS NULL) OR ((unpivoted.response)::text = ''::text)) THEN 1
            ELSE NULL::integer
        END) AS "R_Null",
    count(unpivoted.response) AS "Total Responses",
    round((((count(
        CASE
            WHEN ((unpivoted.response)::text ~~ ANY (ARRAY['Buri gihe%'::text, 'Kenshi%'::text])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(
        CASE
            WHEN ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text)) THEN 1
            ELSE NULL::integer
        END), 0))::numeric), 2) AS "Good"
   FROM unpivoted
  WHERE ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text))
  GROUP BY unpivoted."UMWAKA", unpivoted."Hitamo Akarere ubarizwamo", unpivoted."HC", unpivoted."Urwego ukoreraho", unpivoted."Imyaka yawe", unpivoted."Imyaka umaze ukora muri iki kigo", unpivoted."Igitsina", unpivoted."Timestamp";


ALTER VIEW public.v_staff_leadership_satisfaction_2 OWNER TO health_builders;

--
-- Name: v_staff_satisfaction_district_hc_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_staff_satisfaction_district_hc_summary AS
 WITH unpivoted AS (
         SELECT staff_satisfaction."Timestamp",
            staff_satisfaction."Hitamo Akarere ubarizwamo",
            staff_satisfaction."Urwego ukoreraho",
            staff_satisfaction."Imyaka yawe",
            staff_satisfaction."Imyaka umaze ukora muri iki kigo",
            staff_satisfaction."Igitsina",
            staff_satisfaction."UMWAKA",
            staff_satisfaction."HC",
            unnest(ARRAY['Nzi neza kandi numva intego zirambye z’ikigo nderabuzima'::text, 'Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki'::text, 'Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger'::text, 'Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima'::text, 'Tuvugana bihagije n’ubuyobozi'::text, 'Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige'::text, 'Imikorere inoze niyo ishyirwa imbere muri iki kigo'::text, 'Abandi bantu baha agaciro akazi nkora'::text, 'Ufitiye impamyabushobozi ibyo ukora'::text, 'Mpabwa amahirwe yo kwiyungura ubumenyi'::text, 'Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye'::text, 'Nasobanuriwe neza ibisabwa mu kazi'::text, 'Nejejwe n’akazi nkora mu rwego nkoreraho'::text, 'Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye'::text, 'Nifitiye icyizere cy’ubushobozi mfite mu kazi'::text, 'Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata'::text, 'Numva ndengerewe n’inshingano zanjye'::text, 'Numva dushyize hamwe muri iki kigo'::text, 'Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha'::text, 'Umuyobozi aha abakozi ijambo mu gufata ibyemezo'::text, 'Aho dukorera no hanze yaho haratekanye'::text, 'Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima'::text, 'Mbona ishimwe/agahimbazamusyi kubera imikorere myiza'::text, 'Nyuzwe n’uburyo duhabwa ikiruhuko/impushya'::text, 'Ubwishingizi bw’ubuzima mpabwa buranyuze'::text, 'Umushahara wanjye ujyanye n’inshingano z’akazi kanjye'::text]) AS question,
            unnest(ARRAY[staff_satisfaction."Nzi neza kandi numva intego zirambye z’ikigo nderabuzima", staff_satisfaction."Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki", staff_satisfaction."Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger", staff_satisfaction."Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima", staff_satisfaction."Tuvugana bihagije n’ubuyobozi", staff_satisfaction."Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige", staff_satisfaction."Imikorere inoze niyo ishyirwa imbere muri iki kigo", staff_satisfaction."Abandi bantu baha agaciro akazi nkora", staff_satisfaction."Ufitiye impamyabushobozi ibyo ukora", staff_satisfaction."Mpabwa amahirwe yo kwiyungura ubumenyi", staff_satisfaction."Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye", staff_satisfaction."Nasobanuriwe neza ibisabwa mu kazi", staff_satisfaction."Nejejwe n’akazi nkora mu rwego nkoreraho", staff_satisfaction."Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye", staff_satisfaction."Nifitiye icyizere cy’ubushobozi mfite mu kazi", staff_satisfaction."Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata", staff_satisfaction."Numva ndengerewe n’inshingano zanjye", staff_satisfaction."Numva dushyize hamwe muri iki kigo", staff_satisfaction."Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha", staff_satisfaction."Umuyobozi aha abakozi ijambo mu gufata ibyemezo", staff_satisfaction."Aho dukorera no hanze yaho haratekanye", staff_satisfaction."Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima", staff_satisfaction."Mbona ishimwe/agahimbazamusyi kubera imikorere myiza", staff_satisfaction."Nyuzwe n’uburyo duhabwa ikiruhuko/impushya", staff_satisfaction."Ubwishingizi bw’ubuzima mpabwa buranyuze", staff_satisfaction."Umushahara wanjye ujyanye n’inshingano z’akazi kanjye"]) AS response
           FROM public.staff_satisfaction
        )
 SELECT unpivoted."Timestamp",
    unpivoted."UMWAKA",
    unpivoted."Hitamo Akarere ubarizwamo" AS district_name,
    unpivoted."HC",
    unpivoted."Urwego ukoreraho",
    unpivoted."Imyaka yawe",
    unpivoted."Imyaka umaze ukora muri iki kigo",
    unpivoted."Igitsina",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Ndabyemera cyane (5)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "5",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Ndabyemera (4)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "4",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Biraho (3)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "3",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Simbyemera (2)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "2",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Simbyemera na gato (1)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "1",
    count(
        CASE
            WHEN ((unpivoted.response IS NULL) OR ((unpivoted.response)::text = ''::text)) THEN 1
            ELSE NULL::integer
        END) AS "R_Null",
    count(unpivoted.response) AS "Total Responses",
    round((((count(
        CASE
            WHEN ((unpivoted.response)::text ~~ ANY (ARRAY[('Ndabyemera cyane (5)%'::character varying)::text, ('Ndabyemera (4)%'::character varying)::text])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(
        CASE
            WHEN ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text)) THEN 1
            ELSE NULL::integer
        END), 0))::numeric), 2) AS "Good"
   FROM unpivoted
  GROUP BY unpivoted."UMWAKA", unpivoted."Hitamo Akarere ubarizwamo", unpivoted."HC", unpivoted."Urwego ukoreraho", unpivoted."Imyaka yawe", unpivoted."Imyaka umaze ukora muri iki kigo", unpivoted."Igitsina", unpivoted."Timestamp";


ALTER VIEW public.v_staff_satisfaction_district_hc_summary OWNER TO health_builders;

--
-- Name: v_staff_satisfaction_district_hc_summary_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_staff_satisfaction_district_hc_summary_copy1 AS
 WITH unpivoted AS (
         SELECT staff_satisfaction."Timestamp",
            staff_satisfaction."Hitamo Akarere ubarizwamo",
            staff_satisfaction."Urwego ukoreraho",
            staff_satisfaction."Imyaka yawe",
            staff_satisfaction."Imyaka umaze ukora muri iki kigo",
            staff_satisfaction."Igitsina",
            staff_satisfaction."UMWAKA",
            staff_satisfaction."HC",
            unnest(ARRAY['Nzi neza kandi numva intego zirambye z’ikigo nderabuzima'::text, 'Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki'::text, 'Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger'::text, 'Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima'::text, 'Tuvugana bihagije n’ubuyobozi'::text, 'Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige'::text, 'Imikorere inoze niyo ishyirwa imbere muri iki kigo'::text, 'Abandi bantu baha agaciro akazi nkora'::text, 'Ufitiye impamyabushobozi ibyo ukora'::text, 'Mpabwa amahirwe yo kwiyungura ubumenyi'::text, 'Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye'::text, 'Nasobanuriwe neza ibisabwa mu kazi'::text, 'Nejejwe n’akazi nkora mu rwego nkoreraho'::text, 'Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye'::text, 'Nifitiye icyizere cy’ubushobozi mfite mu kazi'::text, 'Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata'::text, 'Numva ndengerewe n’inshingano zanjye'::text, 'Numva dushyize hamwe muri iki kigo'::text, 'Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha'::text, 'Umuyobozi aha abakozi ijambo mu gufata ibyemezo'::text, 'Aho dukorera no hanze yaho haratekanye'::text, 'Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima'::text, 'Mbona ishimwe/agahimbazamusyi kubera imikorere myiza'::text, 'Nyuzwe n’uburyo duhabwa ikiruhuko/impushya'::text, 'Ubwishingizi bw’ubuzima mpabwa buranyuze'::text, 'Umushahara wanjye ujyanye n’inshingano z’akazi kanjye'::text]) AS question,
            unnest(ARRAY[staff_satisfaction."Nzi neza kandi numva intego zirambye z’ikigo nderabuzima", staff_satisfaction."Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki", staff_satisfaction."Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger", staff_satisfaction."Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima", staff_satisfaction."Tuvugana bihagije n’ubuyobozi", staff_satisfaction."Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige", staff_satisfaction."Imikorere inoze niyo ishyirwa imbere muri iki kigo", staff_satisfaction."Abandi bantu baha agaciro akazi nkora", staff_satisfaction."Ufitiye impamyabushobozi ibyo ukora", staff_satisfaction."Mpabwa amahirwe yo kwiyungura ubumenyi", staff_satisfaction."Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye", staff_satisfaction."Nasobanuriwe neza ibisabwa mu kazi", staff_satisfaction."Nejejwe n’akazi nkora mu rwego nkoreraho", staff_satisfaction."Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye", staff_satisfaction."Nifitiye icyizere cy’ubushobozi mfite mu kazi", staff_satisfaction."Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata", staff_satisfaction."Numva ndengerewe n’inshingano zanjye", staff_satisfaction."Numva dushyize hamwe muri iki kigo", staff_satisfaction."Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha", staff_satisfaction."Umuyobozi aha abakozi ijambo mu gufata ibyemezo", staff_satisfaction."Aho dukorera no hanze yaho haratekanye", staff_satisfaction."Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima", staff_satisfaction."Mbona ishimwe/agahimbazamusyi kubera imikorere myiza", staff_satisfaction."Nyuzwe n’uburyo duhabwa ikiruhuko/impushya", staff_satisfaction."Ubwishingizi bw’ubuzima mpabwa buranyuze", staff_satisfaction."Umushahara wanjye ujyanye n’inshingano z’akazi kanjye"]) AS response
           FROM public.staff_satisfaction
        )
 SELECT unpivoted."Timestamp",
    unpivoted."UMWAKA",
    unpivoted."Hitamo Akarere ubarizwamo" AS district_name,
    unpivoted."HC",
    unpivoted."Urwego ukoreraho",
    unpivoted."Imyaka yawe",
    unpivoted."Imyaka umaze ukora muri iki kigo",
    unpivoted."Igitsina",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Ndabyemera cyane (5)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "5",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Ndabyemera (4)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "4",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Biraho (3)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "3",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Simbyemera (2)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "2",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Simbyemera na gato (1)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "1",
    count(
        CASE
            WHEN ((unpivoted.response IS NULL) OR ((unpivoted.response)::text = ''::text)) THEN 1
            ELSE NULL::integer
        END) AS "R_Null",
    count(unpivoted.response) AS "Total Responses",
    round((((count(
        CASE
            WHEN ((unpivoted.response)::text ~~ ANY (ARRAY[('Ndabyemera cyane (5)%'::character varying)::text, ('Ndabyemera (4)%'::character varying)::text])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(
        CASE
            WHEN ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text)) THEN 1
            ELSE NULL::integer
        END), 0))::numeric), 2) AS "Good"
   FROM unpivoted
  GROUP BY unpivoted."UMWAKA", unpivoted."Hitamo Akarere ubarizwamo", unpivoted."HC", unpivoted."Urwego ukoreraho", unpivoted."Imyaka yawe", unpivoted."Imyaka umaze ukora muri iki kigo", unpivoted."Igitsina", unpivoted."Timestamp";


ALTER VIEW public.v_staff_satisfaction_district_hc_summary_copy1 OWNER TO health_builders;

--
-- Name: v_staff_satisfaction_district_summary; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_staff_satisfaction_district_summary AS
 WITH unpivoted AS (
         SELECT staff_satisfaction."UMWAKA",
            staff_satisfaction."Hitamo Akarere ubarizwamo",
            unnest(ARRAY['Nzi neza kandi numva intego zirambye z’ikigo nderabuzima'::text, 'Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki'::text, 'Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger'::text, 'Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima'::text, 'Tuvugana bihagije n’ubuyobozi'::text, 'Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige'::text, 'Imikorere inoze niyo ishyirwa imbere muri iki kigo'::text, 'Abandi bantu baha agaciro akazi nkora'::text, 'Ufitiye impamyabushobozi ibyo ukora'::text, 'Mpabwa amahirwe yo kwiyungura ubumenyi'::text, 'Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye'::text, 'Nasobanuriwe neza ibisabwa mu kazi'::text, 'Nejejwe n’akazi nkora mu rwego nkoreraho'::text, 'Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye'::text, 'Nifitiye icyizere cy’ubushobozi mfite mu kazi'::text, 'Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata'::text, 'Numva ndengerewe n’inshingano zanjye'::text, 'Numva dushyize hamwe muri iki kigo'::text, 'Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha'::text, 'Umuyobozi aha abakozi ijambo mu gufata ibyemezo'::text, 'Aho dukorera no hanze yaho haratekanye'::text, 'Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima'::text, 'Mbona ishimwe/agahimbazamusyi kubera imikorere myiza'::text, 'Nyuzwe n’uburyo duhabwa ikiruhuko/impushya'::text, 'Ubwishingizi bw’ubuzima mpabwa buranyuze'::text, 'Umushahara wanjye ujyanye n’inshingano z’akazi kanjye'::text]) AS question,
            unnest(ARRAY[staff_satisfaction."Nzi neza kandi numva intego zirambye z’ikigo nderabuzima", staff_satisfaction."Numva ko hari umusanzu wanjye ntanga mu kugera ku ntego y’iki", staff_satisfaction."Mfitiye icyizere ubuyobozi bw’iki kigo nderabuzima mu gukuger", staff_satisfaction."Ntanga umusanzu mu gutegura igenamigambi ry’ikigo nderabuzima", staff_satisfaction."Tuvugana bihagije n’ubuyobozi", staff_satisfaction."Nzi iterambere ikigo kimaze kugeraho ndetse n’aho kigeze kige", staff_satisfaction."Imikorere inoze niyo ishyirwa imbere muri iki kigo", staff_satisfaction."Abandi bantu baha agaciro akazi nkora", staff_satisfaction."Ufitiye impamyabushobozi ibyo ukora", staff_satisfaction."Mpabwa amahirwe yo kwiyungura ubumenyi", staff_satisfaction."Umuyobozi wanjye ambwira aho nkeneye kunoza imikorere yanjye", staff_satisfaction."Nasobanuriwe neza ibisabwa mu kazi", staff_satisfaction."Nejejwe n’akazi nkora mu rwego nkoreraho", staff_satisfaction."Mbasha gukoresha neza ubumenyi mfite mu kazi kanjye", staff_satisfaction."Nifitiye icyizere cy’ubushobozi mfite mu kazi", staff_satisfaction."Mpabwa ububasha buhagije bwo gufata ibyemezo ngomba gufata", staff_satisfaction."Numva ndengerewe n’inshingano zanjye", staff_satisfaction."Numva dushyize hamwe muri iki kigo", staff_satisfaction."Numva umuyobozi wanjye ampa ubufasha buhagije ndetse ananyubaha", staff_satisfaction."Umuyobozi aha abakozi ijambo mu gufata ibyemezo", staff_satisfaction."Aho dukorera no hanze yaho haratekanye", staff_satisfaction."Habaho amahugurwa ahoraho kubijyanye n’ubwirinzi mu buzima", staff_satisfaction."Mbona ishimwe/agahimbazamusyi kubera imikorere myiza", staff_satisfaction."Nyuzwe n’uburyo duhabwa ikiruhuko/impushya", staff_satisfaction."Ubwishingizi bw’ubuzima mpabwa buranyuze", staff_satisfaction."Umushahara wanjye ujyanye n’inshingano z’akazi kanjye"]) AS response
           FROM public.staff_satisfaction
        )
 SELECT unpivoted."UMWAKA",
    unpivoted."Hitamo Akarere ubarizwamo" AS district_name,
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Ndabyemera cyane (5)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "5",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Ndabyemera (4)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "4",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Biraho (3)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "3",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Simbyemera (2)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "2",
    count(
        CASE
            WHEN ((unpivoted.response)::text ~~ '%Simbyemera na gato (1)%'::text) THEN 1
            ELSE NULL::integer
        END) AS "1",
    count(
        CASE
            WHEN ((unpivoted.response IS NULL) OR ((unpivoted.response)::text = ''::text)) THEN 1
            ELSE NULL::integer
        END) AS "R_Null",
    count(unpivoted.response) AS "Total Responses",
    round((((count(
        CASE
            WHEN ((unpivoted.response)::text ~~ ANY (ARRAY[('Ndabyemera cyane (5)%'::character varying)::text, ('Ndabyemera (4)%'::character varying)::text])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(
        CASE
            WHEN ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text)) THEN 1
            ELSE NULL::integer
        END), 0))::numeric), 2) AS "Good"
   FROM unpivoted
  WHERE ((unpivoted.response IS NOT NULL) AND ((unpivoted.response)::text <> ''::text))
  GROUP BY unpivoted."UMWAKA", unpivoted."Hitamo Akarere ubarizwamo";


ALTER VIEW public.v_staff_satisfaction_district_summary OWNER TO health_builders;

--
-- Name: v_stock_management_Novartis; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public."v_stock_management_Novartis" AS
 SELECT districts.district AS district_name,
    health_centers.name AS health_center_name,
    qr_codes.survey_year,
    qr_code_types.name AS code_type,
    qr_codes.is_active AS is_code_active,
    stock_managements.survey_id,
    stock_managements.created_at,
    date_part('year'::text, stock_managements.created_at) AS record_year,
    date_part('month'::text, stock_managements.created_at) AS record_month,
    stock_managements.created_by,
    stock_managements.drug_name,
    pharmacy_drugs.is_novartis,
    pharmacy_drugs.is_health_center,
    pharmacy_drugs.is_medicalised_health_center,
    pharmacy_drugs.is_hospital,
    stock_managements.available,
    stock_managements.not_expired,
    stock_managements.requested,
    stock_managements.stock_card_available,
    stock_managements.bottom_of_card_filled_for_each_month,
    stock_managements.stock_monthly_inventory_available,
    stock_managements.quantity_listed_on_stock_card,
    stock_managements.quantity_on_shelf,
    stock_managements.evidence_of_excess_available,
    stock_managements.drug_properly_labeled,
    stock_managements.number_of_stock_out_days,
    stock_managements.days_with_stock_less_than_threshold,
    stock_managements.last_synced_at,
    users.first_name,
    users.surname
   FROM ((((((public.stock_managements
     LEFT JOIN public.qr_codes ON ((qr_codes.id = stock_managements.survey_id)))
     LEFT JOIN public.qr_code_types ON ((qr_code_types.id = qr_codes.type_id)))
     LEFT JOIN public.pharmacy_drugs ON (((pharmacy_drugs.drug_name)::text = stock_managements.drug_name)))
     LEFT JOIN public.health_centers ON ((health_centers.id = qr_codes.health_center_id)))
     LEFT JOIN public.districts ON (((districts.id = health_centers.district_id) AND (districts.id = qr_codes.district_id))))
     LEFT JOIN public.users ON (((users.id = qr_codes.created_by) AND (users.id = stock_managements.created_by))));


ALTER VIEW public."v_stock_management_Novartis" OWNER TO health_builders;

--
-- Name: v_stock_values; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.v_stock_values AS
 SELECT q.id AS survey_id,
    q.survey_year,
    d.district AS district_name,
    hc.name AS health_facility,
    hc.type AS facility_type,
    psv.opening_stock_value,
    psv.pharmacy_stock_value,
    psv.cost_of_expired_medicine,
    psv.cost_of_sold_medicine,
    cb.medicine_sales,
    cb.purchased_medicine
   FROM ((((public.qr_codes q
     LEFT JOIN public.districts d ON ((q.district_id = d.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
     LEFT JOIN public.pharmacy_stock_values psv ON ((q.id = psv.survey_id)))
     LEFT JOIN public.closing_balances cb ON ((q.id = cb.survey_id)));


ALTER VIEW public.v_stock_values OWNER TO health_builders;

--
-- Name: validation_rules; Type: TABLE; Schema: public; Owner: health_builders
--

CREATE TABLE public.validation_rules (
    id character varying(10) NOT NULL,
    indicator character varying(100),
    rule text
);


ALTER TABLE public.validation_rules OWNER TO health_builders;

--
-- Name: view_dispensary_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_dispensary_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE (((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true)))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), available_drugs_count AS (
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
            count(DISTINCT
                CASE
                    WHEN (dm.available = true) THEN
                    CASE
                        WHEN (dm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                        ELSE dm.drug_name
                    END
                    ELSE NULL::text
                END) AS drugs_available
           FROM (((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.dispensary_managements dm ON ((dm.survey_id = qr.id)))
          WHERE ((dm.deleted_at IS NULL) AND (qr.deleted_at IS NULL))
          GROUP BY hc.id, qr.id, qr.survey_year, qct.name
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT adc.survey_id,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
    adc.qr_code_type,
    hcdt.district_name,
    hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.view_dispensary_drug_availability_percentage OWNER TO health_builders;

--
-- Name: view_dispensary_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_dispensary_drug_availability_by_district AS
 SELECT view_dispensary_drug_availability_percentage.district_name,
    count(DISTINCT view_dispensary_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(view_dispensary_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(view_dispensary_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(view_dispensary_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(view_dispensary_drug_availability_percentage.drugs_available) / sum(view_dispensary_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.view_dispensary_drug_availability_percentage
  GROUP BY view_dispensary_drug_availability_percentage.district_name
  ORDER BY view_dispensary_drug_availability_percentage.district_name;


ALTER VIEW public.view_dispensary_drug_availability_by_district OWNER TO health_builders;

--
-- Name: view_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_drug_availability_by_district AS
 SELECT v_drug_availability_percentage.district_name,
    count(DISTINCT v_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(v_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(v_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(v_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(v_drug_availability_percentage.drugs_available) / sum(v_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.v_drug_availability_percentage
  GROUP BY v_drug_availability_percentage.district_name
  ORDER BY v_drug_availability_percentage.district_name;


ALTER VIEW public.view_drug_availability_by_district OWNER TO health_builders;

--
-- Name: view_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE (((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true)))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), available_drugs_count AS (
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
            count(DISTINCT
                CASE
                    WHEN (sm.available = true) THEN
                    CASE
                        WHEN (sm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                        ELSE sm.drug_name
                    END
                    ELSE NULL::text
                END) AS drugs_available
           FROM (((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.stock_managements sm ON ((sm.survey_id = qr.id)))
          WHERE ((sm.deleted_at IS NULL) AND (qr.deleted_at IS NULL))
          GROUP BY hc.id, qr.id, qr.survey_year, qct.name
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT adc.survey_id,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
    adc.qr_code_type,
    hcdt.district_name,
    hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.view_drug_availability_percentage OWNER TO health_builders;

--
-- Name: view_merged_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_merged_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE (((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true)))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), combined_drug_availability AS (
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
                CASE
                    WHEN (sm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                    ELSE sm.drug_name
                END AS drug_group_name,
            sm.available
           FROM (((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.stock_managements sm ON ((sm.survey_id = qr.id)))
          WHERE ((sm.deleted_at IS NULL) AND (qr.deleted_at IS NULL) AND (sm.drug_name IS NOT NULL))
        UNION ALL
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
                CASE
                    WHEN (dm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                    ELSE dm.drug_name
                END AS drug_group_name,
            dm.available
           FROM (((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.dispensary_managements dm ON ((dm.survey_id = qr.id)))
          WHERE ((dm.deleted_at IS NULL) AND (qr.deleted_at IS NULL) AND (dm.drug_name IS NOT NULL))
        ), available_drugs_count AS (
         SELECT available_drug_groups.health_center_id,
            available_drug_groups.survey_id,
            available_drug_groups.survey_year,
            available_drug_groups.qr_code_type,
            count(DISTINCT available_drug_groups.drug_group_name) AS drugs_available
           FROM ( SELECT combined_drug_availability.health_center_id,
                    combined_drug_availability.survey_id,
                    combined_drug_availability.survey_year,
                    combined_drug_availability.qr_code_type,
                    combined_drug_availability.drug_group_name
                   FROM combined_drug_availability
                  WHERE (combined_drug_availability.available = true)
                  GROUP BY combined_drug_availability.health_center_id, combined_drug_availability.survey_id, combined_drug_availability.survey_year, combined_drug_availability.qr_code_type, combined_drug_availability.drug_group_name
                 HAVING (count(*) > 0)) available_drug_groups
          GROUP BY available_drug_groups.health_center_id, available_drug_groups.survey_id, available_drug_groups.survey_year, available_drug_groups.qr_code_type
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT adc.survey_id,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
    adc.qr_code_type,
    hcdt.district_name,
    hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.view_merged_drug_availability_percentage OWNER TO health_builders;

--
-- Name: view_merged_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_merged_drug_availability_by_district AS
 SELECT view_merged_drug_availability_percentage.district_name,
    count(DISTINCT view_merged_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(view_merged_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(view_merged_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(view_merged_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(view_merged_drug_availability_percentage.drugs_available) / sum(view_merged_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.view_merged_drug_availability_percentage
  GROUP BY view_merged_drug_availability_percentage.district_name
  ORDER BY view_merged_drug_availability_percentage.district_name;


ALTER VIEW public.view_merged_drug_availability_by_district OWNER TO health_builders;

--
-- Name: view_merged_drug_availability_by_district_copy1; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_merged_drug_availability_by_district_copy1 AS
 SELECT view_merged_drug_availability_percentage.district_name,
    count(DISTINCT view_merged_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(view_merged_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(view_merged_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(view_merged_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(view_merged_drug_availability_percentage.drugs_available) / sum(view_merged_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.view_merged_drug_availability_percentage
  GROUP BY view_merged_drug_availability_percentage.district_name
  ORDER BY view_merged_drug_availability_percentage.district_name;


ALTER VIEW public.view_merged_drug_availability_by_district_copy1 OWNER TO health_builders;

--
-- Name: view_novartis_dispensary_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_dispensary_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE ((((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true))) AND (pd.is_novartis = true))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), available_drugs_count AS (
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
            count(DISTINCT
                CASE
                    WHEN (dm.available = true) THEN
                    CASE
                        WHEN (dm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                        WHEN (dm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                        ELSE dm.drug_name
                    END
                    ELSE NULL::text
                END) AS drugs_available
           FROM ((((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.dispensary_managements dm ON ((dm.survey_id = qr.id)))
             LEFT JOIN public.pharmacy_drugs pd ON (((pd.drug_name)::text = dm.drug_name)))
          WHERE ((dm.deleted_at IS NULL) AND (qr.deleted_at IS NULL) AND (pd.is_novartis = true))
          GROUP BY hc.id, qr.id, qr.survey_year, qct.name
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT adc.survey_id,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
    adc.qr_code_type,
    hcdt.district_name,
    hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.view_novartis_dispensary_drug_availability_percentage OWNER TO health_builders;

--
-- Name: view_novartis_dispensary_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_dispensary_drug_availability_by_district AS
 SELECT view_novartis_dispensary_drug_availability_percentage.district_name,
    count(DISTINCT view_novartis_dispensary_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(view_novartis_dispensary_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(view_novartis_dispensary_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(view_novartis_dispensary_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(view_novartis_dispensary_drug_availability_percentage.drugs_available) / sum(view_novartis_dispensary_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.view_novartis_dispensary_drug_availability_percentage
  GROUP BY view_novartis_dispensary_drug_availability_percentage.district_name
  ORDER BY view_novartis_dispensary_drug_availability_percentage.district_name;


ALTER VIEW public.view_novartis_dispensary_drug_availability_by_district OWNER TO health_builders;

--
-- Name: view_novartis_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE ((((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true))) AND (pd.is_novartis = true))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), available_drugs_count AS (
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
            count(DISTINCT
                CASE
                    WHEN (sm.available = true) THEN
                    CASE
                        WHEN (sm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                        WHEN (sm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                        ELSE sm.drug_name
                    END
                    ELSE NULL::text
                END) AS drugs_available
           FROM ((((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.stock_managements sm ON ((sm.survey_id = qr.id)))
             LEFT JOIN public.pharmacy_drugs pd ON (((pd.drug_name)::text = sm.drug_name)))
          WHERE ((sm.deleted_at IS NULL) AND (qr.deleted_at IS NULL) AND (pd.is_novartis = true))
          GROUP BY hc.id, qr.id, qr.survey_year, qct.name
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT adc.survey_id,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
    adc.qr_code_type,
    hcdt.district_name,
    hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.view_novartis_drug_availability_percentage OWNER TO health_builders;

--
-- Name: view_novartis_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_drug_availability_by_district AS
 SELECT view_novartis_drug_availability_percentage.district_name,
    count(DISTINCT view_novartis_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(view_novartis_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(view_novartis_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(view_novartis_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(view_novartis_drug_availability_percentage.drugs_available) / sum(view_novartis_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.view_novartis_drug_availability_percentage
  GROUP BY view_novartis_drug_availability_percentage.district_name
  ORDER BY view_novartis_drug_availability_percentage.district_name;


ALTER VIEW public.view_novartis_drug_availability_by_district OWNER TO health_builders;

--
-- Name: view_novartis_merged_drug_availability_percentage; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_merged_drug_availability_percentage AS
 WITH health_center_drug_totals AS (
         SELECT hc.id AS health_center_id,
            hc.name AS health_center_name,
            hc.type AS health_center_type,
            hc.district_id,
            d.district AS district_name,
            count(DISTINCT
                CASE
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Amilodipine'::character varying, 'Nifedipine (Tablet)'::character varying])::text[])) THEN 'AmilodipineORNifedipine'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Enalapril (Tablet)'::character varying, 'Captopril (Capsule/Tablet)'::character varying, 'Captopril (Tablet)'::character varying])::text[])) THEN 'EnalaprilORCaptopril'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Gliclazide (Tablet)'::character varying, 'Glibenclamide (Capsule/Tablet)'::character varying])::text[])) THEN 'GliclazideORGlibenclamide'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Carvedilol (Tablet)'::character varying, 'Atenolol (Capsule/Tablet)'::character varying, 'Atenolol (Tablet)'::character varying, 'Propranolol (Tablet)'::character varying])::text[])) THEN 'CarvedilolORAtenololORPropranolol'::character varying
                    WHEN ((pd.drug_name)::text = ANY ((ARRAY['Dopamine (Injection)'::character varying, 'Dobutamine (Injection)'::character varying])::text[])) THEN 'DopamineORDobutamine'::character varying
                    ELSE pd.drug_name
                END) AS total_expected_drugs
           FROM ((public.health_centers hc
             JOIN public.districts d ON ((d.id = hc.district_id)))
             CROSS JOIN public.pharmacy_drugs pd)
          WHERE ((((hc.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((hc.type = 'Medicalised Health Center'::text) AND (pd.is_medicalised_health_center = true)) OR ((hc.type = 'Hospital'::text) AND (pd.is_hospital = true))) AND (pd.is_novartis = true))
          GROUP BY hc.id, hc.name, hc.type, hc.district_id, d.district
        ), combined_drug_availability AS (
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
                CASE
                    WHEN (sm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                    WHEN (sm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                    ELSE sm.drug_name
                END AS drug_group_name,
            sm.available
           FROM ((((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.stock_managements sm ON ((sm.survey_id = qr.id)))
             LEFT JOIN public.pharmacy_drugs pd ON (((pd.drug_name)::text = sm.drug_name)))
          WHERE ((sm.deleted_at IS NULL) AND (qr.deleted_at IS NULL) AND (sm.drug_name IS NOT NULL) AND (pd.is_novartis = true))
        UNION ALL
         SELECT hc.id AS health_center_id,
            qr.id AS survey_id,
            qr.survey_year,
            qct.name AS qr_code_type,
                CASE
                    WHEN (dm.drug_name = ANY (ARRAY['Amilodipine'::text, 'Nifedipine (Tablet)'::text])) THEN 'AmilodipineORNifedipine'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Enalapril (Tablet)'::text, 'Captopril (Capsule/Tablet)'::text, 'Captopril (Tablet)'::text])) THEN 'EnalaprilORCaptopril'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Gliclazide (Tablet)'::text, 'Glibenclamide (Capsule/Tablet)'::text])) THEN 'GliclazideORGlibenclamide'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Carvedilol (Tablet)'::text, 'Atenolol (Capsule/Tablet)'::text, 'Atenolol (Tablet)'::text, 'Propranolol (Tablet)'::text])) THEN 'CarvedilolORAtenololORPropranolol'::text
                    WHEN (dm.drug_name = ANY (ARRAY['Dopamine (Injection)'::text, 'Dobutamine (Injection)'::text])) THEN 'DopamineORDobutamine'::text
                    ELSE dm.drug_name
                END AS drug_group_name,
            dm.available
           FROM ((((public.health_centers hc
             LEFT JOIN public.qr_codes qr ON ((qr.health_center_id = hc.id)))
             LEFT JOIN public.qr_code_types qct ON ((qct.id = qr.type_id)))
             LEFT JOIN public.dispensary_managements dm ON ((dm.survey_id = qr.id)))
             LEFT JOIN public.pharmacy_drugs pd ON (((pd.drug_name)::text = dm.drug_name)))
          WHERE ((dm.deleted_at IS NULL) AND (qr.deleted_at IS NULL) AND (dm.drug_name IS NOT NULL) AND (pd.is_novartis = true))
        ), available_drugs_count AS (
         SELECT available_drug_groups.health_center_id,
            available_drug_groups.survey_id,
            available_drug_groups.survey_year,
            available_drug_groups.qr_code_type,
            count(DISTINCT available_drug_groups.drug_group_name) AS drugs_available
           FROM ( SELECT combined_drug_availability.health_center_id,
                    combined_drug_availability.survey_id,
                    combined_drug_availability.survey_year,
                    combined_drug_availability.qr_code_type,
                    combined_drug_availability.drug_group_name
                   FROM combined_drug_availability
                  WHERE (combined_drug_availability.available = true)
                  GROUP BY combined_drug_availability.health_center_id, combined_drug_availability.survey_id, combined_drug_availability.survey_year, combined_drug_availability.qr_code_type, combined_drug_availability.drug_group_name
                 HAVING (count(*) > 0)) available_drug_groups
          GROUP BY available_drug_groups.health_center_id, available_drug_groups.survey_id, available_drug_groups.survey_year, available_drug_groups.qr_code_type
        ), latest_surveys AS (
         SELECT available_drugs_count.health_center_id,
            max((available_drugs_count.survey_year)::text) AS latest_survey_year
           FROM available_drugs_count
          GROUP BY available_drugs_count.health_center_id
        )
 SELECT adc.survey_id,
    COALESCE(adc.survey_year, 'N/A'::character varying) AS survey_year,
    adc.qr_code_type,
    hcdt.district_name,
    hcdt.health_center_name,
    hcdt.health_center_type,
    hcdt.total_expected_drugs,
    COALESCE(adc.drugs_available, (0)::bigint) AS drugs_available,
        CASE
            WHEN (hcdt.total_expected_drugs > 0) THEN round((((COALESCE(adc.drugs_available, (0)::bigint))::numeric / (hcdt.total_expected_drugs)::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS availability_percentage
   FROM ((health_center_drug_totals hcdt
     LEFT JOIN latest_surveys ls ON ((ls.health_center_id = hcdt.health_center_id)))
     LEFT JOIN available_drugs_count adc ON (((adc.health_center_id = hcdt.health_center_id) AND ((adc.survey_year)::text = ls.latest_survey_year))))
  ORDER BY hcdt.district_name, hcdt.health_center_name;


ALTER VIEW public.view_novartis_merged_drug_availability_percentage OWNER TO health_builders;

--
-- Name: view_novartis_merged_drug_availability_by_district; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_merged_drug_availability_by_district AS
 SELECT view_novartis_merged_drug_availability_percentage.district_name,
    count(DISTINCT view_novartis_merged_drug_availability_percentage.health_center_name) AS total_health_centers,
    sum(view_novartis_merged_drug_availability_percentage.total_expected_drugs) AS total_expected_drugs_all_centers,
    sum(view_novartis_merged_drug_availability_percentage.drugs_available) AS total_drugs_available_all_centers,
        CASE
            WHEN (sum(view_novartis_merged_drug_availability_percentage.total_expected_drugs) > (0)::numeric) THEN round(((sum(view_novartis_merged_drug_availability_percentage.drugs_available) / sum(view_novartis_merged_drug_availability_percentage.total_expected_drugs)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS district_availability_percentage
   FROM public.view_novartis_merged_drug_availability_percentage
  GROUP BY view_novartis_merged_drug_availability_percentage.district_name
  ORDER BY view_novartis_merged_drug_availability_percentage.district_name;


ALTER VIEW public.view_novartis_merged_drug_availability_by_district OWNER TO health_builders;

--
-- Name: view_novartis_missing_data_accuracies; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_novartis_missing_data_accuracies AS
 SELECT q.id AS survey_id,
    d.district,
    h.name AS health_center_name,
    ( SELECT string_agg(v.src, ', '::text ORDER BY v.src) AS string_agg
           FROM ( VALUES ('Cardiomyopathy, Total Cases'::text), ('Diabetes, Total Cases'::text), ('Dyslipidemia, Total Cases'::text), ('Hypertension, Old Cases, Total Cases'::text), ('Hypertension, Total Cases'::text)) v(src)
          WHERE (NOT (EXISTS ( SELECT 1
                   FROM public.data_accuracies da
                  WHERE ((da.survey_id = q.id) AND (da.source = v.src)))))) AS missing_data_accuracy_sources
   FROM ((public.qr_codes q
     LEFT JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
  WHERE ((q.type_id = 2) AND (q.is_active = true))
  ORDER BY d.district, h.name;


ALTER VIEW public.view_novartis_missing_data_accuracies OWNER TO postgres;

--
-- Name: view_novartis_missing_data_accuracies_exploded; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_novartis_missing_data_accuracies_exploded AS
 SELECT q.id AS survey_id,
    q.health_center_id,
    d.id AS district_id,
    d.district,
    h.name AS health_center_name,
    v.src AS missing_source
   FROM (((public.qr_codes q
     JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
     CROSS JOIN ( VALUES ('Cardiomypathy, Total Cases'::text), ('Diabetes, Total Cases'::text), ('Dyslipidemia, Total Cases'::text), ('Hypertension, Old Cases, Total Cases'::text), ('Hypertension, Total Cases'::text)) v(src))
  WHERE ((q.type_id = 2) AND (q.is_active = true) AND (NOT (EXISTS ( SELECT 1
           FROM public.data_accuracies da
          WHERE ((da.survey_id = q.id) AND (da.source = v.src))))) AND ((v.src <> ALL (ARRAY['Cardiomypathy, Total Cases'::text, 'Dyslipidemia, Total Cases'::text])) OR (h.type = 'Hospital'::text)));


ALTER VIEW public.view_novartis_missing_data_accuracies_exploded OWNER TO postgres;

--
-- Name: view_novartis_missing_drugs; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_novartis_missing_drugs AS
 SELECT q.id AS survey_id,
    d.district,
    h.name AS health_center_name,
    ( SELECT string_agg((pd.drug_name)::text, ', '::text ORDER BY (pd.drug_name)::text) AS string_agg
           FROM public.pharmacy_drugs pd
          WHERE ((pd.is_novartis = true) AND (NOT (EXISTS ( SELECT 1
                   FROM public.stock_managements sm
                  WHERE ((sm.survey_id = q.id) AND (sm.drug_name = (pd.drug_name)::text))))) AND (NOT (EXISTS ( SELECT 1
                   FROM public.dispensary_managements dm
                  WHERE ((dm.survey_id = q.id) AND (dm.drug_name = (pd.drug_name)::text))))))) AS missing_novartis_drugs
   FROM ((public.qr_codes q
     LEFT JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
  WHERE ((q.type_id = 2) AND (q.is_active = true))
  ORDER BY d.district, h.name;


ALTER VIEW public.view_novartis_missing_drugs OWNER TO postgres;

--
-- Name: view_novartis_missing_drugs_exploded; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_missing_drugs_exploded AS
 SELECT q.id AS survey_id,
    q.health_center_id,
    d.id AS district_id,
    d.district,
    h.name AS health_center_name,
    pd.drug_name AS missing_drug_name
   FROM (((public.qr_codes q
     JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
     CROSS JOIN public.pharmacy_drugs pd)
  WHERE ((q.type_id = 2) AND (q.is_active = true) AND (pd.is_novartis = true) AND (NOT (EXISTS ( SELECT 1
           FROM public.stock_managements sm
          WHERE ((sm.survey_id = q.id) AND (sm.drug_name = (pd.drug_name)::text))))) AND (NOT (EXISTS ( SELECT 1
           FROM public.dispensary_managements dm
          WHERE ((dm.survey_id = q.id) AND (dm.drug_name = (pd.drug_name)::text))))));


ALTER VIEW public.view_novartis_missing_drugs_exploded OWNER TO health_builders;

--
-- Name: view_novartis_missing_drugs_exploded_detailed; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_missing_drugs_exploded_detailed AS
 SELECT q.id AS survey_id,
    q.health_center_id,
    d.id AS district_id,
    d.district,
    h.name AS health_center_name,
    pd.drug_name,
    (NOT (EXISTS ( SELECT 1
           FROM public.stock_managements sm
          WHERE ((sm.survey_id = q.id) AND (sm.drug_name = (pd.drug_name)::text))))) AS missing_stock,
    (NOT (EXISTS ( SELECT 1
           FROM public.dispensary_managements dm
          WHERE ((dm.survey_id = q.id) AND (dm.drug_name = (pd.drug_name)::text))))) AS missing_dispensary
   FROM (((public.qr_codes q
     JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
     CROSS JOIN public.pharmacy_drugs pd)
  WHERE ((q.type_id = 2) AND (q.is_active = true) AND (pd.is_novartis = true) AND (((h.type = 'Health Center'::text) AND (pd.is_health_center = true)) OR ((h.type = 'Hospital'::text) AND (pd.is_hospital = true)) OR (h.type <> ALL (ARRAY['Health Center'::text, 'Hospital'::text]))) AND ((NOT (EXISTS ( SELECT 1
           FROM public.stock_managements sm
          WHERE ((sm.survey_id = q.id) AND (sm.drug_name = (pd.drug_name)::text))))) OR (NOT (EXISTS ( SELECT 1
           FROM public.dispensary_managements dm
          WHERE ((dm.survey_id = q.id) AND (dm.drug_name = (pd.drug_name)::text)))))));


ALTER VIEW public.view_novartis_missing_drugs_exploded_detailed OWNER TO health_builders;

--
-- Name: view_novartis_missing_projects_exploded; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_novartis_missing_projects_exploded AS
 SELECT hc.id AS health_center_id,
    d.id AS district_id,
    d.district,
    hc.name AS health_center_name,
    p.id AS project_id,
    p.name AS missing_project_name
   FROM ((public.health_centers hc
     LEFT JOIN public.districts d ON ((hc.district_id = d.id)))
     CROSS JOIN public.projects p)
  WHERE ((p.name ~~* '%novartis%'::text) AND (p.status_id = 1) AND (NOT (EXISTS ( SELECT 1
           FROM public.project_data pd
          WHERE ((pd.project_id = p.id) AND (pd.health_center_id = hc.id) AND (pd.deleted_at IS NULL))))) AND (((p.name !~~* '%cardiomyopathy%'::text) AND (p.name !~~* '%dyslipidemia%'::text) AND (p.name !~~* '%dylipidemia%'::text)) OR (hc.type = 'Hospital'::text)));


ALTER VIEW public.view_novartis_missing_projects_exploded OWNER TO postgres;

--
-- Name: view_novartis_missing_survey_basic_info_exploded; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_missing_survey_basic_info_exploded AS
 SELECT q.id AS survey_id,
    q.health_center_id,
    d.id AS district_id,
    d.district,
    h.name AS health_center_name
   FROM ((public.qr_codes q
     LEFT JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
  WHERE ((q.type_id = 2) AND (q.is_active = true) AND ((h.type IS NULL) OR (h.type <> 'Hospital'::text)) AND (NOT (EXISTS ( SELECT 1
           FROM public.survey_basic_informations sbi
          WHERE (sbi.survey_id = q.id)))));


ALTER VIEW public.view_novartis_missing_survey_basic_info_exploded OWNER TO health_builders;

--
-- Name: view_novartis_missing_treatment_guidelines_exploded; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_novartis_missing_treatment_guidelines_exploded AS
 SELECT q.id AS survey_id,
    q.health_center_id,
    d.id AS district_id,
    d.district,
    h.name AS health_center_name,
    v.name AS missing_treatment_guideline
   FROM (((public.qr_codes q
     JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
     CROSS JOIN ( VALUES ('Cardiomyopathy'::text), ('Diabetes'::text), ('Dyslipidemia'::text), ('Hypertension'::text)) v(name))
  WHERE ((q.type_id = 2) AND (q.is_active = true) AND (NOT (EXISTS ( SELECT 1
           FROM public.treatment_guidelines t
          WHERE ((t.survey_id = q.id) AND (t.treatment_guideline = v.name))))) AND ((v.name <> ALL (ARRAY['Cardiomyopathy'::text, 'Dyslipidemia'::text])) OR (h.type = 'Hospital'::text)));


ALTER VIEW public.view_novartis_missing_treatment_guidelines_exploded OWNER TO postgres;

--
-- Name: view_novartis_records_count; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.view_novartis_records_count AS
 SELECT q.id,
    d.district,
    h.name AS health_center_name,
    ( SELECT count(*) AS count
           FROM public.cardiomyopathy_treatment_guidelines ca
          WHERE (ca.survey_id = q.id)) AS cardiomyopath_guidelines_count,
    ( SELECT count(*) AS count
           FROM public.diabetes_treatment_guidelines dt
          WHERE (dt.survey_id = q.id)) AS diabetes_guidelines_count,
    ( SELECT count(*) AS count
           FROM public.dyslipidemia_treatment_guidelines dy
          WHERE (dy.survey_id = q.id)) AS dyslipidemia_guidelines_count,
    ( SELECT count(*) AS count
           FROM public.hypertension_treatment_guidelines ht
          WHERE (ht.survey_id = q.id)) AS hypertension_guidelines_count,
    ( SELECT count(*) AS count
           FROM public.treatment_guidelines t
          WHERE (t.survey_id = q.id)) AS treatment_guidelines_count,
    ( SELECT count(*) AS count
           FROM public.cardiomyopathy_treatment_outcomes cto
          WHERE (cto.survey_id = q.id)) AS cardiomyopath_outcomes_count,
    ( SELECT count(*) AS count
           FROM public.diabetes_nephropathy_prevalences dnp
          WHERE (dnp.survey_id = q.id)) AS diabetes_nephropathy_count,
    ( SELECT count(*) AS count
           FROM public.dyslipidemia_treatment_outcomes dto
          WHERE (dto.survey_id = q.id)) AS dyslipidemia_outcomes_count,
    ( SELECT count(*) AS count
           FROM public.hypertension_nephropathy_prevalences hnp
          WHERE (hnp.survey_id = q.id)) AS hypertension_nephropathy_count,
    ( SELECT count(*) AS count
           FROM public.new_diabetes_treatment_outcomes ndto
          WHERE (ndto.survey_id = q.id)) AS new_diabetes_outcomes_count,
    ( SELECT count(*) AS count
           FROM public.new_hypertension_treatment_outcomes nhto
          WHERE (nhto.survey_id = q.id)) AS new_hypertension_outcomes_count,
    ( SELECT count(*) AS count
           FROM public.pharmacy_reviews pr
          WHERE (pr.survey_id = q.id)) AS pharmacy_review_count,
    ( SELECT count(*) AS count
           FROM public.expired_drugs_managements edm
          WHERE (edm.survey_id = q.id)) AS expired_drug_management_count,
    ( SELECT count(*) AS count
           FROM public.additional_pharmacy_informations api
          WHERE (api.survey_id = q.id)) AS additional_pharmacy_information_count,
    ( SELECT count(*) AS count
           FROM (public.stock_managements sm
             JOIN public.pharmacy_drugs pd ON ((sm.drug_name = (pd.drug_name)::text)))
          WHERE ((sm.survey_id = q.id) AND (pd.is_novartis = true))) AS stock_management_count,
    ( SELECT count(*) AS count
           FROM (public.dispensary_managements dm
             JOIN public.pharmacy_drugs pd ON ((dm.drug_name = (pd.drug_name)::text)))
          WHERE ((dm.survey_id = q.id) AND (pd.is_novartis = true))) AS dispensary_management_count,
    ( SELECT count(*) AS count
           FROM public.monthly_data_reports mdr
          WHERE (mdr.survey_id = q.id)) AS monthly_data_reports_count,
    ( SELECT count(*) AS count
           FROM public.data_management_sops dms
          WHERE (dms.survey_id = q.id)) AS data_management_sops_count,
    ( SELECT count(*) AS count
           FROM public.data_accuracies da
          WHERE ((da.survey_id = q.id) AND (da.source = ANY (ARRAY['Cardiomyopathy, Total Cases'::text, 'Diabetes, Total Cases'::text, 'Dyslipidemia, Total Cases'::text, 'Hypertension, Old Cases, Total Cases'::text, 'Hypertension, Total Cases'::text])))) AS data_accuracies_count_over_5
   FROM ((public.qr_codes q
     LEFT JOIN public.health_centers h ON ((q.health_center_id = h.id)))
     LEFT JOIN public.districts d ON ((h.district_id = d.id)))
  WHERE ((q.type_id = 2) AND (q.is_active = true))
  ORDER BY d.district, h.name;


ALTER VIEW public.view_novartis_records_count OWNER TO health_builders;

--
-- Name: vw_hbs_hms_project_data_details; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.vw_hbs_hms_project_data_details AS
 SELECT pd.id AS project_data_id,
    pd.project_id,
    p.name AS project_name,
    hc.district_id,
    d.district AS district_name,
    pd.health_center_id,
    hc.name AS health_center_name,
    pd.question_id,
    q.question,
    pd.answer,
    pd.category_id,
    pqc.category,
    pd.start_date,
    pd.end_date,
    pd.created_by,
    ((u.first_name || ' '::text) || u.surname) AS created_by_name,
    pd.created_at
   FROM ((((((public.project_data pd
     JOIN public.project_questions q ON ((pd.question_id = q.id)))
     JOIN public.projects p ON ((pd.project_id = p.id)))
     JOIN public.project_question_categories pqc ON ((pd.category_id = pqc.id)))
     JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     JOIN public.districts d ON ((hc.district_id = d.id)))
     JOIN public.users u ON ((pd.created_by = u.id)))
  WHERE (pd.project_id = ANY (ARRAY['13658817-6375-47c8-aba6-3f7f197271dd'::text, '3fcd71ff-f277-4bec-8bdf-740e3dc29688'::text]))
  ORDER BY pd.updated_at DESC;


ALTER VIEW public.vw_hbs_hms_project_data_details OWNER TO health_builders;

--
-- Name: vw_novartis_project_stats; Type: VIEW; Schema: public; Owner: health_builders
--

CREATE VIEW public.vw_novartis_project_stats AS
 SELECT d.id AS district_id,
    d.district AS district_name,
    hc.id AS health_center_id,
    hc.name AS health_center_name,
    p.id AS project_id,
    p.name AS project_name,
    count(DISTINCT pd.id) AS records_added,
    min(pd.start_date) AS start_date,
    max(pd.end_date) AS end_date,
    max(pd.last_synced_at) AS synced_at,
    max(pd.created_at) AS latest_data_entry,
    concat_ws(''::text, u.first_name, u.surname) AS added_by
   FROM ((((public.project_data pd
     JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     JOIN public.districts d ON ((hc.district_id = d.id)))
     JOIN public.projects p ON ((pd.project_id = p.id)))
     JOIN public.users u ON ((pd.created_by = u.id)))
  WHERE ((p.name ~~* '%novartis%'::text) AND (p.status_id = 1) AND (pd.deleted_at IS NULL))
  GROUP BY d.id, d.district, hc.id, hc.name, p.id, p.name, pd.start_date, pd.end_date, u.first_name, u.surname, pd.created_at
  ORDER BY pd.created_at DESC, d.district, hc.name, p.name, pd.start_date;


ALTER VIEW public.vw_novartis_project_stats OWNER TO health_builders;

--
-- Name: meeting_frequencies id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.meeting_frequencies ALTER COLUMN id SET DEFAULT nextval('public.meeting_frequencies_id_seq'::regclass);


--
-- Name: meetings id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.meetings ALTER COLUMN id SET DEFAULT nextval('public.meetings_id_seq'::regclass);


--
-- Name: ncd_community_screening id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening ALTER COLUMN id SET DEFAULT nextval('public.ncd_community_screening_id_seq'::regclass);


--
-- Name: ncd_community_screening_august_4_with_duplicates id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening_august_4_with_duplicates ALTER COLUMN id SET DEFAULT nextval('public.ncd_community_screening_august_4_with_duplicates_id_seq'::regclass);


--
-- Name: ncd_community_screening_full_with_duplicates id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening_full_with_duplicates ALTER COLUMN id SET DEFAULT nextval('public.ncd_community_screening_full_with_duplicates_id_seq'::regclass);


--
-- Name: ncd_patient_age_ranges id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_age_ranges ALTER COLUMN id SET DEFAULT nextval('public.ncd_patient_age_ranges_id_seq'::regclass);


--
-- Name: ncd_patient_education_levels id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_education_levels ALTER COLUMN id SET DEFAULT nextval('public.ncd_patient_education_levels_id_seq'::regclass);


--
-- Name: ncd_patient_genders id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_genders ALTER COLUMN id SET DEFAULT nextval('public.ncd_patient_genders_id_seq'::regclass);


--
-- Name: ncd_patient_illness_durations id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_illness_durations ALTER COLUMN id SET DEFAULT nextval('public.ncd_patient_illness_durations_id_seq'::regclass);


--
-- Name: patient_age_ranges id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_age_ranges ALTER COLUMN id SET DEFAULT nextval('public.patient_age_ranges_id_seq'::regclass);


--
-- Name: patient_education_levels id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_education_levels ALTER COLUMN id SET DEFAULT nextval('public.patient_education_levels_id_seq'::regclass);


--
-- Name: patient_genders id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_genders ALTER COLUMN id SET DEFAULT nextval('public.patient_genders_id_seq'::regclass);


--
-- Name: patient_satisfaction_ratings id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_ratings ALTER COLUMN id SET DEFAULT nextval('public.patient_satisfaction_ratings_id_seq'::regclass);


--
-- Name: patient_satisfaction_services id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_services ALTER COLUMN id SET DEFAULT nextval('public.patient_satisfaction_services_id_seq'::regclass);


--
-- Name: pharmacy_drugs id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_drugs ALTER COLUMN id SET DEFAULT nextval('public.pharmacy_drugs_id_seq'::regclass);


--
-- Name: pharmacy_management_drug_names id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_management_drug_names ALTER COLUMN id SET DEFAULT nextval('public.pharmacy_management_drug_names_id_seq'::regclass);


--
-- Name: project_question_categories id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_question_categories ALTER COLUMN id SET DEFAULT nextval('public.project_question_categories_id_seq'::regclass);


--
-- Name: project_statuses id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_statuses ALTER COLUMN id SET DEFAULT nextval('public.project_statuses_id_seq'::regclass);


--
-- Name: qr_code_types id; Type: DEFAULT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_code_types ALTER COLUMN id SET DEFAULT nextval('public.qr_code_types_id_seq'::regclass);


--
-- Name: accountings accountings_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.accountings
    ADD CONSTRAINT accountings_pkey PRIMARY KEY (survey_id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (survey_id);


--
-- Name: action_plans action_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.action_plans
    ADD CONSTRAINT action_plans_pkey PRIMARY KEY (survey_id);


--
-- Name: additional_pharmacy_informations additional_pharmacy_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_pharmacy_informations
    ADD CONSTRAINT additional_pharmacy_informations_pkey PRIMARY KEY (survey_id);


--
-- Name: additional_suggestions additional_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_suggestions
    ADD CONSTRAINT additional_suggestions_pkey PRIMARY KEY (id);


--
-- Name: admitted_patients_outcomes admitted_patients_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.admitted_patients_outcomes
    ADD CONSTRAINT admitted_patients_outcomes_pkey PRIMARY KEY (id);


--
-- Name: anc_treatment_guidelines anc_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.anc_treatment_guidelines
    ADD CONSTRAINT anc_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: ancs ancs_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ancs
    ADD CONSTRAINT ancs_pkey PRIMARY KEY (survey_id);


--
-- Name: annual_malaria_prevention_plans annual_malaria_prevention_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.annual_malaria_prevention_plans
    ADD CONSTRAINT annual_malaria_prevention_plans_pkey PRIMARY KEY (survey_id);


--
-- Name: arvs arvs_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.arvs
    ADD CONSTRAINT arvs_pkey PRIMARY KEY (survey_id);


--
-- Name: asthma_classifications asthma_classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.asthma_classifications
    ADD CONSTRAINT asthma_classifications_pkey PRIMARY KEY (id);


--
-- Name: asthma_treatment_guidelines asthma_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.asthma_treatment_guidelines
    ADD CONSTRAINT asthma_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: attendance_registers attendance_registers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.attendance_registers
    ADD CONSTRAINT attendance_registers_pkey PRIMARY KEY (survey_id);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (survey_id);


--
-- Name: business_plans business_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.business_plans
    ADD CONSTRAINT business_plans_pkey PRIMARY KEY (survey_id);


--
-- Name: cardiomyopathy_treatment_guidelines cardiomyopathy_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cardiomyopathy_treatment_guidelines
    ADD CONSTRAINT cardiomyopathy_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: cardiomyopathy_treatment_outcomes cardiomyopathy_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cardiomyopathy_treatment_outcomes
    ADD CONSTRAINT cardiomyopathy_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: cashiers cashiers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cashiers
    ADD CONSTRAINT cashiers_pkey PRIMARY KEY (survey_id);


--
-- Name: cehos cehos_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cehos
    ADD CONSTRAINT cehos_pkey PRIMARY KEY (survey_id);


--
-- Name: check_list_treatment_guidelines check_list_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.check_list_treatment_guidelines
    ADD CONSTRAINT check_list_treatment_guidelines_pkey PRIMARY KEY (survey_id);


--
-- Name: closing_balances closing_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.closing_balances
    ADD CONSTRAINT closing_balances_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: completeness_of_opd_registers completeness_of_opd_registers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.completeness_of_opd_registers
    ADD CONSTRAINT completeness_of_opd_registers_pkey PRIMARY KEY (id);


--
-- Name: consultation_rooms consultation_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.consultation_rooms
    ADD CONSTRAINT consultation_rooms_pkey PRIMARY KEY (survey_id);


--
-- Name: cough_treatment_guidelines cough_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cough_treatment_guidelines
    ADD CONSTRAINT cough_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: customer_care_programs customer_care_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.customer_care_programs
    ADD CONSTRAINT customer_care_programs_pkey PRIMARY KEY (survey_id);


--
-- Name: data_accuracies data_accuracies_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_accuracies
    ADD CONSTRAINT data_accuracies_pkey PRIMARY KEY (id);


--
-- Name: data_management_sops data_management_sops_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_management_sops
    ADD CONSTRAINT data_management_sops_pkey PRIMARY KEY (survey_id);


--
-- Name: data_managers data_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_managers
    ADD CONSTRAINT data_managers_pkey PRIMARY KEY (survey_id);


--
-- Name: diabetes_clearances diabetes_clearances_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_clearances
    ADD CONSTRAINT diabetes_clearances_pkey PRIMARY KEY (id);


--
-- Name: diabetes_glycemia_treatment_outcomes diabetes_glycemia_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_glycemia_treatment_outcomes
    ADD CONSTRAINT diabetes_glycemia_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: diabetes_hba1c_treatment_outcomes diabetes_hba1c_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_hba1c_treatment_outcomes
    ADD CONSTRAINT diabetes_hba1c_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: diabetes_knowledge_on_home_self_managements diabetes_knowledge_on_home_self_managements_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT diabetes_knowledge_on_home_self_managements_pkey PRIMARY KEY (id);


--
-- Name: diabetes_nephropathy_prevalences diabetes_nephropathy_prevalences_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_nephropathy_prevalences
    ADD CONSTRAINT diabetes_nephropathy_prevalences_pkey PRIMARY KEY (survey_id);


--
-- Name: diabetes_treatment_guidelines diabetes_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_guidelines
    ADD CONSTRAINT diabetes_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: diabetes_treatment_guidelines_copy diabetes_treatment_guidelines_pkey_1; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_guidelines_copy
    ADD CONSTRAINT diabetes_treatment_guidelines_pkey_1 PRIMARY KEY (id);


--
-- Name: diabetes_treatment_outcomes diabetes_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_outcomes
    ADD CONSTRAINT diabetes_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: diarrhoea_key_performance_indicators diarrhoea_key_performance_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diarrhoea_key_performance_indicators
    ADD CONSTRAINT diarrhoea_key_performance_indicators_pkey PRIMARY KEY (survey_id);


--
-- Name: diarrhoea_treatment_guidelines diarrhoea_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diarrhoea_treatment_guidelines
    ADD CONSTRAINT diarrhoea_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: dispensary_managements dispensary_managements_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dispensary_managements
    ADD CONSTRAINT dispensary_managements_pkey PRIMARY KEY (id);


--
-- Name: dispensing_pharmacies dispensing_pharmacies_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dispensing_pharmacies
    ADD CONSTRAINT dispensing_pharmacies_pkey PRIMARY KEY (survey_id);


--
-- Name: districts districts_district_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_district_key UNIQUE (district);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: dyslipidemia_treatment_guidelines dyslipidemia_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dyslipidemia_treatment_guidelines
    ADD CONSTRAINT dyslipidemia_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: dyslipidemia_treatment_outcomes dyslipidemia_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dyslipidemia_treatment_outcomes
    ADD CONSTRAINT dyslipidemia_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: expected_questions expected_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.expected_questions
    ADD CONSTRAINT expected_questions_pkey PRIMARY KEY (question_id);


--
-- Name: expired_drugs_managements expired_drugs_managements_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.expired_drugs_managements
    ADD CONSTRAINT expired_drugs_managements_pkey PRIMARY KEY (survey_id);


--
-- Name: external_trainings_reports external_trainings_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.external_trainings_reports
    ADD CONSTRAINT external_trainings_reports_pkey PRIMARY KEY (survey_id);


--
-- Name: facility_perfomance_observations facility_perfomance_observations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.facility_perfomance_observations
    ADD CONSTRAINT facility_perfomance_observations_pkey PRIMARY KEY (id);


--
-- Name: failed_syncs failed_syncs_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.failed_syncs
    ADD CONSTRAINT failed_syncs_pkey PRIMARY KEY (id);


--
-- Name: family_plannings family_plannings_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.family_plannings
    ADD CONSTRAINT family_plannings_pkey PRIMARY KEY (survey_id);


--
-- Name: fever_treatment_guidelines fever_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.fever_treatment_guidelines
    ADD CONSTRAINT fever_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: focal_persons focal_persons_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.focal_persons
    ADD CONSTRAINT focal_persons_pkey PRIMARY KEY (survey_id);


--
-- Name: frequency_of_committee_meetings frequency_of_committee_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.frequency_of_committee_meetings
    ADD CONSTRAINT frequency_of_committee_meetings_pkey PRIMARY KEY (id);


--
-- Name: health_centers health_centers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.health_centers
    ADD CONSTRAINT health_centers_pkey PRIMARY KEY (id);


--
-- Name: health_educations health_educations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.health_educations
    ADD CONSTRAINT health_educations_pkey PRIMARY KEY (id);


--
-- Name: hospitalizations hospitalizations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hospitalizations
    ADD CONSTRAINT hospitalizations_pkey PRIMARY KEY (survey_id);


--
-- Name: hypertension_clearances hypertension_clearances_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_clearances
    ADD CONSTRAINT hypertension_clearances_pkey PRIMARY KEY (id);


--
-- Name: hypertension_knowledge_on_home_self_managements hypertension_knowledge_on_home_self_managements_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT hypertension_knowledge_on_home_self_managements_pkey PRIMARY KEY (id);


--
-- Name: hypertension_nephropathy_prevalences hypertension_nephropathy_prevalences_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_nephropathy_prevalences
    ADD CONSTRAINT hypertension_nephropathy_prevalences_pkey PRIMARY KEY (survey_id);


--
-- Name: hypertension_treatment_guidelines hypertension_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_guidelines
    ADD CONSTRAINT hypertension_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: hypertension_treatment_guidelines_copy hypertension_treatment_guidelines_pkey_1; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_guidelines_copy
    ADD CONSTRAINT hypertension_treatment_guidelines_pkey_1 PRIMARY KEY (id);


--
-- Name: hypertension_treatment_outcomes hypertension_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_outcomes
    ADD CONSTRAINT hypertension_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: health_centers idx_health_centers_name; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.health_centers
    ADD CONSTRAINT idx_health_centers_name UNIQUE (name);


--
-- Name: imci_merged_copy1 imci_merged_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged_copy1
    ADD CONSTRAINT imci_merged_copy1_pkey PRIMARY KEY (patient_id);


--
-- Name: imci_merged imci_merged_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged
    ADD CONSTRAINT imci_merged_pkey PRIMARY KEY (patient_id);


--
-- Name: in_service_training_plans in_service_training_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.in_service_training_plans
    ADD CONSTRAINT in_service_training_plans_pkey PRIMARY KEY (survey_id);


--
-- Name: income_reviews income_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.income_reviews
    ADD CONSTRAINT income_reviews_pkey PRIMARY KEY (id);


--
-- Name: information_delivery_and_support_satisfactions information_delivery_and_support_satisfactions_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.information_delivery_and_support_satisfactions
    ADD CONSTRAINT information_delivery_and_support_satisfactions_pkey PRIMARY KEY (id);


--
-- Name: inpatients_care_treatment_guidelines inpatients_care_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.inpatients_care_treatment_guidelines
    ADD CONSTRAINT inpatients_care_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: insurances insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.insurances
    ADD CONSTRAINT insurances_pkey PRIMARY KEY (id);


--
-- Name: job_descriptions job_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.job_descriptions
    ADD CONSTRAINT job_descriptions_pkey PRIMARY KEY (id);


--
-- Name: laboratories laboratories_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.laboratories
    ADD CONSTRAINT laboratories_pkey PRIMARY KEY (survey_id);


--
-- Name: malaria_key_performance_indicators malaria_key_performance_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malaria_key_performance_indicators
    ADD CONSTRAINT malaria_key_performance_indicators_pkey PRIMARY KEY (survey_id);


--
-- Name: malaria_treatment_guidelines malaria_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malaria_treatment_guidelines
    ADD CONSTRAINT malaria_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: malnutrition_key_performance_indicators malnutrition_key_performance_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malnutrition_key_performance_indicators
    ADD CONSTRAINT malnutrition_key_performance_indicators_pkey PRIMARY KEY (survey_id);


--
-- Name: matenities matenities_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.matenities
    ADD CONSTRAINT matenities_pkey PRIMARY KEY (survey_id);


--
-- Name: maternal_and_neonatal_healths maternal_and_neonatal_healths_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.maternal_and_neonatal_healths
    ADD CONSTRAINT maternal_and_neonatal_healths_pkey PRIMARY KEY (id);


--
-- Name: maternity_treatment_guidelines maternity_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.maternity_treatment_guidelines
    ADD CONSTRAINT maternity_treatment_guidelines_pkey PRIMARY KEY (survey_id);


--
-- Name: meeting_frequencies meeting_frequencies_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.meeting_frequencies
    ADD CONSTRAINT meeting_frequencies_pkey PRIMARY KEY (id);


--
-- Name: meetings meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (id);


--
-- Name: monthly_data_reports monthly_data_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.monthly_data_reports
    ADD CONSTRAINT monthly_data_reports_pkey PRIMARY KEY (survey_id);


--
-- Name: ncd_community_screening_august_4_with_duplicates ncd_community_screening_august_4_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening_august_4_with_duplicates
    ADD CONSTRAINT ncd_community_screening_august_4_pkey PRIMARY KEY (id);


--
-- Name: ncd_community_screening_copy1 ncd_community_screening_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening_copy1
    ADD CONSTRAINT ncd_community_screening_copy1_pkey PRIMARY KEY (id);


--
-- Name: ncd_community_screening_full_with_duplicates ncd_community_screening_full_with_duplicates_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening_full_with_duplicates
    ADD CONSTRAINT ncd_community_screening_full_with_duplicates_pkey PRIMARY KEY (id);


--
-- Name: ncd_community_screening ncd_community_screening_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening
    ADD CONSTRAINT ncd_community_screening_pkey PRIMARY KEY (id);


--
-- Name: ncd_community_screening_old ncd_community_screening_updated_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_community_screening_old
    ADD CONSTRAINT ncd_community_screening_updated_copy1_pkey PRIMARY KEY (id);


--
-- Name: ncd_patient_age_ranges ncd_patient_age_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_age_ranges
    ADD CONSTRAINT ncd_patient_age_ranges_pkey PRIMARY KEY (id);


--
-- Name: ncd_patient_education_levels ncd_patient_education_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_education_levels
    ADD CONSTRAINT ncd_patient_education_levels_pkey PRIMARY KEY (id);


--
-- Name: ncd_patient_genders ncd_patient_genders_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_genders
    ADD CONSTRAINT ncd_patient_genders_pkey PRIMARY KEY (id);


--
-- Name: ncd_patient_illness_durations ncd_patient_illness_durations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncd_patient_illness_durations
    ADD CONSTRAINT ncd_patient_illness_durations_pkey PRIMARY KEY (id);


--
-- Name: ncds ncds_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncds
    ADD CONSTRAINT ncds_pkey PRIMARY KEY (survey_id);


--
-- Name: new_closing_balances new_closing_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_closing_balances
    ADD CONSTRAINT new_closing_balances_pkey PRIMARY KEY (id);


--
-- Name: new_diabetes_treatment_outcomes new_diabetes_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_diabetes_treatment_outcomes
    ADD CONSTRAINT new_diabetes_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: new_hypertension_treatment_outcomes_copy1 new_hypertension_treatment_outcomes_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_hypertension_treatment_outcomes_copy1
    ADD CONSTRAINT new_hypertension_treatment_outcomes_copy1_pkey PRIMARY KEY (id);


--
-- Name: new_hypertension_treatment_outcomes new_hypertension_treatment_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_hypertension_treatment_outcomes
    ADD CONSTRAINT new_hypertension_treatment_outcomes_pkey PRIMARY KEY (id);


--
-- Name: new_pharmacy_stock_values new_pharmacy_stock_values_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_pharmacy_stock_values
    ADD CONSTRAINT new_pharmacy_stock_values_pkey PRIMARY KEY (id);


--
-- Name: notice_boards notice_boards_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.notice_boards
    ADD CONSTRAINT notice_boards_pkey PRIMARY KEY (survey_id);


--
-- Name: organization_charts organization_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.organization_charts
    ADD CONSTRAINT organization_charts_pkey PRIMARY KEY (survey_id);


--
-- Name: patient_age_ranges patient_age_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_age_ranges
    ADD CONSTRAINT patient_age_ranges_pkey PRIMARY KEY (id);


--
-- Name: patient_arrival_perceptions patient_arrival_perceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_arrival_perceptions
    ADD CONSTRAINT patient_arrival_perceptions_pkey PRIMARY KEY (id);


--
-- Name: patient_education_levels patient_education_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_education_levels
    ADD CONSTRAINT patient_education_levels_pkey PRIMARY KEY (id);


--
-- Name: patient_genders patient_genders_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_genders
    ADD CONSTRAINT patient_genders_pkey PRIMARY KEY (id);


--
-- Name: patient_rights_and_responsibilitiesses patient_rights_and_responsibilitiesses_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_rights_and_responsibilitiesses
    ADD CONSTRAINT patient_rights_and_responsibilitiesses_pkey PRIMARY KEY (id);


--
-- Name: patient_satisfaction_basic_infos patient_satisfaction_basic_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT patient_satisfaction_basic_infos_pkey PRIMARY KEY (id);


--
-- Name: patient_satisfaction_ratings patient_satisfaction_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_ratings
    ADD CONSTRAINT patient_satisfaction_ratings_pkey PRIMARY KEY (id);


--
-- Name: patient_satisfaction_services patient_satisfaction_services_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_services
    ADD CONSTRAINT patient_satisfaction_services_pkey PRIMARY KEY (id);


--
-- Name: payables_registers payables_registers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.payables_registers
    ADD CONSTRAINT payables_registers_pkey PRIMARY KEY (survey_id);


--
-- Name: pharmacy_drugs pharmacy_drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_drugs
    ADD CONSTRAINT pharmacy_drugs_pkey PRIMARY KEY (id);


--
-- Name: pharmacy_management_drug_names pharmacy_management_drug_names_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_management_drug_names
    ADD CONSTRAINT pharmacy_management_drug_names_pkey PRIMARY KEY (id);


--
-- Name: pharmacy_reviews pharmacy_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_reviews
    ADD CONSTRAINT pharmacy_reviews_pkey PRIMARY KEY (survey_id);


--
-- Name: pharmacy_stock_values pharmacy_stock_values_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_stock_values
    ADD CONSTRAINT pharmacy_stock_values_pkey PRIMARY KEY (id);


--
-- Name: pharmacy_stocks pharmacy_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_stocks
    ADD CONSTRAINT pharmacy_stocks_pkey PRIMARY KEY (survey_id);


--
-- Name: pneumonia_key_performance_indicators pneumonia_key_performance_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pneumonia_key_performance_indicators
    ADD CONSTRAINT pneumonia_key_performance_indicators_pkey PRIMARY KEY (survey_id);


--
-- Name: pneumonia_treatment_guidelines pneumonia_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pneumonia_treatment_guidelines
    ADD CONSTRAINT pneumonia_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: project_data_copy18022026 project_data_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data_copy18022026
    ADD CONSTRAINT project_data_copy1_pkey PRIMARY KEY (id);


--
-- Name: project_data project_data_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data
    ADD CONSTRAINT project_data_pkey PRIMARY KEY (id);


--
-- Name: project_question_categories project_question_categories_category_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_question_categories
    ADD CONSTRAINT project_question_categories_category_key UNIQUE (category);


--
-- Name: project_question_categories project_question_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_question_categories
    ADD CONSTRAINT project_question_categories_pkey PRIMARY KEY (id);


--
-- Name: project_questions_copy1 project_questions_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions_copy1
    ADD CONSTRAINT project_questions_copy1_pkey PRIMARY KEY (id);


--
-- Name: project_questions_copy1 project_questions_copy1_question_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions_copy1
    ADD CONSTRAINT project_questions_copy1_question_key UNIQUE (question);


--
-- Name: project_questions_maps project_questions_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions_maps
    ADD CONSTRAINT project_questions_maps_pkey PRIMARY KEY (project_id, question_id);


--
-- Name: project_questions project_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions
    ADD CONSTRAINT project_questions_pkey PRIMARY KEY (id);


--
-- Name: project_questions project_questions_question_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions
    ADD CONSTRAINT project_questions_question_key UNIQUE (question);


--
-- Name: project_statuses project_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_statuses
    ADD CONSTRAINT project_statuses_pkey PRIMARY KEY (id);


--
-- Name: projects projects_name_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_name_key UNIQUE (name);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: qi_plans qi_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qi_plans
    ADD CONSTRAINT qi_plans_pkey PRIMARY KEY (survey_id);


--
-- Name: qr_code_types qr_code_types_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_code_types
    ADD CONSTRAINT qr_code_types_pkey PRIMARY KEY (id);


--
-- Name: qr_codes qr_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT qr_codes_pkey PRIMARY KEY (id);


--
-- Name: question_categories_maps question_categories_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.question_categories_maps
    ADD CONSTRAINT question_categories_maps_pkey PRIMARY KEY (question_id, category_id);


--
-- Name: receivables_registers receivables_registers_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.receivables_registers
    ADD CONSTRAINT receivables_registers_pkey PRIMARY KEY (survey_id);


--
-- Name: receptionists receptionists_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.receptionists
    ADD CONSTRAINT receptionists_pkey PRIMARY KEY (survey_id);


--
-- Name: referral_process_treatment_guidelines referral_process_treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.referral_process_treatment_guidelines
    ADD CONSTRAINT referral_process_treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: safety_managements safety_managements_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.safety_managements
    ADD CONSTRAINT safety_managements_pkey PRIMARY KEY (survey_id);


--
-- Name: sanitations sanitations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.sanitations
    ADD CONSTRAINT sanitations_pkey PRIMARY KEY (survey_id);


--
-- Name: staff_informations staff_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.staff_informations
    ADD CONSTRAINT staff_informations_pkey PRIMARY KEY (survey_id);


--
-- Name: stock_managements_copy1 stock_managements_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.stock_managements_copy1
    ADD CONSTRAINT stock_managements_copy1_pkey PRIMARY KEY (id);


--
-- Name: stock_managements stock_managements_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.stock_managements
    ADD CONSTRAINT stock_managements_pkey PRIMARY KEY (id);


--
-- Name: survey_basic_informations survey_basic_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.survey_basic_informations
    ADD CONSTRAINT survey_basic_informations_pkey PRIMARY KEY (survey_id);


--
-- Name: titualaires titualaires_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.titualaires
    ADD CONSTRAINT titualaires_pkey PRIMARY KEY (survey_id);


--
-- Name: toilets toilets_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT toilets_pkey PRIMARY KEY (survey_id);


--
-- Name: toilets_1 toilets_pkey_1; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.toilets_1
    ADD CONSTRAINT toilets_pkey_1 PRIMARY KEY (survey_id);


--
-- Name: transaction_expense_reviews transaction_expense_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.transaction_expense_reviews
    ADD CONSTRAINT transaction_expense_reviews_pkey PRIMARY KEY (id);


--
-- Name: transaction_expense_reviews transaction_expense_reviews_reference_number_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.transaction_expense_reviews
    ADD CONSTRAINT transaction_expense_reviews_reference_number_key UNIQUE (reference_number);


--
-- Name: treatment_guidelines treatment_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.treatment_guidelines
    ADD CONSTRAINT treatment_guidelines_pkey PRIMARY KEY (id);


--
-- Name: treatment_guidelines uq_survey_guideline; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.treatment_guidelines
    ADD CONSTRAINT uq_survey_guideline UNIQUE (survey_id, treatment_guideline);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vaccinations vaccinations_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.vaccinations
    ADD CONSTRAINT vaccinations_pkey PRIMARY KEY (survey_id);


--
-- Name: validation_rules validation_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.validation_rules
    ADD CONSTRAINT validation_rules_pkey PRIMARY KEY (id);


--
-- Name: work_schedules work_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.work_schedules
    ADD CONSTRAINT work_schedules_pkey PRIMARY KEY (survey_id);


--
-- Name: idx_data_accuracies_survey_source; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_data_accuracies_survey_source ON public.data_accuracies USING btree (survey_id, source);


--
-- Name: idx_dispensary_managements_drug; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_dispensary_managements_drug ON public.dispensary_managements USING btree (drug_name);


--
-- Name: idx_dispensary_managements_survey_drug; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_dispensary_managements_survey_drug ON public.dispensary_managements USING btree (survey_id, drug_name);


--
-- Name: idx_health_centers_district; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_health_centers_district ON public.health_centers USING btree (district_id);


--
-- Name: idx_pharmacy_drugs_is_novartis; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_pharmacy_drugs_is_novartis ON public.pharmacy_drugs USING btree (drug_name) WHERE (is_novartis = true);


--
-- Name: idx_pharmacy_drugs_name; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_pharmacy_drugs_name ON public.pharmacy_drugs USING btree (drug_name);


--
-- Name: idx_project_data_health_center; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_project_data_health_center ON public.project_data USING btree (health_center_id);


--
-- Name: idx_project_data_health_center_copy1; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_project_data_health_center_copy1 ON public.project_data_copy18022026 USING btree (health_center_id);


--
-- Name: idx_project_data_project_healthcenter_active; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_project_data_project_healthcenter_active ON public.project_data USING btree (project_id, health_center_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_project_data_project_healthcenter_active_copy1; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_project_data_project_healthcenter_active_copy1 ON public.project_data_copy18022026 USING btree (project_id, health_center_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_projects_name_trgm; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_projects_name_trgm ON public.projects USING gin (lower(name) public.gin_trgm_ops);


--
-- Name: idx_qr_codes_type_active_hc; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_qr_codes_type_active_hc ON public.qr_codes USING btree (type_id, is_active, health_center_id);


--
-- Name: idx_stock_managements_drug; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_stock_managements_drug ON public.stock_managements USING btree (drug_name);


--
-- Name: idx_stock_managements_survey_drug; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE INDEX idx_stock_managements_survey_drug ON public.stock_managements USING btree (survey_id, drug_name);


--
-- Name: idx_survey_education; Type: INDEX; Schema: public; Owner: health_builders
--

CREATE UNIQUE INDEX idx_survey_education ON public.health_educations USING btree (survey_id, education_session);


--
-- Name: _41_1_dispensary_tallysheet_tracking _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_1_dispensary_tallysheet_tracking AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS amitriptyline_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS metformin_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS methyldopa_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS nifedipine_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS amilodipine_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS hydrochlorothiazide_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS beclomethasone_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS amoxicillin_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS atenolol_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS captopril_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS ciprofloxacin_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS cotrimoxazole_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS dexamethasone_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS diazepam_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS diclofenac_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS glibenclamide_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS oxyctocin_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS paracetamol_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS salbutamol_tallysheet,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) AS vitamin_tallysheet,
    20 AS expected_drugs,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS total_available_drugs,
    (((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) AS tracking_consumption_count,
    round((((((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.available AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
            ELSE 0
        END)))::numeric / (NULLIF(sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END), 0))::numeric), 2) AS consumption_ratio,
        CASE
            WHEN (round((((((((((((((((((((((max(
            CASE
                WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.available AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_used_throughout_the_day) THEN 1
                ELSE 0
            END)))::numeric / (NULLIF(sum(
            CASE
                WHEN d.available THEN 1
                ELSE 0
            END), 0))::numeric), 2) > 0.85) THEN 1
            ELSE 0
        END AS _41_1_tallysheets_used_to_track_consumption
   FROM (((public.qr_codes q
     LEFT JOIN public.dispensary_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, ds.district, hc.name, hc.type, q.district_id, q.health_center_id;


--
-- Name: _41_25_to26_committee_meetings _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_25_to26_committee_meetings AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
        CASE
            WHEN (count(
            CASE
                WHEN ((f.meeting_id = 3) AND (f.frequency_id = 1)) THEN 1
                ELSE NULL::integer
            END) > 0) THEN 1
            ELSE 0
        END AS _41_25_coge_meeting,
        CASE
            WHEN (count(
            CASE
                WHEN ((f.meeting_id = 2) AND (f.frequency_id = 2)) THEN 1
                ELSE NULL::integer
            END) > 0) THEN 1
            ELSE 0
        END AS _41_26_cosa_meeting
   FROM (((public.qr_codes qr
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
     LEFT JOIN public.frequency_of_committee_meetings f ON ((qr.id = f.survey_id)))
  WHERE (f.meeting_id = ANY (ARRAY[(2)::bigint, (3)::bigint]))
  GROUP BY qr.id, ds.district, hc.name, hc.type, qr.district_id, qr.health_center_id;


--
-- Name: _41_27_job_description_main _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_27_job_description_main AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    count(
        CASE
            WHEN jd.file_available THEN 1
            ELSE 0
        END) AS available_count,
    sum(
        CASE
            WHEN jd.file_available THEN 1
            ELSE 0
        END) AS available_sum,
    sum(
        CASE
            WHEN jd.file_signed_by_employer THEN 1
            ELSE 0
        END) AS signed_by_employer_count,
    sum(
        CASE
            WHEN jd.file_signed_by_employee THEN 1
            ELSE 0
        END) AS signed_by_employee_count,
        CASE
            WHEN (sum(
            CASE
                WHEN (jd.file_available AND jd.file_signed_by_employer AND jd.file_signed_by_employee) THEN 1
                ELSE 0
            END) = 9) THEN 1
            ELSE 0
        END AS _41_27_current_job_descriptions_written_for_each_leader
   FROM (((public.qr_codes qr
     LEFT JOIN public.job_descriptions jd ON ((qr.id = jd.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  GROUP BY qr.id, ds.district, hc.name, hc.type, qr.district_id, qr.health_center_id;


--
-- Name: _41_2_to3_dispensary_consumption_tracking _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_2_to3_dispensary_consumption_tracking AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS amitriptyline_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS metformin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS methyldopa_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS nifedipine_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS amilodipine_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS hydrochlorothiazide_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS beclomethasone_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS amoxicillin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS atenolol_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS captopril_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS ciprofloxacin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS cotrimoxazole_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS dexamethasone_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS diazepam_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS diclofenac_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS glibenclamide_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS oxyctocin_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS paracetamol_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS salbutamol_consumption_reg,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) AS vitamin_consumption_reg,
    (((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) AS updated_consumption_reg_count,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS total_available_drugs,
    20 AS expected_drugs,
    round((((((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
            ELSE 0
        END)))::numeric / (NULLIF(sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END), 0))::numeric), 2) AS updated_consumption_reg_ratio,
        CASE
            WHEN (round((((((((((((((((((((((max(
            CASE
                WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.consumption_register_up_to_date) THEN 1
                ELSE 0
            END)))::numeric / (NULLIF(sum(
            CASE
                WHEN d.available THEN 1
                ELSE 0
            END), 0))::numeric), 2) > 0.85) THEN 1
            ELSE 0
        END AS _41_2_drugs_have_an_updated_consumption_register,
    (pr.dispensary_consumption_register_available)::integer AS _41_3_consumption_register_available_in_dispensary
   FROM ((((public.qr_codes q
     LEFT JOIN public.dispensary_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.pharmacy_reviews pr ON ((q.id = pr.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, ds.district, hc.name, hc.type, q.district_id, q.health_center_id, pr.dispensary_consumption_register_available;


--
-- Name: _41_30_opd_registers_completeness _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_30_opd_registers_completeness AS
 SELECT qr.id AS survey_id,
    qr.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    count(copd.id) AS total_count_of_records,
    sum(copd.number_of_fields) AS number_of_fields,
    sum(copd.number_of_blanks) AS number_of_blanks,
    sum((copd.number_of_fields - copd.number_of_blanks)) AS number_of_completed,
        CASE
            WHEN (sum((copd.number_of_fields - copd.number_of_blanks)) > (0)::numeric) THEN (sum((copd.number_of_fields - copd.number_of_blanks)) / NULLIF(sum(copd.number_of_fields), (0)::numeric))
            ELSE (0)::numeric
        END AS completed_ratio,
        CASE
            WHEN ((sum((copd.number_of_fields - copd.number_of_blanks)) / NULLIF(sum(copd.number_of_fields), (0)::numeric)) > 0.8) THEN 1
            ELSE 0
        END AS _41_30_lines_of_register_80_percent_complete
   FROM (((public.qr_codes qr
     LEFT JOIN public.completeness_of_opd_registers copd ON ((qr.id = copd.survey_id)))
     LEFT JOIN public.districts ds ON ((qr.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
  GROUP BY qr.id, ds.district, hc.name, hc.type, qr.district_id, qr.health_center_id;


--
-- Name: _41_4_dispensary_tallysheet_match_consumption _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_4_dispensary_tallysheet_match_consumption AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS amitriptyline_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS metformin_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS methyldopa_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS nifedipine_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS amilodipine_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS hydrochlorothiazide_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS beclomethasone_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS amoxicillin_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS atenolol_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS captopril_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS ciprofloxacin_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS cotrimoxazole_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS dexamethasone_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS diazepam_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS diclofenac_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS glibenclamide_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS oxyctocin_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS paracetamol_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS salbutamol_tallysheet_match_consumption,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) AS vitamin_tallysheet_match_consumption,
    20 AS expected_drugs,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS total_available_drugs,
    (((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) AS accurate_tallysheet_count,
    round((((((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
            ELSE 0
        END)))::numeric / (NULLIF(sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END), 0))::numeric), 2) AS acurate_tallysheet_ratio,
        CASE
            WHEN (round((((((((((((((((((((((max(
            CASE
                WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.tally_sheets_match_consumption_register) THEN 1
                ELSE 0
            END)))::numeric / (NULLIF(sum(
            CASE
                WHEN d.available THEN 1
                ELSE 0
            END), 0))::numeric), 2) > 0.85) THEN 1
            ELSE 0
        END AS _41_4_drugs_have_accurate_tallysheets
   FROM (((public.qr_codes q
     LEFT JOIN public.dispensary_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, ds.district, hc.name, hc.type, q.district_id, q.health_center_id;


--
-- Name: _41_5_to6_stockcard_shelf_quantity _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_5_to6_stockcard_shelf_quantity AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS amitriptyline_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS metformin_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS methyldopa_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS nifedipine_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS amilodipine_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS hydrochlorothiazide_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS beclomethasone_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS amoxicillin_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS atenolol_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS captopril_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS ciprofloxacin_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS cotrimoxazole_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS dexamethasone_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS diazepam_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS diclofenac_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS glibenclamide_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS oxyctocin_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS paracetamol_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS salbutamol_card_matches_shelf,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) AS vitamin_card_matches_shelf,
    20 AS expected_drugs,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS total_available_drugs,
    (((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) AS matched_quantity_count,
    round(((((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
            ELSE 0
        END)))::numeric / (NULLIF(sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END), 0))::numeric), 2) AS matched_quantity_ratio,
        CASE
            WHEN (round(((((((((((((((((((((max(
            CASE
                WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND (d.quantity_listed_on_stock_card = d.quantity_on_shelf)) THEN 1
                ELSE 0
            END)))::numeric / (NULLIF(sum(
            CASE
                WHEN d.available THEN 1
                ELSE 0
            END), 0))::numeric), 2) > 0.85) THEN 1
            ELSE 0
        END AS _41_5_drugs_on_card_matched_shelf_quantity,
        CASE
            WHEN pr.requisitions_signed_and_stamped THEN 1
            ELSE 0
        END AS _41_6_requisitions_signed_and_stamped
   FROM ((((public.qr_codes q
     LEFT JOIN public.stock_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.pharmacy_reviews pr ON ((q.id = pr.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, ds.district, hc.name, hc.type, q.district_id, q.health_center_id, pr.requisitions_signed_and_stamped;


--
-- Name: _41_7_stock_management_drugs_care _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public._41_7_stock_management_drugs_care AS
 SELECT q.id AS survey_id,
    q.survey_year,
    ds.district,
    hc.name AS health_facility,
    hc.type AS facility_type,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS amitriptyline_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS metformin_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS methyldopa_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS nifedipine_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS amilodipine_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS hydrochlorothiazide_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS beclomethasone_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS amoxicillin_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS atenolol_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS captopril_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS ciprofloxacin_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS cotrimoxazole_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS dexamethasone_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS diazepam_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS diclofenac_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS glibenclamide_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS oxyctocin_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS paracetamol_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS salbutamol_labeled,
    max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) AS vitamin_labeled,
    max(
        CASE
            WHEN pr.drugs_protected_from_direct_sunlight THEN 1
            ELSE 0
        END) AS drugs_protected_from_direct_sunlight,
    max(
        CASE
            WHEN pr.drugs_well_organized THEN 1
            ELSE 0
        END) AS drugs_well_organized,
    (((((((((((((((((((((max(
        CASE
            WHEN pr.drugs_protected_from_direct_sunlight THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN pr.drugs_well_organized THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) AS drugs_labeled_organized_protected_count,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS drugs_labeled_organized_protected,
    20 AS expected_drugs,
    sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) AS total_available_drugs,
    round((((((((((((((((((((((((max(
        CASE
            WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.drug_properly_labeled) THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN pr.drugs_protected_from_direct_sunlight THEN 1
            ELSE 0
        END)) + max(
        CASE
            WHEN pr.drugs_well_organized THEN 1
            ELSE 0
        END)))::numeric / (NULLIF((sum(
        CASE
            WHEN d.available THEN 1
            ELSE 0
        END) + 2), 0))::numeric), 2) AS labeled_organized_protected_ratio,
        CASE
            WHEN (round((((((((((((((((((((((((max(
            CASE
                WHEN ((d.drug_name ~~ '%Amitriptyline Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Metformin%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Methyldopa%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Nifedipine%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amilodipine%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Hydrochlorothiazide%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Beclomethasone Spray%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Amoxicillin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Atenolol Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Captopril Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Ciprofloxacin Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Co-trimoxazole Suspension%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Dexamethasone Inj.%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diazepam Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Diclofenac Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Glibenclamide Capsule/Tablet%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Oxyctocin Inj. Ampulses%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Paracetamol Oral Suspension%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Salbutamol Inhaler%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN ((d.drug_name ~~ '%Vitamin K Inj.%'::text) AND d.drug_properly_labeled) THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN pr.drugs_protected_from_direct_sunlight THEN 1
                ELSE 0
            END)) + max(
            CASE
                WHEN pr.drugs_well_organized THEN 1
                ELSE 0
            END)))::numeric / (NULLIF((sum(
            CASE
                WHEN d.available THEN 1
                ELSE 0
            END) + 2), 0))::numeric), 2) > 0.85) THEN 1
            ELSE 0
        END AS _41_7_drugs_are_labeled_organized_protected
   FROM ((((public.qr_codes q
     LEFT JOIN public.stock_managements d ON ((q.id = d.survey_id)))
     LEFT JOIN public.pharmacy_reviews pr ON ((q.id = pr.survey_id)))
     LEFT JOIN public.districts ds ON ((q.district_id = ds.id)))
     LEFT JOIN public.health_centers hc ON ((q.health_center_id = hc.id)))
  GROUP BY q.id, ds.district, hc.name, hc.type, q.district_id, q.health_center_id, pr.drugs_well_organized;


--
-- Name: v_hb_projects_data _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public.v_hb_projects_data AS
 SELECT p.name AS project_name,
    p.description,
    p.status_id,
    d.district AS district_name,
    hc.name AS health_center_name,
    pd.year,
    pd.month,
    (pd.start_date)::date AS start_date,
    (pd.end_date)::date AS end_date,
    date_part('month'::text, pd.end_date) AS end_date_month,
    date_part('year'::text, pd.created_at) AS record_year,
    date_part('month'::text, pd.created_at) AS record_month,
    pq.id AS question_id,
    pq.question,
    pqc.category,
        CASE
            WHEN (pd.answer ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (pd.answer)::numeric
            ELSE NULL::numeric
        END AS response,
    u.first_name AS created_by
   FROM ((((((public.project_data pd
     LEFT JOIN public.projects p ON ((pd.project_id = p.id)))
     LEFT JOIN public.project_questions pq ON ((pd.question_id = pq.id)))
     LEFT JOIN public.project_question_categories pqc ON ((pd.category_id = pqc.id)))
     LEFT JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     LEFT JOIN public.districts d ON ((hc.district_id = d.id)))
     LEFT JOIN public.users u ON ((pd.created_by = u.id)))
  GROUP BY pd.project_id, pd.health_center_id, pd.year, pd.month, hc.district, p.name, p.description, p.status_id, d.district, hc.name, pd.created_at, pq.id, pqc.category, pd.answer, u.first_name, pd.start_date, pd.end_date;


--
-- Name: v_hb_projects_data_HMS _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public."v_hb_projects_data_HMS" AS
 SELECT p.name AS project_name,
    p.description,
    p.status_id,
    d.district AS district_name,
    hc.name AS health_center_name,
    pd.year,
    pd.month,
    (pd.start_date)::date AS start_date,
    (pd.end_date)::date AS end_date,
    date_part('month'::text, pd.end_date) AS end_date_month,
    date_part('year'::text, pd.created_at) AS record_year,
    date_part('month'::text, pd.created_at) AS record_month,
    pq.id AS question_id,
    pq.question,
    pqc.category,
        CASE
            WHEN (pd.answer ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (pd.answer)::numeric
            ELSE NULL::numeric
        END AS response,
    u.first_name AS created_by
   FROM ((((((public.project_data pd
     LEFT JOIN public.projects p ON ((pd.project_id = p.id)))
     LEFT JOIN public.project_questions pq ON ((pd.question_id = pq.id)))
     LEFT JOIN public.project_question_categories pqc ON ((pd.category_id = pqc.id)))
     LEFT JOIN public.health_centers hc ON ((pd.health_center_id = hc.id)))
     LEFT JOIN public.districts d ON ((hc.district_id = d.id)))
     LEFT JOIN public.users u ON ((pd.created_by = u.id)))
  WHERE (pd.project_id = ANY (ARRAY['13658817-6375-47c8-aba6-3f7f197271dd'::text, '3fcd71ff-f277-4bec-8bdf-740e3dc29688'::text]))
  GROUP BY pd.project_id, pd.health_center_id, pd.year, pd.month, hc.district, p.name, p.description, p.status_id, d.district, hc.name, pd.created_at, pq.id, pqc.category, pd.answer, u.first_name, pd.start_date, pd.end_date;


--
-- Name: v_patient_satisfaction _RETURN; Type: RULE; Schema: public; Owner: health_builders
--

CREATE OR REPLACE VIEW public.v_patient_satisfaction AS
 SELECT subquery."Patient_id",
    subquery.survey_id,
    subquery.survey_year,
    subquery.health_facility,
    subquery.facility_type,
    subquery.district AS district_name,
    subquery.created_at,
    subquery."Service",
    subquery."Gender",
    subquery."Age",
    subquery."Education_level",
    subquery.good_score_count,
    subquery.total_answers,
    subquery.opinions_about_quality_of_service,
    subquery.knowledge_on_rights_and_responsibilities,
    subquery.privacy_and_confidentiality_respected,
    subquery.payment_process_satisfaction,
    subquery.water_facilitation_on_firt_dose,
    subquery.facility_hygiene_satisfaction,
    subquery.likely_to_recommend_relatives_to_the_facility,
    subquery.overral_satisfaction_for_delivered_services,
    subquery.cashier_respect_satisfaction,
    subquery.treating_nurse_respect_satisfaction,
    subquery.lab_technician_respect_satisfaction,
    subquery.dispensing_nurse_respect_satisfaction,
    subquery.medical_insurance_agent_respect_satisfaction,
    subquery.medical_courtesy_satisfaction,
    subquery.facility_safety_satisfaction,
    subquery.medical_attention_satisfaction,
    subquery.health_status_explanation_satisfaction,
    subquery.lab_results_explanation_satisfaction,
    subquery.medicine_use_explanation_satisfaction,
    subquery.next_given_appointment_satisfaction,
    subquery.orientation_satisfaction,
    subquery.health_education_satisfaction,
    subquery.customer_care_satisfaction,
    subquery.reception_waiting_time,
    subquery.cashier_waiting_time,
    subquery.consultation_wiating_area_waiting_time,
    subquery.laboratory_waiting_time,
    subquery.laboratory_results_waiting_time,
    subquery.billing_station_waiting_time,
    subquery.info_about_delays_satisfaction,
    subquery.pharmacy_waiting_time,
    subquery.communicated_language_satisfaction,
    subquery.differentiates_staff,
    subquery.department_signages_helpful,
    subquery.suggestion,
    round((((subquery.good_score_count)::numeric * 100.0) / (NULLIF(subquery.total_answers, 0))::numeric), 0) AS good_score_percentage
   FROM ( SELECT patient_satisfaction_basic_infos.id AS "Patient_id",
            patient_satisfaction_basic_infos.survey_id,
            qr.survey_year,
            hc.name AS health_facility,
            hc.type AS facility_type,
            d.district,
            patient_satisfaction_basic_infos.created_at,
            patient_satisfaction_services.value AS "Service",
            patient_genders.value AS "Gender",
            patient_age_ranges.value AS "Age",
            patient_education_levels.value AS "Education_level",
            (((((((((((((((((((((((((((((((((
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.opinions_about_quality_of_service = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.knowledge_on_rights_and_responsibilities = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.privacy_and_confidentiality_respected = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.payment_process_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.water_facilitation_on_firt_dose = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.facility_hygiene_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.likely_to_recommend_relatives_to_the_facility = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.overral_satisfaction_for_delivered_services = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.cashier_respect_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.treating_nurse_respect_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.lab_technician_respect_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.dispensing_nurse_respect_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medical_insurance_agent_respect_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medical_courtesy_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.facility_safety_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medical_attention_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.health_status_explanation_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.lab_results_explanation_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medicine_use_explanation_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.next_given_appointment_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.orientation_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.health_education_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.customer_care_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.reception_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.cashier_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.consultation_wiating_area_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.laboratory_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.laboratory_results_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.billing_station_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.info_about_delays_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.pharmacy_waiting_time = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.communicated_language_satisfaction = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.differentiates_staff = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.department_signages_helpful = ANY (ARRAY[(4)::bigint, (5)::bigint])) THEN 1
                    ELSE 0
                END) AS good_score_count,
            (((((((((((((((((((((((((((((((((
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.opinions_about_quality_of_service IS NOT NULL) THEN 1
                    ELSE 0
                END +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.knowledge_on_rights_and_responsibilities IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.privacy_and_confidentiality_respected IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.payment_process_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.water_facilitation_on_firt_dose IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.facility_hygiene_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.likely_to_recommend_relatives_to_the_facility IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_rights_and_responsibilitiesses.overral_satisfaction_for_delivered_services IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.cashier_respect_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.treating_nurse_respect_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.lab_technician_respect_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.dispensing_nurse_respect_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medical_insurance_agent_respect_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medical_courtesy_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.facility_safety_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medical_attention_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.health_status_explanation_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.lab_results_explanation_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.medicine_use_explanation_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.next_given_appointment_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.orientation_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (information_delivery_and_support_satisfactions.health_education_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.customer_care_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.reception_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.cashier_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.consultation_wiating_area_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.laboratory_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.laboratory_results_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.billing_station_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.info_about_delays_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.pharmacy_waiting_time IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.communicated_language_satisfaction IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.differentiates_staff IS NOT NULL) THEN 1
                    ELSE 0
                END) +
                CASE
                    WHEN (patient_arrival_perceptions.department_signages_helpful IS NOT NULL) THEN 1
                    ELSE 0
                END) AS total_answers,
            patient_rights_and_responsibilitiesses.opinions_about_quality_of_service,
            patient_rights_and_responsibilitiesses.knowledge_on_rights_and_responsibilities,
            patient_rights_and_responsibilitiesses.privacy_and_confidentiality_respected,
            patient_rights_and_responsibilitiesses.payment_process_satisfaction,
            patient_rights_and_responsibilitiesses.water_facilitation_on_firt_dose,
            patient_rights_and_responsibilitiesses.facility_hygiene_satisfaction,
            patient_rights_and_responsibilitiesses.likely_to_recommend_relatives_to_the_facility,
            patient_rights_and_responsibilitiesses.overral_satisfaction_for_delivered_services,
            information_delivery_and_support_satisfactions.cashier_respect_satisfaction,
            information_delivery_and_support_satisfactions.treating_nurse_respect_satisfaction,
            information_delivery_and_support_satisfactions.lab_technician_respect_satisfaction,
            information_delivery_and_support_satisfactions.dispensing_nurse_respect_satisfaction,
            information_delivery_and_support_satisfactions.medical_insurance_agent_respect_satisfaction,
            information_delivery_and_support_satisfactions.medical_courtesy_satisfaction,
            information_delivery_and_support_satisfactions.facility_safety_satisfaction,
            information_delivery_and_support_satisfactions.medical_attention_satisfaction,
            information_delivery_and_support_satisfactions.health_status_explanation_satisfaction,
            information_delivery_and_support_satisfactions.lab_results_explanation_satisfaction,
            information_delivery_and_support_satisfactions.medicine_use_explanation_satisfaction,
            information_delivery_and_support_satisfactions.next_given_appointment_satisfaction,
            information_delivery_and_support_satisfactions.orientation_satisfaction,
            information_delivery_and_support_satisfactions.health_education_satisfaction,
            patient_arrival_perceptions.customer_care_satisfaction,
            patient_arrival_perceptions.reception_waiting_time,
            patient_arrival_perceptions.cashier_waiting_time,
            patient_arrival_perceptions.consultation_wiating_area_waiting_time,
            patient_arrival_perceptions.laboratory_waiting_time,
            patient_arrival_perceptions.laboratory_results_waiting_time,
            patient_arrival_perceptions.billing_station_waiting_time,
            patient_arrival_perceptions.info_about_delays_satisfaction,
            patient_arrival_perceptions.pharmacy_waiting_time,
            patient_arrival_perceptions.communicated_language_satisfaction,
            patient_arrival_perceptions.differentiates_staff,
            patient_arrival_perceptions.department_signages_helpful,
            additional_suggestions.suggestion
           FROM (((((((((((public.patient_age_ranges
             LEFT JOIN public.patient_satisfaction_basic_infos ON ((patient_age_ranges.id = patient_satisfaction_basic_infos.age)))
             LEFT JOIN public.patient_education_levels ON ((patient_satisfaction_basic_infos.education_level = patient_education_levels.id)))
             LEFT JOIN public.patient_genders ON ((patient_satisfaction_basic_infos.gender = patient_genders.id)))
             LEFT JOIN public.patient_arrival_perceptions ON ((patient_satisfaction_basic_infos.id = patient_arrival_perceptions.patient_id)))
             LEFT JOIN public.patient_rights_and_responsibilitiesses ON ((patient_satisfaction_basic_infos.id = patient_rights_and_responsibilitiesses.patient_id)))
             LEFT JOIN public.patient_satisfaction_services ON ((patient_satisfaction_basic_infos.service = patient_satisfaction_services.id)))
             LEFT JOIN public.information_delivery_and_support_satisfactions ON ((patient_satisfaction_basic_infos.id = information_delivery_and_support_satisfactions.patient_id)))
             LEFT JOIN public.additional_suggestions ON ((patient_satisfaction_basic_infos.id = additional_suggestions.patient_id)))
             LEFT JOIN public.qr_codes qr ON ((patient_satisfaction_basic_infos.survey_id = qr.id)))
             LEFT JOIN public.districts d ON ((qr.district_id = d.id)))
             LEFT JOIN public.health_centers hc ON ((qr.health_center_id = hc.id)))
          GROUP BY patient_satisfaction_basic_infos.id, d.district, hc.name, hc.type, qr.survey_year, qr.district_id, qr.health_center_id, patient_satisfaction_services.value, patient_genders.value, patient_age_ranges.value, patient_education_levels.value, patient_rights_and_responsibilitiesses.opinions_about_quality_of_service, patient_rights_and_responsibilitiesses.knowledge_on_rights_and_responsibilities, patient_rights_and_responsibilitiesses.privacy_and_confidentiality_respected, patient_rights_and_responsibilitiesses.payment_process_satisfaction, patient_rights_and_responsibilitiesses.water_facilitation_on_firt_dose, patient_rights_and_responsibilitiesses.facility_hygiene_satisfaction, patient_rights_and_responsibilitiesses.likely_to_recommend_relatives_to_the_facility, patient_rights_and_responsibilitiesses.overral_satisfaction_for_delivered_services, information_delivery_and_support_satisfactions.cashier_respect_satisfaction, information_delivery_and_support_satisfactions.treating_nurse_respect_satisfaction, information_delivery_and_support_satisfactions.lab_technician_respect_satisfaction, information_delivery_and_support_satisfactions.dispensing_nurse_respect_satisfaction, information_delivery_and_support_satisfactions.medical_insurance_agent_respect_satisfaction, information_delivery_and_support_satisfactions.medical_courtesy_satisfaction, information_delivery_and_support_satisfactions.facility_safety_satisfaction, information_delivery_and_support_satisfactions.medical_attention_satisfaction, information_delivery_and_support_satisfactions.health_status_explanation_satisfaction, information_delivery_and_support_satisfactions.lab_results_explanation_satisfaction, information_delivery_and_support_satisfactions.medicine_use_explanation_satisfaction, information_delivery_and_support_satisfactions.next_given_appointment_satisfaction, information_delivery_and_support_satisfactions.orientation_satisfaction, information_delivery_and_support_satisfactions.health_education_satisfaction, patient_arrival_perceptions.customer_care_satisfaction, patient_arrival_perceptions.reception_waiting_time, patient_arrival_perceptions.cashier_waiting_time, patient_arrival_perceptions.consultation_wiating_area_waiting_time, patient_arrival_perceptions.laboratory_waiting_time, patient_arrival_perceptions.laboratory_results_waiting_time, patient_arrival_perceptions.billing_station_waiting_time, patient_arrival_perceptions.info_about_delays_satisfaction, patient_arrival_perceptions.pharmacy_waiting_time, patient_arrival_perceptions.communicated_language_satisfaction, patient_arrival_perceptions.differentiates_staff, patient_arrival_perceptions.department_signages_helpful, additional_suggestions.suggestion) subquery;


--
-- Name: accountings fk_accountings_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.accountings
    ADD CONSTRAINT fk_accountings_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: accountings fk_accountings_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.accountings
    ADD CONSTRAINT fk_accountings_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: accounts fk_accounts_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_accounts_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: accounts fk_accounts_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_accounts_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: action_plans fk_action_plans_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.action_plans
    ADD CONSTRAINT fk_action_plans_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: action_plans fk_action_plans_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.action_plans
    ADD CONSTRAINT fk_action_plans_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: additional_pharmacy_informations fk_additional_pharmacy_informations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_pharmacy_informations
    ADD CONSTRAINT fk_additional_pharmacy_informations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: additional_pharmacy_informations fk_additional_pharmacy_informations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_pharmacy_informations
    ADD CONSTRAINT fk_additional_pharmacy_informations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: additional_suggestions fk_additional_suggestions_patient_satisfaction_basic_infos; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_suggestions
    ADD CONSTRAINT fk_additional_suggestions_patient_satisfaction_basic_infos FOREIGN KEY (patient_id) REFERENCES public.patient_satisfaction_basic_infos(id);


--
-- Name: additional_suggestions fk_additional_suggestions_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_suggestions
    ADD CONSTRAINT fk_additional_suggestions_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: additional_suggestions fk_additional_suggestions_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.additional_suggestions
    ADD CONSTRAINT fk_additional_suggestions_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: admitted_patients_outcomes fk_admitted_patients_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.admitted_patients_outcomes
    ADD CONSTRAINT fk_admitted_patients_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: admitted_patients_outcomes fk_admitted_patients_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.admitted_patients_outcomes
    ADD CONSTRAINT fk_admitted_patients_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: anc_treatment_guidelines fk_anc_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.anc_treatment_guidelines
    ADD CONSTRAINT fk_anc_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: anc_treatment_guidelines fk_anc_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.anc_treatment_guidelines
    ADD CONSTRAINT fk_anc_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: ancs fk_ancs_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ancs
    ADD CONSTRAINT fk_ancs_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: ancs fk_ancs_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ancs
    ADD CONSTRAINT fk_ancs_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: annual_malaria_prevention_plans fk_annual_malaria_prevention_plans_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.annual_malaria_prevention_plans
    ADD CONSTRAINT fk_annual_malaria_prevention_plans_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: annual_malaria_prevention_plans fk_annual_malaria_prevention_plans_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.annual_malaria_prevention_plans
    ADD CONSTRAINT fk_annual_malaria_prevention_plans_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: arvs fk_arvs_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.arvs
    ADD CONSTRAINT fk_arvs_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: arvs fk_arvs_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.arvs
    ADD CONSTRAINT fk_arvs_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: asthma_classifications fk_asthma_classifications_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.asthma_classifications
    ADD CONSTRAINT fk_asthma_classifications_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: asthma_classifications fk_asthma_classifications_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.asthma_classifications
    ADD CONSTRAINT fk_asthma_classifications_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: asthma_treatment_guidelines fk_asthma_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.asthma_treatment_guidelines
    ADD CONSTRAINT fk_asthma_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: asthma_treatment_guidelines fk_asthma_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.asthma_treatment_guidelines
    ADD CONSTRAINT fk_asthma_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: attendance_registers fk_attendance_registers_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.attendance_registers
    ADD CONSTRAINT fk_attendance_registers_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: attendance_registers fk_attendance_registers_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.attendance_registers
    ADD CONSTRAINT fk_attendance_registers_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: budgets fk_budgets_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT fk_budgets_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: budgets fk_budgets_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT fk_budgets_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: business_plans fk_business_plans_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.business_plans
    ADD CONSTRAINT fk_business_plans_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: business_plans fk_business_plans_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.business_plans
    ADD CONSTRAINT fk_business_plans_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: cardiomyopathy_treatment_guidelines fk_cardiomyopathy_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cardiomyopathy_treatment_guidelines
    ADD CONSTRAINT fk_cardiomyopathy_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: cardiomyopathy_treatment_guidelines fk_cardiomyopathy_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cardiomyopathy_treatment_guidelines
    ADD CONSTRAINT fk_cardiomyopathy_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: cardiomyopathy_treatment_outcomes fk_cardiomyopathy_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cardiomyopathy_treatment_outcomes
    ADD CONSTRAINT fk_cardiomyopathy_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: cardiomyopathy_treatment_outcomes fk_cardiomyopathy_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cardiomyopathy_treatment_outcomes
    ADD CONSTRAINT fk_cardiomyopathy_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: cashiers fk_cashiers_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cashiers
    ADD CONSTRAINT fk_cashiers_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: cashiers fk_cashiers_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cashiers
    ADD CONSTRAINT fk_cashiers_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: cehos fk_cehos_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cehos
    ADD CONSTRAINT fk_cehos_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: cehos fk_cehos_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cehos
    ADD CONSTRAINT fk_cehos_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: check_list_treatment_guidelines fk_check_list_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.check_list_treatment_guidelines
    ADD CONSTRAINT fk_check_list_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: check_list_treatment_guidelines fk_check_list_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.check_list_treatment_guidelines
    ADD CONSTRAINT fk_check_list_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: closing_balances fk_closing_balances_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.closing_balances
    ADD CONSTRAINT fk_closing_balances_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: closing_balances fk_closing_balances_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.closing_balances
    ADD CONSTRAINT fk_closing_balances_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: comments fk_comments_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_comments_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: comments fk_comments_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_comments_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: completeness_of_opd_registers fk_completeness_of_opd_registers_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.completeness_of_opd_registers
    ADD CONSTRAINT fk_completeness_of_opd_registers_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: completeness_of_opd_registers fk_completeness_of_opd_registers_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.completeness_of_opd_registers
    ADD CONSTRAINT fk_completeness_of_opd_registers_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: consultation_rooms fk_consultation_rooms_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.consultation_rooms
    ADD CONSTRAINT fk_consultation_rooms_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: consultation_rooms fk_consultation_rooms_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.consultation_rooms
    ADD CONSTRAINT fk_consultation_rooms_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: cough_treatment_guidelines fk_cough_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cough_treatment_guidelines
    ADD CONSTRAINT fk_cough_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: cough_treatment_guidelines fk_cough_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.cough_treatment_guidelines
    ADD CONSTRAINT fk_cough_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: customer_care_programs fk_customer_care_programs_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.customer_care_programs
    ADD CONSTRAINT fk_customer_care_programs_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: customer_care_programs fk_customer_care_programs_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.customer_care_programs
    ADD CONSTRAINT fk_customer_care_programs_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: data_accuracies fk_data_accuracies_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_accuracies
    ADD CONSTRAINT fk_data_accuracies_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: data_accuracies fk_data_accuracies_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_accuracies
    ADD CONSTRAINT fk_data_accuracies_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: data_management_sops fk_data_management_sops_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_management_sops
    ADD CONSTRAINT fk_data_management_sops_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: data_management_sops fk_data_management_sops_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_management_sops
    ADD CONSTRAINT fk_data_management_sops_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: data_managers fk_data_managers_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_managers
    ADD CONSTRAINT fk_data_managers_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: data_managers fk_data_managers_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.data_managers
    ADD CONSTRAINT fk_data_managers_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_clearances fk_diabetes_clearances_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_clearances
    ADD CONSTRAINT fk_diabetes_clearances_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_clearances fk_diabetes_clearances_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_clearances
    ADD CONSTRAINT fk_diabetes_clearances_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_glycemia_treatment_outcomes fk_diabetes_glycemia_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_glycemia_treatment_outcomes
    ADD CONSTRAINT fk_diabetes_glycemia_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_glycemia_treatment_outcomes fk_diabetes_glycemia_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_glycemia_treatment_outcomes
    ADD CONSTRAINT fk_diabetes_glycemia_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_hba1c_treatment_outcomes fk_diabetes_hba1c_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_hba1c_treatment_outcomes
    ADD CONSTRAINT fk_diabetes_hba1c_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_hba1c_treatment_outcomes fk_diabetes_hba1c_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_hba1c_treatment_outcomes
    ADD CONSTRAINT fk_diabetes_hba1c_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_pati818b1c7e; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_pati818b1c7e FOREIGN KEY (gender_id) REFERENCES public.ncd_patient_genders(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patib5235a1b; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patib5235a1b FOREIGN KEY (illness_duration_id) REFERENCES public.ncd_patient_illness_durations(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patid793246c; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patid793246c FOREIGN KEY (education_level_id) REFERENCES public.ncd_patient_education_levels(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patid7d039d7; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patid7d039d7 FOREIGN KEY (age_id) REFERENCES public.ncd_patient_age_ranges(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patie818b1c7; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patie818b1c7 FOREIGN KEY (gender_id) REFERENCES public.ncd_patient_genders(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patieb5235a1; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patieb5235a1 FOREIGN KEY (illness_duration_id) REFERENCES public.ncd_patient_illness_durations(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patied793246; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patied793246 FOREIGN KEY (education_level_id) REFERENCES public.ncd_patient_education_levels(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_ncd_patied7d039d; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_ncd_patied7d039d FOREIGN KEY (age_id) REFERENCES public.ncd_patient_age_ranges(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_knowledge_on_home_self_managements fk_diabetes_knowledge_on_home_self_managements_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_diabetes_knowledge_on_home_self_managements_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_nephropathy_prevalences fk_diabetes_nephropathy_prevalences_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_nephropathy_prevalences
    ADD CONSTRAINT fk_diabetes_nephropathy_prevalences_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_nephropathy_prevalences fk_diabetes_nephropathy_prevalences_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_nephropathy_prevalences
    ADD CONSTRAINT fk_diabetes_nephropathy_prevalences_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_treatment_guidelines fk_diabetes_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_guidelines
    ADD CONSTRAINT fk_diabetes_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_treatment_guidelines fk_diabetes_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_guidelines
    ADD CONSTRAINT fk_diabetes_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diabetes_treatment_outcomes fk_diabetes_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_outcomes
    ADD CONSTRAINT fk_diabetes_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diabetes_treatment_outcomes fk_diabetes_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diabetes_treatment_outcomes
    ADD CONSTRAINT fk_diabetes_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diarrhoea_key_performance_indicators fk_diarrhoea_key_performance_indicators_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diarrhoea_key_performance_indicators
    ADD CONSTRAINT fk_diarrhoea_key_performance_indicators_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diarrhoea_key_performance_indicators fk_diarrhoea_key_performance_indicators_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diarrhoea_key_performance_indicators
    ADD CONSTRAINT fk_diarrhoea_key_performance_indicators_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: diarrhoea_treatment_guidelines fk_diarrhoea_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diarrhoea_treatment_guidelines
    ADD CONSTRAINT fk_diarrhoea_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: diarrhoea_treatment_guidelines fk_diarrhoea_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.diarrhoea_treatment_guidelines
    ADD CONSTRAINT fk_diarrhoea_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: dispensary_managements fk_dispensary_managements_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dispensary_managements
    ADD CONSTRAINT fk_dispensary_managements_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: dispensary_managements fk_dispensary_managements_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dispensary_managements
    ADD CONSTRAINT fk_dispensary_managements_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: dispensing_pharmacies fk_dispensing_pharmacies_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dispensing_pharmacies
    ADD CONSTRAINT fk_dispensing_pharmacies_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: dispensing_pharmacies fk_dispensing_pharmacies_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dispensing_pharmacies
    ADD CONSTRAINT fk_dispensing_pharmacies_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: dyslipidemia_treatment_guidelines fk_dyslipidemia_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dyslipidemia_treatment_guidelines
    ADD CONSTRAINT fk_dyslipidemia_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: dyslipidemia_treatment_guidelines fk_dyslipidemia_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dyslipidemia_treatment_guidelines
    ADD CONSTRAINT fk_dyslipidemia_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: dyslipidemia_treatment_outcomes fk_dyslipidemia_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dyslipidemia_treatment_outcomes
    ADD CONSTRAINT fk_dyslipidemia_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: dyslipidemia_treatment_outcomes fk_dyslipidemia_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.dyslipidemia_treatment_outcomes
    ADD CONSTRAINT fk_dyslipidemia_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: expired_drugs_managements fk_expired_drugs_managements_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.expired_drugs_managements
    ADD CONSTRAINT fk_expired_drugs_managements_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: expired_drugs_managements fk_expired_drugs_managements_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.expired_drugs_managements
    ADD CONSTRAINT fk_expired_drugs_managements_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: external_trainings_reports fk_external_trainings_reports_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.external_trainings_reports
    ADD CONSTRAINT fk_external_trainings_reports_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: external_trainings_reports fk_external_trainings_reports_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.external_trainings_reports
    ADD CONSTRAINT fk_external_trainings_reports_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: facility_perfomance_observations fk_facility_perfomance_observations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.facility_perfomance_observations
    ADD CONSTRAINT fk_facility_perfomance_observations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: facility_perfomance_observations fk_facility_perfomance_observations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.facility_perfomance_observations
    ADD CONSTRAINT fk_facility_perfomance_observations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: family_plannings fk_family_plannings_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.family_plannings
    ADD CONSTRAINT fk_family_plannings_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: family_plannings fk_family_plannings_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.family_plannings
    ADD CONSTRAINT fk_family_plannings_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: fever_treatment_guidelines fk_fever_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.fever_treatment_guidelines
    ADD CONSTRAINT fk_fever_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: fever_treatment_guidelines fk_fever_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.fever_treatment_guidelines
    ADD CONSTRAINT fk_fever_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: focal_persons fk_focal_persons_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.focal_persons
    ADD CONSTRAINT fk_focal_persons_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: focal_persons fk_focal_persons_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.focal_persons
    ADD CONSTRAINT fk_focal_persons_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: frequency_of_committee_meetings fk_frequency_of_committee_meetings_created_by; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.frequency_of_committee_meetings
    ADD CONSTRAINT fk_frequency_of_committee_meetings_created_by FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: frequency_of_committee_meetings fk_frequency_of_committee_meetings_meeting_frequencies; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.frequency_of_committee_meetings
    ADD CONSTRAINT fk_frequency_of_committee_meetings_meeting_frequencies FOREIGN KEY (frequency_id) REFERENCES public.meeting_frequencies(id);


--
-- Name: frequency_of_committee_meetings fk_frequency_of_committee_meetings_meetings; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.frequency_of_committee_meetings
    ADD CONSTRAINT fk_frequency_of_committee_meetings_meetings FOREIGN KEY (meeting_id) REFERENCES public.meetings(id);


--
-- Name: frequency_of_committee_meetings fk_frequency_of_committee_meetings_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.frequency_of_committee_meetings
    ADD CONSTRAINT fk_frequency_of_committee_meetings_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: frequency_of_committee_meetings fk_frequency_of_committee_meetings_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.frequency_of_committee_meetings
    ADD CONSTRAINT fk_frequency_of_committee_meetings_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: health_centers fk_health_centers_district; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.health_centers
    ADD CONSTRAINT fk_health_centers_district FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- Name: health_educations fk_health_educations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.health_educations
    ADD CONSTRAINT fk_health_educations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: health_educations fk_health_educations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.health_educations
    ADD CONSTRAINT fk_health_educations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hospitalizations fk_hospitalizations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hospitalizations
    ADD CONSTRAINT fk_hospitalizations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: hospitalizations fk_hospitalizations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hospitalizations
    ADD CONSTRAINT fk_hospitalizations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hypertension_clearances fk_hypertension_clearances_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_clearances
    ADD CONSTRAINT fk_hypertension_clearances_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: hypertension_clearances fk_hypertension_clearances_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_clearances
    ADD CONSTRAINT fk_hypertension_clearances_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_3fea6005; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_3fea6005 FOREIGN KEY (age_id) REFERENCES public.ncd_patient_age_ranges(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_4a375c9a; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_4a375c9a FOREIGN KEY (gender_id) REFERENCES public.ncd_patient_genders(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_4d4fe0fb; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_4d4fe0fb FOREIGN KEY (illness_duration_id) REFERENCES public.ncd_patient_illness_durations(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_693d527a; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_693d527a FOREIGN KEY (education_level_id) REFERENCES public.ncd_patient_education_levels(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_p3fea600; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_p3fea600 FOREIGN KEY (age_id) REFERENCES public.ncd_patient_age_ranges(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_p4a375c9; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_p4a375c9 FOREIGN KEY (gender_id) REFERENCES public.ncd_patient_genders(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_p4d4fe0f; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_p4d4fe0f FOREIGN KEY (illness_duration_id) REFERENCES public.ncd_patient_illness_durations(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_ncd_p693d527; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_ncd_p693d527 FOREIGN KEY (education_level_id) REFERENCES public.ncd_patient_education_levels(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: hypertension_knowledge_on_home_self_managements fk_hypertension_knowledge_on_home_self_managements_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_knowledge_on_home_self_managements
    ADD CONSTRAINT fk_hypertension_knowledge_on_home_self_managements_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hypertension_nephropathy_prevalences fk_hypertension_nephropathy_prevalences_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_nephropathy_prevalences
    ADD CONSTRAINT fk_hypertension_nephropathy_prevalences_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: hypertension_nephropathy_prevalences fk_hypertension_nephropathy_prevalences_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_nephropathy_prevalences
    ADD CONSTRAINT fk_hypertension_nephropathy_prevalences_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hypertension_treatment_guidelines fk_hypertension_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_guidelines
    ADD CONSTRAINT fk_hypertension_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: hypertension_treatment_guidelines fk_hypertension_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_guidelines
    ADD CONSTRAINT fk_hypertension_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hypertension_treatment_outcomes fk_hypertension_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_outcomes
    ADD CONSTRAINT fk_hypertension_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: hypertension_treatment_outcomes fk_hypertension_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.hypertension_treatment_outcomes
    ADD CONSTRAINT fk_hypertension_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: imci_merged fk_imci_merged_districts; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged
    ADD CONSTRAINT fk_imci_merged_districts FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- Name: imci_merged fk_imci_merged_health_centers; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged
    ADD CONSTRAINT fk_imci_merged_health_centers FOREIGN KEY (health_center_id) REFERENCES public.health_centers(id);


--
-- Name: imci_merged fk_imci_merged_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged
    ADD CONSTRAINT fk_imci_merged_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: imci_merged fk_imci_merged_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged
    ADD CONSTRAINT fk_imci_merged_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: in_service_training_plans fk_in_service_training_plans_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.in_service_training_plans
    ADD CONSTRAINT fk_in_service_training_plans_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: in_service_training_plans fk_in_service_training_plans_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.in_service_training_plans
    ADD CONSTRAINT fk_in_service_training_plans_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: income_reviews fk_income_reviews_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.income_reviews
    ADD CONSTRAINT fk_income_reviews_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: income_reviews fk_income_reviews_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.income_reviews
    ADD CONSTRAINT fk_income_reviews_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: information_delivery_and_support_satisfactions fk_information_delivery_and_support_satisfactions_patie98306455; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.information_delivery_and_support_satisfactions
    ADD CONSTRAINT fk_information_delivery_and_support_satisfactions_patie98306455 FOREIGN KEY (patient_id) REFERENCES public.patient_satisfaction_basic_infos(id);


--
-- Name: information_delivery_and_support_satisfactions fk_information_delivery_and_support_satisfactions_patien9830645; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.information_delivery_and_support_satisfactions
    ADD CONSTRAINT fk_information_delivery_and_support_satisfactions_patien9830645 FOREIGN KEY (patient_id) REFERENCES public.patient_satisfaction_basic_infos(id);


--
-- Name: information_delivery_and_support_satisfactions fk_information_delivery_and_support_satisfactions_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.information_delivery_and_support_satisfactions
    ADD CONSTRAINT fk_information_delivery_and_support_satisfactions_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: information_delivery_and_support_satisfactions fk_information_delivery_and_support_satisfactions_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.information_delivery_and_support_satisfactions
    ADD CONSTRAINT fk_information_delivery_and_support_satisfactions_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: inpatients_care_treatment_guidelines fk_inpatients_care_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.inpatients_care_treatment_guidelines
    ADD CONSTRAINT fk_inpatients_care_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: inpatients_care_treatment_guidelines fk_inpatients_care_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.inpatients_care_treatment_guidelines
    ADD CONSTRAINT fk_inpatients_care_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: insurances fk_insurances_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.insurances
    ADD CONSTRAINT fk_insurances_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: insurances fk_insurances_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.insurances
    ADD CONSTRAINT fk_insurances_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: job_descriptions fk_job_descriptions_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.job_descriptions
    ADD CONSTRAINT fk_job_descriptions_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: job_descriptions fk_job_descriptions_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.job_descriptions
    ADD CONSTRAINT fk_job_descriptions_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: laboratories fk_laboratories_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.laboratories
    ADD CONSTRAINT fk_laboratories_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: laboratories fk_laboratories_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.laboratories
    ADD CONSTRAINT fk_laboratories_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: malaria_key_performance_indicators fk_malaria_key_performance_indicators_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malaria_key_performance_indicators
    ADD CONSTRAINT fk_malaria_key_performance_indicators_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: malaria_key_performance_indicators fk_malaria_key_performance_indicators_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malaria_key_performance_indicators
    ADD CONSTRAINT fk_malaria_key_performance_indicators_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: malaria_treatment_guidelines fk_malaria_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malaria_treatment_guidelines
    ADD CONSTRAINT fk_malaria_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: malaria_treatment_guidelines fk_malaria_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malaria_treatment_guidelines
    ADD CONSTRAINT fk_malaria_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: malnutrition_key_performance_indicators fk_malnutrition_key_performance_indicators_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malnutrition_key_performance_indicators
    ADD CONSTRAINT fk_malnutrition_key_performance_indicators_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: malnutrition_key_performance_indicators fk_malnutrition_key_performance_indicators_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.malnutrition_key_performance_indicators
    ADD CONSTRAINT fk_malnutrition_key_performance_indicators_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: matenities fk_matenities_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.matenities
    ADD CONSTRAINT fk_matenities_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: matenities fk_matenities_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.matenities
    ADD CONSTRAINT fk_matenities_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: maternal_and_neonatal_healths fk_maternal_and_neonatal_healths_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.maternal_and_neonatal_healths
    ADD CONSTRAINT fk_maternal_and_neonatal_healths_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: maternal_and_neonatal_healths fk_maternal_and_neonatal_healths_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.maternal_and_neonatal_healths
    ADD CONSTRAINT fk_maternal_and_neonatal_healths_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: maternity_treatment_guidelines fk_maternity_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.maternity_treatment_guidelines
    ADD CONSTRAINT fk_maternity_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: maternity_treatment_guidelines fk_maternity_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.maternity_treatment_guidelines
    ADD CONSTRAINT fk_maternity_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: monthly_data_reports fk_monthly_data_reports_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.monthly_data_reports
    ADD CONSTRAINT fk_monthly_data_reports_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: monthly_data_reports fk_monthly_data_reports_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.monthly_data_reports
    ADD CONSTRAINT fk_monthly_data_reports_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: ncds fk_ncds_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncds
    ADD CONSTRAINT fk_ncds_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: ncds fk_ncds_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.ncds
    ADD CONSTRAINT fk_ncds_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: new_closing_balances fk_new_closing_balances_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_closing_balances
    ADD CONSTRAINT fk_new_closing_balances_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: new_closing_balances fk_new_closing_balances_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_closing_balances
    ADD CONSTRAINT fk_new_closing_balances_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: new_diabetes_treatment_outcomes fk_new_diabetes_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_diabetes_treatment_outcomes
    ADD CONSTRAINT fk_new_diabetes_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: new_diabetes_treatment_outcomes fk_new_diabetes_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_diabetes_treatment_outcomes
    ADD CONSTRAINT fk_new_diabetes_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: new_hypertension_treatment_outcomes fk_new_hypertension_treatment_outcomes_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_hypertension_treatment_outcomes
    ADD CONSTRAINT fk_new_hypertension_treatment_outcomes_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: new_hypertension_treatment_outcomes fk_new_hypertension_treatment_outcomes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_hypertension_treatment_outcomes
    ADD CONSTRAINT fk_new_hypertension_treatment_outcomes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: new_pharmacy_stock_values fk_new_pharmacy_stock_values_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_pharmacy_stock_values
    ADD CONSTRAINT fk_new_pharmacy_stock_values_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: new_pharmacy_stock_values fk_new_pharmacy_stock_values_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_pharmacy_stock_values
    ADD CONSTRAINT fk_new_pharmacy_stock_values_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: notice_boards fk_notice_boards_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.notice_boards
    ADD CONSTRAINT fk_notice_boards_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: notice_boards fk_notice_boards_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.notice_boards
    ADD CONSTRAINT fk_notice_boards_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: organization_charts fk_organization_charts_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.organization_charts
    ADD CONSTRAINT fk_organization_charts_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: organization_charts fk_organization_charts_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.organization_charts
    ADD CONSTRAINT fk_organization_charts_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: patient_arrival_perceptions fk_patient_arrival_perceptions_patient_satisfaction_basic_infos; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_arrival_perceptions
    ADD CONSTRAINT fk_patient_arrival_perceptions_patient_satisfaction_basic_infos FOREIGN KEY (patient_id) REFERENCES public.patient_satisfaction_basic_infos(id);


--
-- Name: patient_arrival_perceptions fk_patient_arrival_perceptions_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_arrival_perceptions
    ADD CONSTRAINT fk_patient_arrival_perceptions_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: patient_arrival_perceptions fk_patient_arrival_perceptions_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_arrival_perceptions
    ADD CONSTRAINT fk_patient_arrival_perceptions_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: patient_rights_and_responsibilitiesses fk_patient_rights_and_responsibilitiesses_patient_satisa61973c6; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_rights_and_responsibilitiesses
    ADD CONSTRAINT fk_patient_rights_and_responsibilitiesses_patient_satisa61973c6 FOREIGN KEY (patient_id) REFERENCES public.patient_satisfaction_basic_infos(id);


--
-- Name: patient_rights_and_responsibilitiesses fk_patient_rights_and_responsibilitiesses_patient_satisfa61973c; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_rights_and_responsibilitiesses
    ADD CONSTRAINT fk_patient_rights_and_responsibilitiesses_patient_satisfa61973c FOREIGN KEY (patient_id) REFERENCES public.patient_satisfaction_basic_infos(id);


--
-- Name: patient_rights_and_responsibilitiesses fk_patient_rights_and_responsibilitiesses_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_rights_and_responsibilitiesses
    ADD CONSTRAINT fk_patient_rights_and_responsibilitiesses_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: patient_rights_and_responsibilitiesses fk_patient_rights_and_responsibilitiesses_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_rights_and_responsibilitiesses
    ADD CONSTRAINT fk_patient_rights_and_responsibilitiesses_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_patient_age_ranges; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_patient_age_ranges FOREIGN KEY (age) REFERENCES public.patient_age_ranges(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_patient_education_levels; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_patient_education_levels FOREIGN KEY (education_level) REFERENCES public.patient_education_levels(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_patient_genders; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_patient_genders FOREIGN KEY (gender) REFERENCES public.patient_genders(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_patient_satisfactio83a3eeb9; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_patient_satisfactio83a3eeb9 FOREIGN KEY (service) REFERENCES public.patient_satisfaction_services(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_patient_satisfaction83a3eeb; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_patient_satisfaction83a3eeb FOREIGN KEY (service) REFERENCES public.patient_satisfaction_services(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: patient_satisfaction_basic_infos fk_patient_satisfaction_basic_infos_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.patient_satisfaction_basic_infos
    ADD CONSTRAINT fk_patient_satisfaction_basic_infos_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: payables_registers fk_payables_registers_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.payables_registers
    ADD CONSTRAINT fk_payables_registers_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: payables_registers fk_payables_registers_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.payables_registers
    ADD CONSTRAINT fk_payables_registers_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: pharmacy_reviews fk_pharmacy_reviews_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_reviews
    ADD CONSTRAINT fk_pharmacy_reviews_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: pharmacy_reviews fk_pharmacy_reviews_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_reviews
    ADD CONSTRAINT fk_pharmacy_reviews_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: pharmacy_stock_values fk_pharmacy_stock_values_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_stock_values
    ADD CONSTRAINT fk_pharmacy_stock_values_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: pharmacy_stock_values fk_pharmacy_stock_values_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_stock_values
    ADD CONSTRAINT fk_pharmacy_stock_values_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: pharmacy_stocks fk_pharmacy_stocks_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_stocks
    ADD CONSTRAINT fk_pharmacy_stocks_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: pharmacy_stocks fk_pharmacy_stocks_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pharmacy_stocks
    ADD CONSTRAINT fk_pharmacy_stocks_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: pneumonia_key_performance_indicators fk_pneumonia_key_performance_indicators_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pneumonia_key_performance_indicators
    ADD CONSTRAINT fk_pneumonia_key_performance_indicators_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: pneumonia_key_performance_indicators fk_pneumonia_key_performance_indicators_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pneumonia_key_performance_indicators
    ADD CONSTRAINT fk_pneumonia_key_performance_indicators_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: pneumonia_treatment_guidelines fk_pneumonia_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pneumonia_treatment_guidelines
    ADD CONSTRAINT fk_pneumonia_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: pneumonia_treatment_guidelines fk_pneumonia_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.pneumonia_treatment_guidelines
    ADD CONSTRAINT fk_pneumonia_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: project_data fk_project_data_category; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data
    ADD CONSTRAINT fk_project_data_category FOREIGN KEY (category_id) REFERENCES public.project_question_categories(id);


--
-- Name: project_data fk_project_data_health_center; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data
    ADD CONSTRAINT fk_project_data_health_center FOREIGN KEY (health_center_id) REFERENCES public.health_centers(id);


--
-- Name: project_data fk_project_data_project; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data
    ADD CONSTRAINT fk_project_data_project FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_data fk_project_data_question; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data
    ADD CONSTRAINT fk_project_data_question FOREIGN KEY (question_id) REFERENCES public.project_questions(id);


--
-- Name: project_data fk_project_data_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data
    ADD CONSTRAINT fk_project_data_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: project_question_categories fk_project_question_categories_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_question_categories
    ADD CONSTRAINT fk_project_question_categories_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: project_questions_maps fk_project_questions_maps_project_questions; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions_maps
    ADD CONSTRAINT fk_project_questions_maps_project_questions FOREIGN KEY (question_id) REFERENCES public.project_questions(id) ON DELETE CASCADE;


--
-- Name: project_questions_maps fk_project_questions_maps_projects; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions_maps
    ADD CONSTRAINT fk_project_questions_maps_projects FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_questions fk_project_questions_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions
    ADD CONSTRAINT fk_project_questions_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: project_statuses fk_project_statuses_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_statuses
    ADD CONSTRAINT fk_project_statuses_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: projects fk_projects_status; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_projects_status FOREIGN KEY (status_id) REFERENCES public.project_statuses(id);


--
-- Name: projects fk_projects_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_projects_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: qi_plans fk_qi_plans_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qi_plans
    ADD CONSTRAINT fk_qi_plans_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: qi_plans fk_qi_plans_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qi_plans
    ADD CONSTRAINT fk_qi_plans_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: qr_codes fk_qr_codes_districts; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT fk_qr_codes_districts FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- Name: qr_codes fk_qr_codes_health_centers; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT fk_qr_codes_health_centers FOREIGN KEY (health_center_id) REFERENCES public.health_centers(id);


--
-- Name: qr_codes fk_qr_codes_type; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT fk_qr_codes_type FOREIGN KEY (type_id) REFERENCES public.qr_code_types(id);


--
-- Name: qr_codes fk_qr_codes_type_id; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT fk_qr_codes_type_id FOREIGN KEY (type_id) REFERENCES public.qr_code_types(id);


--
-- Name: qr_codes fk_qr_codes_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.qr_codes
    ADD CONSTRAINT fk_qr_codes_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: question_categories_maps fk_question_categories_maps_project_question_categories; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.question_categories_maps
    ADD CONSTRAINT fk_question_categories_maps_project_question_categories FOREIGN KEY (category_id) REFERENCES public.project_question_categories(id);


--
-- Name: question_categories_maps fk_question_categories_maps_project_questions; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.question_categories_maps
    ADD CONSTRAINT fk_question_categories_maps_project_questions FOREIGN KEY (question_id) REFERENCES public.project_questions(id) ON DELETE CASCADE;


--
-- Name: receivables_registers fk_receivables_registers_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.receivables_registers
    ADD CONSTRAINT fk_receivables_registers_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: receivables_registers fk_receivables_registers_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.receivables_registers
    ADD CONSTRAINT fk_receivables_registers_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: receptionists fk_receptionists_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.receptionists
    ADD CONSTRAINT fk_receptionists_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: receptionists fk_receptionists_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.receptionists
    ADD CONSTRAINT fk_receptionists_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: referral_process_treatment_guidelines fk_referral_process_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.referral_process_treatment_guidelines
    ADD CONSTRAINT fk_referral_process_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: referral_process_treatment_guidelines fk_referral_process_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.referral_process_treatment_guidelines
    ADD CONSTRAINT fk_referral_process_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: safety_managements fk_safety_managements_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.safety_managements
    ADD CONSTRAINT fk_safety_managements_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: safety_managements fk_safety_managements_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.safety_managements
    ADD CONSTRAINT fk_safety_managements_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: sanitations fk_sanitations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.sanitations
    ADD CONSTRAINT fk_sanitations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: sanitations fk_sanitations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.sanitations
    ADD CONSTRAINT fk_sanitations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: staff_informations fk_staff_informations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.staff_informations
    ADD CONSTRAINT fk_staff_informations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: staff_informations fk_staff_informations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.staff_informations
    ADD CONSTRAINT fk_staff_informations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: stock_managements fk_stock_managements_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.stock_managements
    ADD CONSTRAINT fk_stock_managements_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: stock_managements fk_stock_managements_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.stock_managements
    ADD CONSTRAINT fk_stock_managements_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: survey_basic_informations fk_survey_basic_informations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.survey_basic_informations
    ADD CONSTRAINT fk_survey_basic_informations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: survey_basic_informations fk_survey_basic_informations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.survey_basic_informations
    ADD CONSTRAINT fk_survey_basic_informations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: titualaires fk_titualaires_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.titualaires
    ADD CONSTRAINT fk_titualaires_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: titualaires fk_titualaires_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.titualaires
    ADD CONSTRAINT fk_titualaires_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: toilets fk_toilets_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT fk_toilets_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: toilets fk_toilets_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT fk_toilets_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: transaction_expense_reviews fk_transaction_expense_reviews_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.transaction_expense_reviews
    ADD CONSTRAINT fk_transaction_expense_reviews_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: transaction_expense_reviews fk_transaction_expense_reviews_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.transaction_expense_reviews
    ADD CONSTRAINT fk_transaction_expense_reviews_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: treatment_guidelines fk_treatment_guidelines_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.treatment_guidelines
    ADD CONSTRAINT fk_treatment_guidelines_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: treatment_guidelines fk_treatment_guidelines_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.treatment_guidelines
    ADD CONSTRAINT fk_treatment_guidelines_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: vaccinations fk_vaccinations_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.vaccinations
    ADD CONSTRAINT fk_vaccinations_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: vaccinations fk_vaccinations_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.vaccinations
    ADD CONSTRAINT fk_vaccinations_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: work_schedules fk_work_schedules_qr_codes; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.work_schedules
    ADD CONSTRAINT fk_work_schedules_qr_codes FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: work_schedules fk_work_schedules_users; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.work_schedules
    ADD CONSTRAINT fk_work_schedules_users FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: imci_merged_copy1 imci_merged_copy1_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged_copy1
    ADD CONSTRAINT imci_merged_copy1_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: imci_merged_copy1 imci_merged_copy1_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged_copy1
    ADD CONSTRAINT imci_merged_copy1_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- Name: imci_merged_copy1 imci_merged_copy1_health_center_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged_copy1
    ADD CONSTRAINT imci_merged_copy1_health_center_id_fkey FOREIGN KEY (health_center_id) REFERENCES public.health_centers(id);


--
-- Name: imci_merged_copy1 imci_merged_copy1_survey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.imci_merged_copy1
    ADD CONSTRAINT imci_merged_copy1_survey_id_fkey FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: new_hypertension_treatment_outcomes_copy1 new_hypertension_treatment_outcomes_copy1_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_hypertension_treatment_outcomes_copy1
    ADD CONSTRAINT new_hypertension_treatment_outcomes_copy1_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: new_hypertension_treatment_outcomes_copy1 new_hypertension_treatment_outcomes_copy1_survey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.new_hypertension_treatment_outcomes_copy1
    ADD CONSTRAINT new_hypertension_treatment_outcomes_copy1_survey_id_fkey FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- Name: project_data_copy18022026 project_data_copy1_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data_copy18022026
    ADD CONSTRAINT project_data_copy1_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.project_question_categories(id);


--
-- Name: project_data_copy18022026 project_data_copy1_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data_copy18022026
    ADD CONSTRAINT project_data_copy1_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: project_data_copy18022026 project_data_copy1_health_center_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data_copy18022026
    ADD CONSTRAINT project_data_copy1_health_center_id_fkey FOREIGN KEY (health_center_id) REFERENCES public.health_centers(id);


--
-- Name: project_data_copy18022026 project_data_copy1_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data_copy18022026
    ADD CONSTRAINT project_data_copy1_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_data_copy18022026 project_data_copy1_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_data_copy18022026
    ADD CONSTRAINT project_data_copy1_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.project_questions(id);


--
-- Name: project_questions_copy1 project_questions_copy1_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.project_questions_copy1
    ADD CONSTRAINT project_questions_copy1_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: stock_managements_copy1 stock_managements_copy1_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.stock_managements_copy1
    ADD CONSTRAINT stock_managements_copy1_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: stock_managements_copy1 stock_managements_copy1_survey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: health_builders
--

ALTER TABLE ONLY public.stock_managements_copy1
    ADD CONSTRAINT stock_managements_copy1_survey_id_fkey FOREIGN KEY (survey_id) REFERENCES public.qr_codes(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 64Qifoh8VbIdKTonjUL7w1j7U811UiSUoGSQ9RykRTkdPToDEpTkxtXH9X1GvhD


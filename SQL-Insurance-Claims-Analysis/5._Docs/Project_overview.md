
-- ============================================================
-- INSURANCE CLAIMS REPORTING VIEW
-- Database: PostgreSQL
-- Source tables: customers, claims_raw
--
-- Purpose:
-- Prepare claims and customer attributes for SQL reporting.
-- Preserve missing source values for data-quality checks.
-- ============================================================

CREATE OR REPLACE VIEW reporting_claims_vw AS
SELECT
    cl.claim_id,
    cl.customer_id,
    c.first_name,
    c.last_name,
    c.age,
    c.city AS customer_city,
    c.province,
    c.policy_start_date,
    c.policy_type,

    cl.policy_id,
    cl.claim_date,
    cl.claim_type,
    cl.claim_amount,
    cl.claim_status,
    cl.incident_city,
    cl.incident_type,
    cl.police_report,
    cl.days_to_settle,

    EXTRACT(YEAR FROM cl.claim_date)::INT AS claim_year,
    EXTRACT(MONTH FROM cl.claim_date)::INT AS claim_month,
    TO_CHAR(cl.claim_date, 'FMMonth') AS claim_month_name,

    CASE
        WHEN cl.claim_amount IS NULL THEN 'Not Classified'
        WHEN cl.claim_amount < 10000 THEN 'Low'
        WHEN cl.claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    CASE
        WHEN cl.days_to_settle IS NULL THEN 'Missing Settlement Days'
        WHEN cl.days_to_settle <= 10 THEN '0-10 Days'
        WHEN cl.days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_group

FROM claims_raw AS cl
LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id;


**Check the view**


-- 1. Confirm the view returns claim records.
SELECT *
FROM reporting_claims_vw
ORDER BY claim_id;

-- 2. Check the number of records in the view.
SELECT COUNT(*) AS reporting_claim_count
FROM reporting_claims_vw;

-- 3. Check missing values that affect reporting.
SELECT
    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS missing_claim_dates,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS missing_claim_amounts,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,

    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS missing_settlement_days

FROM reporting_claims_vw;



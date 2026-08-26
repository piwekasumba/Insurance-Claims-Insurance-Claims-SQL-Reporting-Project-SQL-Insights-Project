-- ============================================================
-- REPORTING DATASET
-- Purpose:
-- Create a reporting-ready claims table with derived fields
-- used for KPI reporting, trend analysis and operational
-- reporting.
--
-- Reporting layer:
-- Raw claims data -> reporting_claims -> summary tables
-- ============================================================

DROP TABLE IF EXISTS reporting_claims;

CREATE TABLE reporting_claims AS
SELECT
    cl.claim_id,
    cl.customer_id,
    cl.policy_id,
    cl.claim_date,
    cl.claim_type,
    cl.claim_amount,
    cl.claim_status,
    cl.incident_city,
    cl.incident_type,
    cl.police_report,
    cl.days_to_settle,

    -- Derived reporting fields
    EXTRACT(YEAR FROM cl.claim_date)::INT AS claim_year,

    EXTRACT(MONTH FROM cl.claim_date)::INT AS claim_month,

    TO_CHAR(cl.claim_date, 'Month') AS claim_month_name,

    CASE
        WHEN cl.claim_amount < 10000 THEN 'Low'
        WHEN cl.claim_amount BETWEEN 10000 AND 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    CASE
        WHEN cl.days_to_settle IS NULL THEN 'Not Settled'
        WHEN cl.days_to_settle <= 10 THEN '0-10 Days'
        WHEN cl.days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_time_group

FROM claims AS cl;


-- ============================================================
-- CUSTOMER CLAIMS SUMMARY
-- Business Purpose:
-- Summarise customer claims activity for KPI reporting,
-- operational monitoring and business analysis.
-- ============================================================

DROP TABLE IF EXISTS customer_claim_summary;

CREATE TABLE customer_claim_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age,
    c.city,
    c.province,
    c.policy_type,

    COUNT(rc.claim_id) AS total_claims,

    COALESCE(SUM(rc.claim_amount), 0) AS total_claim_amount,

    ROUND(
        COALESCE(AVG(rc.claim_amount), 0),
        2
    ) AS average_claim_amount,

    COALESCE(MAX(rc.claim_amount), 0) AS highest_claim_amount,

    COALESCE(MIN(rc.claim_amount), 0) AS lowest_claim_amount

FROM customers AS c

LEFT JOIN reporting_claims AS rc
    ON c.customer_id = rc.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age,
    c.city,
    c.province,
    c.policy_type;


-- ============================================================
-- POLICY CLAIMS SUMMARY
-- Business Purpose:
-- Produce policy-level reporting used to monitor claim
-- frequency, claim costs and policy performance.
-- ============================================================

DROP TABLE IF EXISTS policy_claim_summary;

CREATE TABLE policy_claim_summary AS
SELECT
    rc.policy_id,

    COUNT(rc.claim_id) AS total_claims,

    SUM(rc.claim_amount) AS total_claim_amount,

    ROUND(
        AVG(rc.claim_amount),
        2
    ) AS average_claim_amount,

    MAX(rc.claim_amount) AS highest_claim_amount,

    MIN(rc.claim_amount) AS lowest_claim_amount

FROM reporting_claims AS rc

GROUP BY
    rc.policy_id;


-- ============================================================
-- CLAIM STATUS SUMMARY
-- Business Purpose:
-- Provide a reporting view of claim volume and financial
-- value by claim status.
-- ============================================================

DROP TABLE IF EXISTS claim_status_summary;

CREATE TABLE claim_status_summary AS
SELECT
    claim_status,

    COUNT(claim_id) AS total_claims,

    SUM(claim_amount) AS total_claim_amount,

    ROUND(
        AVG(claim_amount),
        2
    ) AS average_claim_amount

FROM reporting_claims

GROUP BY
    claim_status;


-- ============================================================
-- CLAIM TYPE SUMMARY
-- Business Purpose:
-- Compare claim frequency and financial exposure by
-- claim type for management reporting.
-- ============================================================

DROP TABLE IF EXISTS claim_type_summary;

CREATE TABLE claim_type_summary AS
SELECT
    claim_type,

    COUNT(claim_id) AS total_claims,

    SUM(claim_amount) AS total_claim_amount,

    ROUND(
        AVG(claim_amount),
        2
    ) AS average_claim_amount

FROM reporting_claims

GROUP BY
    claim_type;


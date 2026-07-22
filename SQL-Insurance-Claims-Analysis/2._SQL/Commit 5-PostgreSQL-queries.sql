-- ============================================================
-- REPORTING DATASET
-- Purpose:
-- Create a reporting-ready claims table with derived fields
-- used for KPI reporting, trend analysis and operational reports.
-- ============================================================

CREATE TABLE reporting_claims AS
SELECT
    claim_id,
    customer_id,
    policy_number,
    claim_date,
    processed_date,
    claim_amount,

    EXTRACT(YEAR FROM claim_date) AS claim_year,
    EXTRACT(MONTH FROM claim_date) AS claim_month,

    CASE
        WHEN claim_amount > 50000 THEN 'High'
        WHEN claim_amount BETWEEN 10000 AND 50000 THEN 'Medium'
        ELSE 'Low'
    END AS claim_severity

FROM claims;

-- ============================================================
-- CUSTOMER CLAIMS SUMMARY
-- Business Purpose:
-- Summarise customer claims activity for KPI reporting,
-- operational monitoring and business analysis.
-- ============================================================

CREATE TABLE customer_claim_summary AS
SELECT
    c.customer_id,
    c.sex AS gender,

    COUNT(rc.claim_id) AS total_claims,

    SUM(rc.claim_amount) AS total_claim_amount,

    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount,

    MAX(rc.claim_amount) AS highest_claim_amount,

    MIN(rc.claim_amount) AS lowest_claim_amount

FROM customers AS c

LEFT JOIN reporting_claims AS rc
    ON c.customer_id = rc.customer_id

GROUP BY
    c.customer_id,
    c.sex;

-- ============================================================
-- POLICY CLAIMS SUMMARY
-- Business Purpose:
-- Produce policy-level reporting used to monitor claim
-- frequency, claim costs and policy performance.
-- ============================================================

CREATE TABLE policy_claim_summary AS
SELECT
    policy_number,

    COUNT(claim_id) AS total_claims,

    SUM(claim_amount) AS total_claim_amount,

    ROUND(AVG(claim_amount), 2) AS average_claim_amount,

    MAX(claim_amount) AS highest_claim_amount,

    MIN(claim_amount) AS lowest_claim_amount

FROM reporting_claims

GROUP BY
    policy_number;

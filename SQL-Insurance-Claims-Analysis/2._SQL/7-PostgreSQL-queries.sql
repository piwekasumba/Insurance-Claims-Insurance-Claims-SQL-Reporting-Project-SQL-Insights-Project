-- ==========================================================
-- INSURANCE CLAIMS EXCEPTION & MONITORING REPORTS
-- PostgreSQL
--
-- Purpose:
-- Produce exception and monitoring reports that support
-- operational review, claims monitoring and business analysis.
--
-- These reports use the reporting_claims and
-- customer_claim_summary reporting tables.
-- ==========================================================


-- ==========================================================
-- REPORT 1: HIGH CLAIM ACTIVITY CUSTOMERS
-- ==========================================================
-- Business Question:
-- Which customers submitted more than one claim?
--
-- Business Purpose:
-- Supports operational reporting by identifying customers
-- with multiple claims for further review.
--
-- Reporting Output:
-- Ranked customer claims activity summary.
-- ==========================================================

SELECT
    customer_id,
    first_name,
    last_name,
    province,
    policy_type,
    total_claims,
    total_claim_amount,
    average_claim_amount
FROM customer_claim_summary
WHERE total_claims > 1
ORDER BY
    total_claims DESC,
    total_claim_amount DESC;


-- ==========================================================
-- REPORT 2: HIGH-VALUE CLAIM EXCEPTIONS
-- ==========================================================
-- Business Question:
-- Which claims are above the overall average claim value?
--
-- Business Purpose:
-- Helps claims teams identify higher-value claims that may
-- require additional review.
--
-- Reporting Output:
-- Ranked high-value claim exception report.
-- ==========================================================

WITH claim_statistics AS (
    SELECT
        AVG(claim_amount) AS average_claim_amount
    FROM reporting_claims
)

SELECT
    rc.claim_id,
    rc.customer_id,
    rc.policy_id,
    rc.claim_date,
    rc.claim_type,
    rc.claim_amount,
    rc.claim_status,
    rc.incident_city
FROM reporting_claims AS rc
CROSS JOIN claim_statistics AS cs
WHERE rc.claim_amount > cs.average_claim_amount
ORDER BY
    rc.claim_amount DESC;


-- ==========================================================
-- REPORT 3: HIGH-SEVERITY CLAIM MONITORING
-- ==========================================================
-- Business Question:
-- Which policies have high-severity claims?
--
-- Business Purpose:
-- Supports operational monitoring by identifying policies
-- associated with higher-value claims.
--
-- Reporting Output:
-- Policy-level high-severity claim summary.
-- ==========================================================

SELECT
    policy_id,
    COUNT(*) AS high_severity_claims,
    SUM(claim_amount) AS total_claim_cost,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MIN(claim_date) AS first_claim_date,
    MAX(claim_date) AS latest_claim_date
FROM reporting_claims
WHERE claim_severity = 'High'
GROUP BY policy_id
ORDER BY
    total_claim_cost DESC;


-- ==========================================================
-- REPORT 4: CUSTOMERS REQUIRING BUSINESS REVIEW
-- ==========================================================
-- Business Question:
-- Which customers have multiple claims and a total claim
-- value above the overall average customer claim value?
--
-- Business Purpose:
-- Produces a simple exception report for operational review.
--
-- Important:
-- This report identifies records for review. It does not
-- determine fraud or customer risk.
-- ==========================================================

WITH customer_statistics AS (
    SELECT
        AVG(total_claim_amount) AS average_customer_claim_amount
    FROM customer_claim_summary
    WHERE total_claims > 0
)

SELECT
    ccs.customer_id,
    ccs.first_name,
    ccs.last_name,
    ccs.province,
    ccs.policy_type,
    ccs.total_claims,
    ccs.total_claim_amount,
    ccs.average_claim_amount
FROM customer_claim_summary AS ccs
CROSS JOIN customer_statistics AS cs
WHERE ccs.total_claims > 1
  AND ccs.total_claim_amount > cs.average_customer_claim_amount
ORDER BY
    ccs.total_claim_amount DESC;


-- ==========================================================
-- REPORT 5: UNSETTLED CLAIMS MONITORING
-- ==========================================================
-- Business Question:
-- Which claims do not yet have settlement information?
--
-- Business Purpose:
-- Supports operational monitoring by identifying claims
-- that may require follow-up.
--
-- Reporting Output:
-- Claims without settlement duration.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_type,
    claim_amount,
    claim_status,
    incident_city
FROM reporting_claims
WHERE days_to_settle IS NULL
ORDER BY
    claim_date NULLS LAST,
    claim_id;


-- ==========================================================
-- REPORT 6: MISSING CLAIM DATE EXCEPTIONS
-- ==========================================================
-- Business Question:
-- Which claims are missing a claim date?
--
-- Business Purpose:
-- Supports data quality monitoring because missing dates
-- can affect time-based reporting and trend analysis.
--
-- Reporting Output:
-- Claims requiring data quality attention.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_type,
    claim_amount,
    claim_status,
    incident_city
FROM reporting_claims
WHERE claim_date IS NULL
ORDER BY claim_id;

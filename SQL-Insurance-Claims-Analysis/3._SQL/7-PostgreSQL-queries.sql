
-- ==========================================================
-- INSURANCE CLAIMS EXCEPTION & MONITORING REPORTS
-- PostgreSQL
--
-- Purpose:
-- Produce exception and monitoring reports for operational
-- review, claims monitoring and data-quality follow-up.
--
-- Required reporting tables:
-- 1. reporting_claims
-- 2. customer_claim_summary
--
-- Note:
-- These reports flag records for review. They do not prove
-- fraud, customer risk or overdue claims.
-- ==========================================================


-- ==========================================================
-- REPORT 1: CUSTOMERS WITH MULTIPLE CLAIMS
-- ==========================================================
-- Business Question:
-- Which customers have submitted more than one recorded claim?
--
-- Business Purpose:
-- Supports operational monitoring of claims activity.
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
    total_claim_amount DESC,
    customer_id;


-- ==========================================================
-- REPORT 2: CLAIMS ABOVE THE OVERALL AVERAGE
-- ==========================================================
-- Business Question:
-- Which recorded claims exceed the overall average claim amount?
--
-- Business Purpose:
-- Identifies higher-value claims for possible further review.
-- ==========================================================

WITH claim_statistics AS (
    SELECT
        AVG(claim_amount) AS average_claim_amount
    FROM reporting_claims
    WHERE claim_amount IS NOT NULL
)

SELECT
    rc.claim_id,
    rc.customer_id,
    rc.policy_id,
    rc.claim_date,
    rc.claim_type,
    rc.claim_amount,
    rc.claim_status,
    rc.incident_city,
    ROUND(cs.average_claim_amount, 2) AS overall_average_claim_amount
FROM reporting_claims AS rc
CROSS JOIN claim_statistics AS cs
WHERE rc.claim_amount > cs.average_claim_amount
ORDER BY
    rc.claim_amount DESC,
    rc.claim_id;


-- ==========================================================
-- REPORT 3: HIGH-SEVERITY CLAIM MONITORING BY POLICY
-- ==========================================================
-- Business Question:
-- Which policy identifiers are associated with high-severity
-- claims under this project's claim-amount classification?
--
-- Severity definition:
-- Low:    below 10,000
-- Medium: 10,000 through 20,000
-- High:   above 20,000
--
-- Business Purpose:
-- Summarises higher-value claims for operational review.
-- ==========================================================

SELECT
    policy_id,
    COUNT(*) AS high_severity_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MIN(claim_date) AS first_claim_date,
    MAX(claim_date) AS latest_claim_date
FROM reporting_claims
WHERE claim_severity = 'High'
GROUP BY policy_id
ORDER BY
    total_claim_amount DESC,
    policy_id NULLS LAST;


-- ==========================================================
-- REPORT 4: CUSTOMERS FLAGGED FOR BUSINESS REVIEW
-- ==========================================================
-- Business Question:
-- Which customers have multiple claims and a total recorded
-- claim amount above the average customer total?
--
-- Calculation:
-- The comparison average is calculated across customers with
-- at least one recorded claim in customer_claim_summary.
--
-- Important:
-- This is a monitoring rule, not a fraud or risk assessment.
-- ==========================================================

WITH customer_statistics AS (
    SELECT
        AVG(total_claim_amount) AS average_customer_total
    FROM customer_claim_summary
    WHERE total_claims > 0
      AND total_claim_amount IS NOT NULL
)

SELECT
    ccs.customer_id,
    ccs.first_name,
    ccs.last_name,
    ccs.province,
    ccs.policy_type,
    ccs.total_claims,
    ccs.total_claim_amount,
    ccs.average_claim_amount,
    ROUND(cs.average_customer_total, 2) AS average_customer_total
FROM customer_claim_summary AS ccs
CROSS JOIN customer_statistics AS cs
WHERE ccs.total_claims > 1
  AND ccs.total_claim_amount > cs.average_customer_total
ORDER BY
    ccs.total_claim_amount DESC,
    ccs.customer_id;


-- ==========================================================
-- REPORT 5: CLAIMS MISSING SETTLEMENT-DURATION INFORMATION
-- ==========================================================
-- Business Question:
-- Which claims have no recorded settlement duration?
--
-- Business Purpose:
-- Supports data-quality and operational follow-up.
--
-- Important:
-- A missing duration does not by itself prove that a claim
-- is unsettled or overdue.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_type,
    claim_amount,
    claim_status,
    incident_city,
    days_to_settle
FROM reporting_claims
WHERE days_to_settle IS NULL
ORDER BY
    claim_date NULLS LAST,
    claim_id;


-- ==========================================================
-- REPORT 6: CLAIMS MISSING A CLAIM DATE
-- ==========================================================
-- Business Question:
-- Which claims have no recorded claim date?
--
-- Business Purpose:
-- Identifies data-quality exceptions that can affect
-- time-based reporting and monthly trend analysis.
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


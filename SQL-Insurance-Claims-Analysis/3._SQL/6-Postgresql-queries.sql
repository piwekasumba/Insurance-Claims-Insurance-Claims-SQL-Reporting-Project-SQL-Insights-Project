-- ==========================================================
-- INSURANCE CLAIMS REPORTING OUTPUTS
-- PostgreSQL
--
-- Purpose:
-- Produce business-focused reporting outputs from the
-- reporting layer built from the simulated claims dataset.
--
-- Prerequisite tables:
--   1. reporting_claims
--   2. customer_claim_summary
--   3. customers
--
-- Reporting focus:
--   Claims severity, monthly performance, claim status,
--   customer exposure, geography, policy type, settlement
--   performance and data-quality exceptions.
--
-- Note:
-- These reports describe the supplied simulated dataset.
-- They do not establish real-world insurance risk or fraud.
-- ==========================================================


-- ==========================================================
-- REPORT 1: CLAIMS BY SEVERITY
--
-- Business question:
-- How many claims fall into each severity level, and what
-- is their recorded financial value?
--
-- Severity thresholds must match the reporting-layer script:
--   Low:    below 10,000
--   Medium: 10,000 to 20,000 inclusive
--   High:   above 20,000
-- ==========================================================

SELECT
    COALESCE(claim_severity, 'Unknown / Unclassified')
        AS claim_severity,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
GROUP BY claim_severity
ORDER BY
    total_claim_amount DESC NULLS LAST,
    claim_severity;


-- ==========================================================
-- REPORT 2: MONTHLY CLAIMS PERFORMANCE
--
-- Business question:
-- How do recorded claim volumes and claim values change
-- across months?
--
-- Claims without a claim date are excluded because they
-- cannot be assigned reliably to a reporting month.
-- ==========================================================

SELECT
    claim_year,
    claim_month,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
WHERE claim_date IS NOT NULL
GROUP BY
    claim_year,
    claim_month
ORDER BY
    claim_year,
    claim_month;


-- ==========================================================
-- REPORT 3: CLAIM STATUS DISTRIBUTION
--
-- Business question:
-- How are claims distributed across their recorded statuses?
--
-- claim_volume_percent is the percentage of all rows in
-- reporting_claims represented by each status.
-- This is a status distribution, not an approval rate.
-- ==========================================================

SELECT
    COALESCE(claim_status, 'Unknown / Missing')
        AS claim_status,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    ROUND(
        100.0 * COUNT(*)
        / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS claim_volume_percent
FROM reporting_claims
GROUP BY claim_status
ORDER BY
    total_claim_amount DESC NULLS LAST,
    claim_status;


-- ==========================================================
-- REPORT 4: TOP CUSTOMERS BY TOTAL CLAIM VALUE
--
-- Business question:
-- Which customers have the highest recorded total claim value?
--
-- This is a ranking by recorded claim value. It is not a
-- finding of customer misconduct or fraud.
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
WHERE total_claims > 0
ORDER BY
    total_claim_amount DESC NULLS LAST,
    customer_id
LIMIT 10;


-- ==========================================================
-- REPORT 5: CLAIMS BY PROVINCE
--
-- Business question:
-- How are recorded claims and claim values distributed
-- across customer provinces?
--
-- LEFT JOIN retains claims even when customer details or
-- province information are missing.
-- ==========================================================

SELECT
    COALESCE(c.province, 'Unknown / Missing') AS province,
    COUNT(rc.claim_id) AS total_claims,
    SUM(rc.claim_amount) AS total_claim_amount,
    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount
FROM reporting_claims AS rc
LEFT JOIN customers AS c
    ON c.customer_id = rc.customer_id
GROUP BY COALESCE(c.province, 'Unknown / Missing')
ORDER BY
    total_claim_amount DESC NULLS LAST,
    province;


-- ==========================================================
-- REPORT 6: CLAIMS BY POLICY TYPE
--
-- Business question:
-- How do recorded claim volumes and values compare across
-- customer policy types?
--
-- Missing policy-type information is retained as a separate
-- reporting category.
-- ==========================================================

SELECT
    COALESCE(c.policy_type, 'Unknown / Missing') AS policy_type,
    COUNT(rc.claim_id) AS total_claims,
    SUM(rc.claim_amount) AS total_claim_amount,
    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount
FROM reporting_claims AS rc
LEFT JOIN customers AS c
    ON c.customer_id = rc.customer_id
GROUP BY COALESCE(c.policy_type, 'Unknown / Missing')
ORDER BY
    total_claim_amount DESC NULLS LAST,
    policy_type;


-- ==========================================================
-- REPORT 7: APPROVED CLAIM SETTLEMENT PERFORMANCE
--
-- Business question:
-- What settlement times are recorded for approved claims?
--
-- Claims with missing settlement days are not included in
-- the average, minimum or maximum settlement calculations.
-- Counts show how many approved claims have settlement data.
-- ==========================================================

SELECT
    COUNT(*) FILTER (
        WHERE claim_status = 'Approved'
    ) AS total_approved_claims,

    COUNT(*) FILTER (
        WHERE claim_status = 'Approved'
          AND days_to_settle IS NOT NULL
    ) AS approved_claims_with_recorded_settlement,

    COUNT(*) FILTER (
        WHERE claim_status = 'Approved'
          AND days_to_settle IS NULL
    ) AS approved_claims_missing_settlement_days,

    ROUND(
        AVG(days_to_settle) FILTER (
            WHERE claim_status = 'Approved'
              AND days_to_settle IS NOT NULL
        ),
        2
    ) AS average_days_to_settle,

    MIN(days_to_settle) FILTER (
        WHERE claim_status = 'Approved'
          AND days_to_settle IS NOT NULL
    ) AS fastest_settlement_days,

    MAX(days_to_settle) FILTER (
        WHERE claim_status = 'Approved'
          AND days_to_settle IS NOT NULL
    ) AS longest_settlement_days

FROM reporting_claims;


-- ==========================================================
-- REPORT 8: CLAIMS BY INCIDENT TYPE
--
-- Business question:
-- Which recorded incident types have the highest total
-- claim value in this dataset?
--
-- This compares observed claim amounts; it does not measure
-- incident probability or establish causation.
-- ==========================================================

SELECT
    COALESCE(incident_type, 'Unknown / Missing') AS incident_type,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
GROUP BY COALESCE(incident_type, 'Unknown / Missing')
ORDER BY
    total_claim_amount DESC NULLS LAST,
    incident_type;


-- ==========================================================
-- REPORT 9: DATA QUALITY EXCEPTIONS
--
-- Business question:
-- Which claims have missing information that may affect
-- reporting completeness or interpretation?
--
-- Returns one row per identified issue. A claim can appear
-- more than once if it has multiple issues.
--
-- Missing settlement days are flagged here only for approved
-- claims. Pending or rejected claims may legitimately have
-- no recorded settlement duration.
-- ==========================================================

SELECT
    rc.claim_id,
    rc.customer_id,
    rc.policy_id,
    rc.claim_date,
    rc.claim_amount,
    rc.claim_status,
    rc.days_to_settle,
    issues.data_quality_issue
FROM reporting_claims AS rc
CROSS JOIN LATERAL (
    VALUES
        (
            'Missing claim date',
            rc.claim_date IS NULL
        ),
        (
            'Missing customer ID',
            rc.customer_id IS NULL
        ),
        (
            'Missing policy ID',
            rc.policy_id IS NULL
        ),
        (
            'Missing claim amount',
            rc.claim_amount IS NULL
        ),
        (
            'Missing claim status',
            rc.claim_status IS NULL
        ),
        (
            'Missing settlement days for approved claim',
            rc.claim_status = 'Approved'
            AND rc.days_to_settle IS NULL
        )
) AS issues(data_quality_issue, issue_found)
WHERE issues.issue_found
ORDER BY
    rc.claim_id,
    issues.data_quality_issue;



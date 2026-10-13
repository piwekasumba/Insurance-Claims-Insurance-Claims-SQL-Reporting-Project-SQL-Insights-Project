
-- ==========================================================
-- INSURANCE CLAIMS BUSINESS ANALYSIS REPORTS
-- PostgreSQL
--
-- Purpose:
-- Produce business-focused reports for customer exposure,
-- claim type performance, monthly trends, policy monitoring
-- and customer claim segmentation.
--
-- Data source:
-- reporting_claims and its supporting summary tables.
--
-- Reporting focus:
-- • Customer claim exposure
-- • Claim type performance
-- • Monthly trends
-- • Policy monitoring
-- • Customer claim segmentation
--
-- Note:
-- These reports describe the simulated dataset.
-- They do not predict future claims or determine fraud.
-- ==========================================================


-- ==========================================================
-- REPORT 1: HIGH-VALUE CUSTOMERS
-- ==========================================================
-- Business Question:
-- Which customers have the highest recorded claim values?
--
-- Business Purpose:
-- Supports customer-level reporting and operational review.
--
-- Reporting Output:
-- Top 10 customers ranked by total recorded claim amount.
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
    total_claims DESC,
    customer_id
LIMIT 10;


-- ==========================================================
-- REPORT 2: CLAIM TYPE PERFORMANCE
-- ==========================================================
-- Business Question:
-- Which claim types contribute the most to recorded costs?
--
-- Business Purpose:
-- Compares claim volumes and amounts across claim types.
--
-- Reporting Output:
-- Claim count, total amount and average amount by type.
-- ==========================================================

SELECT
    COALESCE(claim_type, 'Not recorded') AS claim_type,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
GROUP BY
    claim_type
ORDER BY
    total_claim_amount DESC NULLS LAST,
    total_claims DESC,
    claim_type;


-- ==========================================================
-- REPORT 3: MONTHLY CLAIMS TREND
-- ==========================================================
-- Business Question:
-- How does recorded claims activity change by month?
--
-- Business Purpose:
-- Supports monthly monitoring of claim volume and value.
--
-- Data-quality note:
-- Claims without a claim date are excluded because they
-- cannot be assigned reliably to a reporting month.
--
-- Reporting Output:
-- Monthly claim count, total amount and average amount.
-- ==========================================================

SELECT
    claim_year,
    claim_month,
    TO_CHAR(
        MAKE_DATE(claim_year, claim_month, 1),
        'Mon YYYY'
    ) AS reporting_month,
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
-- REPORT 4: POLICY CLAIM MONITORING
-- ==========================================================
-- Business Question:
-- Which policies have the highest recorded claim activity?
--
-- Business Purpose:
-- Supports policy-level comparison of recorded claim volume
-- and claim amounts.
--
-- Reporting Output:
-- Top 10 policies ranked by total claim amount.
-- ==========================================================

SELECT
    policy_id,
    total_claims,
    total_claim_amount,
    average_claim_amount,
    highest_claim_amount
FROM policy_claim_summary
ORDER BY
    total_claim_amount DESC NULLS LAST,
    total_claims DESC,
    policy_id
LIMIT 10;


-- ==========================================================
-- REPORT 5: CUSTOMER CLAIM SEGMENTATION
-- ==========================================================
-- Business Question:
-- Which customers have more than one Medium- or High-severity
-- recorded claim?
--
-- Business Purpose:
-- Supports review of repeated higher-value claims.
--
-- Important:
-- Severity is based on the project's defined claim-amount
-- thresholds. This report does not establish fraud or risk.
--
-- Reporting Output:
-- Customer details and metrics for Medium/High claims only.
-- ==========================================================

SELECT
    ccs.customer_id,
    ccs.first_name,
    ccs.last_name,
    ccs.province,
    ccs.policy_type,
    COUNT(rc.claim_id) AS medium_high_claims,
    SUM(rc.claim_amount) AS medium_high_claim_amount,
    ROUND(AVG(rc.claim_amount), 2)
        AS average_medium_high_claim_amount
FROM customer_claim_summary AS ccs
INNER JOIN reporting_claims AS rc
    ON ccs.customer_id = rc.customer_id
WHERE rc.claim_severity IN ('Medium', 'High')
GROUP BY
    ccs.customer_id,
    ccs.first_name,
    ccs.last_name,
    ccs.province,
    ccs.policy_type
HAVING COUNT(rc.claim_id) > 1
ORDER BY
    medium_high_claims DESC,
    medium_high_claim_amount DESC,
    ccs.customer_id;


-- ==========================================================
-- REPORT 6: CLAIM EXPOSURE BY PROVINCE
-- ==========================================================
-- Business Question:
-- How are recorded claim amounts distributed by province?
--
-- Business Purpose:
-- Supports geographic comparison of claim activity.
--
-- Data-quality note:
-- A LEFT JOIN keeps claims in the report even when a matching
-- customer or province is unavailable.
--
-- Reporting Output:
-- Claim count, total amount and average amount by province.
-- ==========================================================

SELECT
    COALESCE(c.province, 'Unknown / Not recorded') AS province,
    COUNT(rc.claim_id) AS total_claims,
    SUM(rc.claim_amount) AS total_claim_amount,
    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount
FROM reporting_claims AS rc
LEFT JOIN customers AS c
    ON rc.customer_id = c.customer_id
GROUP BY
    COALESCE(c.province, 'Unknown / Not recorded')
ORDER BY
    total_claim_amount DESC NULLS LAST,
    total_claims DESC,
    province;



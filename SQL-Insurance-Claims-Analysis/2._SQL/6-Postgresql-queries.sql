-- ==========================================================
-- INSURANCE CLAIMS REPORTING OUTPUTS
-- PostgreSQL
--
-- Purpose:
-- Produce business-focused reporting outputs from the
-- reporting layer.
--
-- Reporting focus:
-- • Claims severity
-- • Monthly claims performance
-- • Claim status performance
-- • Customer claims exposure
-- • Geographic claims reporting
-- • Policy type performance
-- • Settlement performance
-- ==========================================================


-- ==========================================================
-- REPORT 1: CLAIMS BY SEVERITY
-- Business Question:
-- How many claims fall into each severity level and what is
-- their financial impact?
--
-- Business Purpose:
-- Helps claims teams understand where claim costs are
-- concentrated and monitor financial exposure.
-- ==========================================================

SELECT
    claim_severity,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
GROUP BY claim_severity
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT 2: MONTHLY CLAIMS PERFORMANCE
-- Business Question:
-- How do claim volumes and claim costs change over time?
--
-- Business Purpose:
-- Supports monthly reporting by monitoring changes in
-- claim activity and financial exposure.
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
-- REPORT 3: CLAIM STATUS PERFORMANCE
-- Business Question:
-- How are claims distributed across their current statuses?
--
-- Business Purpose:
-- Supports operational monitoring by comparing claim volume
-- and financial value across approved, pending and rejected
-- claims.
-- ==========================================================

SELECT
    claim_status,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS claim_volume_percent
FROM reporting_claims
GROUP BY claim_status
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT 4: TOP CUSTOMERS BY TOTAL CLAIM VALUE
-- Business Question:
-- Which customers generated the highest total claim value?
--
-- Business Purpose:
-- Provides a ranked customer-level view for claims monitoring
-- and management reporting.
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
ORDER BY total_claim_amount DESC
LIMIT 10;


-- ==========================================================
-- REPORT 5: CLAIMS BY PROVINCE
-- Business Question:
-- Which provinces have the highest claims expenditure?
--
-- Business Purpose:
-- Combines customer and claims information to provide a
-- geographic management reporting view.
-- ==========================================================

SELECT
    c.province,
    COUNT(rc.claim_id) AS total_claims,
    SUM(rc.claim_amount) AS total_claim_amount,
    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN reporting_claims AS rc
    ON c.customer_id = rc.customer_id
GROUP BY c.province
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT 6: CLAIMS BY POLICY TYPE
-- Business Question:
-- Which policy types have the highest claims activity?
--
-- Business Purpose:
-- Supports policy-level reporting by comparing claim volume
-- and financial exposure across policy types.
-- ==========================================================

SELECT
    c.policy_type,
    COUNT(rc.claim_id) AS total_claims,
    SUM(rc.claim_amount) AS total_claim_amount,
    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN reporting_claims AS rc
    ON c.customer_id = rc.customer_id
GROUP BY c.policy_type
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT 7: SETTLEMENT PERFORMANCE
-- Business Question:
-- How quickly are approved claims being settled?
--
-- Business Purpose:
-- Supports operational reporting by measuring settlement
-- performance for approved claims.
-- ==========================================================

SELECT
    COUNT(claim_id) AS approved_claims,
    ROUND(AVG(days_to_settle), 2) AS average_days_to_settle,
    MIN(days_to_settle) AS fastest_settlement_days,
    MAX(days_to_settle) AS longest_settlement_days
FROM reporting_claims
WHERE claim_status = 'Approved'
  AND days_to_settle IS NOT NULL;


-- ==========================================================
-- REPORT 8: CLAIMS BY INCIDENT TYPE
-- Business Question:
-- Which incident types generate the greatest financial
-- exposure?
--
-- Business Purpose:
-- Supports incident-level reporting and helps identify
-- categories with higher claim costs.
-- ==========================================================

SELECT
    incident_type,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
GROUP BY incident_type
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT 9: DATA QUALITY EXCEPTIONS
-- Business Question:
-- Which claims contain missing information that could affect
-- reporting accuracy?
--
-- Business Purpose:
-- Helps identify records requiring attention before results
-- are used for management reporting.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    claim_date,
    claim_status,
    days_to_settle,
    CASE
        WHEN claim_date IS NULL
             AND days_to_settle IS NULL
            THEN 'Missing claim date and settlement days'

        WHEN claim_date IS NULL
            THEN 'Missing claim date'

        WHEN days_to_settle IS NULL
            THEN 'Missing settlement days'

        ELSE 'No identified issue'
    END AS data_quality_issue
FROM reporting_claims
WHERE claim_date IS NULL
   OR days_to_settle IS NULL
ORDER BY claim_id;


-- ==========================================================
-- INSURANCE CLAIMS BUSINESS ANALYSIS REPORTS
-- PostgreSQL
--
-- Purpose:
-- Produce business-focused reports for customer exposure,
-- claim type performance, monthly trends, policy monitoring
-- and customer claim segmentation.
--
-- Reporting focus:
-- • Customer claim exposure
-- • Claim type performance
-- • Monthly trends
-- • Policy monitoring
-- • Customer claim segmentation
-- ==========================================================


-- ==========================================================
-- REPORT 1: HIGH-VALUE CUSTOMERS
-- ==========================================================
-- Business Question:
-- Which customers have the highest total claim costs?
--
-- Business Purpose:
-- Helps identify customers with higher claim exposure for
-- operational monitoring and business review.
--
-- Reporting Output:
-- Ranked customer list by total claim value.
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
    total_claim_amount DESC
LIMIT 10;


-- ==========================================================
-- REPORT 2: CLAIM TYPE PERFORMANCE
-- ==========================================================
-- Business Question:
-- Which claim types contribute the most to total claim costs?
--
-- Business Purpose:
-- Helps claims teams understand which claim categories have
-- the greatest financial impact.
--
-- Reporting Output:
-- Claim volume, total cost and average claim value by type.
-- ==========================================================

SELECT
    claim_type,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM reporting_claims
GROUP BY claim_type
ORDER BY
    total_claim_amount DESC;


-- ==========================================================
-- REPORT 3: MONTHLY CLAIMS TREND
-- ==========================================================
-- Business Question:
-- How does claims activity change over time?
--
-- Business Purpose:
-- Supports monthly reporting by monitoring claim volume and
-- total claim costs.
--
-- Reporting Output:
-- Monthly claim count, total value and average claim value.
-- ==========================================================

SELECT
    claim_year,
    claim_month,
    COUNT(claim_id) AS total_claims,
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
-- Which policies have the highest claim activity and costs?
--
-- Business Purpose:
-- Supports policy-level operational monitoring and helps
-- identify policies with higher claims exposure.
--
-- Reporting Output:
-- Ranked policy claims summary.
-- ==========================================================

SELECT
    policy_id,
    total_claims,
    total_claim_amount,
    average_claim_amount,
    highest_claim_amount
FROM policy_claim_summary
ORDER BY
    total_claim_amount DESC,
    total_claims DESC
LIMIT 10;


-- ==========================================================
-- REPORT 5: CUSTOMER CLAIM SEGMENTATION
-- ==========================================================
-- Business Question:
-- Which customers have multiple claims with Medium or High
-- severity?
--
-- Business Purpose:
-- Supports customer-level operational monitoring by
-- identifying customers with repeated higher-value claims.
--
-- Important:
-- This report identifies customers for business review.
-- It does not determine fraud or customer risk.
-- ==========================================================

SELECT
    ccs.customer_id,
    ccs.first_name,
    ccs.last_name,
    ccs.province,
    ccs.policy_type,
    COUNT(rc.claim_id) AS medium_high_claims,
    SUM(rc.claim_amount) AS total_claim_amount,
    ROUND(AVG(rc.claim_amount), 2) AS average_claim_amount
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
    total_claim_amount DESC;


-- ==========================================================
-- REPORT 6: CLAIM EXPOSURE BY PROVINCE
-- ==========================================================
-- Business Question:
-- Which provinces have the greatest total claim exposure?
--
-- Business Purpose:
-- Supports geographic reporting and helps management compare
-- claims activity across provinces.
--
-- Reporting Output:
-- Province-level claims KPI summary.
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
ORDER BY
    total_claim_amount DESC;


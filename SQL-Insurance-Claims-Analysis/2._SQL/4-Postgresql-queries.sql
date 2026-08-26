-- ===========================================================
-- INSURANCE CLAIMS REPORTING & ANALYSIS
-- PostgreSQL
--
-- Purpose:
-- Analyse insurance claims and produce reporting outputs
-- that support claims monitoring, KPI reporting and
-- business decision-making.
--
-- Skills demonstrated:
-- • SELECT and filtering
-- • INNER JOIN
-- • GROUP BY and aggregations
-- • CASE expressions
-- • ORDER BY and LIMIT
-- • KPI calculations
-- • Data quality checks
-- • Customer and claims analysis
--
-- Data sources:
-- • customers_raw.csv
-- • claims_raw.csv
-- ===========================================================


-- ===========================================================
-- REPORT 1
-- Overall Claims KPI Summary
--
-- Business Question:
-- What is the overall claims position?
--
-- Reporting Purpose:
-- Provides a high-level summary of claim volume,
-- total claim value and average claim value.
-- ===========================================================

SELECT
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MIN(claim_amount) AS lowest_claim_amount,
    MAX(claim_amount) AS highest_claim_amount
FROM claims;


-- ===========================================================
-- REPORT 2
-- Claims by Claim Type
--
-- Business Question:
-- Which types of claims contribute the most
-- to overall claims expenditure?
--
-- Reporting Purpose:
-- Helps management compare claim volume and
-- financial exposure across claim types.
-- ===========================================================

SELECT
    claim_type,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims
GROUP BY claim_type
ORDER BY total_claim_amount DESC;


-- ===========================================================
-- REPORT 3
-- Claims by Incident City
--
-- Business Question:
-- Which incident locations have the highest
-- claims activity and claim value?
--
-- Reporting Purpose:
-- Supports geographic claims reporting and
-- identification of locations with higher
-- claims expenditure.
-- ===========================================================

SELECT
    incident_city,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims
GROUP BY incident_city
ORDER BY total_claim_amount DESC;


-- ===========================================================
-- REPORT 4
-- Claims by Status
--
-- Business Question:
-- How are claims distributed across
-- Approved, Pending and Rejected statuses?
--
-- Reporting Purpose:
-- Supports claims pipeline monitoring by
-- comparing claim volume and financial value
-- across statuses.
-- ===========================================================

SELECT
    claim_status,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims
GROUP BY claim_status
ORDER BY total_claims DESC;


-- ===========================================================
-- REPORT 5
-- Claims by Customer Province
--
-- Business Question:
-- Which provinces have the highest total
-- claims expenditure?
--
-- Reporting Purpose:
-- Combines customer and claims data to provide
-- a province-level reporting view.
-- ===========================================================

SELECT
    c.province,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY c.province
ORDER BY total_claim_amount DESC;


-- ===========================================================
-- REPORT 6
-- Claims by Policy Type
--
-- Business Question:
-- Which policy types have the highest claims
-- activity and claim value?
--
-- Reporting Purpose:
-- Supports reporting by policy segment and
-- helps compare claims performance across
-- different policy types.
-- ===========================================================

SELECT
    c.policy_type,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY c.policy_type
ORDER BY total_claim_amount DESC;


-- ===========================================================
-- REPORT 7
-- Claims by Customer Age Group
--
-- Business Question:
-- How does claims activity differ across
-- customer age groups?
--
-- Reporting Purpose:
-- Provides a simple customer segmentation view
-- for management reporting.
-- ===========================================================

SELECT
    CASE
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY age_group
ORDER BY total_claim_amount DESC;


-- ===========================================================
-- REPORT 8
-- Top Customers by Total Claim Value
--
-- Business Question:
-- Which customers have generated the highest
-- total claim value?
--
-- Reporting Purpose:
-- Provides a ranked customer-level reporting
-- view for claims monitoring.
-- ===========================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount,
    MAX(cl.claim_amount) AS highest_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_claim_amount DESC
LIMIT 10;


-- ===========================================================
-- REPORT 9
-- Approved Claims Settlement Performance
--
-- Business Question:
-- How long do approved claims take to settle?
--
-- Reporting Purpose:
-- Supports operational reporting by measuring
-- settlement performance for approved claims.
-- ===========================================================

SELECT
    COUNT(claim_id) AS approved_claims,
    ROUND(AVG(days_to_settle), 2) AS average_days_to_settle,
    MIN(days_to_settle) AS fastest_settlement_days,
    MAX(days_to_settle) AS longest_settlement_days
FROM claims
WHERE claim_status = 'Approved'
  AND days_to_settle IS NOT NULL;


-- ===========================================================
-- REPORT 10
-- Data Quality Check
--
-- Business Question:
-- Which claims contain missing information
-- that may affect reporting?
--
-- Reporting Purpose:
-- Identifies missing claim dates and settlement
-- information before reporting results are used.
-- ===========================================================

SELECT
    COUNT(*) FILTER (WHERE claim_date IS NULL)
        AS missing_claim_dates,

    COUNT(*) FILTER (WHERE days_to_settle IS NULL)
        AS missing_settlement_days,

    COUNT(*) FILTER (WHERE claim_amount IS NULL)
        AS missing_claim_amounts
FROM claims;



-- ===========================================================
-- INSURANCE CLAIMS REPORTING & ANALYSIS
-- PostgreSQL
--
-- Purpose:
-- Analyse simulated insurance claims and produce reporting
-- outputs for claims monitoring, KPI reporting and analysis.
--
-- Data sources:
-- customers_raw.csv
-- claims_raw.csv
--
-- Database tables:
-- customers
-- claims_raw
--
-- Important:
-- These queries report recorded claim values. They do not
-- predict future claims or establish fraud or risk.
-- ===========================================================


-- ===========================================================
-- REPORT 1
-- Overall Claims KPI Summary
-- ===========================================================

SELECT
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MIN(claim_amount) AS lowest_claim_amount,
    MAX(claim_amount) AS highest_claim_amount
FROM claims_raw;


-- ===========================================================
-- REPORT 2
-- Claims by Claim Type
-- ===========================================================

SELECT
    COALESCE(claim_type, 'Unknown / Missing') AS claim_type,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_raw
GROUP BY COALESCE(claim_type, 'Unknown / Missing')
ORDER BY total_claim_amount DESC NULLS LAST,
         claim_type;


-- ===========================================================
-- REPORT 3
-- Claims by Incident City
-- ===========================================================

SELECT
    COALESCE(incident_city, 'Unknown / Missing') AS incident_city,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_raw
GROUP BY COALESCE(incident_city, 'Unknown / Missing')
ORDER BY total_claim_amount DESC NULLS LAST,
         incident_city;


-- ===========================================================
-- REPORT 4
-- Claims by Status
-- ===========================================================

SELECT
    COALESCE(claim_status, 'Unknown / Missing') AS claim_status,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_raw
GROUP BY COALESCE(claim_status, 'Unknown / Missing')
ORDER BY total_claims DESC,
         claim_status;


-- ===========================================================
-- REPORT 5
-- Claims by Customer Province
--
-- LEFT JOIN retains claims even when customer details
-- are missing or cannot be matched.
-- ===========================================================

SELECT
    COALESCE(c.province, 'Unknown / Missing') AS customer_province,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM claims_raw AS cl
LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id
GROUP BY COALESCE(c.province, 'Unknown / Missing')
ORDER BY total_claim_amount DESC NULLS LAST,
         customer_province;


-- ===========================================================
-- REPORT 6
-- Claims by Customer Policy Type
-- ===========================================================

SELECT
    COALESCE(c.policy_type, 'Unknown / Missing') AS policy_type,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM claims_raw AS cl
LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id
GROUP BY COALESCE(c.policy_type, 'Unknown / Missing')
ORDER BY total_claim_amount DESC NULLS LAST,
         policy_type;


-- ===========================================================
-- REPORT 7
-- Claims by Customer Age Group
-- ===========================================================

SELECT
    CASE
        WHEN c.age IS NULL THEN 'Unknown / Missing'
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM claims_raw AS cl
LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id
GROUP BY
    CASE
        WHEN c.age IS NULL THEN 'Unknown / Missing'
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END
ORDER BY total_claim_amount DESC NULLS LAST,
         age_group;


-- ===========================================================
-- REPORT 8
-- Top 10 Customers by Total Claim Value
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
INNER JOIN claims_raw AS cl
    ON c.customer_id = cl.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_claim_amount DESC,
         total_claims DESC,
         c.customer_id
LIMIT 10;


-- ===========================================================
-- REPORT 9
-- Approved Claims Settlement Performance
--
-- Counts all approved claims separately from those with
-- recorded settlement days.
-- ===========================================================

SELECT
    COUNT(claim_id) AS total_approved_claims,

    COUNT(days_to_settle) AS approved_claims_with_settlement_days,

    ROUND(AVG(days_to_settle), 2) AS average_days_to_settle,

    MIN(days_to_settle) AS fastest_recorded_settlement_days,

    MAX(days_to_settle) AS longest_recorded_settlement_days
FROM claims_raw
WHERE claim_status = 'Approved';


-- ===========================================================
-- REPORT 10
-- Data Quality Summary
--
-- Missing settlement days are not automatically errors:
-- pending or rejected claims may not have settlement values.
-- ===========================================================

SELECT
    COUNT(*) AS total_claim_records,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,

    COUNT(*) FILTER (
        WHERE policy_id IS NULL
    ) AS missing_policy_ids,

    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS missing_claim_dates,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS missing_claim_amounts,

    COUNT(*) FILTER (
        WHERE claim_status IS NULL
    ) AS missing_claim_statuses,

    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS missing_settlement_days,

    COUNT(*) FILTER (
        WHERE claim_status = 'Approved'
          AND days_to_settle IS NULL
    ) AS approved_claims_missing_settlement_days
FROM claims_raw;

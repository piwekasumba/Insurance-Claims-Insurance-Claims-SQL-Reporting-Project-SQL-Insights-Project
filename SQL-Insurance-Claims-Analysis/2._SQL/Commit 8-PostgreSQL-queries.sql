-- ==========================================================
-- REPORT: HIGH-VALUE CUSTOMERS
-- ==========================================================
-- Business Question
-- Which customers have generated total claim costs above R100,000?
--
-- Business Purpose
-- Helps identify customers who may require additional risk
-- monitoring and supports operational claims reporting.
--
-- Reporting Output
-- Ranked list of customers with high total claim costs.
-- ==========================================================

SELECT
    cs.customer_id,
    cs.full_name,
    cs.total_claims,
    cs.total_claim_amount,
    ROUND(cs.avg_claim_amount, 2) AS avg_claim_amount
FROM customer_summary AS cs
WHERE cs.total_claim_amount > 100000
ORDER BY cs.total_claim_amount DESC;


-- ==========================================================
-- REPORT: CLAIM TYPE PERFORMANCE
-- ==========================================================
-- Business Question
-- Which claim types contribute the most to total claim costs?
--
-- Business Purpose
-- Helps claims managers understand which claim categories
-- have the greatest financial impact.
--
-- Reporting Output
-- Summary of claim volume, total cost and average claim value
-- by claim type.
-- ==========================================================

SELECT
    claim_type_clean AS claim_type,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount
FROM claims_clean
GROUP BY claim_type_clean
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT: MONTHLY CLAIMS TREND
-- ==========================================================
-- Business Question
-- How does claims activity change over time?
--
-- Business Purpose
-- Supports monthly reporting by monitoring claim volumes and
-- total claim costs to identify operational trends.
--
-- Reporting Output
-- Monthly summary showing claim count and total claim value.
-- ==========================================================

SELECT
    claim_year,
    claim_month,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount
FROM claims_clean
GROUP BY
    claim_year,
    claim_month
ORDER BY
    claim_year,
    claim_month;


-- ==========================================================
-- REPORT: HIGH-RISK POLICIES
-- ==========================================================
-- Business Question
-- Which policies have experienced three or more high-severity
-- claims?
--
-- Business Purpose
-- Supports risk monitoring by identifying policies with
-- repeated high-value claims.
--
-- Reporting Output
-- Ranked list of policies requiring further business review.
-- ==========================================================

SELECT
    policy_number,
    COUNT(*) AS high_severity_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount
FROM claims_clean
WHERE claim_severity = 'High'
GROUP BY
    policy_number
HAVING COUNT(*) >= 3
ORDER BY
    total_claim_amount DESC;


-- ==========================================================
-- REPORT: CUSTOMER RISK SEGMENTATION
-- ==========================================================
-- Business Question
-- Which customers have three or more Medium or High severity
-- claims?
--
-- Business Purpose
-- Supports customer segmentation by identifying customers
-- with consistently higher claims activity.
--
-- Reporting Output
-- Customers requiring closer operational monitoring.
-- ==========================================================

SELECT
    cs.customer_id,
    cs.full_name,
    SUM(
        CASE
            WHEN cl.claim_severity IN ('Medium', 'High')
            THEN 1
            ELSE 0
        END
    ) AS medium_high_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS avg_claim_amount
FROM customer_summary AS cs
INNER JOIN claims_clean AS cl
    ON cs.customer_id = cl.customer_id
GROUP BY
    cs.customer_id,
    cs.full_name
HAVING SUM(
        CASE
            WHEN cl.claim_severity IN ('Medium', 'High')
            THEN 1
            ELSE 0
        END
    ) >= 3
ORDER BY
    medium_high_claims DESC,
    total_claim_amount DESC;

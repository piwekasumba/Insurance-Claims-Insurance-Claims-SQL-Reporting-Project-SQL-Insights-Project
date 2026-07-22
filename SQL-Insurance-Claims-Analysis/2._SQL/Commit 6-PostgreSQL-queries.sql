-- ==========================================================
-- REPORT 1: CLAIMS BY SEVERITY
-- Business Question:
-- How many claims fall into each severity level and what is
-- their financial impact?
--
-- Business Purpose:
-- Helps claims managers understand where the largest claim
-- costs are concentrated and monitor overall risk exposure.
-- ==========================================================

SELECT
    claim_severity,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_clean
GROUP BY claim_severity
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT 2: MONTHLY CLAIMS PERFORMANCE
-- Business Question:
-- How do claim volumes and claim costs change over time?
--
-- Business Purpose:
-- Supports monthly operational reporting by monitoring trends
-- in claim activity and identifying changes in business
-- performance.
-- ==========================================================

SELECT
    claim_year,
    claim_month,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_clean
GROUP BY claim_year, claim_month
ORDER BY claim_year, claim_month;


-- ==========================================================
-- REPORT 3: CLAIM APPROVAL PERFORMANCE
-- Business Question:
-- What percentage of claims are approved within each
-- severity category?
--
-- Business Purpose:
-- Supports operational performance reporting by comparing
-- approval rates across different levels of claim severity.
-- ==========================================================

SELECT
    claim_severity,
    COUNT(*) AS total_claims,
    SUM(
        CASE
            WHEN claim_status = 'Approved' THEN 1
            ELSE 0
        END
    ) AS approved_claims,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN claim_status = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS approval_rate_percent,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_clean
GROUP BY claim_severity
ORDER BY approval_rate_percent DESC;


-- ==========================================================
-- REPORT 4: TOP CUSTOMERS BY TOTAL CLAIM VALUE
-- Business Question:
-- Which customers generated the highest total claim costs?
--
-- Business Purpose:
-- Helps identify customers with high claim activity for
-- operational monitoring and business reporting.
-- ==========================================================

SELECT
    customer_id,
    total_claims,
    total_claim_amount,
    ROUND(avg_claim_amount, 2) AS average_claim_amount
FROM customer_summary
ORDER BY total_claim_amount DESC
LIMIT 10;


-- ==========================================================
-- REPORT 5: CLAIM SEVERITY DISTRIBUTION
-- Business Question:
-- How are claims distributed across severity categories?
--
-- Business Purpose:
-- Provides a high-level summary of the claims portfolio to
-- support management reporting and risk monitoring.
-- ==========================================================

SELECT
    claim_severity,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount
FROM claims_clean
GROUP BY claim_severity
ORDER BY total_claim_amount DESC;


-- ==========================================================
-- REPORT: HIGH CLAIM ACTIVITY CUSTOMERS
-- ==========================================================
-- Business Question:
-- Which customers submitted the highest number of claims?
--
-- Business Purpose:
-- Supports operational reporting by identifying customers
-- with high claims activity that may require further review.
--
-- Reporting Output:
-- Ranked customer claims summary.
-- ==========================================================

SELECT
    cs.customer_id,
    cs.full_name,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customer_summary AS cs
INNER JOIN claims_clean AS cl
    ON cs.customer_id = cl.customer_id
GROUP BY
    cs.customer_id,
    cs.full_name
HAVING COUNT(cl.claim_id) >= 5
ORDER BY
    total_claim_amount DESC,
    total_claims DESC;


-- ==========================================================
-- REPORT: HIGH-VALUE CLAIM EXCEPTIONS
-- ==========================================================
-- Business Question:
-- Which claims are significantly above the average claim value?
--
-- Business Purpose:
-- Helps claims teams identify unusually large claims that
-- may require additional business review.
--
-- Reporting Output:
-- Exception report for high-value claims.
-- ==========================================================

WITH claim_statistics AS (
    SELECT
        AVG(claim_amount) AS average_claim,
        STDDEV(claim_amount) AS standard_deviation
    FROM claims_clean
)

SELECT
    c.claim_id,
    c.customer_id,
    c.policy_number,
    c.claim_date,
    c.claim_amount
FROM claims_clean AS c
CROSS JOIN claim_statistics AS s
WHERE c.claim_amount >
      (s.average_claim + (2 * s.standard_deviation))
ORDER BY
    c.claim_amount DESC;


-- ==========================================================
-- REPORT: HIGH-SEVERITY POLICY MONITORING
-- ==========================================================
-- Business Question:
-- Which policies generated multiple high-severity claims?
--
-- Business Purpose:
-- Supports operational monitoring by identifying policies
-- with repeated high-cost claims.
--
-- Reporting Output:
-- Policy risk monitoring report.
-- ==========================================================

SELECT
    policy_number,
    COUNT(*) AS high_severity_claims,
    SUM(claim_amount) AS total_claim_cost,
    MIN(claim_date) AS first_claim_date,
    MAX(claim_date) AS latest_claim_date
FROM claims_clean
WHERE claim_severity = 'High'
GROUP BY
    policy_number
HAVING COUNT(*) >= 3
ORDER BY
    total_claim_cost DESC;


-- ==========================================================
-- REPORT: CUSTOMERS REQUIRING BUSINESS REVIEW
-- ==========================================================
-- Business Question:
-- Which customers have both high claim frequency and
-- unusually high claim values?
--
-- Business Purpose:
-- Produces an exception report to support operational
-- review and risk monitoring.
--
-- Reporting Output:
-- Customer review report.
-- ==========================================================

WITH high_frequency_customers AS (
    SELECT
        customer_id
    FROM claims_clean
    GROUP BY customer_id
    HAVING COUNT(*) >= 5
),

high_value_customers AS (
    SELECT
        customer_id
    FROM claims_clean
    WHERE claim_amount >
    (
        SELECT
            AVG(claim_amount) + (2 * STDDEV(claim_amount))
        FROM claims_clean
    )
)

SELECT DISTINCT
    c.customer_id,
    c.full_name
FROM customers AS c
INNER JOIN high_frequency_customers AS hf
    ON c.customer_id = hf.customer_id
INNER JOIN high_value_customers AS hv
    ON c.customer_id = hv.customer_id
ORDER BY
    c.customer_id;

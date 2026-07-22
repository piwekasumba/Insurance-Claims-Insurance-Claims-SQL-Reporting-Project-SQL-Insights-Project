-- ==========================================
-- REPORT EXPORTS
-- Prepare reporting outputs for business users
-- ==========================================

-- Export cleaned claims dataset
-- Used for operational reporting and dashboard development
COPY claims_clean
TO 'reports/claims_clean.csv'
WITH CSV HEADER;

-- Export customer claims summary
-- Used to monitor customer claim activity and claim values
COPY customer_summary
TO 'reports/customer_claim_summary.csv'
WITH CSV HEADER;

-- Export policy claims summary
-- Used for policy performance reporting
COPY policy_summary
TO 'reports/policy_claim_summary.csv'
WITH CSV HEADER;

-- ==========================================
-- HIGH-RISK CUSTOMER REVIEW REPORT
-- Business Purpose:
-- Identify customers with unusually high claim activity
-- and high claim values for further business review.
-- ==========================================

COPY (

WITH high_frequency AS (

    SELECT
        customer_id
    FROM claims_clean
    GROUP BY customer_id
    HAVING COUNT(*) > 5

),

high_value AS (

    SELECT
        customer_id
    FROM claims_clean
    WHERE claim_amount >
    (
        SELECT AVG(claim_amount) + (2 * STDDEV(claim_amount))
        FROM claims_clean
    )

)

SELECT DISTINCT

    c.customer_id,
    c.full_name

FROM customers AS c

INNER JOIN high_frequency AS hf
    ON c.customer_id = hf.customer_id

INNER JOIN high_value AS hv
    ON c.customer_id = hv.customer_id

ORDER BY c.customer_id

)

TO 'reports/high_risk_customer_review.csv'
WITH CSV HEADER;

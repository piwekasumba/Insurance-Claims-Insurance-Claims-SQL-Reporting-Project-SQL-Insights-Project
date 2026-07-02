-- =========================
-- EXPORT ANALYTICS TABLES
-- =========================

COPY claims_clean
TO 'data/claims_clean.csv'
WITH CSV HEADER;

COPY customer_summary
TO 'data/customer_summary.csv'
WITH CSV HEADER;

COPY policy_summary
TO 'data/policy_summary.csv'
WITH CSV HEADER;

-- =========================
-- EXPORT FRAUD REVIEW LIST
-- =========================

COPY (WITH high_frequency AS (
        SELECT customer_id
        FROM claims_clean
        GROUP BY customer_id
        HAVING COUNT(*) > 5
    ),
    high_value AS (SELECT customer_id
        FROM claims_clean
        WHERE claim_amount > (SELECT AVG(claim_amount) + (2 * STDDEV(claim_amount))
            FROM claims_clean)
    )

    SELECT DISTINCT
        c.customer_id,
        c.full_name
    FROM customers c
    INNER JOIN high_frequency hf
        ON c.customer_id = hf.customer_id
    INNER JOIN high_value hv
        ON c.customer_id = hv.customer_id
)
TO 'data/fraud_review_customers.csv'
WITH CSV HEADER;

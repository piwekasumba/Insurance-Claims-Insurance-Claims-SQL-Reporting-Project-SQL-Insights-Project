-- ==========================================
-- HIGH CLAIM ACTIVITY CUSTOMERS (CURRENT YEAR)
-- ==========================================

SELECT
    cs.customer_id,
    cs.full_name,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS avg_claim_amount
FROM customer_summary AS cs
JOIN claims_clean AS cl
    ON cs.customer_id = cl.customer_id
WHERE cl.claim_year = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
    cs.customer_id,
    cs.full_name
HAVING COUNT(cl.claim_id) > 5
ORDER BY
    total_claim_amount DESC,
    total_claims DESC;

-- =========================
-- STATISTICAL OUTLIER CLAIMS (2 STD DEV RULE)
-- =========================

WITH stats AS (
    SELECT
        AVG(claim_amount) AS avg_amount,
        STDDEV(claim_amount) AS std_dev
    FROM claims_clean
)
SELECT
    cl.claim_id,
    cl.customer_id,
    cl.claim_amount,
    cl.claim_date,
    cl.policy_number
FROM claims_clean cl
CROSS JOIN stats s
WHERE cl.claim_amount > (s.avg_amount + 2 * s.std_dev)
ORDER BY cl.claim_amount DESC;

-- =========================
-- POLICIES WITH FREQUENT HIGH-SEVERITY CLAIMS
-- =========================

SELECT
    policy_number,
    COUNT(*) AS high_severity_claims,
    MIN(claim_date) AS first_claim_date,
    MAX(claim_date) AS last_claim_date
FROM claims_clean
WHERE claim_severity = 'High'
GROUP BY policy_number
HAVING COUNT(*) >= 3
   AND (MAX(claim_date) - MIN(claim_date)) <= INTERVAL '90 days'
ORDER BY high_severity_claims DESC;

-- =========================
-- FRAUD INDICATOR: HIGH FREQUENCY + HIGH VALUE CLAIMS
-- =========================

WITH high_frequency AS (
    SELECT customer_id
    FROM claims_clean
    GROUP BY customer_id
    HAVING COUNT(*) > 5
),
high_value AS (
    SELECT customer_id
    FROM claims_clean
    WHERE claim_amount > (
        SELECT AVG(claim_amount) + 2 * STDDEV(claim_amount)
        FROM claims_clean
    )
)

SELECT DISTINCT c.customer_id, c.full_name
FROM customers c
JOIN high_frequency hf ON c.customer_id = hf.customer_id
JOIN high_value hv ON c.customer_id = hv.customer_id;


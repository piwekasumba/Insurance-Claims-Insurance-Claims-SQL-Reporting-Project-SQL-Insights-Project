-- =========================
-- ETL: Build Claims Reporting Table
-- =========================

CREATE TABLE claims_reporting AS
SELECT
    claim_id,
    customer_id,
    claim_date,
    claim_amount,

    EXTRACT(YEAR FROM claim_date) AS claim_year,
    EXTRACT(MONTH FROM claim_date) AS claim_month,

    CASE
        WHEN claim_amount > 50000 THEN 'High'
        WHEN claim_amount BETWEEN 10000 AND 50000 THEN 'Medium'
        ELSE 'Low'
    END AS claim_severity

FROM claims;

-- =========================
-- Reporting Summary by Customer
-- =========================

CREATE TABLE customer_summary AS
SELECT
    c.customer_id,
    c.sex AS gender,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    AVG(cl.claim_amount) AS avg_claim_amount,
    MAX(cl.claim_amount) AS max_claim_amount,
    MIN(cl.claim_amount) AS min_claim_amount
FROM customers c
LEFT JOIN claims_clean cl ON c.customer_id = cl.customer_id
GROUP BY c.customer_id, c.sex;

-- =========================
-- customer_claim_summary
-- =========================

CREATE TABLE policy_summary AS
SELECT
    customer_id,
    COUNT(claim_id) AS num_claims,
    SUM(claim_amount) AS total_claim_amount,
    AVG(claim_amount) AS avg_claim_amount,
    MAX(claim_amount) AS max_claim_amount,
    MIN(claim_amount) AS min_claim_amount
FROM claims_clean
GROUP BY customer_id;

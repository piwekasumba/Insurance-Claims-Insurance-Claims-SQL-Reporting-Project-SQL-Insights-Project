-- =========================
-- EXTRACT LAYER (RAW TABLE)
-- =========================

CREATE TABLE IF NOT EXISTS claims_raw (
    claim_id SERIAL PRIMARY KEY,
    policy_id INT,
    customer_id INT,
    claim_amount NUMERIC,
    claim_date DATE,
    policy_type VARCHAR(50),
    fraud_flag BOOLEAN DEFAULT FALSE
);

-- =========================
-- BASIC DATA CLEANING
-- =========================

-- Remove invalid records (missing critical values)
DELETE FROM claims_raw
WHERE claim_amount IS NULL
   OR claim_date IS NULL;

-- Standardize text values
UPDATE claims_raw
SET policy_type = INITCAP(policy_type);

-- =========================
-- TRANSFORMATION LAYER (DERIVED TABLE)
-- =========================

CREATE TABLE claims_clean AS
SELECT
    claim_id,
    policy_id,
    customer_id,
    claim_amount,
    claim_date,
    policy_type,
    fraud_flag,

    -- Derived time feature
    EXTRACT(YEAR FROM claim_date) AS claim_year,

    -- Business risk classification
    CASE
        WHEN claim_amount > 50000 THEN 'High'
        WHEN claim_amount BETWEEN 10000 AND 50000 THEN 'Medium'
        ELSE 'Low'
    END AS claim_risk_level

FROM claims_raw;

-- =========================
-- AGGREGATION LAYER (REPORTING TABLE)
-- =========================

CREATE TABLE claims_summary AS
SELECT
    policy_type,
    COUNT(*) AS total_claims,
    AVG(claim_amount) AS avg_claim_amount,
    SUM(claim_amount) AS total_claim_amount,
    SUM(CASE WHEN fraud_flag = TRUE THEN 1 ELSE 0 END) AS total_fraud_cases
FROM claims_clean
GROUP BY policy_type;


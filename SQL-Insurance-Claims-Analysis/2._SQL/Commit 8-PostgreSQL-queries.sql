-- =========================
-- HIGH VALUE CUSTOMERS (THRESHOLD ANALYSIS)
-- =========================

SELECT
    cs.customer_id,
    cs.full_name,
    cs.total_claims,
    cs.total_claim_amount,
    cs.avg_claim_amount
FROM customer_summary cs
WHERE cs.total_claim_amount > 100000
ORDER BY cs.total_claim_amount DESC;

-- =========================
-- CLAIM TYPE PERFORMANCE ANALYSIS
-- =========================

SELECT
    claim_type_clean AS claim_type,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_amount,
    AVG(claim_amount) AS avg_claim_amount
FROM claims_clean
GROUP BY claim_type_clean
ORDER BY total_claim_amount DESC;

-- =========================
-- MONTHLY CLAIM TREND ANALYSIS
-- =========================

SELECT
    claim_year,
    claim_month,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_amount
FROM claims_clean
GROUP BY claim_year, claim_month
HAVING SUM(claim_amount) > 50000
ORDER BY claim_year, claim_month;

-- =========================
-- POLICIES WITH REPEATED HIGH-SEVERITY CLAIMS
-- =========================

SELECT
    policy_number,
    COUNT(*) AS high_severity_claims,
    SUM(claim_amount) AS total_claim_amount
FROM claims_clean
WHERE claim_severity = 'High'
GROUP BY policy_number
HAVING COUNT(*) >= 3
ORDER BY total_claim_amount DESC;

-- =========================
-- CUSTOMER CLAIM SEVERITY SEGMENTATION
-- =========================

SELECT
    cs.customer_id,
    cs.full_name,
    SUM(CASE WHEN cl.claim_severity IN ('Medium', 'High') THEN 1 ELSE 0 END) AS medium_high_claims
FROM customer_summary cs
JOIN claims_clean cl ON cs.customer_id = cl.customer_id
GROUP BY cs.customer_id, cs.full_name
HAVING SUM(CASE WHEN cl.claim_severity IN ('Medium', 'High') THEN 1 ELSE 0 END) >= 3
ORDER BY medium_high_claims DESC;


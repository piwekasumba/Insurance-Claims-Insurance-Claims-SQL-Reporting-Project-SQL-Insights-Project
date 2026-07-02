-- =========================
-- HIGH-VALUE CUSTOMERS
-- Business Question:
-- Which customers have generated claim costs above R100,000?
-- This helps identify customers who may require closer risk monitoring.
-- =========================

SELECT
    cs.customer_id,
    cs.full_name,
    cs.total_claims,
    cs.total_claim_amount,
    cs.avg_claim_amount
FROM customer_summary AS cs
WHERE cs.total_claim_amount > 100000
ORDER BY cs.total_claim_amount DESC;


-- =========================
-- CLAIM TYPE PERFORMANCE
-- Business Question:
-- Which claim types contribute the most to total claim costs?
-- This supports reporting and risk analysis.
-- =========================

SELECT
    claim_type_clean AS claim_type,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount),2) AS avg_claim_amount
FROM claims_clean
GROUP BY claim_type_clean
ORDER BY total_claim_amount DESC;


-- =========================
-- MONTHLY CLAIMS TREND
-- Business Question:
-- Which months recorded the highest total claim costs?
-- Only months exceeding R50,000 are included.
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
-- Business Question:
-- Which policies have experienced three or more high-severity claims?
-- Useful for identifying potentially high-risk policies.
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
-- Business Question:
-- Which customers have three or more Medium or High severity claims?
-- Supports customer risk segmentation.
-- =========================

SELECT
    cs.customer_id,
    cs.full_name,
    SUM(
        CASE
            WHEN cl.claim_severity IN ('Medium', 'High') THEN 1
            ELSE 0
        END
    ) AS medium_high_claims
FROM customer_summary AS cs
JOIN claims_clean AS cl
    ON cs.customer_id = cl.customer_id
GROUP BY
    cs.customer_id,
    cs.full_name
HAVING SUM(
    CASE
        WHEN cl.claim_severity IN ('Medium', 'High') THEN 1
        ELSE 0
    END
) >= 3
ORDER BY medium_high_claims DESC;

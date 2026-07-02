-- Claims by status (severity proxy)
SELECT
    claim_severity,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_amount,
    AVG(claim_amount) AS avg_claim_amount
FROM claims_clean
GROUP BY claim_severity
ORDER BY num_claims DESC;

-- Monthly claims trend
SELECT
    claim_year,
    claim_month,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_amount,
    AVG(claim_amount) AS avg_claim_amount
FROM claims_clean
GROUP BY claim_year, claim_month
ORDER BY claim_year, claim_month;

-- Claim approval performance by severity
SELECT
    claim_severity,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN claim_status = 'Approved' THEN 1 ELSE 0 END) AS approved_claims,
    ROUND(100.0 * SUM(CASE WHEN claim_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*),
        2) AS approval_rate_percent,
    AVG(claim_amount) AS avg_claim_amount
FROM claims_clean
GROUP BY claim_severity
ORDER BY approval_rate_percent DESC;

-- Top high-value customers
SELECT
    customer_id,
    total_claims,
    total_claim_amount,
    avg_claim_amount
FROM customer_summary
ORDER BY total_claim_amount DESC
LIMIT 10;

-- Severity distribution
SELECT
    claim_severity,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_amount
FROM claims_clean
GROUP BY claim_severity
ORDER BY claim_severity;



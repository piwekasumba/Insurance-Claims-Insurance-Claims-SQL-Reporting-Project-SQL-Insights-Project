
-- ==========================================================
-- INSURANCE CLAIMS BUSINESS ANALYSIS REPORTS
-- PostgreSQL
--
-- Project:
-- Simulated Insurance Claims Reporting and Analysis
--
-- Purpose:
-- Produce six business-focused reports supporting:
-- customer claim exposure, claim type analysis, monthly
-- reporting, policy monitoring, customer monitoring and
-- geographic claim exposure.
--
-- Data sources:
-- reporting_claims
-- customer_claim_summary
-- policy_claim_summary
-- customers
--
-- Reporting grain:
-- Reports 1 and 5: Customer-level
-- Report 2: Claim-type level
-- Report 3: Monthly level
-- Report 4: Policy level
-- Report 6: Province level
--
-- Severity definitions:
-- Low:    claim_amount < 10000
-- Medium: claim_amount BETWEEN 10000 AND 20000
-- High:   claim_amount > 20000
--
-- Missing-value handling:
-- • NULL claim amounts are not included in SUM or AVG.
-- • Missing amounts are counted explicitly where relevant.
-- • Claims without claim dates cannot be assigned to a
--   reporting month and are excluded from Report 3.
-- • Missing settlement durations remain unrecorded and
--   must not be interpreted as zero days.
-- • Missing customer or province information is retained
--   in Report 6 through a LEFT JOIN.
--
-- Interpretation:
-- Monitoring results identify records or patterns that
-- may require further investigation. They do not establish
-- fraud, customer risk, overdue claims or misconduct.
--
-- Dataset:
-- Simulated project data; not production insurance data.
-- ==========================================================


-- ==========================================================
-- REPORT 1: HIGH-VALUE CUSTOMERS
-- ==========================================================
-- Business Question:
-- Which customers have the highest recorded claim values,
-- and how do their average claim amounts compare with the
-- overall claim amount benchmark?
--
-- Business Purpose:
-- Supports customer-level claim exposure reporting and
-- comparison against the overall average claim amount.
--
-- Benchmark:
-- Average of all non-NULL claim amounts in reporting_claims.
--
-- Reporting Output:
-- Top 10 customers, their claim totals, average claim
-- amounts and the overall average claim benchmark.
-- ==========================================================

WITH overall_claim_benchmark AS (
    SELECT
        AVG(claim_amount) AS overall_average_claim_amount,
        COUNT(claim_amount) AS benchmark_claim_count,
        COUNT(DISTINCT customer_id)
            FILTER (WHERE claim_amount IS NOT NULL)
            AS benchmark_customer_count
    FROM reporting_claims
)

SELECT
    ccs.customer_id,
    ccs.first_name,
    ccs.last_name,
    ccs.province,
    ccs.policy_type,
    ccs.total_claims,
    ccs.total_claim_amount,
    ccs.average_claim_amount,
    ROUND(
        ocb.overall_average_claim_amount,
        2
    ) AS overall_average_claim_benchmark,
    ocb.benchmark_claim_count,
    ocb.benchmark_customer_count
FROM customer_claim_summary AS ccs
CROSS JOIN overall_claim_benchmark AS ocb
WHERE ccs.total_claims > 0
ORDER BY
    ccs.total_claim_amount DESC NULLS LAST,
    ccs.total_claims DESC,
    ccs.customer_id
LIMIT 10;


-- ==========================================================
-- REPORT 2: CLAIM TYPE PERFORMANCE
-- ==========================================================
-- Business Question:
-- Which claim types contribute the most to recorded
-- claim volumes and amounts?
--
-- Business Purpose:
-- Compares claim volumes and financial amounts across
-- recorded claim types.
--
-- Data-quality considerations:
-- NULL claim amounts are excluded from SUM and AVG.
-- They are counted separately so that incomplete financial
-- records remain visible in the reporting output.
--
-- Reporting Output:
-- Claim count, claims with recorded amounts, missing
-- amounts, total claim amount and average claim amount.
-- ==========================================================

SELECT
    COALESCE(claim_type, 'Not recorded') AS claim_type,
    COUNT(*) AS total_claims,
    COUNT(claim_amount) AS claims_with_recorded_amounts,
    COUNT(*) - COUNT(claim_amount)
        AS claims_missing_amounts,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2)
        AS average_claim_amount
FROM reporting_claims
GROUP BY
    COALESCE(claim_type, 'Not recorded')
ORDER BY
    total_claim_amount DESC NULLS LAST,
    total_claims DESC,
    claim_type;


-- ==========================================================
-- REPORT 3: MONTHLY CLAIMS TREND
-- ==========================================================
-- Business Question:
-- How does recorded claims activity change across months?
--
-- Business Purpose:
-- Supports monthly monitoring of claim volume and
-- recorded financial amounts.
--
-- Data-quality considerations:
-- Claims with NULL claim_date values are excluded because
-- they cannot be assigned reliably to a reporting month.
--
-- NULL claim amounts are counted separately and excluded
-- from SUM and AVG calculations.
--
-- Missing claim dates remain data-quality exceptions;
-- their exclusion does not mean those claims do not exist.
--
-- Reporting Output:
-- Monthly claim count, recorded amount count, missing
-- amount count, total amount and average amount.
-- ==========================================================

SELECT
    claim_year,
    claim_month,
    TO_CHAR(
        MAKE_DATE(claim_year, claim_month, 1),
        'Mon YYYY'
    ) AS reporting_month,
    COUNT(*) AS total_claims,
    COUNT(claim_amount) AS claims_with_recorded_amounts,
    COUNT(*) - COUNT(claim_amount)
        AS claims_missing_amounts,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2)
        AS average_claim_amount
FROM reporting_claims
WHERE claim_date IS NOT NULL
GROUP BY
    claim_year,
    claim_month
ORDER BY
    claim_year,
    claim_month;


-- ==========================================================
-- REPORT 4: POLICY CLAIM MONITORING
-- ==========================================================
-- Business Question:
-- Which policies have the highest recorded claim activity
-- and financial exposure?
--
-- Business Purpose:
-- Supports policy-level comparison of claim volumes,
-- total recorded amounts, average amounts and highest
-- individual claim amounts.
--
-- Data-quality consideration:
-- NULL claim amounts are not included in the underlying
-- SUM, AVG or MAX calculations.
--
-- Reporting Output:
-- Top 10 policies ranked by total recorded claim amount.
-- ==========================================================

SELECT
    policy_id,
    total_claims,
    total_claim_amount,
    average_claim_amount,
    highest_claim_amount
FROM policy_claim_summary
ORDER BY
    total_claim_amount DESC NULLS LAST,
    total_claims DESC,
    policy_id
LIMIT 10;


-- ==========================================================
-- REPORT 5: CUSTOMER CLAIM MONITORING AND SEGMENTATION
-- ==========================================================
-- Business Question:
-- Which customers have more than one recorded Medium-
-- or High-severity claim, and how do their claim patterns
-- compare with the overall claim amount benchmark?
--
-- Business Purpose:
-- Supports review of repeated higher-severity claims,
-- customer-level claim exposure and amounts above the
-- overall average claim amount.
--
-- Severity definitions:
-- Medium: R10,000 to R20,000 inclusive.
-- High: Above R20,000.
--
-- Benchmark:
-- Overall average of non-NULL claim amounts across
-- reporting_claims.
--
-- Benchmark customer count:
-- Distinct customers contributing at least one non-NULL
-- claim amount to the overall average benchmark.
--
-- Data-quality consideration:
-- Missing claim amounts are counted separately and are
-- not classified as Medium or High.
--
-- Interpretation:
-- Repeated Medium/High claims are monitoring indicators
-- for further investigation, not proof of fraud,
-- customer risk or misconduct.
--
-- Reporting Output:
-- Customer details, repeated Medium/High claim counts,
-- High-severity claim counts, claim amount totals,
-- above-benchmark claim counts and benchmark information.
-- ==========================================================

WITH overall_claim_benchmark AS (
    SELECT
        AVG(claim_amount) AS overall_average_claim_amount,
        COUNT(claim_amount) AS benchmark_claim_count,
        COUNT(DISTINCT customer_id)
            FILTER (WHERE claim_amount IS NOT NULL)
            AS benchmark_customer_count
    FROM reporting_claims
),

customer_monitoring AS (
    SELECT
        ccs.customer_id,
        ccs.first_name,
        ccs.last_name,
        ccs.province,
        ccs.policy_type,

        COUNT(rc.claim_id) AS total_claims,

        COUNT(rc.claim_id) FILTER (
            WHERE rc.claim_severity IN ('Medium', 'High')
              AND rc.claim_amount >= 10000
        ) AS medium_high_claims,

        COUNT(rc.claim_id) FILTER (
            WHERE rc.claim_severity = 'High'
              AND rc.claim_amount > 20000
        ) AS high_severity_claims,

        COUNT(rc.claim_id) FILTER (
            WHERE rc.claim_amount IS NOT NULL
        ) AS claims_with_recorded_amounts,

        COUNT(rc.claim_id) FILTER (
            WHERE rc.claim_amount IS NULL
        ) AS claims_missing_amounts,

        SUM(rc.claim_amount) FILTER (
            WHERE rc.claim_severity IN ('Medium', 'High')
              AND rc.claim_amount >= 10000
        ) AS medium_high_claim_amount,

        COUNT(rc.claim_id) FILTER (
            WHERE rc.claim_amount >
                ocb.overall_average_claim_amount
        ) AS claims_above_overall_average,

        SUM(rc.claim_amount) AS total_claim_amount

    FROM customer_claim_summary AS ccs
    INNER JOIN reporting_claims AS rc
        ON ccs.customer_id = rc.customer_id
    CROSS JOIN overall_claim_benchmark AS ocb
    GROUP BY
        ccs.customer_id,
        ccs.first_name,
        ccs.last_name,
        ccs.province,
        ccs.policy_type
)

SELECT
    cm.customer_id,
    cm.first_name,
    cm.last_name,
    cm.province,
    cm.policy_type,
    cm.total_claims,
    cm.medium_high_claims,
    cm.high_severity_claims,
    cm.claims_with_recorded_amounts,
    cm.claims_missing_amounts,
    cm.medium_high_claim_amount,
    cm.total_claim_amount,
    cm.claims_above_overall_average,
    ROUND(
        ocb.overall_average_claim_amount,
        2
    ) AS overall_average_claim_benchmark,
    ocb.benchmark_claim_count,
    ocb.benchmark_customer_count
FROM customer_monitoring AS cm
CROSS JOIN overall_claim_benchmark AS ocb
WHERE cm.medium_high_claims > 1
ORDER BY
    cm.medium_high_claims DESC,
    cm.medium_high_claim_amount DESC NULLS LAST,
    cm.customer_id;


-- ==========================================================
-- REPORT 6: CLAIM EXPOSURE BY PROVINCE
-- ==========================================================
-- Business Question:
-- How are recorded claim volumes and financial amounts
-- distributed across provinces?
--
-- Business Purpose:
-- Supports geographic comparison of recorded claim
-- activity and financial exposure.
--
-- Data-quality considerations:
-- A LEFT JOIN retains claims even when a matching customer
-- record or province is unavailable.
--
-- Missing province information is grouped as Unknown /
-- Not recorded.
--
-- NULL claim amounts are counted separately and excluded
-- from SUM and AVG calculations.
--
-- Reporting Output:
-- Province-level claim counts, recorded amount counts,
-- missing amount counts, total amounts and averages.
-- ==========================================================

SELECT
    COALESCE(
        c.province,
        'Unknown / Not recorded'
    ) AS province,

    COUNT(rc.claim_id) AS total_claims,

    COUNT(rc.claim_amount)
        AS claims_with_recorded_amounts,

    COUNT(rc.claim_id) - COUNT(rc.claim_amount)
        AS claims_missing_amounts,

    SUM(rc.claim_amount)
        AS total_claim_amount,

    ROUND(AVG(rc.claim_amount), 2)
        AS average_claim_amount

FROM reporting_claims AS rc
LEFT JOIN customers AS c
    ON rc.customer_id = c.customer_id
GROUP BY
    COALESCE(
        c.province,
        'Unknown / Not recorded'
    )
ORDER BY
    total_claim_amount DESC NULLS LAST,
    total_claims DESC,
    province;




-- ============================================================
-- INSURANCE CLAIMS RISK ANALYTICS SQL INSIGHTS PROJECT
-- PostgreSQL Reporting Queries
--
-- Dataset: Simulated insurance claims and customer records
-- Source tables: customers, claims_raw
--
-- Purpose:
-- Create a consistent reporting layer and run core analysis
-- and data-quality checks.
--
-- Important:
-- High-value claims and repeated claims are monitoring
-- indicators only. They do not establish fraud or risk.
-- ============================================================


-- ============================================================
-- SECTION 1: CREATE REPORTING VIEW
-- ============================================================

CREATE OR REPLACE VIEW claims_reporting AS
SELECT
    cr.claim_id,
    cr.customer_id,
    c.first_name,
    c.last_name,
    c.age,
    c.city AS customer_city,
    c.province,
    c.policy_type,
    cr.policy_id,
    cr.claim_date,
    EXTRACT(YEAR FROM cr.claim_date)::INT AS claim_year,
    EXTRACT(MONTH FROM cr.claim_date)::INT AS claim_month,
    TO_CHAR(cr.claim_date, 'FMMonth') AS claim_month_name,
    cr.claim_type,
    cr.claim_amount,
    cr.claim_status,
    cr.incident_city,
    cr.incident_type,
    cr.police_report,
    cr.days_to_settle,

    CASE
        WHEN cr.claim_amount < 10000 THEN 'Low'
        WHEN cr.claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    CASE
        WHEN cr.days_to_settle IS NULL THEN 'Unknown / Not Recorded'
        WHEN cr.days_to_settle <= 10 THEN '0-10 Days'
        WHEN cr.days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_group

FROM claims_raw AS cr
LEFT JOIN customers AS c
    ON cr.customer_id = c.customer_id;


-- ============================================================
-- SECTION 2: OVERALL CLAIMS KPIs
-- Query 01: Overall recorded claims
-- ============================================================

SELECT
    COUNT(*) AS recorded_claims,
    COUNT(claim_amount) AS claims_with_amount,
    SUM(claim_amount) AS total_recorded_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MIN(claim_amount) AS minimum_claim_amount,
    MAX(claim_amount) AS maximum_claim_amount
FROM claims_reporting;


-- ============================================================
-- Query 02: Claims by claim type
-- ============================================================

SELECT
    claim_type,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY claim_type
ORDER BY total_claim_value DESC NULLS LAST;


-- ============================================================
-- Query 03: Claims by status
-- ============================================================

SELECT
    claim_status,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(
        100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS percentage_of_recorded_claims
FROM claims_reporting
GROUP BY claim_status
ORDER BY claim_count DESC;


-- ============================================================
-- Query 04: Claims by incident city
-- ============================================================

SELECT
    incident_city,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY incident_city
ORDER BY total_claim_value DESC NULLS LAST;


-- ============================================================
-- Query 05: Claims by customer province
-- ============================================================

SELECT
    province,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY province
ORDER BY total_claim_value DESC NULLS LAST;


-- ============================================================
-- Query 06: Claims by customer policy type
-- ============================================================

SELECT
    policy_type,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY policy_type
ORDER BY total_claim_value DESC NULLS LAST;


-- ============================================================
-- Query 07: Claims by customer age group
-- ============================================================

SELECT
    CASE
        WHEN age IS NULL THEN 'Unknown'
        WHEN age < 25 THEN 'Under 25'
        WHEN age < 40 THEN '25-39'
        WHEN age < 60 THEN '40-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value
FROM claims_reporting
GROUP BY
    CASE
        WHEN age IS NULL THEN 'Unknown'
        WHEN age < 25 THEN 'Under 25'
        WHEN age < 40 THEN '25-39'
        WHEN age < 60 THEN '40-59'
        ELSE '60+'
    END
ORDER BY age_group;


-- ============================================================
-- Query 08: Customers with the highest recorded claim value
-- ============================================================

SELECT
    customer_id,
    first_name,
    last_name,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY customer_id, first_name, last_name
ORDER BY total_claim_value DESC NULLS LAST
LIMIT 10;


-- ============================================================
-- Query 09: Approved claims with recorded settlement days
-- ============================================================

SELECT
    COUNT(*) AS approved_claims_with_settlement_days,
    ROUND(AVG(days_to_settle), 2) AS average_days_to_settle,
    MIN(days_to_settle) AS minimum_days_to_settle,
    MAX(days_to_settle) AS maximum_days_to_settle
FROM claims_reporting
WHERE claim_status = 'Approved'
  AND days_to_settle IS NOT NULL;


-- ============================================================
-- Query 10: Claims by severity
-- ============================================================

SELECT
    claim_severity,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY claim_severity
ORDER BY
    CASE claim_severity
        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Low' THEN 3
    END;


-- ============================================================
-- Query 11: Claims by year and month
-- ============================================================

SELECT
    claim_year,
    claim_month,
    claim_month_name,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value
FROM claims_reporting
WHERE claim_date IS NOT NULL
GROUP BY claim_year, claim_month, claim_month_name
ORDER BY claim_year, claim_month;


-- ============================================================
-- Query 12: Claims by settlement group
-- ============================================================

SELECT
    settlement_group,
    COUNT(*) AS claim_count,
    ROUND(AVG(days_to_settle), 2) AS average_days_to_settle
FROM claims_reporting
GROUP BY settlement_group
ORDER BY
    CASE settlement_group
        WHEN '0-10 Days' THEN 1
        WHEN '11-20 Days' THEN 2
        WHEN '21+ Days' THEN 3
        ELSE 4
    END;


-- ============================================================
-- SECTION 3: DATA-QUALITY CHECKS
-- ============================================================

-- Query 13: Missing or incomplete fields
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL)
        AS missing_customer_id,
    COUNT(*) FILTER (WHERE policy_id IS NULL)
        AS missing_policy_id,
    COUNT(*) FILTER (WHERE claim_date IS NULL)
        AS missing_claim_date,
    COUNT(*) FILTER (WHERE claim_type IS NULL)
        AS missing_claim_type,
    COUNT(*) FILTER (WHERE claim_amount IS NULL)
        AS missing_claim_amount,
    COUNT(*) FILTER (WHERE claim_status IS NULL)
        AS missing_claim_status,
    COUNT(*) FILTER (WHERE incident_city IS NULL)
        AS missing_incident_city,
    COUNT(*) FILTER (WHERE days_to_settle IS NULL)
        AS missing_settlement_days
FROM claims_raw;


-- Query 14: Inspect claims with missing important fields
SELECT *
FROM claims_raw
WHERE customer_id IS NULL
   OR policy_id IS NULL
   OR claim_date IS NULL
   OR claim_amount IS NULL
   OR claim_status IS NULL
ORDER BY claim_id;


-- Query 15: Claims linked to a customer ID not found in customers
-- A foreign key may prevent these records from being inserted
-- into claims_raw, but this check is useful for imported sources
-- before constraints are applied.

SELECT
    cr.claim_id,
    cr.customer_id,
    cr.policy_id,
    cr.claim_amount
FROM claims_raw AS cr
LEFT JOIN customers AS c
    ON cr.customer_id = c.customer_id
WHERE cr.customer_id IS NOT NULL
  AND c.customer_id IS NULL;


-- Query 16: Claims with invalid or unexpected values
-- These checks inspect existing data. They do not repair it.

SELECT *
FROM claims_raw
WHERE (claim_amount IS NOT NULL AND claim_amount <= 0)
   OR (days_to_settle IS NOT NULL AND days_to_settle < 0)
   OR (
        claim_status IS NOT NULL
        AND claim_status NOT IN
            ('Pending', 'Approved', 'Rejected', 'Under Review')
      )
   OR (
        police_report IS NOT NULL
        AND police_report NOT IN ('Yes', 'No')
      )
ORDER BY claim_id;


-- Query 17: Review claims with missing settlement days
SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_status,
    claim_amount,
    days_to_settle
FROM claims_raw
WHERE days_to_settle IS NULL
ORDER BY claim_id;


-- Query 18: Review claims with missing claim dates
SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_type,
    claim_amount,
    claim_status
FROM claims_raw
WHERE claim_date IS NULL
ORDER BY claim_id;


-- ============================================================
-- SECTION 4: OPERATIONAL MONITORING
-- ============================================================

-- Query 19: Customers with multiple recorded claims
-- Multiple claims alone do not indicate fraud.

SELECT
    customer_id,
    first_name,
    last_name,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_value
FROM claims_reporting
GROUP BY customer_id, first_name, last_name
HAVING COUNT(*) > 1
ORDER BY claim_count DESC, total_claim_value DESC NULLS LAST;


-- Query 20: Claims above the average recorded claim amount
-- This is a value-monitoring query, not a risk classification.

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_type,
    claim_amount,
    claim_status
FROM claims_reporting
WHERE claim_amount > (
    SELECT AVG(claim_amount)
    FROM claims_reporting
)
ORDER BY claim_amount DESC;


-- Query 21: High-severity claims for review
-- Severity is defined here by claim amount, not by fraud probability.

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_type,
    claim_amount,
    claim_status,
    incident_city
FROM claims_reporting
WHERE claim_severity = 'High'
ORDER BY claim_amount DESC;


-- Query 22: Claims that have no recorded settlement days
-- Do not assume every NULL means the claim is still open.
-- Check claim status and source records before interpreting it.

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_status,
    claim_date,
    days_to_settle
FROM claims_reporting
WHERE days_to_settle IS NULL
ORDER BY claim_date NULLS LAST, claim_id;


-- Query 23: Claim type and status cross-tabulation
SELECT
    claim_type,
    COUNT(*) FILTER (WHERE claim_status = 'Approved')
        AS approved_claims,
    COUNT(*) FILTER (WHERE claim_status = 'Pending')
        AS pending_claims,
    COUNT(*) FILTER (WHERE claim_status = 'Rejected')
        AS rejected_claims,
    COUNT(*) FILTER (WHERE claim_status = 'Under Review')
        AS under_review_claims,
    COUNT(*) AS total_claims
FROM claims_reporting
GROUP BY claim_type
ORDER BY total_claims DESC;


-- ============================================================
-- SECTION 5: RECONCILIATION CHECKS
-- ============================================================

-- Query 24: Compare raw source row count and reporting row count.
-- The LEFT JOIN in the view should preserve claims_raw rows,
-- including claims that do not match a customer.

SELECT
    (SELECT COUNT(*) FROM claims_raw) AS raw_claim_rows,
    (SELECT COUNT(*) FROM claims_reporting) AS reporting_view_rows;


-- Query 25: Compare total claim amount between source and view.
-- Any difference should be investigated before reporting.

SELECT
    (SELECT COUNT(claim_amount) FROM claims_raw)
        AS raw_rows_with_amount,
    (SELECT SUM(claim_amount) FROM claims_raw)
        AS raw_total_claim_amount,
    (SELECT COUNT(claim_amount) FROM claims_reporting)
        AS reporting_rows_with_amount,
    (SELECT SUM(claim_amount) FROM claims_reporting)
        AS reporting_total_claim_amount;


-- Query 26: Check for duplicate claim IDs in a source without
-- a primary-key constraint. The current claims_raw schema has
-- claim_id as its primary key, so duplicates cannot normally
-- be stored in that table.

SELECT
    claim_id,
    COUNT(*) AS duplicate_count
FROM claims_raw
GROUP BY claim_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, claim_id;


-- ============================================================
-- END OF REPORTING QUERIES
-- ============================================================


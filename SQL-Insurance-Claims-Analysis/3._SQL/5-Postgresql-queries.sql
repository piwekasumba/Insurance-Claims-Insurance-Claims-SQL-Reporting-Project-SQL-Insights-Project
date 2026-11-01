
-- ============================================================
-- INSURANCE CLAIMS REPORTING DATASET
-- PostgreSQL Reporting Layer
--
-- Purpose:
-- Build reporting-ready claims data and summary tables
-- for KPI reporting, operational reporting and analysis.
--
-- Workflow:
-- customers + claims_raw
--        |
--        v
-- reporting_claims
--        |
--        v
-- customer / policy / status / type summaries
-- monthly / incident-city summaries
--        |
--        v
-- reporting validation
--
-- Data provenance:
-- Simulated insurance claims data.
--
-- Important:
-- Severity bands are reporting classifications only.
-- They do not represent actuarial risk or fraud detection.
-- ============================================================


-- ============================================================
-- 1. REMOVE EXISTING REPORTING TABLES
-- Drop dependent summaries before the reporting table.
-- ============================================================

DROP TABLE IF EXISTS customer_claim_summary;
DROP TABLE IF EXISTS policy_claim_summary;
DROP TABLE IF EXISTS claim_status_summary;
DROP TABLE IF EXISTS claim_type_summary;
DROP TABLE IF EXISTS monthly_claim_summary;
DROP TABLE IF EXISTS incident_city_summary;
DROP TABLE IF EXISTS reporting_claims;


-- ============================================================
-- 2. CREATE REPORTING CLAIMS TABLE
--
-- Preserve source fields and add derived reporting fields.
-- Missing values remain distinguishable from valid values.
-- ============================================================

CREATE TABLE reporting_claims AS
SELECT
    cl.claim_id,
    cl.customer_id,
    cl.policy_id,
    cl.claim_date,
    cl.claim_type,
    cl.claim_amount,
    cl.claim_status,
    cl.incident_city,
    cl.incident_type,
    cl.police_report,
    cl.days_to_settle,

    -- Derived date fields
    EXTRACT(YEAR FROM cl.claim_date)::INT AS claim_year,

    EXTRACT(MONTH FROM cl.claim_date)::INT AS claim_month,

    DATE_TRUNC('month', cl.claim_date)::DATE AS claim_month_start,

    TO_CHAR(cl.claim_date, 'FMMonth') AS claim_month_name,

    -- Claim amount classification
    CASE
        WHEN cl.claim_amount IS NULL THEN 'Unknown'
        WHEN cl.claim_amount < 0 THEN 'Invalid Amount'
        WHEN cl.claim_amount < 10000 THEN 'Low'
        WHEN cl.claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    -- Settlement duration classification
    CASE
        WHEN cl.days_to_settle IS NULL THEN 'Not Recorded'
        WHEN cl.days_to_settle < 0 THEN 'Invalid Duration'
        WHEN cl.days_to_settle <= 10 THEN '0-10 Days'
        WHEN cl.days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_time_group

FROM claims_raw AS cl;


-- ============================================================
-- 3. CUSTOMER CLAIM SUMMARY
--
-- Retain customers with no matching claims.
-- Distinguish missing claim amounts from claim counts.
-- ============================================================

CREATE TABLE customer_claim_summary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age,
    c.city,
    c.province,
    c.policy_type,

    COUNT(rc.claim_id) AS total_claims,

    COUNT(rc.claim_amount) AS claims_with_recorded_amount,

    COUNT(rc.claim_id) FILTER (
        WHERE rc.claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(rc.claim_amount) AS total_recorded_claim_amount,

    ROUND(AVG(rc.claim_amount), 2)
        AS average_recorded_claim_amount,

    MAX(rc.claim_amount) AS highest_recorded_claim_amount,

    MIN(rc.claim_amount) AS lowest_recorded_claim_amount

FROM customers AS c

LEFT JOIN reporting_claims AS rc
    ON c.customer_id = rc.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age,
    c.city,
    c.province,
    c.policy_type;


-- ============================================================
-- 4. POLICY CLAIM SUMMARY
--
-- Retain NULL policy identifiers as a separate group
-- for data-quality investigation.
-- ============================================================

CREATE TABLE policy_claim_summary AS
SELECT
    policy_id,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(claim_id) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(AVG(claim_amount), 2)
        AS average_recorded_claim_amount,

    MAX(claim_amount) AS highest_recorded_claim_amount,

    MIN(claim_amount) AS lowest_recorded_claim_amount

FROM reporting_claims

GROUP BY policy_id;


-- ============================================================
-- 5. CLAIM STATUS SUMMARY
--
-- Compare recorded claim volumes and amounts by status.
-- ============================================================

CREATE TABLE claim_status_summary AS
SELECT
    claim_status,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(claim_id) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(AVG(claim_amount), 2)
        AS average_recorded_claim_amount

FROM reporting_claims

GROUP BY claim_status;


-- ============================================================
-- 6. CLAIM TYPE SUMMARY
--
-- Compare claim volumes and recorded amounts by claim type.
-- ============================================================

CREATE TABLE claim_type_summary AS
SELECT
    claim_type,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(claim_id) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(AVG(claim_amount), 2)
        AS average_recorded_claim_amount

FROM reporting_claims

GROUP BY claim_type;


-- ============================================================
-- 7. MONTHLY CLAIM SUMMARY
--
-- Group claims into calendar months.
-- Exclude claims without a recorded claim date.
-- ============================================================

CREATE TABLE monthly_claim_summary AS
SELECT
    claim_year,
    claim_month,
    claim_month_start,
    claim_month_name,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(claim_id) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(AVG(claim_amount), 2)
        AS average_recorded_claim_amount

FROM reporting_claims

WHERE claim_date IS NOT NULL

GROUP BY
    claim_year,
    claim_month,
    claim_month_start,
    claim_month_name;


-- ============================================================
-- 8. INCIDENT CITY SUMMARY
--
-- Compare reported claims by incident location.
-- Preserve missing city values for review.
-- ============================================================

CREATE TABLE incident_city_summary AS
SELECT
    incident_city,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(claim_id) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(AVG(claim_amount), 2)
        AS average_recorded_claim_amount

FROM reporting_claims

GROUP BY incident_city;


-- ============================================================
-- 9. REPORTING-LAYER ROW COUNT CHECK
--
-- Compare source and reporting row counts.
-- ============================================================

SELECT
    (
        SELECT COUNT(*)
        FROM claims_raw
    ) AS source_claim_count,

    (
        SELECT COUNT(*)
        FROM reporting_claims
    ) AS reporting_claim_count,

    (
        SELECT COUNT(*)
        FROM claims_raw
    ) -
    (
        SELECT COUNT(*)
        FROM reporting_claims
    ) AS row_count_difference;


-- ============================================================
-- 10. CLAIM AMOUNT RECONCILIATION
--
-- Compare recorded amounts between source and reporting
-- layers. NULL amounts remain excluded from SUM.
-- ============================================================

SELECT
    (
        SELECT COUNT(claim_amount)
        FROM claims_raw
    ) AS source_recorded_amount_count,

    (
        SELECT COUNT(claim_amount)
        FROM reporting_claims
    ) AS reporting_recorded_amount_count,

    (
        SELECT SUM(claim_amount)
        FROM claims_raw
    ) AS source_total_recorded_claim_amount,

    (
        SELECT SUM(claim_amount)
        FROM reporting_claims
    ) AS reporting_total_recorded_claim_amount,

    (
        SELECT SUM(claim_amount)
        FROM claims_raw
    ) -
    (
        SELECT SUM(claim_amount)
        FROM reporting_claims
    ) AS amount_difference;


-- ============================================================
-- 11. MISSING VALUE CHECKS
--
-- Identify missing reporting fields.
-- ============================================================

SELECT
    COUNT(*) AS total_claims,

    COUNT(*) FILTER (
        WHERE claim_id IS NULL
    ) AS claims_missing_id,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS claims_missing_customer_id,

    COUNT(*) FILTER (
        WHERE policy_id IS NULL
    ) AS claims_missing_policy_id,

    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS claims_missing_date,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    COUNT(*) FILTER (
        WHERE claim_status IS NULL
    ) AS claims_missing_status,

    COUNT(*) FILTER (
        WHERE incident_city IS NULL
    ) AS claims_missing_incident_city,

    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS claims_missing_settlement_days

FROM reporting_claims;


-- ============================================================
-- 12. INVALID VALUE CHECKS
--
-- Identify negative amounts and settlement durations.
-- These are review indicators, not automatic corrections.
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE claim_amount < 0
    ) AS claims_with_negative_amount,

    COUNT(*) FILTER (
        WHERE days_to_settle < 0
    ) AS claims_with_negative_settlement_days

FROM reporting_claims;


-- ============================================================
-- 13. DUPLICATE CLAIM IDENTIFIER CHECK
-- ============================================================

SELECT
    claim_id,
    COUNT(*) AS duplicate_count

FROM reporting_claims

GROUP BY claim_id

HAVING COUNT(*) > 1;


-- ============================================================
-- 14. BROKEN CUSTOMER REFERENCE CHECK
--
-- Identify claims whose customer identifiers do not
-- match an existing customer record.
-- ============================================================

SELECT
    rc.claim_id,
    rc.customer_id

FROM reporting_claims AS rc

LEFT JOIN customers AS c
    ON rc.customer_id = c.customer_id

WHERE
    rc.customer_id IS NULL
    OR c.customer_id IS NULL;


-- ============================================================
-- 15. SUMMARY TABLE ROW COUNTS
--
-- Confirm that each reporting summary was generated.
-- ============================================================

SELECT 'customer_claim_summary' AS summary_table,
       COUNT(*) AS row_count
FROM customer_claim_summary

UNION ALL

SELECT 'policy_claim_summary',
       COUNT(*)
FROM policy_claim_summary

UNION ALL

SELECT 'claim_status_summary',
       COUNT(*)
FROM claim_status_summary

UNION ALL

SELECT 'claim_type_summary',
       COUNT(*)
FROM claim_type_summary

UNION ALL

SELECT 'monthly_claim_summary',
       COUNT(*)
FROM monthly_claim_summary

UNION ALL

SELECT 'incident_city_summary',
       COUNT(*)
FROM incident_city_summary;


-- ============================================================
-- END OF INSURANCE CLAIMS REPORTING LAYER
-- ============================================================


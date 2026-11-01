
-- ==========================================================
-- INSURANCE CLAIMS SQL ETL WORKFLOW
-- PostgreSQL
--
-- Purpose:
-- Prepare simulated insurance claims data for reporting.
--
-- Prerequisites:
-- 1. Run the database schema script.
-- 2. Load customer records into customers.
-- 3. Load claims records into claims_raw.
--
-- Workflow:
-- 1. Validate source records
-- 2. Review potential data-quality exceptions
-- 3. Refresh the reporting dataset
-- 4. Refresh reporting summary tables
-- 5. Review data-quality indicators
-- 6. Reconcile source and reporting row counts
--
-- Important:
-- This workflow prepares reporting data. It does not load
-- source CSV files, resolve data-quality exceptions, or
-- establish that source data is complete.
--
-- Claim amount bands are illustrative reporting categories,
-- not official insurance claim severity classifications.
-- ==========================================================


-- ==========================================================
-- 1. SOURCE DATA VALIDATION
-- Identify missing critical fields and invalid values.
-- Records are flagged for review, not automatically removed.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_type,
    claim_amount,
    claim_status,
    days_to_settle
FROM claims_raw
WHERE claim_id IS NULL
   OR customer_id IS NULL
   OR policy_id IS NULL
   OR claim_date IS NULL
   OR claim_type IS NULL
   OR claim_status IS NULL
   OR claim_amount IS NULL
   OR claim_amount < 0
   OR days_to_settle < 0
ORDER BY claim_id;


-- ==========================================================
-- 2. DUPLICATE CLAIM ID REVIEW
-- Identify claim IDs appearing more than once.
-- Duplicate records are not automatically removed.
-- ==========================================================

SELECT
    claim_id,
    COUNT(*) AS occurrences
FROM claims_raw
WHERE claim_id IS NOT NULL
GROUP BY claim_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, claim_id;


-- ==========================================================
-- 3. SETTLEMENT DATA-QUALITY REVIEW
-- Identify missing claim dates and settlement durations.
--
-- A missing duration does not prove that a claim is unsettled.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    claim_status,
    claim_date,
    days_to_settle
FROM claims_raw
WHERE claim_date IS NULL
   OR days_to_settle IS NULL
   OR days_to_settle < 0
ORDER BY claim_id;


-- ==========================================================
-- 4. TRANSFORMATION LAYER
-- Refresh reporting tables within a transaction.
--
-- Existing summary tables are dropped before the reporting
-- dataset to maintain the correct dependency order.
-- ==========================================================

BEGIN;

DROP TABLE IF EXISTS claims_type_summary;
DROP TABLE IF EXISTS claims_status_summary;
DROP TABLE IF EXISTS claims_city_summary;
DROP TABLE IF EXISTS claims_reporting;


CREATE TABLE claims_reporting AS
SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_type,
    claim_amount,
    claim_status,
    incident_city,
    incident_type,
    police_report,
    days_to_settle,

    EXTRACT(YEAR FROM claim_date)::INT AS claim_year,

    EXTRACT(MONTH FROM claim_date)::INT AS claim_month,

    -- Illustrative claim amount reporting bands.
    CASE
        WHEN claim_amount IS NULL THEN 'Unknown'
        WHEN claim_amount < 10000 THEN 'Low'
        WHEN claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_amount_band,

    -- Missing duration is not interpreted as an unsettled claim.
    CASE
        WHEN days_to_settle IS NULL THEN 'Not Recorded'
        WHEN days_to_settle < 0 THEN 'Invalid Duration'
        WHEN days_to_settle <= 10 THEN '0-10 Days'
        WHEN days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_time_group

FROM claims_raw;


-- ==========================================================
-- 5. REPORTING SUMMARY: CLAIM TYPE
-- ==========================================================

CREATE TABLE claims_type_summary AS
SELECT
    claim_type,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY claim_type;


-- ==========================================================
-- 6. REPORTING SUMMARY: CLAIM STATUS
-- ==========================================================

CREATE TABLE claims_status_summary AS
SELECT
    claim_status,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY claim_status;


-- ==========================================================
-- 7. REPORTING SUMMARY: INCIDENT CITY
-- ==========================================================

CREATE TABLE claims_city_summary AS
SELECT
    incident_city,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY incident_city;


-- ==========================================================
-- 8. DATA-QUALITY SUMMARY
-- Quantify selected source-data exceptions.
-- Duplicate claim ID count represents duplicate ID groups,
-- not the total number of affected records.
-- ==========================================================

SELECT
    COUNT(*) AS total_claim_records,

    COUNT(*) FILTER (
        WHERE claim_id IS NULL
    ) AS missing_claim_ids,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,

    COUNT(*) FILTER (
        WHERE policy_id IS NULL
    ) AS missing_policy_ids,

    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS missing_claim_dates,

    COUNT(*) FILTER (
        WHERE claim_type IS NULL
    ) AS missing_claim_types,

    COUNT(*) FILTER (
        WHERE claim_status IS NULL
    ) AS missing_claim_statuses,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS missing_claim_amounts,

    COUNT(*) FILTER (
        WHERE claim_amount < 0
    ) AS negative_claim_amounts,

    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS missing_settlement_durations,

    COUNT(*) FILTER (
        WHERE days_to_settle < 0
    ) AS negative_settlement_durations,

    (
        SELECT COUNT(*)
        FROM (
            SELECT claim_id
            FROM claims_raw
            WHERE claim_id IS NOT NULL
            GROUP BY claim_id
            HAVING COUNT(*) > 1
        ) AS duplicate_groups
    ) AS duplicate_claim_id_groups

FROM claims_raw;


-- ==========================================================
-- 9. SOURCE-TO-REPORTING RECONCILIATION
-- Compare source and reporting row counts.
--
-- A matching count supports basic refresh verification.
-- It does not prove that every record is accurate or unique.
-- ==========================================================

SELECT
    (SELECT COUNT(*) FROM claims_raw) AS raw_claim_count,

    (SELECT COUNT(*) FROM claims_reporting)
        AS reporting_claim_count,

    (SELECT COUNT(*) FROM claims_reporting)
    -
    (SELECT COUNT(*) FROM claims_raw)
        AS row_count_difference;


-- ==========================================================
-- 10. PREVIEW REPORTING SUMMARIES
-- ==========================================================

SELECT *
FROM claims_type_summary
ORDER BY total_claims DESC, claim_type;


SELECT *
FROM claims_status_summary
ORDER BY total_claims DESC, claim_status;


SELECT *
FROM claims_city_summary
ORDER BY total_claims DESC, incident_city;


-- ==========================================================
-- 11. COMPLETE REPORTING REFRESH
-- ==========================================================

COMMIT;




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
-- 2. Create a refreshed reporting dataset
-- 3. Create refreshed summary tables
-- 4. Report data-quality exceptions
--
-- Note:
-- This script prepares reporting data. It does not load the
-- source CSV files or prove that the source data is complete.
-- ==========================================================


-- ==========================================================
-- 1. SOURCE DATA VALIDATION
-- Identify records with missing critical reporting fields.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_type,
    claim_amount,
    claim_status
FROM claims_raw
WHERE customer_id IS NULL
   OR policy_id IS NULL
   OR claim_amount IS NULL
   OR claim_date IS NULL
   OR claim_type IS NULL
   OR claim_status IS NULL
ORDER BY claim_id;


-- ==========================================================
-- 2. DATA-QUALITY REVIEW
-- Identify missing claim dates and settlement durations.
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
ORDER BY claim_id;


-- ==========================================================
-- 3. TRANSFORMATION LAYER
-- Refresh the reporting dataset on each run.
-- ==========================================================

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

    CASE
        WHEN claim_amount IS NULL THEN 'Unknown'
        WHEN claim_amount < 10000 THEN 'Low'
        WHEN claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    CASE
        WHEN days_to_settle IS NULL THEN 'Not Recorded'
        WHEN days_to_settle <= 10 THEN '0-10 Days'
        WHEN days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_time_group

FROM claims_raw;


-- ==========================================================
-- 4. REPORTING SUMMARY: CLAIM TYPE
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
-- 5. REPORTING SUMMARY: CLAIM STATUS
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
-- 6. REPORTING SUMMARY: INCIDENT CITY
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
-- 7. DATA-QUALITY SUMMARY
-- Report missing dates, amounts and settlement durations.
-- ==========================================================

SELECT
    COUNT(*) AS total_claim_records,

    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS missing_claim_dates,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS missing_claim_amounts,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,

    COUNT(*) FILTER (
        WHERE policy_id IS NULL
    ) AS missing_policy_ids,

    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS missing_settlement_durations

FROM claims_raw;


-- ==========================================================
-- 8. BASIC REFRESH CHECKS
-- Compare source and reporting row counts.
-- ==========================================================

SELECT
    (SELECT COUNT(*) FROM claims_raw) AS raw_claim_count,
    (SELECT COUNT(*) FROM claims_reporting) AS reporting_claim_count;


-- ==========================================================
-- 9. PREVIEW REPORTING SUMMARIES
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





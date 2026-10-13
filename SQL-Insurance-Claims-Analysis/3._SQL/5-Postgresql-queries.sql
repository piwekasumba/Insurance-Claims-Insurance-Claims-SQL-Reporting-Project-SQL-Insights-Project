
-- ============================================================
-- INSURANCE CLAIMS REPORTING DATASET
-- PostgreSQL Reporting Layer
--
-- Purpose:
-- Create a reporting-ready claims table with derived fields
-- for KPI reporting, trend analysis and operational reporting.
--
-- Workflow:
-- customers + claims_raw
--        -> reporting_claims
--        -> summary tables
--
-- Source data is simulated.
-- ============================================================


-- ============================================================
-- 1. REMOVE EXISTING REPORTING TABLES
-- Drop summaries before the reporting table so the script
-- can be rerun without leaving old summary results behind.
-- ============================================================

DROP TABLE IF EXISTS customer_claim_summary;
DROP TABLE IF EXISTS policy_claim_summary;
DROP TABLE IF EXISTS claim_status_summary;
DROP TABLE IF EXISTS claim_type_summary;
DROP TABLE IF EXISTS reporting_claims;


-- ============================================================
-- 2. REPORTING CLAIMS TABLE
-- Add derived fields while preserving the source claim values.
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

    TO_CHAR(cl.claim_date, 'FMMonth') AS claim_month_name,

    -- Claim severity based on recorded claim amount
    CASE
        WHEN cl.claim_amount IS NULL THEN 'Unknown'
        WHEN cl.claim_amount < 10000 THEN 'Low'
        WHEN cl.claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    -- Settlement duration based on recorded days
    CASE
        WHEN cl.days_to_settle IS NULL THEN 'Not Recorded'
        WHEN cl.days_to_settle <= 10 THEN '0-10 Days'
        WHEN cl.days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_time_group

FROM claims_raw AS cl;


-- ============================================================
-- 3. CUSTOMER CLAIMS SUMMARY
-- Purpose:
-- Summarise claim activity and recorded claim amounts by
-- customer, including customers who have no claims.
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

    ROUND(
        AVG(rc.claim_amount),
        2
    ) AS average_recorded_claim_amount,

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
-- 4. POLICY CLAIMS SUMMARY
-- Purpose:
-- Summarise claim frequency and recorded amounts by policy.
-- A NULL policy_id, if present, remains visible as a group
-- for further data-quality investigation.
-- ============================================================

CREATE TABLE policy_claim_summary AS
SELECT
    rc.policy_id,

    COUNT(rc.claim_id) AS total_claims,

    COUNT(rc.claim_amount) AS claims_with_recorded_amount,

    COUNT(*) FILTER (
        WHERE rc.claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(rc.claim_amount) AS total_recorded_claim_amount,

    ROUND(
        AVG(rc.claim_amount),
        2
    ) AS average_recorded_claim_amount,

    MAX(rc.claim_amount) AS highest_recorded_claim_amount,

    MIN(rc.claim_amount) AS lowest_recorded_claim_amount

FROM reporting_claims AS rc

GROUP BY
    rc.policy_id;


-- ============================================================
-- 5. CLAIM STATUS SUMMARY
-- Purpose:
-- Compare claim volumes and recorded amounts by status.
-- ============================================================

CREATE TABLE claim_status_summary AS
SELECT
    claim_status,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(
        AVG(claim_amount),
        2
    ) AS average_recorded_claim_amount

FROM reporting_claims

GROUP BY
    claim_status;


-- ============================================================
-- 6. CLAIM TYPE SUMMARY
-- Purpose:
-- Compare claim volumes and recorded amounts by claim type.
-- ============================================================

CREATE TABLE claim_type_summary AS
SELECT
    claim_type,

    COUNT(claim_id) AS total_claims,

    COUNT(claim_amount) AS claims_with_recorded_amount,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,

    SUM(claim_amount) AS total_recorded_claim_amount,

    ROUND(
        AVG(claim_amount),
        2
    ) AS average_recorded_claim_amount

FROM reporting_claims

GROUP BY
    claim_type;


-- ============================================================
-- 7. BASIC REPORTING-LAYER CHECKS
-- Run these queries after creating the tables to inspect
-- row counts and confirm that the summaries were generated.
-- ============================================================

SELECT
    COUNT(*) AS reporting_claim_count,
    COUNT(claim_date) AS claims_with_recorded_date,
    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS claims_missing_date,
    COUNT(claim_amount) AS claims_with_recorded_amount,
    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS claims_missing_amount,
    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS claims_missing_settlement_days
FROM reporting_claims;


SELECT COUNT(*) AS customer_summary_rows
FROM customer_claim_summary;

SELECT COUNT(*) AS policy_summary_rows
FROM policy_claim_summary;

SELECT COUNT(*) AS status_summary_rows
FROM claim_status_summary;

SELECT COUNT(*) AS claim_type_summary_rows
FROM claim_type_summary;




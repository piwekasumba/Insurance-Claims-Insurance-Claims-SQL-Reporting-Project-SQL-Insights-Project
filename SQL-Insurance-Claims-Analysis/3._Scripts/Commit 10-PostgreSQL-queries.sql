-- ==========================================================
-- INSURANCE CLAIMS SQL ETL WORKFLOW
-- PostgreSQL
--
-- Purpose:
-- Demonstrate a simple Extract, Transform and Load workflow
-- for preparing insurance claims data for reporting.
--
-- Workflow:
-- 1. Extract raw claims data into a staging table
-- 2. Validate and standardize the data
-- 3. Create reporting-ready derived fields
-- 4. Prepare summary data for business reporting
-- ==========================================================


-- ==========================================================
-- EXTRACT LAYER
-- Raw claims staging table
-- ==========================================================

CREATE TABLE IF NOT EXISTS claims_raw (
    claim_id INT PRIMARY KEY,
    customer_id VARCHAR(10),
    policy_id VARCHAR(20),
    claim_date DATE,
    claim_type VARCHAR(50),
    claim_amount NUMERIC(12,2),
    claim_status VARCHAR(20),
    incident_city VARCHAR(100),
    incident_type VARCHAR(100),
    police_report VARCHAR(10),
    days_to_settle INT
);


-- ==========================================================
-- DATA VALIDATION
-- Identify records with missing critical reporting fields.
-- ==========================================================

SELECT
    claim_id,
    customer_id,
    policy_id,
    claim_date,
    claim_amount
FROM claims_raw
WHERE customer_id IS NULL
   OR policy_id IS NULL
   OR claim_amount IS NULL;


-- ==========================================================
-- TRANSFORMATION LAYER
-- Create a reporting-ready claims dataset.
-- ==========================================================

CREATE TABLE IF NOT EXISTS claims_reporting AS
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
        WHEN claim_amount > 50000 THEN 'High'
        WHEN claim_amount >= 10000 THEN 'Medium'
        ELSE 'Low'
    END AS claim_severity,

    CASE
        WHEN days_to_settle IS NULL THEN 'Unsettled'
        WHEN days_to_settle <= 10 THEN '0-10 Days'
        WHEN days_to_settle <= 20 THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_time_group

FROM claims_raw;


-- ==========================================================
-- REPORTING SUMMARY
-- Summarise claims by claim type.
-- ==========================================================

CREATE TABLE IF NOT EXISTS claims_type_summary AS
SELECT
    claim_type,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY claim_type;


-- ==========================================================
-- REPORTING SUMMARY
-- Summarise claims by status.
-- ==========================================================

CREATE TABLE IF NOT EXISTS claims_status_summary AS
SELECT
    claim_status,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY claim_status;


-- ==========================================================
-- REPORTING SUMMARY
-- Summarise claims by incident city.
-- ==========================================================

CREATE TABLE IF NOT EXISTS claims_city_summary AS
SELECT
    incident_city,
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount
FROM claims_reporting
GROUP BY incident_city;


-- ==========================================================
-- DATA QUALITY SUMMARY
-- Identify missing claim dates and unsettled claims.
-- ==========================================================

SELECT
    COUNT(*) FILTER (WHERE claim_date IS NULL)
        AS missing_claim_dates,

    COUNT(*) FILTER (WHERE days_to_settle IS NULL)
        AS unsettled_claims

FROM claims_raw;



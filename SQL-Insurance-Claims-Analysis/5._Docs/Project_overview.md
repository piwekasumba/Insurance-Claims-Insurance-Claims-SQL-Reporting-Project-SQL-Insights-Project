
-- ============================================================
-- INSURANCE CLAIMS REPORTING VIEW
-- Database: PostgreSQL
-- Source tables: claims_raw, customers
--
-- Purpose:
-- Prepare claim and customer attributes for SQL reporting.
-- Create reporting-friendly date fields and claim amount bands.
-- Preserve source claim records when customer information is
-- missing or unavailable.
--
-- Data quality:
-- Retain missing source values for validation and review.
--
-- Reporting flow:
-- Source Data -> Reporting View -> Validation -> Analysis
--
-- Note:
-- Claim amount bands are reporting classifications based on
-- claim_amount. They are not independently assessed insurance
-- severity or predictive risk classifications.
-- ============================================================

CREATE OR REPLACE VIEW reporting_claims_vw AS

SELECT
    -- Claim and customer identification
    cl.claim_id,
    cl.customer_id,
    c.first_name,
    c.last_name,
    c.age,
    c.city AS customer_city,
    c.province,

    -- Customer policy information
    c.policy_start_date,
    c.policy_type,
    cl.policy_id,

    -- Claim information
    cl.claim_date,
    cl.claim_type,
    cl.claim_amount,
    cl.claim_status,
    cl.incident_city,
    cl.incident_type,
    cl.police_report,
    cl.days_to_settle,

    -- Reporting date attributes
    EXTRACT(YEAR FROM cl.claim_date)::INT AS claim_year,
    EXTRACT(MONTH FROM cl.claim_date)::INT AS claim_month,
    TO_CHAR(cl.claim_date, 'FMMonth') AS claim_month_name,

    -- Claim amount classification
    CASE
        WHEN cl.claim_amount IS NULL THEN 'Not Classified'
        WHEN cl.claim_amount < 10000 THEN 'Low'
        WHEN cl.claim_amount <= 20000 THEN 'Medium'
        ELSE 'High'
    END AS claim_severity,

    -- Settlement time classification
    CASE
        WHEN cl.days_to_settle IS NULL
            THEN 'Missing Settlement Days'
        WHEN cl.days_to_settle <= 10
            THEN '0-10 Days'
        WHEN cl.days_to_settle <= 20
            THEN '11-20 Days'
        ELSE '21+ Days'
    END AS settlement_group

FROM claims_raw AS cl

LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id;


-- ============================================================
-- REPORTING VIEW VALIDATION
-- Purpose:
-- Review record counts, join preservation, missing values,
-- customer references and claim identifier uniqueness.
-- ============================================================


-- 1. Review reporting view records

SELECT *
FROM reporting_claims_vw
ORDER BY claim_id;


-- 2. Compare source and reporting view record counts

SELECT
    (SELECT COUNT(*)
     FROM claims_raw) AS source_claim_count,

    (SELECT COUNT(*)
     FROM reporting_claims_vw) AS reporting_claim_count;


-- 3. Check duplicate claim identifiers in the reporting view

SELECT
    claim_id,
    COUNT(*) AS record_count

FROM reporting_claims_vw

GROUP BY claim_id

HAVING COUNT(*) > 1

ORDER BY record_count DESC, claim_id;


-- 4. Check missing reporting values

SELECT
    COUNT(*) FILTER (
        WHERE claim_id IS NULL
    ) AS missing_claim_ids,

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
        WHERE days_to_settle IS NULL
    ) AS missing_settlement_days

FROM reporting_claims_vw;


-- 5. Identify claims with customer IDs that have no matching
-- customer record in the customers table

SELECT
    cl.claim_id,
    cl.customer_id

FROM claims_raw AS cl

WHERE cl.customer_id IS NOT NULL

  AND NOT EXISTS (
      SELECT 1
      FROM customers AS c
      WHERE c.customer_id = cl.customer_id
  )

ORDER BY cl.claim_id;



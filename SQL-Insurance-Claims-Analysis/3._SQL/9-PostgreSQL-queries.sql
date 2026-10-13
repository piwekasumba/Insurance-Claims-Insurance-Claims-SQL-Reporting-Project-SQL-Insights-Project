
-- ==========================================================
-- INSURANCE CLAIMS REPORT EXPORTS
-- PostgreSQL
--
-- Purpose:
-- Export prepared reporting datasets and business review
-- outputs as CSV files for further analysis.
--
-- Prerequisites:
-- 1. Customer and claims data have been loaded.
-- 2. The reporting workflow has completed successfully.
-- 3. The reporting tables referenced below exist.
-- 4. The destination directory exists on the PostgreSQL
--    SERVER and is writable by the PostgreSQL service.
--
-- Important:
-- COPY TO writes files on the database server, not directly
-- into this GitHub repository or your local project folder.
--
-- Replace the example relative paths below with absolute
-- server-side paths if required by your environment.
-- PostgreSQL must also have permission to write to the path.
-- ==========================================================


-- ==========================================================
-- EXPORT 1: REPORTING CLAIMS DATASET
-- ==========================================================
-- Purpose:
-- Provide the prepared claims dataset for operational
-- reporting and further analysis.
-- ==========================================================

COPY reporting_claims
TO 'reports/reporting_claims.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 2: CUSTOMER CLAIM SUMMARY
-- ==========================================================
-- Purpose:
-- Summarise claim volumes and recorded claim amounts
-- by customer.
-- ==========================================================

COPY customer_claim_summary
TO 'reports/customer_claim_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 3: POLICY CLAIM SUMMARY
-- ==========================================================
-- Purpose:
-- Summarise claim activity and recorded claim amounts
-- by policy.
-- ==========================================================

COPY policy_claim_summary
TO 'reports/policy_claim_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 4: CLAIM STATUS SUMMARY
-- ==========================================================
-- Purpose:
-- Compare recorded claim volumes and claim amounts
-- across claim statuses.
-- ==========================================================

COPY claim_status_summary
TO 'reports/claim_status_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 5: CLAIM TYPE SUMMARY
-- ==========================================================
-- Purpose:
-- Compare recorded claim volumes and claim amounts
-- across claim types.
-- ==========================================================

COPY claim_type_summary
TO 'reports/claim_type_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 6: CUSTOMER BUSINESS REVIEW
-- ==========================================================
-- Purpose:
-- Identify customers with more than one recorded claim
-- whose total recorded claim amount exceeds the average
-- total claim amount per customer among customers with
-- at least one recorded claim.
--
-- Limitation:
-- This is an operational review based on the available
-- simulated data. It does not establish fraud, misconduct
-- or customer risk.
-- ==========================================================

COPY (
    WITH customer_statistics AS (
        SELECT
            AVG(total_claim_amount) AS average_customer_claim_amount
        FROM customer_claim_summary
        WHERE total_claims > 0
    )
    SELECT
        ccs.customer_id,
        ccs.first_name,
        ccs.last_name,
        ccs.province,
        ccs.policy_type,
        ccs.total_claims,
        ccs.total_claim_amount,
        ccs.average_claim_amount
    FROM customer_claim_summary AS ccs
    CROSS JOIN customer_statistics AS cs
    WHERE ccs.total_claims > 1
      AND ccs.total_claim_amount >
          cs.average_customer_claim_amount
    ORDER BY
        ccs.total_claim_amount DESC,
        ccs.customer_id
)
TO 'reports/customer_business_review.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 7: CLAIMS DATA QUALITY EXCEPTIONS
-- ==========================================================
-- Purpose:
-- Export claims with missing fields that may affect
-- reporting completeness or interpretation.
--
-- A missing settlement duration is an exception for review;
-- it does not by itself prove that a claim was mishandled.
-- ==========================================================

COPY (
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
        days_to_settle
    FROM reporting_claims
    WHERE customer_id IS NULL
       OR policy_id IS NULL
       OR claim_date IS NULL
       OR claim_type IS NULL
       OR claim_amount IS NULL
       OR claim_status IS NULL
       OR days_to_settle IS NULL
    ORDER BY claim_id
)
TO 'reports/claims_data_quality_exceptions.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- END OF REPORT EXPORTS
-- ==========================================================
-- These statements export existing reporting outputs.
-- They do not create reporting tables or validate the
-- exported files after creation.
-- ==========================================================


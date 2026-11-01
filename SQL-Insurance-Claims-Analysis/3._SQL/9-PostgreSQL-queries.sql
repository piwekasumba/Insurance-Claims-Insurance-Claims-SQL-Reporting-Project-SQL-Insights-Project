
-- ==========================================================
-- INSURANCE CLAIMS REPORT EXPORTS
-- PostgreSQL
--
-- Purpose:
-- Export prepared reporting datasets, business review
-- outputs and data quality exceptions as CSV files.
--
-- EXECUTION PREREQUISITES:
-- 1. Customer and claims source data have been loaded.
-- 2. The ETL and reporting preparation workflow has completed.
-- 3. The following reporting tables exist:
--      claims_reporting
--      customer_claim_summary
--      policy_claim_summary
--      claims_status_summary
--      claims_type_summary
-- 4. The destination reports directory already exists.
-- 5. PostgreSQL has permission to write to the destination.
--
-- IMPORTANT:
-- COPY TO writes files to the DATABASE SERVER filesystem.
-- It does not automatically save files into this SQL script's
-- directory or the GitHub repository.
--
-- Replace the example directory in every export path below
-- with the actual absolute path to your reports directory.
--
-- Forward slashes are supported in Windows PostgreSQL paths.
-- ==========================================================


-- ==========================================================
-- EXPORT 1: REPORTING CLAIMS DATASET
-- ==========================================================
-- Purpose:
-- Export the prepared claims reporting dataset, including
-- reporting attributes derived during ETL preparation.
-- ==========================================================

COPY claims_reporting
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/reporting_claims.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 2: CUSTOMER CLAIM SUMMARY
-- ==========================================================
-- Purpose:
-- Export customer-level claim metrics for reporting and
-- further analysis.
-- ==========================================================

COPY customer_claim_summary
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/customer_claim_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 3: POLICY CLAIM SUMMARY
-- ==========================================================
-- Purpose:
-- Export policy-level claim metrics for reporting and
-- further analysis.
-- ==========================================================

COPY policy_claim_summary
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/policy_claim_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 4: CLAIM STATUS SUMMARY
-- ==========================================================
-- Purpose:
-- Export recorded claim volumes and amounts grouped
-- by claim status.
-- ==========================================================

COPY claims_status_summary
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/claims_status_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 5: CLAIM TYPE SUMMARY
-- ==========================================================
-- Purpose:
-- Export recorded claim volumes and amounts grouped
-- by claim type.
-- ==========================================================

COPY claims_type_summary
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/claims_type_summary.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 6: CUSTOMER BUSINESS REVIEW
-- ==========================================================
-- Purpose:
-- Identify customers who:
--   1. Have more than one recorded claim.
--   2. Have a total recorded claim amount greater than
--      the average total claim amount among customers
--      with at least one recorded claim.
--
-- Review considerations:
-- This output highlights records for further operational
-- review. It does not establish fraud, misconduct,
-- customer risk or inappropriate claims activity.
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
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/customer_business_review.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- EXPORT 7: CLAIMS DATA QUALITY EXCEPTIONS
-- ==========================================================
-- Purpose:
-- Identify claims with missing reporting fields that may
-- affect reporting completeness or interpretation.
--
-- Review considerations:
-- A missing settlement duration is an exception requiring
-- review. It does not independently establish that a claim
-- was mishandled.
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

    FROM claims_reporting

    WHERE customer_id IS NULL
       OR policy_id IS NULL
       OR claim_date IS NULL
       OR claim_type IS NULL
       OR claim_amount IS NULL
       OR claim_status IS NULL
       OR days_to_settle IS NULL

    ORDER BY claim_id
)
TO 'C:/REPLACE_WITH_PROJECT_PATH/reports/claims_data_quality_exceptions.csv'
WITH (FORMAT CSV, HEADER TRUE);


-- ==========================================================
-- END OF REPORT EXPORTS
-- ==========================================================
-- These statements export existing reporting outputs.
--
-- They do not:
--   - Create the reporting tables.
--   - Perform the ETL process.
--   - Validate the exported CSV contents.
--   - Automatically create the destination directory.
--
-- Export success depends on the availability of the
-- reporting tables, valid destination paths and the
-- PostgreSQL service's filesystem permissions.
-- ==========================================================

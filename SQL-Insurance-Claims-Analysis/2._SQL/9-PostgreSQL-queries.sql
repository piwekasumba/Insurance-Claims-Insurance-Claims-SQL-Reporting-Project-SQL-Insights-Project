-- ==========================================================
-- REPORT EXPORTS
-- PostgreSQL
--
-- Purpose:
-- Prepare reporting outputs for business users and downstream
-- reporting or dashboard development.
--
-- Note:
-- COPY TO writes files on the PostgreSQL server.
-- The export path must exist and PostgreSQL must have permission
-- to write to it.
-- ==========================================================


-- ==========================================================
-- EXPORT 1: REPORTING CLAIMS DATASET
-- ==========================================================
-- Used for operational claims reporting and further analysis.
-- ==========================================================

COPY reporting_claims
TO 'reports/reporting_claims.csv'
WITH CSV HEADER;


-- ==========================================================
-- EXPORT 2: CUSTOMER CLAIM SUMMARY
-- ==========================================================
-- Used to monitor customer claim activity and claim values.
-- ==========================================================

COPY customer_claim_summary
TO 'reports/customer_claim_summary.csv'
WITH CSV HEADER;


-- ==========================================================
-- EXPORT 3: POLICY CLAIM SUMMARY
-- ==========================================================
-- Used for policy-level claims performance reporting.
-- ==========================================================

COPY policy_claim_summary
TO 'reports/policy_claim_summary.csv'
WITH CSV HEADER;


-- ==========================================================
-- EXPORT 4: CLAIM STATUS SUMMARY
-- ==========================================================
-- Used to monitor claim volumes and financial exposure
-- by claim status.
-- ==========================================================

COPY claim_status_summary
TO 'reports/claim_status_summary.csv'
WITH CSV HEADER;


-- ==========================================================
-- EXPORT 5: CLAIM TYPE SUMMARY
-- ==========================================================
-- Used to compare claim volume and financial exposure
-- across claim categories.
-- ==========================================================

COPY claim_type_summary
TO 'reports/claim_type_summary.csv'
WITH CSV HEADER;


-- ==========================================================
-- EXPORT 6: CUSTOMER BUSINESS REVIEW REPORT
-- ==========================================================
-- Business Purpose:
-- Identify customers with multiple claims and total claim
-- values above the average customer claim value.
--
-- Important:
-- This is an operational review report.
-- It does not determine fraud or customer risk.
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
        ccs.total_claim_amount DESC

)

TO 'reports/customer_business_review.csv'
WITH CSV HEADER;


-- ==========================================================
-- EXPORT 7: DATA QUALITY EXCEPTIONS
-- ==========================================================
-- Business Purpose:
-- Export claims containing missing information that could
-- affect reporting accuracy.
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

    WHERE claim_date IS NULL
       OR days_to_settle IS NULL

    ORDER BY
        claim_id

)

TO 'reports/claims_data_quality_exceptions.csv'
WITH CSV HEADER;

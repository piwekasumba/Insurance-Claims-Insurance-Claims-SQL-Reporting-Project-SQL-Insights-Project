
-- ===========================================================
-- INSURANCE CLAIMS REPORTING & ANALYSIS
-- PostgreSQL
--
-- Purpose:
-- Analyse simulated insurance claims and produce reporting
-- outputs for claims monitoring, KPI reporting and analysis.
--
-- Data sources:
-- customers_raw.csv
-- claims_raw.csv
--
-- Database tables:
-- customers
-- claims_raw
--
-- Reporting scope:
-- Recorded claims and associated customer information.
--
-- Important limitations:
-- These queries describe recorded claim values and statuses.
-- They do not predict future claims, establish fraud, assess
-- individual risk or establish causation.
--
-- Customer joins are reviewed for missing matches and
-- duplicate customer keys that could multiply reporting rows.
-- ===========================================================


-- ===========================================================
-- REPORT 1
-- Overall Claims KPI Summary
-- ===========================================================

SELECT
    COUNT(*) AS total_claim_records,
    COUNT(claim_id) AS claims_with_claim_id,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MIN(claim_amount) AS lowest_claim_amount,
    MAX(claim_amount) AS highest_claim_amount
FROM claims_raw;


-- ===========================================================
-- REPORT 2
-- Claims by Claim Type
-- ===========================================================

SELECT
    COALESCE(
        NULLIF(BTRIM(claim_type), ''),
        'Unknown / Missing'
    ) AS claim_type,

    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount

FROM claims_raw

GROUP BY
    COALESCE(
        NULLIF(BTRIM(claim_type), ''),
        'Unknown / Missing'
    )

ORDER BY
    total_claim_amount DESC NULLS LAST,
    claim_type;


-- ===========================================================
-- REPORT 3
-- Claims by Incident City
-- ===========================================================

SELECT
    COALESCE(
        NULLIF(BTRIM(incident_city), ''),
        'Unknown / Missing'
    ) AS incident_city,

    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount

FROM claims_raw

GROUP BY
    COALESCE(
        NULLIF(BTRIM(incident_city), ''),
        'Unknown / Missing'
    )

ORDER BY
    total_claim_amount DESC NULLS LAST,
    incident_city;


-- ===========================================================
-- REPORT 4
-- Claims by Status
-- ===========================================================

SELECT
    COALESCE(
        NULLIF(BTRIM(claim_status), ''),
        'Unknown / Missing'
    ) AS claim_status,

    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount

FROM claims_raw

GROUP BY
    COALESCE(
        NULLIF(BTRIM(claim_status), ''),
        'Unknown / Missing'
    )

ORDER BY
    total_claims DESC,
    claim_status;


-- ===========================================================
-- REPORT 5
-- Claims by Customer Province
--
-- LEFT JOIN retains claims without a matching customer.
-- ===========================================================

SELECT
    COALESCE(
        NULLIF(BTRIM(c.province), ''),
        'Unknown / Missing'
    ) AS customer_province,

    COUNT(*) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount

FROM claims_raw AS cl

LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id

GROUP BY
    COALESCE(
        NULLIF(BTRIM(c.province), ''),
        'Unknown / Missing'
    )

ORDER BY
    total_claim_amount DESC NULLS LAST,
    customer_province;


-- ===========================================================
-- REPORT 6
-- Claims by Customer Policy Type
-- ===========================================================

SELECT
    COALESCE(
        NULLIF(BTRIM(c.policy_type), ''),
        'Unknown / Missing'
    ) AS policy_type,

    COUNT(*) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount

FROM claims_raw AS cl

LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id

GROUP BY
    COALESCE(
        NULLIF(BTRIM(c.policy_type), ''),
        'Unknown / Missing'
    )

ORDER BY
    total_claim_amount DESC NULLS LAST,
    policy_type;


-- ===========================================================
-- REPORT 7
-- Claims by Customer Age Group
--
-- Negative ages are separated from valid age groups.
-- Missing customer matches are classified as unknown.
-- ===========================================================

SELECT
    CASE
        WHEN c.customer_id IS NULL THEN 'Unknown / Missing'
        WHEN c.age IS NULL THEN 'Unknown / Missing'
        WHEN c.age < 0 THEN 'Invalid Age'
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,

    COUNT(*) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount

FROM claims_raw AS cl

LEFT JOIN customers AS c
    ON cl.customer_id = c.customer_id

GROUP BY
    CASE
        WHEN c.customer_id IS NULL THEN 'Unknown / Missing'
        WHEN c.age IS NULL THEN 'Unknown / Missing'
        WHEN c.age < 0 THEN 'Invalid Age'
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END

ORDER BY
    total_claim_amount DESC NULLS LAST,
    age_group;


-- ===========================================================
-- REPORT 8
-- Top 10 Customers by Total Claim Value
--
-- Claims are aggregated before customer details are joined.
-- LEFT JOIN retains claims with missing customer matches.
-- ===========================================================

WITH customer_claim_summary AS (
    SELECT
        customer_id,
        COUNT(*) AS total_claims,
        SUM(claim_amount) AS total_claim_amount,
        ROUND(AVG(claim_amount), 2) AS average_claim_amount,
        MAX(claim_amount) AS highest_claim_amount

    FROM claims_raw

    GROUP BY customer_id
)

SELECT
    ccs.customer_id,

    COALESCE(
        NULLIF(BTRIM(c.first_name), ''),
        'Unknown'
    ) AS first_name,

    COALESCE(
        NULLIF(BTRIM(c.last_name), ''),
        'Unknown'
    ) AS last_name,

    ccs.total_claims,
    ccs.total_claim_amount,
    ccs.average_claim_amount,
    ccs.highest_claim_amount

FROM customer_claim_summary AS ccs

LEFT JOIN customers AS c
    ON ccs.customer_id = c.customer_id

ORDER BY
    ccs.total_claim_amount DESC NULLS LAST,
    ccs.total_claims DESC,
    ccs.customer_id

LIMIT 10;


-- ===========================================================
-- REPORT 9
-- Approved Claims Settlement Performance
--
-- Separates all approved claims from those with recorded
-- settlement days.
-- ===========================================================

SELECT
    COUNT(*) AS total_approved_claims,

    COUNT(days_to_settle)
        AS approved_claims_with_settlement_days,

    ROUND(AVG(days_to_settle), 2)
        AS average_days_to_settle,

    MIN(days_to_settle)
        AS fastest_recorded_settlement_days,

    MAX(days_to_settle)
        AS longest_recorded_settlement_days

FROM claims_raw

WHERE claim_status = 'Approved';


-- ===========================================================
-- REPORT 10
-- Data Quality Summary
--
-- Missing settlement days are not automatically errors.
-- Pending or rejected claims may not require settlement days.
-- Negative values are flagged for investigation.
-- ===========================================================

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
    (
        SELECT COUNT(*)
        FROM (
            SELECT claim_id
            FROM claims_raw
            WHERE claim_id IS NOT NULL
            GROUP BY claim_id
            HAVING COUNT(*) > 1
        ) AS duplicate_claims
    ) AS duplicate_claim_id_groups,
    
    COUNT(*) FILTER (
        WHERE claim_date IS NULL
    ) AS missing_claim_dates,

    COUNT(*) FILTER (
        WHERE claim_amount IS NULL
    ) AS missing_claim_amounts,

    COUNT(*) FILTER (
        WHERE claim_amount < 0
    ) AS negative_claim_amounts,

    COUNT(*) FILTER (
        WHERE claim_status IS NULL
           OR BTRIM(claim_status) = ''
    ) AS missing_claim_statuses,

    COUNT(*) FILTER (
        WHERE claim_type IS NULL
           OR BTRIM(claim_type) = ''
    ) AS missing_claim_types,

    COUNT(*) FILTER (
        WHERE incident_city IS NULL
           OR BTRIM(incident_city) = ''
    ) AS missing_incident_cities,

    COUNT(*) FILTER (
        WHERE days_to_settle IS NULL
    ) AS missing_settlement_days,

    COUNT(*) FILTER (
        WHERE days_to_settle < 0
    ) AS negative_settlement_days,

    COUNT(*) FILTER (
        WHERE claim_status = 'Approved'
          AND days_to_settle IS NULL
    ) AS approved_claims_missing_settlement_days

FROM claims_raw;


-- ===========================================================
-- REPORT 11
-- Customer Key Uniqueness Check
--
-- Identifies duplicate customer IDs that could multiply
-- claim records when customers are joined to claims.
-- ===========================================================

SELECT
    COUNT(*) AS duplicate_customer_id_groups,

    COALESCE(
        SUM(customer_record_count - 1),
        0
    ) AS excess_customer_records

FROM (
    SELECT
        customer_id,
        COUNT(*) AS customer_record_count

    FROM customers

    WHERE customer_id IS NOT NULL

    GROUP BY customer_id

    HAVING COUNT(*) > 1
) AS duplicate_customers;


-- ===========================================================
-- REPORT 12
-- Claims-to-Customers Join Reconciliation
--
-- Compares source claim records and amounts with the results
-- after a LEFT JOIN to the customer table.
--
-- More joined rows than source records may indicate
-- duplicate customer keys.
-- ===========================================================

WITH source_summary AS (
    SELECT
        COUNT(*) AS source_claim_records,
        COUNT(claim_id) AS source_claims_with_id,
        SUM(claim_amount) AS source_total_claim_amount

    FROM claims_raw
),

joined_summary AS (
    SELECT
        COUNT(*) AS joined_row_count,

        COUNT(DISTINCT cl.claim_id)
            AS distinct_claim_ids_after_join,

        COUNT(*) FILTER (
            WHERE c.customer_id IS NOT NULL
        ) AS matched_join_rows,

        COUNT(*) FILTER (
            WHERE c.customer_id IS NULL
        ) AS unmatched_join_rows,

        SUM(cl.claim_amount)
            AS joined_total_claim_amount

    FROM claims_raw AS cl

    LEFT JOIN customers AS c
        ON cl.customer_id = c.customer_id
)

SELECT
    s.source_claim_records,
    s.source_claims_with_id,
    s.source_total_claim_amount,

    j.joined_row_count,
    j.distinct_claim_ids_after_join,
    j.matched_join_rows,
    j.unmatched_join_rows,
    j.joined_total_claim_amount,

    j.joined_row_count - s.source_claim_records
        AS difference_in_row_count,

    j.joined_total_claim_amount - s.source_total_claim_amount
        AS difference_in_claim_amount

FROM source_summary AS s

CROSS JOIN joined_summary AS j;

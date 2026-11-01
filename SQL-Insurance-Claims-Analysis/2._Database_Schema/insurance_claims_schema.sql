
-- ===========================================================
-- INSURANCE CLAIMS REPORTING DATABASE
-- PostgreSQL Relational Database Schema
--
-- Purpose:
-- Create the relational database structure for the simulated
-- insurance claims reporting project.
--
-- Tables:
-- 1. customers
-- 2. claims_raw
--
-- Design approach:
-- - Maintain customer reference data.
-- - Preserve source claim values for data-quality review.
-- - Allow incomplete and unexpected claim values to be
--   investigated through SQL validation queries.
-- - Support reporting joins and commonly used filters.
--
-- Dataset:
-- 20 customers
-- 20 claims
--
-- ===========================================================


-- ===========================================================
-- 1. CUSTOMERS
--
-- Stores customer reference information.
-- Customer IDs provide the unique identifier for each
-- customer in the dataset.
-- ===========================================================

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10)
        CHECK (gender IN ('Male', 'Female')),
    age INT
        CHECK (age > 0),
    city VARCHAR(100),
    province VARCHAR(100),
    policy_start_date DATE,
    policy_type VARCHAR(50)
);


-- ===========================================================
-- 2. RAW CLAIMS
--
-- Stores the source claims dataset before data-quality
-- validation and reporting analysis.
--
-- Design decision:
-- Constraints that could reject unexpected source values
-- are intentionally excluded from this table.
--
-- This allows validation queries to investigate:
-- - Missing customer references.
-- - Unexpected claim statuses.
-- - Unexpected police report values.
-- - Missing, zero or negative claim amounts.
-- - Negative settlement durations.
--
-- claim_id remains the primary key because the current
-- simulated dataset contains unique claim identifiers.
--
-- Note:
-- Source values must still be compatible with their
-- PostgreSQL column data types.
-- ===========================================================

CREATE TABLE claims_raw (
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


-- ===========================================================
-- 3. INDEXES
--
-- Support common reporting operations involving:
-- - Customer-based joins.
-- - Policy-based filtering.
-- - Claim-date filtering.
-- - Claim-status filtering.
--
-- These indexes provide useful access paths for reporting
-- queries. Actual performance benefits depend on dataset
-- size, query patterns and PostgreSQL query planning.
-- ===========================================================

CREATE INDEX idx_claims_raw_customer
    ON claims_raw(customer_id);

CREATE INDEX idx_claims_raw_policy
    ON claims_raw(policy_id);

CREATE INDEX idx_claims_raw_date
    ON claims_raw(claim_date);

CREATE INDEX idx_claims_raw_status
    ON claims_raw(claim_status);


-- ===========================================================
-- END OF INSURANCE CLAIMS DATABASE SCHEMA
-- ===========================================================

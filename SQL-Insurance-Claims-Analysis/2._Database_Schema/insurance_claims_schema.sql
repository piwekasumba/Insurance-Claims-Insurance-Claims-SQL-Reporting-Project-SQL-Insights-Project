
-- ===========================================================
-- INSURANCE CLAIMS REPORTING DATABASE
-- PostgreSQL Relational Database Schema
--
-- Purpose:
-- Create the core tables for the simulated claims project.
--
-- Tables:
-- 1. customers
-- 2. claims_raw
--
-- The raw claims table preserves source values for validation.
-- ===========================================================


-- ===========================================================
-- CUSTOMERS
-- Matches the 20-record customer dataset.
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
-- RAW CLAIMS
-- Matches the 20-record claims dataset.
--
-- Nullable fields allow incomplete source records to be
-- retained and identified during data-quality checks.
-- ===========================================================

CREATE TABLE claims_raw (
    claim_id INT PRIMARY KEY,
    customer_id VARCHAR(10)
        REFERENCES customers(customer_id),
    policy_id VARCHAR(20),
    claim_date DATE,
    claim_type VARCHAR(50),
    claim_amount NUMERIC(12,2)
        CHECK (claim_amount > 0),
    claim_status VARCHAR(20)
        CHECK (
            claim_status IN (
                'Pending',
                'Approved',
                'Rejected',
                'Under Review'
            )
            OR claim_status IS NULL
        ),
    incident_city VARCHAR(100),
    incident_type VARCHAR(100),
    police_report VARCHAR(10)
        CHECK (
            police_report IN ('Yes', 'No')
            OR police_report IS NULL
        ),
    days_to_settle INT
        CHECK (days_to_settle >= 0)
);


-- ===========================================================
-- INDEXES
-- Support common joins and reporting filters.
-- ===========================================================

CREATE INDEX idx_claims_raw_customer
    ON claims_raw(customer_id);

CREATE INDEX idx_claims_raw_policy
    ON claims_raw(policy_id);

CREATE INDEX idx_claims_raw_date
    ON claims_raw(claim_date);

CREATE INDEX idx_claims_raw_status
    ON claims_raw(claim_status);

CREATE INDEX idx_customers_last_name
    ON customers(last_name);


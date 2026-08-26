-- ===========================================================
-- INSURANCE CLAIMS RISK ANALYTICS DATABASE
-- PostgreSQL Relational Database Schema
--
-- Purpose:
-- Create the core database structure used for insurance claims
-- reporting and analysis.
--
-- The schema demonstrates:
-- • Relational database design
-- • Primary and foreign keys
-- • Data validation constraints
-- • Lookup tables
-- • Default values
-- • Indexes for common reporting queries
-- ===========================================================


-- ===========================================================
-- CUSTOMERS
-- Stores customer information used for claims reporting.
-- ===========================================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10)
        CHECK (gender IN ('Male', 'Female')),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ===========================================================
-- CLAIM STATUS LOOKUP
-- Standardises claim statuses for consistent reporting.
-- ===========================================================

CREATE TABLE claim_status_lookup (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(20) UNIQUE NOT NULL
);


-- Insert the standard claim statuses used by the project.

INSERT INTO claim_status_lookup (status_name)
VALUES
    ('Pending'),
    ('Approved'),
    ('Rejected'),
    ('Under Review');


-- ===========================================================
-- CLAIMS
-- Stores insurance claim transactions linked to customers.
-- ===========================================================

CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL
        REFERENCES customers(customer_id),

    policy_number VARCHAR(50) NOT NULL,

    claim_date DATE NOT NULL,

    processed_date DATE,

    claim_amount NUMERIC(12,2) NOT NULL
        CHECK (claim_amount > 0),

    status_id INT NOT NULL
        DEFAULT 1
        REFERENCES claim_status_lookup(status_id),

    claim_type VARCHAR(50),

    description TEXT,

    processed_by VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ===========================================================
-- INDEXES
-- Support common reporting and filtering queries.
-- ===========================================================

-- Supports policy-level analysis.

CREATE INDEX idx_claims_policy_number
ON claims(policy_number);


-- Supports customer-to-claims joins.

CREATE INDEX idx_claims_customer
ON claims(customer_id);


-- Supports date-based claims reporting.

CREATE INDEX idx_claims_claim_date
ON claims(claim_date);


-- Supports reporting by claim status.

CREATE INDEX idx_claims_status
ON claims(status_id);


-- Supports customer searches by surname.

CREATE INDEX idx_customers_last_name
ON customers(last_name);

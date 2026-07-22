-- ===========================================================
-- INSURANCE CLAIMS RISK ANALYTICS DATABASE
-- PostgreSQL Relational Schema
-- ===========================================================

-- ===========================================================
-- CUSTOMERS
-- Stores customer information used for reporting and analysis.
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
-- Improve query performance for reporting workloads.
-- ===========================================================

-- Frequently used when analysing policies
CREATE INDEX idx_claims_policy_number
ON claims(policy_number);

-- Frequently used when joining customers and claims
CREATE INDEX idx_claims_customer
ON claims(customer_id);

-- Frequently used for monthly and yearly reporting
CREATE INDEX idx_claims_claim_date
ON claims(claim_date);

-- Frequently used when reporting by claim status
CREATE INDEX idx_claims_status
ON claims(status_id);

-- Supports customer searches
CREATE INDEX idx_customers_last_name
ON customers(last_name);

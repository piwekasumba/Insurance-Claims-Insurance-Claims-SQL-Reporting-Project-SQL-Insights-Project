-- ==============================
-- CUSTOMERS TABLE
-- ==============================
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

-- ==============================
-- CLAIM STATUS LOOKUP TABLE
-- ==============================
CREATE TABLE claim_status_lookup (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(20) UNIQUE NOT NULL
);

-- Insert default claim statuses
INSERT INTO claim_status_lookup (status_name) VALUES
('Pending'),
('Approved'),
('Rejected'),
('Under Review');

-- ==============================
-- CLAIMS TABLE
-- ==============================
CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL
        REFERENCES customers(customer_id),

    policy_number VARCHAR(50) NOT NULL,

    claim_date DATE NOT NULL,

    processed_date DATE,

    claim_amount NUMERIC(12,2) NOT NULL
        CHECK (claim_amount > 0),

    status_id INT
        REFERENCES claim_status_lookup(status_id)
        DEFAULT 1,

    claim_type VARCHAR(50),

    description TEXT,

    processed_by VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- INDEXES (PERFORMANCE OPTIMIZATION)
-- ==============================

-- Improve claim search performance by policy number
CREATE INDEX idx_claims_policy
ON claims(policy_number);

-- Improve customer search by last name
CREATE INDEX idx_customers_lastname
ON customers(last_name);

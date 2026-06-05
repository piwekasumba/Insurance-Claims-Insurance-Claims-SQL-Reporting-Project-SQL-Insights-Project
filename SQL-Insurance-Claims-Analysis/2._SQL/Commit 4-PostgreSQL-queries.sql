-- =========================
-- CREATE CORE TABLES
-- =========================

-- Create customers table (raw dataset structure)
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    age INT,
    sex VARCHAR(10),
    bmi NUMERIC(5,2),
    children INT,
    smoker VARCHAR(10),
    region VARCHAR(50)
);

-- Create claims table (raw claims data)
CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    customer_id INT,
    claim_amount NUMERIC(10,2),
    claim_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- =========================
-- DATA LOADING
-- =========================

-- Load customer data from CSV
COPY customers(age, sex, bmi, children, smoker, region)
FROM '/path/customers.csv'
DELIMITER ','
CSV HEADER;

-- Load claims data from CSV
COPY claims(customer_id, claim_amount, claim_date)
FROM '/path/claims.csv'
DELIMITER ','
CSV HEADER;

-- =========================
-- BASIC ANALYSIS QUERIES
-- =========================

-- Total claim amount by region
SELECT
    c.region,
    SUM(cl.claim_amount) AS total_claim_amount
FROM customers c
JOIN claims cl ON c.customer_id = cl.customer_id
GROUP BY c.region
ORDER BY total_claim_amount DESC;

-- Average claim amount by smoker status
SELECT
    c.smoker,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers c
JOIN claims cl ON c.customer_id = cl.customer_id
GROUP BY c.smoker;

-- Top 10 highest claims per customer
SELECT
    customer_id,
    MAX(claim_amount) AS highest_claim
FROM claims
GROUP BY customer_id
ORDER BY highest_claim DESC
LIMIT 10;

-- Claims by age group
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(cl.claim_id) AS total_claims
FROM customers c
JOIN claims cl ON c.customer_id = cl.customer_id
GROUP BY age_group
ORDER BY total_claims DESC;


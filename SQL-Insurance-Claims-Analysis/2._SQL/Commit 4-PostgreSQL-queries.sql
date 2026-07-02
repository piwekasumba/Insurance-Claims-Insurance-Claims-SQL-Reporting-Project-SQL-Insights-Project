-- =====================================
-- CREATE TABLES
-- =====================================

-- Customer information
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    age INT,
    sex VARCHAR(10),
    bmi NUMERIC(5,2),
    children INT,
    smoker VARCHAR(10),
    region VARCHAR(50)
);

-- Insurance claims
CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    claim_amount NUMERIC(10,2),
    claim_date DATE,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- =====================================
-- LOAD DATA
-- =====================================

COPY customers (
    age,
    sex,
    bmi,
    children,
    smoker,
    region
)
FROM '/path/customers.csv'
DELIMITER ','
CSV HEADER;

COPY claims (
    customer_id,
    claim_amount,
    claim_date
)
FROM '/path/claims.csv'
DELIMITER ','
CSV HEADER;

-- =====================================
-- BUSINESS QUESTIONS
-- =====================================

-- 1. Which regions have the highest total claim amounts?
SELECT
    c.region,
    SUM(cl.claim_amount) AS total_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY c.region
ORDER BY total_claim_amount DESC;

-- 2. Do smokers have higher average claim amounts?
SELECT
    c.smoker,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY c.smoker
ORDER BY average_claim_amount DESC;

-- 3. Which customers submitted the highest individual claims?
SELECT
    customer_id,
    MAX(claim_amount) AS highest_claim
FROM claims
GROUP BY customer_id
ORDER BY highest_claim DESC
LIMIT 10;

-- 4. Which age groups submit the most insurance claims?
SELECT
    CASE
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(cl.claim_id) AS total_claims
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY age_group
ORDER BY total_claims DESC;


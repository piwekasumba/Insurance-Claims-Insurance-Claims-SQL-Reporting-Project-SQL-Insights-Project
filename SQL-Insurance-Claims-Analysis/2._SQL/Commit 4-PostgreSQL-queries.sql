-- =====================================
-- INSURANCE CLAIMS ANALYSIS
-- PostgreSQL
-- =====================================

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
-- BUSINESS QUESTION 1
-- Which regions generated the highest total
-- insurance claim costs?
--
-- Business Purpose:
-- Helps identify regions contributing most
-- to overall claims expenditure.
--
-- Reporting Output:
-- Regional claims summary ranked by total
-- claim value.
-- =====================================

SELECT
    c.region,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY c.region
ORDER BY total_claim_amount DESC;

-- =====================================
-- BUSINESS QUESTION 2
-- Do smokers generate higher insurance
-- claim costs than non-smokers?
--
-- Business Purpose:
-- Supports customer risk reporting by
-- comparing claims performance across
-- customer groups.
--
-- Reporting Output:
-- Claims summary by smoker status.
-- =====================================

SELECT
    c.smoker,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY c.smoker
ORDER BY total_claim_amount DESC;

-- =====================================
-- BUSINESS QUESTION 3
-- Which customers generated the highest
-- total insurance claim costs?
--
-- Business Purpose:
-- Supports reporting by identifying
-- customers with the highest overall
-- claims activity.
--
-- Reporting Output:
-- Ranked customer claims report.
-- =====================================

SELECT
    customer_id,
    COUNT(claim_id) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS average_claim_amount,
    MAX(claim_amount) AS highest_claim_amount
FROM claims
GROUP BY customer_id
ORDER BY total_claim_amount DESC
LIMIT 10;

-- =====================================
-- BUSINESS QUESTION 4
-- Which age groups generate the greatest
-- claims activity?
--
-- Business Purpose:
-- Helps understand claims patterns across
-- customer age groups for reporting.
--
-- Reporting Output:
-- Age group claims summary.
-- =====================================

SELECT
    CASE
        WHEN c.age < 30 THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(cl.claim_id) AS total_claims,
    SUM(cl.claim_amount) AS total_claim_amount,
    ROUND(AVG(cl.claim_amount), 2) AS average_claim_amount
FROM customers AS c
INNER JOIN claims AS cl
    ON c.customer_id = cl.customer_id
GROUP BY age_group
ORDER BY total_claim_amount DESC;

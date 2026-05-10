#  Insurance Claims Analysis (SQL Project) 

This project is part of my SQL learning portfolio focused on building real-world data analysis and data engineering fundamentals using PostgreSQL.

This project focuses on using SQL to clean, transform, and analyse insurance claims data.

---

## • Real-world Data Challenges

The dataset contains common issues found in real business data:

- missing values  
- duplicate records  
- inconsistent categories  
- unstructured data  

---

## • What I Worked On

In this project, I used SQL to simulate real data workflow tasks including:

- cleaning and standardising raw data  
- handling missing and duplicate values  
- joining related tables  
- creating analysis-ready datasets  
- exploring basic business insights  

---

## • How I Approached It

I focused on thinking in terms of raw data → cleaned data → analysis-ready output, rather than just writing isolated SQL queries.

---

## • Tools Used

PostgreSQL  
SQL  
Git & GitHub  

---

## • Project Contents

- Data cleaning queries  
- Transformation queries  
- Exploratory analysis queries  
- Business insight examples  

---

## • Example SQL Query

```sql
SELECT 
    customer_id,
    SUM(claim_amount) AS total_claim_value
FROM claims
WHERE claim_status = 'Approved'
GROUP BY customer_id
ORDER BY total_claim_value DESC;


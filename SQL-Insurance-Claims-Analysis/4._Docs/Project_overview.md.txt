- Insurance Claims SQL Reporting Project

- Project Overview

This project demonstrates how I used PostgreSQL and SQL to analyse a simulated insurance claims dataset from a business reporting perspective.

The project focuses on relational database design, data validation, SQL analysis, KPI reporting, trend analysis, and preparation of reporting-ready datasets.

The goal is to demonstrate how structured claims data can be transformed into useful information for operational reporting and business decision support.

---

- Business Scenario

Insurance companies process large volumes of claims data. Accurate reporting helps teams monitor claim activity, understand claim costs, identify trends, and review operational performance.

This project simulates a claims reporting workflow in which raw customer and claims data is organised in PostgreSQL and analysed using SQL.

The analysis focuses on practical reporting questions rather than making unsupported fraud or risk predictions.

---

- Project Objectives

- Build a relational database using PostgreSQL
- Organise customer and claims data into related tables
- Apply primary and foreign key relationships
- Validate and prepare data for reporting
- Use SQL to answer business questions
- Calculate claims KPIs and summary metrics
- Analyse claims trends and patterns
- Create reporting-ready datasets
- Produce operational exception reports
- Demonstrate how SQL supports business reporting

---

- Dataset

| Item | Description |
|---|---|
| Dataset Type | Simulated Insurance Claims Dataset |
| Database | PostgreSQL |
| Customer Records | 20 |
| Claim Records | 20 |
| Main Customer Data | Customer ID, name, gender, age, city, province, policy start date, policy type |
| Main Claims Data | Claim ID, customer ID, policy ID, claim date, claim type, claim amount, claim status, incident city, incident type, police report, days to settle |

---

- Project Structure

```text
SQL-Insurance-Claims-Analysis/
│
├── 01-Data/
│   ├── customers_raw.csv
│   └── claims_raw.csv
│
├── 02-Database-Schema/
│   └── schema_design.sql
│
├── 03-SQL/
│   ├── SQL analysis queries
│   ├── reporting queries
│   ├── exception monitoring queries
│   └── report export queries
│
├── 04-Scripts/
│   └── insurance_claims_postgresql_pipeline.sql
│
└── 05-Docs/
    └── README.md


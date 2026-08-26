# Insurance Claims Risk Analytics SQL Project

A PostgreSQL project focused on analysing simulated insurance claims data, calculating reporting KPIs and exploring patterns that can support claims and risk monitoring.
---
## Business Problem

Insurance businesses need reliable reporting to monitor claims activity, claim costs and changes in risk indicators.

Without structured analysis, it can be difficult to understand claim volumes, claim severity and other performance measures.

This project uses SQL to turn simulated insurance data into structured reporting outputs that can be used to explore these questions.
---
## Project Objective

The objective is to use PostgreSQL and SQL to:

* Analyse insurance claims data
* Connect related customer, policy and claims information
* Calculate reporting KPIs
* Explore claim severity and claim activity
* Produce structured SQL outputs
* Translate the analysis into business reporting observations
---
## Tools / Technologies

* PostgreSQL
* SQL
* SQL joins
* Aggregate functions
* Common Table Expressions (CTEs)
* Data preparation
* KPI analysis
* Business reporting
---
## Dataset

The project uses a simulated insurance dataset.

The main business areas include:

* Customers
* Policies
* Claims

The data is for portfolio and learning purposes and does not represent real insurance customers or claims.
---
## Business Questions

The analysis explores questions such as:

* Which claim severity levels are associated with the highest claim costs?
* How many claims fall into each severity category?
* How does claim activity change over time?
* What is the average claim amount?
* What is the claim approval rate?
* Which reporting KPIs are useful for monitoring claims activity?
* How can related insurance tables be combined to answer reporting questions?
---
## SQL Analysis

The project uses SQL to join, aggregate and analyse the insurance data.

The analysis includes areas such as:

* Claims summaries
* Claim severity analysis
* Claim value analysis
* Approval metrics
* Claim frequency
* High-risk claim indicators
* Customer claim activity
* Time-based claim analysis

The repository contains the SQL analysis work under the `SQL-Insurance-Claims-Analysis` directory.
---
## Key KPIs

The project includes reporting measures such as:

* Total Claims
* Total Claim Value
* Average Claim Amount
* Claim Approval Rate
* Claim Frequency
* High-Risk Claim Ratio
* Customer Claim Activity
---
## Key Findings

The analysis is intended to identify differences in claim activity, claim severity and claim costs.

The main finding should come from the actual SQL results rather than assumptions about the dataset.

This README therefore avoids adding unsupported numerical claims and keeps the findings tied to the analysis contained in the repository.
---
## Business / Reporting Insights

The project demonstrates how claims reporting can help analysts and business users:

* Monitor claim volumes
* Review claim costs
* Compare claim severity
* Track approval measures
* Identify areas requiring further investigation
* Monitor changes in claims activity over time

The reporting value comes from turning several related tables into measures that are easier to review and compare.
---
## Data Quality Considerations

Claims reporting depends on relationships between customers, policies and claims being handled correctly.

Important considerations include:

* Correct relationships between tables
* Consistent claim and policy records
* Accurate joins
* Correct aggregation of claim values
* Appropriate handling of missing or inconsistent data
* Validation of calculated KPIs

Because this is simulated data, the project demonstrates the analytical process rather than production insurance reporting.
---
## Project Structure

```text
Insurance-Claims-Insurance-Claims-SQL-Reporting-Project-SQL-Insights-Project
│
├── README.md
│
├── Read-Me.md
│
└── SQL-Insurance-Claims-Analysis
    ├── 1._Data
    ├── 2._SQL
    ├── 3._Scripts
    ├── 4._Docs
    └── Insurance_claims_postgresql_pipeline.sql
```
---
## How to Run

The repository contains the SQL analysis and supporting project files.

A typical PostgreSQL workflow is:

1. Install PostgreSQL.
2. Create a database for the project.
3. Review the files under `SQL-Insurance-Claims-Analysis`.
4. Follow the SQL/scripts in the project to create and prepare the required tables.
5. Run the analysis queries.
6. Review the results against the business questions and KPIs.

The exact execution order should follow the SQL and script files included in the repository.
---
## What This Project Demonstrates

This project demonstrates my ability to:

* Work with PostgreSQL
* Analyse relational business data
* Use SQL joins and aggregation
* Build reporting KPIs
* Explore claims and risk-related business questions
* Organise analytical SQL into a structured project
* Communicate reporting observations clearly
---
## About

This project forms part of my SQL portfolio as I build practical evidence for entry-level Reporting Analyst opportunities.

My focus is on using SQL and PostgreSQL to understand business data, produce useful reporting outputs and continue developing my analytical skills.

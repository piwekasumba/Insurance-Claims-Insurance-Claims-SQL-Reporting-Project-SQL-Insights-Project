# Insurance Claims SQL Reporting & Risk Analytics
---
A PostgreSQL portfolio project demonstrating SQL-based insurance reporting, KPI analysis, data validation and risk-oriented investigation using simulated customer and claims data.

The project explores how relational data can be analysed to answer business questions, calculate reporting measures, identify data-quality issues and produce structured analytical outputs.

**Portfolio focus:** PostgreSQL | SQL | Insurance Reporting | KPI Analysis | Data Quality | Risk Indicators

---

## 1. Project Overview

Insurance reporting involves analysing claims information to understand recorded claim volumes, claim values, claim statuses and changes over time.

This project uses PostgreSQL to explore how SQL can support these reporting requirements through relational joins, aggregations, conditional logic and validation checks.

The analysis focuses on questions such as:

- How many claims have been recorded?
- What are the total and average recorded claim amounts?
- How are claims distributed across different statuses?
- How do claim amounts vary across severity categories?
- Which claim types account for higher recorded claim values?
- How does claim activity vary across reporting periods?
- Which customers have multiple recorded claims?
- Which records require further data-quality investigation?

The project uses simulated data and is intended for SQL learning and portfolio demonstration.
---
## 2. Project Objectives

The main objectives are to:

1. Work with related customer and claims tables in PostgreSQL.
2. Translate insurance-related business questions into SQL queries.
3. Calculate and analyse reporting KPIs.
4. Examine claim status, claim value and severity distributions.
5. Explore customer-level and time-based claim activity.
6. Identify missing, inconsistent or potentially duplicated information.
7. Validate calculations and relationships before interpreting reporting outputs.
8. Communicate analytical findings within the limitations of the dataset.
---
## 3. Tools and Technologies

| Technology / Concept | Application |
|---|---|
| PostgreSQL | Relational database environment |
| SQL | Data retrieval and analysis |
| JOIN operations | Combining customer and claims records |
| Aggregate functions | Calculating counts, totals and averages |
| GROUP BY | Summarising reporting categories |
| CASE expressions | Conditional logic and severity classification |
| Common Table Expressions (CTEs) | Structuring SQL analysis |
| Filtering and sorting | Selecting and organising reporting records |
| Data validation | Examining data completeness and consistency |
| KPI analysis | Defining and calculating reporting measures |
---
## 4. Dataset

The project uses simulated insurance data consisting of two main datasets.

| Dataset | Records | Description |
|---|---:|---|
| Customers | 20 | Customer identifiers, demographics, location and policy-related information |
| Claims | 20 | Claim identifiers, customer references, claim dates, types, amounts and statuses |

Additional claims fields include information such as:

- Incident location
- Incident type
- Police-report indicator
- Days to settlement

Some fields may contain missing values, providing opportunities to investigate data completeness and reporting limitations.

**Data limitations:** These records do not represent real customers, policies or insurance claims. The sample is small and is not suitable for generalising findings to the insurance industry.
---
## 5. Business Questions and Reporting Analysis

The project explores the following reporting areas.

| Business question | SQL approach | Reporting purpose |
|---|---|---|
| How many claims are recorded? | COUNT | Claims volume |
| What is the total claim amount? | SUM | Recorded claim value |
| What is the average claim amount? | AVG | Average recorded claim size |
| How are claims distributed by status? | GROUP BY | Status reporting |
| How do claims vary by severity? | CASE and aggregation | Claim-value classification |
| How does claim activity change over time? | Date-based aggregation | Period reporting |
| Which claim types have higher recorded values? | Grouped aggregation | Claim-type comparisons |
| How does activity vary by province? | Customer-to-claims JOIN | Geographic reporting |
| Which customers have multiple claims? | GROUP BY and HAVING | Customer-level analysis |
| Which records require review? | Validation queries | Data-quality investigation |

These questions provide a structured connection between business requirements and SQL analysis.
---
## 6. KPI Definitions and Reporting Accuracy

A reporting measure needs a clear definition before its results can be interpreted.

For example, an approval rate requires agreement on:

- The reporting period.
- Which claim statuses qualify for inclusion.
- The numerator used to count approved claims.
- The denominator used to represent eligible claims.
- How pending, rejected and under-review claims are treated.
- How missing or invalid records affect the calculation.

Similarly, an average claim amount must have a clearly defined population. An average across all recorded claims is not necessarily equivalent to an average of approved claims.

This project emphasises the importance of defining reporting measures, applying consistent filters and checking the underlying data.

**Key principle:** A SQL query producing a numerical result does not automatically make that result a reliable business KPI.
---
## 7. Claim Severity Analysis

### Business question

How do recorded claim counts and claim values differ across severity categories?

### SQL approach

Conditional logic using `CASE` expressions can classify claim amounts into documented severity categories.

The categories can then be analysed using:

- Number of claims.
- Total recorded claim amount.
- Average recorded claim amount.

### Reporting interpretation

The analysis can help compare claim-value categories and identify concentrations of higher recorded values.

However, severity categories derived from claim amounts are reporting classifications. They do not independently establish the cause of a claim or predict future insurance losses.
---
## 8. Claim Status and Approval Analysis

### Business question

What does the distribution of recorded claim statuses show?

SQL aggregation can summarise claims by status and calculate their respective proportions.

Potential reporting questions include:

- What proportion of recorded claims are approved?
- How many claims remain pending?
- How does the status distribution change over time?
- Are missing status values affecting the reporting output?

An approval rate should only be presented when its numerator, denominator and eligible claim population have been explicitly defined.

Status distribution and approval rate are related but different reporting measures.
---
## 9. Time-Based Claim Reporting

Claim records can be grouped by an appropriate date field to examine changes across reporting periods.

Possible measures include:

- Claim volume.
- Total recorded claim amount.
- Average claim amount.
- Claim-status distribution.
- Severity distribution.

Missing or invalid dates can affect reporting-period comparisons.

The analysis should identify records without usable dates and apply consistent inclusion rules before comparing periods.

Changes in reported claim activity should be treated as observations requiring investigation, rather than automatic evidence of a particular business cause.
---
## 10. Risk-Oriented Reporting

The project explores indicators that may support further investigation, including:

- Higher-value claims.
- Higher-severity categories.
- Customers with multiple recorded claims.
- Concentrations of claims by type or location.
- Changes in claim frequency.
- Changes in recorded claim outcomes.

These indicators can help formulate additional analytical questions.

They do not establish fraud, misconduct or future risk.

**Scope boundary:** This is SQL-based reporting and exploratory analysis. It is not a predictive risk model, machine-learning system or automated fraud-detection solution.
---
## 11. Data Quality and Validation

Reliable reporting depends on the quality of the underlying records and the accuracy of the SQL logic.

The project considers data-quality areas such as:

| Validation area | What to investigate |
|---|---|
| Missing values | Missing dates, amounts and identifiers |
| Duplicate records | Repeated claim identifiers or records |
| Referential integrity | Claims referencing valid customers |
| Status consistency | Unexpected or inconsistent claim statuses |
| Date validity | Missing or unsuitable claim dates |
| Join accuracy | Whether customer-to-claims joins preserve the intended reporting grain |
| Aggregation accuracy | Whether calculations introduce duplication |
| KPI consistency | Whether definitions and filters remain consistent |

Particular attention should be given to joins and aggregation.

For example, joining customer and claims records can produce misleading totals if the relationship between the tables and the intended level of reporting are not understood.

Validation should therefore be considered part of the reporting workflow, not simply a final check.
---
## 12. Analytical Workflow

The project follows this general reporting approach:

**Business Question → Dataset Review → SQL Analysis → KPI Calculation → Data Validation → Reporting Output → Interpretation → Further Investigation**

The purpose is to connect SQL calculations to meaningful reporting questions while distinguishing observed results from assumptions.
---
## 13. What This Project Demonstrates

This project provides evidence of self-directed practice in:

- PostgreSQL and SQL.
- Relational database analysis.
- Joining customer and claims records.
- Filtering and aggregating data.
- Conditional logic using `CASE`.
- Structuring queries with CTEs.
- Calculating reporting measures.
- Analysing claim values and status distributions.
- Exploring customer-level and time-based activity.
- Identifying potential data-quality issues.
- Considering KPI definitions and calculation accuracy.
- Interpreting SQL outputs within dataset limitations.

These are portfolio-based learning and project skills, not claims of professional insurance-industry experience.
---
## 14. Repository Structure

The project repository includes the following documented organisation:

```text
Insurance-Claims-Insurance-Claims-SQL-Reporting-Project-SQL-Insights-Project/
│
├── README.md
├── Read-Me.md
│
└── SQL-Insurance-Claims-Analysis/
    ├── 1._Data/
    ├── 2._SQL/
    ├── 3._Scripts/
    ├── 4._Docs/
    └── Insurance_claims_postgresql_pipeline.sql
```

The root `README.md` is the primary project overview.

The structure above reflects the supplied project documentation. Individual files and execution dependencies should be checked against the actual repository contents.
---
## 15. How to Run the Project

1. Install PostgreSQL and open a database client such as pgAdmin.
2. Create a database for the project.
3. Inspect the available data, schema and SQL scripts.
4. Create the required tables using the relevant schema scripts.
5. Load customer records before claims records if the foreign-key relationships require this order.
6. Review the available preparation and transformation scripts.
7. Execute the SQL scripts in their required dependency order.
8. Run the reporting and validation queries.
9. Review the outputs and investigate any exceptions.

The exact execution sequence should be confirmed against the actual SQL files.

Numerical findings should only be presented as verified results after the relevant queries have been executed and checked in PostgreSQL.
---
## 16. Portfolio Context

This project represents the insurance reporting and risk-oriented analysis component of my SQL portfolio.

It complements other simulated business-reporting projects:

- **RetailMart Executive Reporting SQL Project:** Retail reporting, KPI analysis and data validation.
- **Retail Sales Analytics ETL Data Pipeline Project:** Data preparation, transformation and validation.
- **SQL Data Analytics Fundamentals for Business Reporting:** Foundational SQL analysis and reporting practice.

Together, these projects demonstrate the application of SQL to different business contexts, with an emphasis on reporting logic, data quality and analytical interpretation.
---
## 17. Career Relevance

This project forms part of my self-directed development towards entry-level opportunities such as:

- Junior Reporting Analyst.
- Junior Data and Reporting Analyst.
- Junior Data Analyst (Reporting).
- SQL-focused Reporting Analyst.
- Junior Data Quality Analyst.

My primary career direction is SQL and PostgreSQL-based reporting, KPI analysis and data quality.

This project demonstrates independent learning and simulated business analysis. It does not represent professional employment or production insurance reporting experience.
---
## 18. Limitations

The project has important limitations:

- It uses simulated rather than real insurance data.
- The dataset contains only 20 customer records and 20 claim records.
- Findings cannot be generalised to the insurance industry.
- The project does not implement predictive modelling.
- Risk-oriented indicators do not establish fraud or misconduct.
- The analysis does not represent a complete production insurance environment.
- Numerical findings require execution and validation of the relevant SQL queries.

A production insurance reporting environment would require additional business controls, security, access management, governance and substantially more comprehensive data.
---
## About

I am building practical PostgreSQL and SQL projects focused on business reporting, KPI analysis, data quality and analytical thinking.

This project extends that work into an insurance reporting context, demonstrating how SQL can be used to investigate business questions, examine reporting measures and assess data reliability using simulated data.

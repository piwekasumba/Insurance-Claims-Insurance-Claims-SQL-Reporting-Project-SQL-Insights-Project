# Insurance Claims Risk Analytics SQL Project

A PostgreSQL portfolio project focused on **insurance claims reporting, KPI analysis, data quality, claim severity and risk-oriented business analysis** using simulated insurance data.

The project demonstrates how SQL can connect customer, policy and claims information and turn relational records into structured reporting evidence.

> **Portfolio focus:** SQL | PostgreSQL | Insurance Reporting | KPI Analysis | Risk Indicators | Data Quality

---

## Why This Project Exists

Insurance reporting depends on reliable information about claims, customers, policies, claim values, claim outcomes and changes over time.

A reporting analyst may need to answer questions such as:

* How many claims are being received?
* What is the average claim amount?
* How is claim severity distributed?
* What proportion of claims are approved?
* How does claim activity change over time?
* Where are claim costs concentrated?
* Which patterns require further investigation?
* Can the reported KPI be trusted?

This project uses PostgreSQL to practise those reporting questions with simulated insurance data.

---

## Industry Context

This project represents the **insurance and financial-services** side of my portfolio.

Insurance reporting can involve measures such as:

* Claims volume
* Claim value
* Claim severity
* Approval activity
* Customer claim activity
* Policy activity
* Time-based trends
* Risk-oriented indicators

The project focuses on reporting and investigation rather than attempting to build a predictive insurance model.

---

## Project Objective

The objective is to analyse related insurance data and produce structured reporting outputs using PostgreSQL and SQL.

The workflow is:

```text
Business Question
       ↓
Relevant Insurance Data
       ↓
SQL Analysis
       ↓
KPI / Measure
       ↓
Validation
       ↓
Reporting Output
       ↓
Business Interpretation
       ↓
Further Investigation
```

---

## Tools & Technologies

* PostgreSQL
* SQL
* Relational databases
* SQL joins
* Aggregate functions
* `GROUP BY`
* `ORDER BY`
* Filtering
* `CASE` expressions
* Common Table Expressions (CTEs)
* KPI calculations
* Business reporting analysis

---

## Dataset

The project uses simulated insurance data covering areas such as:

* Customers
* Insurance policies
* Claims
* Claim outcomes/status information

The dataset is intended for portfolio and learning purposes.

It does not represent real insurance customers, policies or claims.

---

## Business Questions

| Business Question                             | SQL Analysis                               | Reporting Purpose                        |
| --------------------------------------------- | ------------------------------------------ | ---------------------------------------- |
| What is the total number of claims?           | Count claims                               | Monitor claims volume                    |
| What is the average claim amount?             | Calculate average claim value              | Monitor typical claim size               |
| How are claims distributed by severity?       | Group claims by severity                   | Compare claim categories                 |
| What is the claim approval rate?              | Compare approved claims with total claims  | Monitor claim outcomes                   |
| How does claim activity change over time?     | Aggregate claims by period                 | Identify changes requiring investigation |
| Which categories have higher claim values?    | Aggregate claim amounts                    | Identify concentration of claim costs    |
| Which customers have higher claim activity?   | Join customers and claims                  | Compare customer-level activity          |
| Which indicators may require risk monitoring? | Combine claim characteristics and measures | Support further investigation            |

---

## KPI Definition & Validation

Insurance KPIs can appear simple while depending heavily on their definitions.

For example, an approval rate requires clarity around:

* What counts as a claim?
* Which statuses are included?
* What is the denominator?
* Which reporting period is being measured?
* How are incomplete records handled?
* Are duplicate records present?

Average claim amount similarly requires decisions about:

* Which claims are included?
* Which amount field represents the measure?
* Whether rejected claims are included
* Whether duplicate records exist
* Which reporting period is being measured

The project therefore treats KPI definition and validation as part of reporting rather than as an afterthought.

---

## Claims Severity Analysis

### Business Question

Which claim-severity categories are associated with higher claim costs?

### SQL Approach

Claims are grouped by severity and analysed using measures such as:

* Claim count
* Total claim amount
* Average claim amount

### Reporting Value

The resulting comparison can help a reporting user understand differences between severity categories and identify areas requiring further investigation.

The output should not automatically be treated as a causal explanation.

It is reporting evidence for investigation.

---

## Claim Approval Rate

### Business Question

What proportion of claims are approved?

### SQL Approach

Claim outcomes are grouped and used to calculate an approval measure.

### Reporting Value

The resulting measure can support monitoring of claim outcomes over time.

If the approval rate changes, further questions could include:

* Did claim mix change?
* Did severity distribution change?
* Did policy mix change?
* Did the underlying process change?
* Could a data-quality issue affect the result?

---

## Claim Activity Over Time

Claims can be grouped using relevant date information and summarised by reporting period.

This allows the analysis to examine changes in:

* Claim volume
* Claim value
* Average claim amount
* Severity distribution

The purpose is to identify patterns that deserve investigation rather than assume their cause.

---

## Risk-Oriented Reporting

The project uses SQL to create reporting indicators that could support further investigation.

Examples include:

* Higher-value claims
* Higher-severity claims
* Concentrations of claims
* Changes in claim frequency
* Customer-level claim activity
* Changes in claim outcomes

These are **reporting indicators**, not predictive risk models.

This repository does not claim machine-learning or predictive-modelling capability.

---

## Data Quality & Validation

Insurance reporting can be affected by incorrect joins, inconsistent statuses, duplicate records or inappropriate filtering.

The project therefore considers:

* Customer-policy relationships
* Policy-claim relationships
* Join accuracy
* Duplicate records
* Missing information
* Consistent claim statuses
* Appropriate filtering
* Correct aggregation
* KPI definitions
* Validation of calculated measures

A production insurance environment would require additional controls, governance and validation.

---

## Reporting Investigation Mindset

A useful reporting result should create the next useful question.

For example:

```text
Claim volume increased
        ↓
Which period changed?
        ↓
Which categories contributed?
        ↓
Did average claim value also change?
        ↓
Did severity distribution change?
        ↓
Did customer or policy mix change?
        ↓
Is the underlying data complete and consistent?
```

This approach helps distinguish evidence from unsupported assumptions.

---

## What This Project Demonstrates

This project provides evidence of my ability to:

* Work with PostgreSQL
* Analyse relational business data
* Join customer, policy and claims information
* Use SQL aggregation
* Use CTE-based analysis
* Calculate reporting KPIs
* Analyse claim severity
* Analyse claim values
* Examine changes over time
* Consider data quality
* Translate business questions into SQL analysis
* Communicate reporting observations without overstating what simulated data proves

---

## Project Structure

```text
Insurance-Claims-Insurance-Claims-SQL-Reporting-Project-SQL-Insights-Project
│
├── README.md
├── Read-Me.md
│
└── SQL-Insurance-Claims-Analysis
    ├── 1._Data
    ├── 2._SQL
    ├── 3._Scripts
    ├── 4._Docs
    └── Insurance_claims_postgresql_pipeline.sql
```

The repository currently contains both `README.md` and `Read-Me.md`.

The root `README.md` is the primary recruiter-facing project overview.

---

## How to Run

1. Install PostgreSQL.
2. Create a database for the project.
3. Review the files under:

```text
SQL-Insurance-Claims-Analysis
```

4. Follow the SQL and supporting scripts included in the repository.
5. Create and prepare the required tables.
6. Run the analysis queries.
7. Compare the results with the business questions and KPI definitions.

The exact execution sequence should follow the SQL and script files contained in the repository.

---

## How to Review This Project

A recruiter, hiring manager or analyst can review the project in this order:

1. Read this README.
2. Review the data structure.
3. Review the SQL preparation/analysis.
4. Identify the business questions.
5. Review the KPI logic.
6. Review the data-quality considerations.
7. Examine the resulting reporting outputs.

The central portfolio signal is:

**Insurance Business Question → SQL → KPI → Validation → Reporting Meaning**

---

## Portfolio Position

This project represents the **insurance and risk-reporting** side of my SQL portfolio.

It complements:

* **RetailMart Executive Reporting SQL Project** — retail management reporting and KPIs
* **Retail Sales Analytics ETL Data Pipeline Project** — data preparation and transformation
* **SQL Data Analytics Fundamentals for Business Reporting** — foundational SQL

Together, these projects demonstrate application of SQL across different business contexts rather than only generic SQL syntax.

---

## Career Relevance

This project forms part of my portfolio as I build practical evidence toward:

* Junior Reporting Analyst
* Reporting Analyst
* Junior Data Analyst
* Data Analyst
* SQL-focused analyst opportunities

My primary target is **Johannesburg/Gauteng**, with credible remote opportunities across South Africa as a secondary target.

The repository represents portfolio evidence of skills I am developing and does not claim professional insurance-industry employment.

---

## Limitations

This project uses simulated data.

It does not represent:

* Real insurance claims
* Real customers
* Real policies
* Production insurance reporting
* Predictive risk modelling
* Machine-learning risk scoring
* Professional insurance employment experience

Numerical findings should therefore be interpreted within the context of the simulated dataset.

---

## About

I am building practical PostgreSQL and SQL projects focused on business reporting, KPI analysis, data quality and analytical thinking.

## This project extends that work into an insurance and risk-reporting context while keeping the analysis grounded in SQL and reporting fundamentals.


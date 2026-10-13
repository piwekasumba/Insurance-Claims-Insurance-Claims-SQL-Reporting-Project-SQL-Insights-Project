# Insurance Claims Risk Analytics SQL Project

A PostgreSQL portfolio project focused on **insurance claims reporting, KPI analysis, data quality, claim severity and risk-oriented business analysis** using simulated insurance data.

The project explores how SQL can connect customer and claims records, calculate reporting measures, check data quality and turn relational data into structured business reporting.

> **Portfolio focus:** SQL | PostgreSQL | Insurance Reporting | KPI Analysis | Risk Indicators | Data Quality

---

## Why This Project Exists

Insurance reporting depends on reliable information about claims, customers, claim values, claim outcomes and changes over time.

Reporting questions may include:

- How many claims have been recorded?
- What is the total and average claim amount?
- How are claims distributed by status and severity?
- What proportion of recorded claims are approved?
- How does claim activity change over time?
- Which claim types or locations account for higher recorded claim values?
- Which patterns require further investigation?
- Can the reported measures be trusted?

This project uses PostgreSQL to practise answering these questions with simulated insurance data.

## Industry Context

This project represents the insurance and risk-reporting side of my SQL portfolio.

Insurance reporting may involve:

- Claims volume and value
- Claim status and approval activity
- Claim severity categories
- Customer-level claim activity
- Claim types and incident locations
- Time-based reporting
- Data-quality checks
- Indicators for further investigation

The focus is on SQL reporting and analytical investigation, not predictive insurance modelling.

## Project Objective

The objective is to use PostgreSQL and SQL to analyse simulated customer and claims data and develop structured reporting queries.

The intended workflow is:


Business Question
       ↓
Customer and Claims Data
       ↓
SQL Analysis
       ↓
KPI Calculation
       ↓
Data Validation
       ↓
Reporting Output
       ↓
Business Interpretation
       ↓
Further Investigation


## Tools and Technologies

- PostgreSQL
- SQL
- Relational databases
- SQL joins
- Aggregate functions
- `GROUP BY` and `ORDER BY`
- Filtering and conditional logic
- `CASE` expressions
- Common Table Expressions (CTEs)
- KPI calculations
- Data-quality checks
- Business reporting analysis

## Dataset

The project uses simulated insurance data for portfolio and learning purposes.

The sample data covers two main areas:

| Dataset   | Example fields                                                                       | Reporting purpose                                          |
|-----------|--------------------------------------------------------------------------------------|------------------------------------------------------------|
| Customers | Customer ID, age, city, province, policy start date, policy type                     | Customer-level analysis and segmentation                   |
| Claims    | Claim ID, customer ID, policy ID, claim date, claim type, claim amount, claim status | Claims reporting, status analysis and claim-value analysis |

The sample contains 20 customer records and 20 claim records.

The claims data includes fields such as incident location, incident type, police-report indicator and days to settle. Some fields may be missing, allowing data-quality checks to be explored.

The dataset does not represent real insurance customers, policies or claims.

## Business Questions

| Business question                              | SQL analysis                              | Reporting purpose                             |
|------------------------------------------------|-------------------------------------------|-----------------------------------------------|
| How many claims are recorded?                  | Count claim records                       | Understand recorded claims volume             |
| What is the total claim amount?                | Sum claim amounts                         | Measure recorded claim value                  |
| What is the average claim amount?              | Calculate average claim amount            | Compare typical claim size                    |
| How are claims distributed by status?          | Group claims by status                    | Monitor recorded claim outcomes               |
| How are claims distributed by severity?        | Group claims by derived severity category | Compare claim-value categories                |
| How does claim activity change over time?      | Group claims by date or reporting period  | Identify changes requiring investigation      |
| Which claim types have higher recorded values? | Aggregate claim amounts by claim type     | Examine the concentration of claim costs      |
| How does claim activity vary by province?      | Join customer and claims data             | Compare recorded activity geographically      |
| Which customers have multiple claims?          | Group claims by customer                  | Examine customer-level claim activity         |
| Which records require data-quality review?     | Check missing or inconsistent values      | Identify exceptions that may affect reporting |

## KPI Definition and Validation

A reporting KPI is only meaningful when its definition is clear and its underlying data has been checked.

For example, an approval-rate calculation requires clarity about:

- Which claims are included in the denominator
- Whether pending and under-review claims are included
- How approved and rejected claims are counted
- Which reporting period is being measured
- How missing or invalid records are handled
- Whether duplicate records could affect the result

Average claim amount also requires a defined population. Including all recorded claims produces a different measure from calculating the average for approved claims only.

The project treats KPI definitions, filters, joins and validation as part of the reporting process rather than as an afterthought.

**Important:** A SQL query returning a number does not, by itself, establish that the number is suitable for business reporting. The definition, data and calculation must also be checked.

## Claims Severity Analysis

### Business question

How do recorded claim counts and claim values differ across severity categories?

### SQL approach

Claim amounts can be grouped into defined severity categories using a `CASE` expression. Each category can then be analysed using:

- Claim count
- Total claim amount
- Average claim amount

The category thresholds must be documented and applied consistently across the relevant queries.

### Reporting value

This comparison can help identify categories with higher recorded claim values or concentrations of claims that may warrant further investigation.

Severity categories derived from claim amounts are reporting classifications. They do not independently establish the underlying cause of a claim or the probability of future loss.

## Claim Status and Approval Analysis

### Business question

What does the distribution of recorded claim statuses show?

### SQL approach

Claims can be grouped by status and summarised using claim counts and percentages.

An approval rate can be calculated when the numerator, denominator, eligible statuses and reporting period are explicitly defined.

### Reporting value

Status reporting can help monitor recorded claim outcomes and identify changes that warrant further questions, such as:

- Has the mix of claim statuses changed?
- Has the volume of pending claims increased?
- Are missing values affecting the calculation?
- Is the reporting period consistent across comparisons?
- Could changes in the underlying process explain the pattern?

A status distribution should not automatically be described as an approval rate. The calculation must match the stated KPI definition.

## Claim Activity Over Time

Claims can be grouped by a suitable date field and summarised by reporting period.

Possible measures include:

- Claim volume
- Total recorded claim amount
- Average claim amount
- Claim-status distribution
- Severity distribution

Missing claim dates can affect time-based reporting. Records without usable dates should be identified and handled according to the measure's documented rules.

The purpose of trend analysis is to identify changes worth investigating, not to assume their cause.

## Risk-Oriented Reporting

The project explores reporting indicators that could support further investigation, including:

- Higher-value claims
- Higher-severity categories
- Concentrations of recorded claims
- Customers with multiple claims
- Changes in claim frequency
- Changes in recorded claim outcomes

These are **risk-oriented reporting indicators**, not proof of fraud or misconduct.

The project does not claim to implement a predictive risk model, machine learning or automated risk scoring.

## Data Quality and Validation

Data-quality issues can affect claim counts, totals, averages and comparisons. A join can also produce misleading results if relationships or aggregation levels are not understood.

The project considers checks such as:

- Missing claim dates
- Missing customer or policy identifiers
- Missing claim amounts or settlement information
- Unexpected status or indicator values
- Duplicate claim identifiers or records
- Customer-to-claims join accuracy
- Appropriate filtering and aggregation
- Consistent KPI definitions
- Validation of calculated measures

The claims source table is intended to preserve the supplied source fields, including nullable fields that can be examined during validation.

A production insurance environment would require additional controls, documented business rules, access controls and formal data governance.

## Reporting Investigation Mindset

A reporting result should help identify the next useful question.

For example:


Recorded claim volume increased
             ↓
Which reporting period changed?
             ↓
Which claim types contributed?
             ↓
Did total or average claim value change?
             ↓
Did the status or severity distribution change?
             ↓
Are the customer and claims records complete?
             ↓
Which findings need further investigation?


This approach helps separate observed results from assumptions about their causes.

## What This Project Demonstrates

This project provides portfolio evidence of practice in:

- Using PostgreSQL and SQL
- Working with related customer and claims records
- Joining relational data
- Applying SQL filters and aggregate functions
- Using conditional logic and CTE-based analysis
- Calculating and interpreting reporting measures
- Analysing claim amounts and status distributions
- Examining changes across reporting periods
- Identifying potential data-quality issues
- Translating business questions into SQL analysis
- Communicating findings within the limitations of simulated data

These are project-based skills, not claims of professional insurance-industry experience.

## Project Structure


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


The structure above describes the intended organisation of the project. Review the actual repository files for the available scripts, documentation and data.

The root `README.md` is the primary recruiter-facing project overview.

## How to Run

1. Install PostgreSQL and open a PostgreSQL client such as pgAdmin.
2. Create a database for the project.
3. Review the schema and data files in `SQL-Insurance-Claims-Analysis`.
4. Create the required tables using the schema script.
5. Load the customer records before loading claims that reference those customers.
6. Review the data and run the preparation, validation and reporting scripts in their intended order.
7. Compare the query logic with the documented business questions and KPI definitions.
8. Review query outputs and investigate any exceptions before presenting numerical findings.

**Execution note:** The README documents the intended workflow. The exact run order must be confirmed against the actual SQL files, and results should only be described as verified after the scripts have been executed and checked in PostgreSQL.

## How to Review This Project

Recruiters, hiring managers and analysts can review the project in this order:

1. Read this overview.
2. Inspect the simulated data and database schema.
3. Review the SQL preparation and validation logic.
4. Examine the business questions and KPI definitions.
5. Review the reporting queries and their outputs.
6. Consider the data-quality checks and limitations.
7. Assess how the analysis connects SQL results to reporting questions.

The central portfolio workflow is:

**Insurance Business Question → SQL → KPI → Validation → Reporting Meaning**

## Portfolio Position

This project represents the insurance and risk-reporting side of my SQL portfolio.

It complements:

- **RetailMart Executive Reporting SQL Project** — retail reporting, KPI comparisons and validation.
- **Retail Sales Analytics ETL Data Pipeline Project** — data preparation, transformation and validation.
- **SQL Data Analytics Fundamentals for Business Reporting** — foundational SQL analysis.

Together, these projects show how I practise applying SQL to reporting questions across different simulated business contexts.

## Career Relevance

This project forms part of my portfolio as I build practical evidence toward entry-level roles such as:

- Junior Reporting Analyst
- Reporting Analyst
- Junior Data Analyst
- Data Analyst
- SQL-focused reporting and data-quality roles

My primary job-search focus is Johannesburg/Gauteng, with suitable remote opportunities across South Africa as a secondary target.

The project demonstrates self-directed learning and portfolio work. It does not claim professional insurance-industry employment.

## Limitations

This project uses simulated data and has a small sample size.

It does not represent:

- Real insurance claims, customers or policies
- Production insurance reporting
- A complete insurance database or full insurance lifecycle
- Predictive risk modelling or machine-learning risk scoring
- Verified findings from a live insurance business
- Professional insurance-industry employment experience

Patterns observed in this dataset should not be generalised to the insurance industry. Numerical findings should only be reported after the relevant SQL has been executed and its results validated.

## About

I am building practical PostgreSQL and SQL projects focused on business reporting, KPI analysis, data quality and analytical thinking.


This project extends that work into an insurance and risk-reporting context, with an emphasis on clear SQL logic, defined measures and careful interpretation of results.

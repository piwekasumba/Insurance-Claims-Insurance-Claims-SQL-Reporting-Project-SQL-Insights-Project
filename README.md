# Insurance Claims Risk Analytics SQL Project

A PostgreSQL project analysing simulated insurance claims data to produce reporting KPIs, investigate claim patterns and explore risk-related business questions using SQL.

The project follows a reporting workflow:

**Business Question → Data → SQL Analysis → KPI → Validation → Reporting Interpretation**

---

## Why This Project Exists

Insurance organisations need reliable information to monitor claims activity, claim costs, processing outcomes and potential risk indicators.

Reporting questions may include:

* How many claims are being submitted?
* What is the average claim amount?
* How are claims distributed by severity?
* How does claims activity change over time?
* What proportion of claims are approved?
* Where are higher claim costs concentrated?
* Which patterns may require further investigation?

This project uses simulated insurance data to explore those questions through PostgreSQL and SQL.

---

## Project Objective

The objective is to analyse related insurance records and transform them into structured reporting outputs.

The project focuses on:

* Relational data analysis
* SQL joins
* Claims reporting
* KPI calculation
* Claim severity
* Claim values
* Approval activity
* Time-based analysis
* Customer claim activity
* Risk-related indicators
* Data-quality considerations
* Reporting interpretation

---

## Industry Context

This project represents the **insurance** side of my portfolio.

Insurance reporting can involve areas such as:

* Claims volume
* Claim severity
* Claim costs
* Approval rates
* Customer claim activity
* Operational trends
* Risk indicators
* Exception investigation

The project demonstrates how SQL can be applied to an industry-specific reporting problem rather than only to generic datasets.

---

## Tools & Technologies

* PostgreSQL
* SQL
* SQL joins
* Aggregate functions
* Common Table Expressions (CTEs)
* Filtering
* Data preparation
* KPI calculations
* Reporting analysis

---

## Dataset

The project uses a simulated insurance dataset.

The main business entities include:

* Customers
* Policies
* Claims

The data is intended for learning and portfolio purposes.

It does not represent real insurance customers, policies or claims.

---

## Business Questions

| Business Question                                                 | SQL Analysis                                          | Reporting Purpose                        |
| ----------------------------------------------------------------- | ----------------------------------------------------- | ---------------------------------------- |
| Which severity categories are associated with higher claim costs? | Group claims by severity and calculate claim measures | Compare claim severity and cost          |
| How many claims fall into each severity category?                 | Count claims by severity                              | Monitor claim distribution               |
| How does claim activity change over time?                         | Aggregate claims by reporting period                  | Identify changes requiring investigation |
| What is the average claim amount?                                 | Calculate average claim value                         | Monitor typical claim size               |
| What is the claim approval rate?                                  | Compare approved claims with total claims             | Monitor claims-processing performance    |
| Which customers have significant claim activity?                  | Aggregate claims by customer                          | Examine customer-level patterns          |
| How can customer, policy and claim information be combined?       | Join related tables                                   | Produce more complete reporting outputs  |

---

## Reporting Workflow

```text
Business Question
        ↓
Identify Required Data
        ↓
Join Customer / Policy / Claim Data
        ↓
Define KPI
        ↓
Calculate Measure
        ↓
Validate Result
        ↓
Produce Reporting Output
        ↓
Interpret Pattern
        ↓
Identify Further Investigation
```

This workflow keeps the analysis focused on the reporting question rather than treating SQL output as the final answer.

---

## SQL Analysis

### Claims Summary

Provides an overview of claims activity in the dataset.

### Claim Severity Analysis

Groups claims by severity to compare claim counts and values.

### Claim Value Analysis

Examines claim amounts using aggregate measures.

### Claim Approval Analysis

Calculates approval-related reporting measures.

### Claims Over Time

Groups claims using relevant date information to identify changes in activity.

### Customer Claim Activity

Connects customers with their claim activity for customer-level analysis.

### Risk-Related Indicators

Uses available claim characteristics to identify categories or records that may warrant additional investigation.

These indicators are analytical signals, not formal insurance risk scores.

---

## Business Question → SQL Analysis → Reporting Meaning

### 1. Claim Severity

**Business question**

Which claim severity levels are associated with higher claim costs?

**SQL approach**

Claims are grouped by severity and analysed using measures such as claim count and claim value.

**Reporting output**

A comparison of claim activity and claim costs across severity categories.

**Reporting meaning**

The comparison can help identify where higher claim costs are concentrated and where further investigation may be useful.

---

### 2. Claim Approval Rate

**Business question**

What proportion of claims are approved?

**SQL approach**

Claim outcomes are grouped and used to calculate an approval measure.

**Reporting output**

An approval-rate view of claims activity.

**Reporting meaning**

The measure can help monitor claim outcomes and identify changes over time.

---

### 3. Average Claim Amount

**Business question**

What is the average value of an insurance claim?

**SQL approach**

Claim amounts are aggregated to calculate the average claim value.

**Reporting output**

A consistent measure of average claim size.

**Reporting meaning**

Average claim value provides context when monitoring claim costs and comparing categories or periods.

---

### 4. Claim Activity Over Time

**Business question**

How does claim activity change over time?

**SQL approach**

Claims are grouped using relevant date information and summarised by reporting period.

**Reporting output**

A time-based view of claims activity.

**Reporting meaning**

Changes can identify periods that deserve further investigation.

---

### 5. Risk-Related Indicators

**Business question**

Which claim characteristics may require additional monitoring?

**SQL approach**

Available claim characteristics such as severity and claim value are analysed using SQL conditions and aggregation.

**Reporting output**

Structured indicators for comparing claim activity.

**Reporting meaning**

The indicators can help prioritise areas for investigation without presenting them as formal underwriting or actuarial conclusions.

---

## Data Quality & Validation

Insurance reporting requires careful treatment of relationships between customers, policies and claims.

This project considers:

* Correct relationships between tables
* Appropriate SQL joins
* Consistent claim and policy records
* Accurate aggregation
* Missing or inconsistent values
* Date consistency
* KPI definitions
* Validation of calculated measures
* Avoiding duplicate records caused by incorrect joins

A reporting result should be checked before being treated as a business conclusion.

---

## Reconciliation & Investigation

When different analyses produce different claim totals or values, the difference should be investigated rather than ignored.

Potential checks include:

* Reporting dates
* Claim status definitions
* Severity definitions
* Source tables
* Join conditions
* Duplicate records
* Missing records
* Aggregation logic
* Inclusion/exclusion rules
* Data-quality issues

The purpose of reconciliation is to understand **where the difference came from and why it exists**.

---

## Reporting Value

The project demonstrates how related insurance records can be transformed into useful reporting information.

The process is:

1. Define the business question.
2. Identify the required data.
3. Join the relevant tables.
4. Define the measure.
5. Calculate the KPI.
6. Validate the result.
7. Interpret the output.
8. Identify questions requiring further investigation.

---

## Key Skills Demonstrated

* PostgreSQL
* SQL
* Relational data analysis
* SQL joins
* Aggregation
* CTEs
* KPI calculation
* Claims analysis
* Data-quality awareness
* Reporting validation
* Risk-oriented business questions
* Structured analytical thinking

---

## Portfolio Role Alignment

This project provides industry-specific evidence for my broader SQL reporting portfolio.

It demonstrates how PostgreSQL can be applied to an insurance reporting context while remaining explicit that the data is simulated.

The project supports my preparation for entry-level opportunities such as:

* Junior Reporting Analyst
* Reporting Analyst
* Junior Data Analyst
* Data Analyst
* SQL-focused analyst roles

with a primary focus on Johannesburg/Gauteng and credible remote opportunities across South Africa.

It does not claim professional insurance, actuarial or enterprise analytics experience.

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

1. Install PostgreSQL.
2. Create a database for the project.
3. Review the files under:

```text
SQL-Insurance-Claims-Analysis
```

4. Review the available data and SQL stages.
5. Follow the SQL/scripts in their intended sequence.
6. Run the analysis queries.
7. Compare the outputs with the business questions and KPI definitions.

The exact execution order should follow the SQL and script files contained in the repository.

---

## How to Review This Project

A reviewer can start with:

1. `README.md` — business context and reporting workflow
2. `1._Data` — available project data
3. `2._SQL` — SQL analysis
4. `3._Scripts` — supporting scripts
5. `4._Docs` — supporting documentation

The key evidence is how the SQL connects insurance data to defined reporting questions.

---

## Limitations

This project uses simulated data.

It is not:

* A real insurance claims system
* A production risk-management system
* An actuarial model
* A formal underwriting model
* A real customer database
* Professional insurance employment experience

Risk-related indicators are analytical portfolio examples and should not be interpreted as production insurance decisions.

---

## What I Am Building Through This Project

I am strengthening my ability to use PostgreSQL and SQL to investigate business questions where accuracy, definitions, data relationships and validation matter.

The central workflow is:

**Business Question → Data → SQL → Validation → Reporting Meaning**

---

## About

I am building practical SQL and PostgreSQL projects focused on business reporting, KPI analysis, data quality and industry-specific business questions.

This repository forms part of that portfolio and demonstrates my application of SQL to a simulated insurance reporting environment.


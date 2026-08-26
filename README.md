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

The reporting analysis is designed to answer practical insurance management questions:

| Business Question                                                           | SQL Analysis                               | Reporting Purpose |
|-----------------------------------------------------------------------------|--------------------------------------------|---|
| Which claim severity levels are associated with the highest claim costs?    | Analyse claim amounts by severity category | Compare claim severity, understand where higher claim costs are concentrated|
| How many claims fall into each severity category?                           | Count claims by severity                   | Monitor the distribution of claims across severity levels                   |
| How does claim activity change over time?                                   | Aggregate claims by relevant time period   | Identify changes in claims activity that may require further investigation  |
| What is the average claim amount?                                           | Calculate average claim value              | Monitor the typical financial size of claims                                |
| What is the claim approval rate?                                            | Compare approved claims with total claims  | Monitor an important claims-processing KPI                                  |
| Which reporting KPIs are useful for monitoring claims activity?             | Calculate and compare claims measures      | Support consistent management reporting                                     |
| How can related insurance tables be combined to answer reporting questions? | Join customer, policy and claims data      | Demonstrate relational data transformed into reporting information          |

The purpose is not only to produce SQL query results, but to turn those results into information that could support claims monitoring, performance review and further business investigation.
---
## SQL Analysis

The project uses SQL to join, aggregate and analyse the insurance data.

The analysis includes areas such as:

- Claims summaries
- Claim severity analysis
- Claim value analysis
- Approval metrics
- Claim frequency
- High-risk claim indicators
- Customer claim activity
- Time-based claim analysis

The project uses SQL joins, aggregation and KPI calculations to turn related insurance records into structured reporting outputs.

The reporting workflow follows:

- **Business Question → SQL Analysis → Result → Reporting Interpretation**

For example, a claim-severity analysis does more than group claims into categories. The resulting comparison can help identify differences in claim activity and claim costs across severity levels, providing an evidence base for further investigation.

Similarly, approval, claim-frequency, customer-activity and time-based analysis can provide different perspectives for monitoring claims performance.

The SQL results remain the evidence base. Business interpretations should be made from the actual results rather than assumptions about the dataset.
---
## Key Findings

The SQL analysis produces reporting evidence across claim volume, claim severity, claim value, approval activity, customer activity and changes over time.

The findings should be interpreted directly from the SQL results. Examples of the reporting questions supported by the analysis include:

- Comparing claim activity across severity categories
- Reviewing differences in claim values
- Monitoring the average claim amount
- Reviewing claim approval performance
- Identifying patterns in claim frequency
- Examining customer claim activity
- Monitoring changes in claims activity over time

These findings demonstrate how SQL analysis can turn related insurance records into structured reporting information.

Specific numerical findings are intentionally not stated here unless they can be verified directly from the project's SQL results.
---
## Key Findings

The analysis is intended to identify differences in claim activity, claim severity and claim costs.

The main finding should come from the actual SQL results rather than assumptions about the dataset.

This README therefore avoids adding unsupported numerical claims and keeps the findings tied to the analysis contained in the repository.
---
## Business / Reporting Insights

The project demonstrates a reporting workflow where SQL analysis is used to answer business questions and support claims monitoring.

Examples include:

- Monitoring claim volumes
- Comparing claim severity
- Reviewing claim costs
- Monitoring approval measures
- Examining customer claim activity
- Identifying changes in claims activity over time
- Highlighting areas that may require further investigation

The business meaning depends on the actual SQL result.

For example:

**Business question:** Which claim severity levels are associated with the highest claim costs?

**SQL analysis:** Group claims by severity and calculate the relevant claim-value measures.

**Result:** The query produces a comparison of claim activity and claim values across severity categories.

**Reporting interpretation:** The comparison can help reporting users understand where higher claim costs are concentrated and where further investigation may be appropriate.

This approach demonstrates that SQL reporting is not simply about producing query outputs. The objective is to make business performance and activity easier to understand, compare and monitor.
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

# Insurance Claims Risk Analytics SQL Project

A PostgreSQL portfolio project focused on **insurance claims reporting, KPI analysis, claim severity and risk-oriented data analysis** using simulated insurance data.

The project demonstrates how SQL can be used to connect customer, policy and claims information and turn transactional records into structured reporting evidence.

> **Portfolio focus:** SQL | PostgreSQL | Claims Reporting | KPI Analysis | Risk Indicators | Data Quality

---

## Business Context

Insurance organisations need reliable information to monitor claims activity, claim costs and changes in risk-related indicators.

A reporting analyst may need to answer questions such as:

* How many claims are being received?
* What is the average claim amount?
* How does claim severity vary?
* What proportion of claims are approved?
* Are claim volumes changing over time?
* Which categories have higher claim values?
* What patterns require further investigation?

This project uses simulated insurance data to practise answering these types of questions with PostgreSQL and SQL.

---

## Project Objective

The objective is to analyse related insurance data and produce structured reporting outputs.

The project follows:

**Business Question → Data → SQL Analysis → KPI → Validation → Reporting Interpretation**

The emphasis is on understanding what the SQL result can tell a reporting user and what additional investigation may be required.

---

## Industry Context

Insurance is a useful reporting environment because business decisions can depend on consistent measures of:

* Claims volume
* Claim value
* Claim severity
* Approval activity
* Customer claim activity
* Time-based trends
* Risk indicators

This project intentionally focuses on those reporting concepts rather than presenting the simulated results as real insurance performance.

---

## Tools & Technologies

* PostgreSQL
* SQL
* Relational databases
* SQL joins
* Aggregate functions
* Common Table Expressions (CTEs)
* Filtering
* KPI calculations
* Data preparation
* Business reporting analysis

---

## Dataset

The project uses simulated insurance data covering:

* Customers
* Policies
* Claims

The data is created for portfolio and learning purposes and does not represent real customers, policies or claims.

---

## Reporting Questions

| Business Question                             | SQL Analysis                               | Reporting Purpose                        |
| --------------------------------------------- | ------------------------------------------ | ---------------------------------------- |
| What is the total number of claims?           | Count claims                               | Monitor claims volume                    |
| What is the average claim amount?             | Calculate average claim value              | Monitor typical claim size               |
| How are claims distributed by severity?       | Group claims by severity                   | Compare claim categories                 |
| What is the claim approval rate?              | Compare approved claims with total claims  | Monitor claims outcomes                  |
| How does claim activity change over time?     | Aggregate claims by date/period            | Identify changes requiring investigation |
| Which categories have higher claim values?    | Aggregate claim amounts                    | Identify concentration of claim costs    |
| Which customers have higher claim activity?   | Join customers and claims                  | Compare customer-level activity          |
| Which indicators may require risk monitoring? | Combine claim characteristics and measures | Support further investigation            |

---

## SQL Analysis

The project includes SQL analysis covering:

* Claims summaries
* Claim severity
* Claim value
* Average claim amount
* Approval metrics
* Claim frequency
* Customer claim activity
* Time-based claims analysis
* Risk-oriented indicators

The analysis uses joins, aggregation, filtering and CTE-based logic where appropriate.

---

## KPI Thinking

Insurance reporting depends heavily on clearly defined measures.

For example, an approval rate requires a clear definition of:

* What counts as a claim?
* Which claim statuses are included?
* What is the denominator?
* How are incomplete records treated?
* Which reporting period is being measured?

Similarly, average claim amount requires clarity around:

* Which claims are included?
* Whether rejected claims are included
* Whether duplicate records exist
* Which amount field represents the reporting measure

The project therefore treats **definition and validation as part of KPI reporting**.

---

## Claims Severity Analysis

### Business Question

Which claim severity categories are associated with higher claim costs?

### SQL Approach

Claims are grouped by severity and analysed using measures such as:

* Claim count
* Claim amount
* Average claim amount

### Reporting Value

The resulting comparison can help a reporting user understand how claims activity differs between severity categories.

The output should not automatically be treated as a causal explanation. It is evidence for further investigation.

---

## Approval Rate

### Business Question

What proportion of claims are approved?

### SQL Approach

Claim outcomes are grouped and used to calculate an approval measure.

### Reporting Value

The result provides a consistent reporting view of claim outcomes and can be monitored over time.

If the approval rate changes materially, further questions could include:

* Did claim mix change?
* Did severity distribution change?
* Did policy types change?
* Did the underlying claims process change?
* Could a data-quality issue affect the result?

---

## Claim Activity Over Time

### Business Question

How does claims activity change over time?

Claims are grouped using the relevant date field and summarised by reporting period.

This allows changes in:

* Claim volume
* Claim value
* Average claim amount
* Severity distribution

to be investigated.

The purpose is to identify patterns rather than assume their cause.

---

## Risk-Oriented Reporting

The project also demonstrates how SQL can be used to create indicators for further risk investigation.

Examples include:

* Higher-value claims
* Higher-severity claims
* Concentrations of claims
* Changes in claim frequency
* Customer-level claim activity
* Changes in claim outcomes

These are treated as **reporting indicators**, not predictive risk models.

No machine-learning or predictive modelling claim is made by this project.

---

## Data Quality & Validation

Insurance reporting can be sensitive to incorrect joins, inconsistent statuses and duplicated records.

This project considers:

* Customer-policy relationships
* Policy-claim relationships
* Correct joins
* Duplicate records
* Missing information
* Consistent claim statuses
* Appropriate filtering
* Correct aggregation
* KPI definitions
* Validation of calculated measures

A production environment would require additional controls, governance and validation appropriate to the organisation.

---

## Reporting Investigation Mindset

A reporting result should create the next useful question.

For example:

**Claim volume increased**

→ Which period changed?

→ Which claim categories contributed?

→ Did average claim value also change?

→ Did severity distribution change?

→ Did the customer or policy mix change?

→ Is the underlying data complete and consistent?

This approach helps distinguish **reporting evidence from unsupported assumptions**.

---

## Key Portfolio Evidence

This project demonstrates practical evidence of:

* PostgreSQL
* SQL joins
* Aggregation
* CTEs
* KPI calculations
* Claims reporting
* Risk-oriented analysis
* Data-quality awareness
* Business-question translation
* Structured reporting analysis

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

---

## How to Run

1. Install PostgreSQL.
2. Create a database for the project.
3. Review the files under `SQL-Insurance-Claims-Analysis`.
4. Follow the SQL/scripts included in the repository.
5. Create and prepare the required tables.
6. Run the analysis queries.
7. Compare the results with the reporting questions and KPI definitions.

The exact execution order should follow the SQL and script files contained in the repository.

---

## What This Project Demonstrates

I am using this project to demonstrate that I can:

* Work with PostgreSQL
* Analyse relational business data
* Join customer, policy and claims information
* Calculate reporting KPIs
* Analyse claim severity and claim values
* Explore changes over time
* Think about data quality
* Translate business questions into SQL analysis
* Communicate reporting observations without overstating what the data proves

---

## Career Relevance

This project forms part of my portfolio as I build practical evidence toward **Junior / Entry-Level Reporting Analyst opportunities in Johannesburg, Gauteng and credible remote opportunities across South Africa**.

It complements my retail reporting project by showing that the same SQL and reporting principles can be applied to a different business domain.

---

## Portfolio Position

This project represents the **insurance and risk-reporting** side of my portfolio.

It complements:

* **RetailMart Executive Reporting SQL Project** — management reporting and retail KPIs
* **Retail Sales Analytics ETL Data Pipeline Project** — data preparation and transformation
* **SQL Data Analytics Fundamentals for Business Reporting** — foundational SQL

Together, the projects demonstrate an ability to apply SQL across different business contexts rather than only discussing generic SQL syntax.

---

## About

I am building practical SQL projects focused on PostgreSQL, business reporting, KPI analysis and data quality as I work toward an entry-level Reporting Analyst career.

My current focus is developing strong SQL fundamentals and learning how to connect technical analysis with practical business reporting questions.


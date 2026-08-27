# Customer Data Warehouse and Analytics Project

This project demonstrates the design and developement of a SQL-based customer data warehouse and analytics solution, from centralizing and structuring business data to analyzing customer churn patterns.

## Project Overview

This project involves:

1. Data Architecture: Designing a Modern Data Warehouse Using Inmon Architecture.
2. ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
3. Data Modeling: Developing fact and dimension tables optimized for analytical queries.
4. Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

## Data Architecture

The data architecture for this project follows Inmon Architecture, Stage, Enterprise Data Warehouse, and Data Mart layers:
1. Stage Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. Enterprise Data Warehouse Layer: Models the data using 3NF. Builds a new integrated data model from the multiple sources. This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. Data Mart Layer: Takes small subsets of a data warehouse and models them into topic-specific star schemas, a data mart delivers business-ready data optimized specifically for targeted reporting and analytics.

## Project Requirements

### Building the Data Warehouse (Data Engineering)

Objective

Develop a modern data warehouse using SQL Server to consolidate customer data, enabling analytical reporting and informed decision-making.

Specifications

- Data Sources: Import data from source system (Excel) provided as CSV files.
- Data Quality: Cleanse and resolve data quality issues prior to analysis.
- Scope: Focus on the entire dataset; historization of data is required.
- Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

For more details, refer to [SQL Customer Data Warehouse](https://github.com/marthag0311/Projects/tree/main/Data%20Engineer%20Projects/SQL%20Customer%20Data%20Warehouse%20-%20Kimball%20Architecture).

### BI: Analytics & Reporting (Data Analysis)

Objective

Develop SQL-based analytics and a Power BI dashboard to deliver detailed insights into customer churn patterns: [Customer Churn Analysis Power BI Dashboard](https://github.com/marthag0311/Projects/tree/main/Data%20Analysis%20Projects/Customer%20Churn%20Analysis%20Power%20BI%20Dashboard) and [Advanced SQL Customer Churn Analytics](https://github.com/marthag0311/Projects/tree/main/Data%20Analysis%20Projects/Advanced%20SQL%20Customer%20Churn%20Analytics).

![Customer Churn Analysis](https://github.com/marthag0311/Projects/blob/main/Data%20Analysis%20Projects/Customer%20Churn%20Analysis%20Power%20BI%20Dashboard/dashboard/Customer%20Churn%20Analysis.png)

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## Repository Structure

...

Important Links & Tools:

- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads): Lightweight server for hosting SQL database.
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/install/install?view=sql-server-ver16): GUI for managing and interacting with databases.
- [Git Repository](https://github.com/): Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- [DrawIO](https://www.drawio.com/): Design data arhitecute, models, flows, and diagram.
- [Notion](https://app.notion.com/p/Steps-Data-Warehouse-Project-36b62eb92c9380a3ab13c577cb90f6aa?source=copy_link): Structure project steps, phases, and tasks.

- ## About Me

Hi there! I'm Martha Geoffrey Kabakaki. I’m an IT professional!

Let's stay in touch! Feel free to connect with me on the following platforms: [LinkedIn](https://www.linkedin.com/in/martha-geoffrey/)

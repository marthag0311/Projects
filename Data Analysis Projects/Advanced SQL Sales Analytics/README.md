# Data Warehouse and Analytics Project

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights.

## Project Overview

This project involves: 
1. Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
2. ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
3. Data Modeling: Developing fact and dimension tables optimized for analytical queries.
4. Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

## Data Architecture
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers: 

![Data Warehouse Architecture](https://github.com/marthag0311/Projects/blob/main/Data%20Engineer%20Projects/Sales%20Data%20Warehouse/docs/data_warehouse_architecture.png)

1. Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.

## Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications

- **Data Sources**: Import data from source system (Excel) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine data into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the entire dataset; historization of data is required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

For more details, refer to [Sales Data Warehouse](https://github.com/marthag0311/Projects/tree/main/Data%20Engineer%20Projects/Sales%20Data%20Warehouse)

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:

- Service Performance
- Expense Trends
- Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## Repository Structure 
...

Important Links & Tools:
- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads): Lightweight server for hosting your SQL database.
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/install/install?view=sql-server-ver16): GUI for managing and interacting with databases.
- [Git Repository](https://github.com/): Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- [DrawIO](https://www.drawio.com/): Design data arhitecute, models, flows, and diagram.
- Notion: Structure project steps, phases, and tasks.

## 🌟 About Me
Hi there! I'm Martha Geoffrey Kabakaki. I’m an IT professional!

Let's stay in touch! Feel free to connect with me on the following platforms:
- [LinkedIn](https://www.linkedin.com/in/martha-geoffrey/)

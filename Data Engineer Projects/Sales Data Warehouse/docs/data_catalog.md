# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.

### 1. gold.dim_employees
- Purpose: Stores employee details
- Columns:


| Column Name       | Data Type    | Description |
| :---------------- | :----------- | :---------- |
| employee_key      | INT          | Surrogate key uniquely identifying eache employee record in the dimesion table            | 
| employee_name     | NVARCHAR(50) |             |
| employee_position | NVARCHAR(50) |             |
| employee_phone1   | NVARCHAR(20) |             |
| employee_phone2   | NVARCHAR(20) |             |
| employee_gender   | NVARCHAR(20) |             |


### 2. gold.dim_date
- Purpose: Stores date details
- Columns:


| Column Name  | Data Type | Description |
| :----------- | :-------  | :---------- |
| date_key     | INT       |             | 
| date         | DATE      |             |
| year         | INT       |             |
| month        | INT       |             |
| month_name   | NVARCHAR  |             |
| quarter      | INT       |             |
| day_of_month | INT       |             |
| weekday_name | NVARCHAR  |             |
| day_type     | NVARCHAR  |             |


### 2. gold.fact_expenses
- Purpose: Stores expense data for analytical purposes
- Columns:


| Column Name      | Data Type      | Description |
| :--------------- | :------------- | :---------- |
| expense_key      | INT            |             | 
| expense_date     | DATE           |             |
| expense_type     | NVARCHAR(50)   |             |
| expense_category | NVARCHAR(50)   |             |
| expense_amount   | DECIMAL(10, 2) |             |


### 2. gold.fact_salaries
- Purpose: Stores salary data for analytical purposes
- Columns:


| Column Name  | Data Type      | Description |
| :----------- | :------------- | :---------- |
| salary_key   | INT            |             |
| employee_key | INT            |             |
| salary_date  | DATE           |             |
| salary       | DECIMAL(10, 2) |             |


### 2. gold.fact_sales
- Purpose: Stores transactional sales data for analytical purposes
- Columns:


| Column Name  | Data Type      | Description |
| :----------- | :------------- | :---------- |
| sale_key     | INT            |             |
| employee_key | INT            |             | 
| sale_date    | DATE           |             |
| sale_service | NVARCHAR(200)  |             |
| sales        | DECIMAL(10, 2) |             |


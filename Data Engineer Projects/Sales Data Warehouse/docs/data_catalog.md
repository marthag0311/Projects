# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.

### 1. gold.dim_employees
- Purpose: Stores employee details
- Columns:


| Column Name       | Data Type    | Description                                                                              |
| :---------------- | :----------- | :--------------------------------------------------------------------------------------- |
| employee_key      | INT          | Surrogate key uniquely identifying eache employee record in the employee dimesion table. | 
| employee_name     | NVARCHAR(50) | The employee's name.                                                                     |
| employee_position | NVARCHAR(50) | The employee's position.                                                                 |
| employee_phone1   | NVARCHAR(20) | The employee's phone number.                                                             |
| employee_phone2   | NVARCHAR(20) | The employee's phone number.                                                             |
| employee_gender   | NVARCHAR(20) | The employee's gender.                                                                   |


### 2. gold.dim_date
- Purpose: Stores date details
- Columns:


| Column Name  | Data Type | Description                                                                      |
| :----------- | :-------  | :------------------------------------------------------------------------------- |
| date_key     | INT       | Surrogate key uniquely identifying each date record in the date dimension table. | 
| date         | DATE      | The date.                                                                        |
| year         | INT       | The year of the date.                                                            |
| month        | INT       | The month of the date.                                                           |
| month_name   | NVARCHAR  | The month name of the date.                                                      |
| quarter      | INT       | The quarter of the date.                                                         |
| day_of_month | INT       | The day of month of the date.                                                    |
| weekday_name | NVARCHAR  | The weekday name of the date.                                                    |
| day_type     | NVARCHAR  | The day type of the date.                                                        |


### 2. gold.fact_expenses
- Purpose: Stores expense data for analytical purposes
- Columns:


| Column Name         | Data Type      | Description                                                                       |
| :------------------ | :------------- | :-------------------------------------------------------------------------------- |
| expense_key         | INT            | Surrogate key uniquely identifying each expense record in the expense fact table. | 
| expense_date        | DATE           | The date when the expense was incurred.                                           |
| expense_category    | NVARCHAR(50)   | The category of the expense.                                                      |
| expense_description | NVARCHAR(50)   | The description of the expense                                                    |
| expense_amount      | DECIMAL(10, 2) | The value of the expense                                                          |


### 2. gold.fact_wages
- Purpose: Stores wage data for analytical purposes
- Columns:


| Column Name   | Data Type      | Description                                                                     |
| :------------ | :------------- | :------------------------------------------------------------------------------ |
| wage_key      | INT            | Surrogate key uniquely identifying each salary record in the salary fact table. |
| employee_key  | INT            | Surrogate key linking salary to the employee dimension table.                   |
| wage_date     | DATE           | The date when the salary was given to the employee.                             |
| wage_amount   | DECIMAL(10, 2) | The value of the salary.                                                        |


### 2. gold.fact_sales
- Purpose: Stores transactional sales data for analytical purposes
- Columns:


| Column Name  | Data Type      | Description                                                                 |
| :----------- | :------------- | :-------------------------------------------------------------------------- |
| order_key    | INT            | Surrogate key uniquely identifying each sle record in the sala fact table. |
| employee_key | INT            | Surrogate key linking the order to the.                                     | 
| order_date   | DATE           | The date when the order was placed.                                         |
| service      | NVARCHAR(200)  | The service that was given.                                                 |
| sales_amount | DECIMAL(10, 2) | The total monetary value of the sale.                                       |


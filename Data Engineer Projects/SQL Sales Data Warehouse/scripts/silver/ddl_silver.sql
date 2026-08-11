/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID ('silver.employees', 'U') IS NOT NULL
	DROP TABLE silver.employees;
CREATE TABLE silver.employees (
[employee_key] INT,
[employee] NVARCHAR(50), 
[employee_position] NVARCHAR(50),
[employee_phone1] NVARCHAR(20),
[employee_phone2] NVARCHAR(20),
[employee_gender] NVARCHAR(20),
[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.wages', 'U') IS NOT NULL
	DROP TABLE silver.wages;
CREATE TABLE silver.wages (
[wage_key] INT,
[wage_date] DATE,
[employee_key] INT, 
[wage] DECIMAL(10,2),
[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.expenses', 'U') IS NOT NULL
	DROP TABLE silver.expenses;
CREATE TABLE silver.expenses (
[expense_key] INT,
[expense_date] DATE,
[expense_category] NVARCHAR(50), 
[expense_subcategory] NVARCHAR(50), 
[expense_name] NVARCHAR(50), 
[expense_amount] DECIMAL(10,2),
[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.sales', 'U') IS NOT NULL
	DROP TABLE silver.sales;
CREATE TABLE silver.sales (
[sale_key] INT,
[sale_date] DATE,
[sale_service] NVARCHAR(200), 
[sales] DECIMAL(10,2),
[employee_key] INT,
[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.mapping', 'U') IS NOT NULL
	DROP TABLE silver.mapping;
CREATE TABLE silver.mapping (
old_value VARCHAR(100) PRIMARY KEY,
new_value VARCHAR(100) NOT NULL
);
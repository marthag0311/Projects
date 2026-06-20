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

IF OBJECT_ID ('silver.salaries', 'U') IS NOT NULL
	DROP TABLE silver.salaries;
CREATE TABLE silver.salaries (
[salary_key] INT,
[salary_date] DATE,
[employee_key] NVARCHAR(50), 
[salary] DECIMAL(10,2),
[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.expenses', 'U') IS NOT NULL
	DROP TABLE silver.expenses;
CREATE TABLE silver.expenses (
[expense_key] INT,
[expense_date] DATE,
[expense_type] NVARCHAR(50), 
[expense_category] NVARCHAR(50), 
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
[employee_key] NVARCHAR(50),
[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);
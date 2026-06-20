/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID ('bronze.employees', 'U') IS NOT NULL
	DROP TABLE bronze.employees;
CREATE TABLE bronze.employees (
[employee_key] INT,
[employee] NVARCHAR(50), 
[employee_position] NVARCHAR(50),
[employee_phone1] NVARCHAR(20),
[employee_phone2] NVARCHAR(20),
[employee_gender] NVARCHAR(20)
);

IF OBJECT_ID ('bronze.salaries', 'U') IS NOT NULL
	DROP TABLE bronze.salaries;
CREATE TABLE bronze.salaries (
[salary_key] INT,
[salary_date] DATE,
[employee_key] NVARCHAR(50), 
[salary] DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.expenses', 'U') IS NOT NULL
	DROP TABLE bronze.expenses;
CREATE TABLE bronze.expenses (
[expense_key] INT,
[expense_date] DATE,
[expense_type] NVARCHAR(50), 
[expense_category] NVARCHAR(50), 
[expense_amount] DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.sales', 'U') IS NOT NULL
	DROP TABLE bronze.sales;
CREATE TABLE bronze.sales (
[sale_key] INT,
[sale_date] DATE,
[sale_service] NVARCHAR(200), 
[sales] DECIMAL(10,2),
[employee_key] NVARCHAR(50)
);
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
[employee] NVARCHAR(50), 
[employee_position] NVARCHAR(50),
[employee_phone1] NVARCHAR(20),
[employee_phone2] NVARCHAR(20)
);

IF OBJECT_ID ('bronze.salaries', 'U') IS NOT NULL
	DROP TABLE bronze.salaries;
CREATE TABLE bronze.salaries (
[salary_date] DATETIME,
[salary_employee] NVARCHAR(50), 
[salary] DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.expenses', 'U') IS NOT NULL
	DROP TABLE bronze.expenses;
CREATE TABLE bronze.expenses (
[expense_date] DATETIME,
[expense_type] NVARCHAR(50), 
[expense_category] NVARCHAR(50), 
[expense_amount] DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.sales', 'U') IS NOT NULL
	DROP TABLE bronze.sales;
CREATE TABLE bronze.sales (
[sale_date] DATETIME,
[sale_service] NVARCHAR(200), 
[sale_price] DECIMAL(10,2)
);

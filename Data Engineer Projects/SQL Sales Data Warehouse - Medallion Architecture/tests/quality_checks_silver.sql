/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.employees'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    employee_key,
    COUNT(*) 
FROM silver.employees
GROUP BY employee_key
HAVING COUNT(*) > 1 OR employee_key IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
-- employee
SELECT 
    employee
FROM silver.employees
WHERE employee != TRIM(employee);

-- employee_position
SELECT 
    employee_position 
FROM silver.employees
WHERE employee_position != TRIM(employee_position);

-- employee_gender
SELECT 
    employee_gender 
FROM silver.employees
WHERE employee_gender != TRIM(employee_gender);

-- Data Standardization & Consistency
SELECT DISTINCT 
    employee_gender 
FROM silver.employees;

-- ====================================================================
-- Checking 'silver.expenses'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    expense_key,
    COUNT(*) 
FROM silver.expenses
GROUP BY expense_key
HAVING COUNT(*) > 1 OR expense_key IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
-- expense_type
SELECT 
    expense_type 
FROM silver.expenses
WHERE expense_type != TRIM(expense_type);

-- expense_category
SELECT 
    expense_category 
FROM silver.expenses
WHERE expense_category != TRIM(expense_category);

-- Check for NULLs or Negative Values in Cost
-- Expectation: No Results
SELECT 
    expense_amount 
FROM silver.expenses
WHERE expense_amount  < 0 OR expense_amount  IS NULL;

-- Data Standardization & Consistency
-- expense_type
SELECT DISTINCT 
    expense_type 
FROM silver.expenses;

-- expense_category
SELECT DISTINCT 
    expense_category 
FROM silver.expenses;

-- ====================================================================
-- Checking 'silver.salaries'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    salary_key,
    COUNT(*) 
FROM silver.salaries
GROUP BY salary_key
HAVING COUNT(*) > 1 OR salary_key IS NULL;

-- ====================================================================
-- Checking 'silver.sales'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    sale_key,
    COUNT(*) 
FROM silver.sales
GROUP BY sale_key
HAVING COUNT(*) > 1 OR sale_key IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
-- expense_type
SELECT 
    sale_service 
FROM silver.sales
WHERE sale_service != TRIM(sale_service);
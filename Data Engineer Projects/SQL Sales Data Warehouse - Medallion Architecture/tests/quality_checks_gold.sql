/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_employees'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    employee_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_employees
GROUP BY employee_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_date'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    date_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_date
GROUP BY date_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_expenses'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_expenses e
LEFT JOIN gold.dim_date d
ON d.[date] = e.expense_date
WHERE d.[date] IS NULL 

-- ====================================================================
-- Checking 'gold.fact_salaries'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_salaries s
LEFT JOIN gold.dim_employees e
ON e.employee_key = s.employee_key
WHERE e.employee_key IS NULL 

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales s
LEFT JOIN gold.dim_employees e
ON e.employee_key = s.employee_key
WHERE e.employee_key IS NULL  
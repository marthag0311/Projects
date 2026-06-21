/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_employees
-- =============================================================================
IF OBJECT_ID('gold.dim_employees', 'V') IS NOT NULL
    DROP VIEW gold.dim_employees;
GO

CREATE VIEW gold.dim_employees AS 
SELECT 
employee_key, -- surrofate key
employee AS employee_name,
employee_position,
employee_phone1,
employee_phone2,
employee_gender
FROM silver.employees emp
GO

-- =============================================================================
-- Create Dimension: gold.dim_date
-- =============================================================================
IF OBJECT_ID('gold.dim_date', 'V') IS NOT NULL
    DROP VIEW gold.dim_date;
GO

CREATE VIEW gold.dim_date AS
WITH date_range AS
(
    SELECT
        CAST ('2026-01-01' AS DATE) AS [start_date],
        CAST(GETDATE() AS DATE) AS [end_date]
),
Numbers AS
(
    SELECT TOP (50000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS number
    FROM sys.objects so
    CROSS JOIN sys.objects 
)
SELECT
    YEAR(DATEADD(DAY, number, dr.[start_date])) * 10000 +
    MONTH(DATEADD(DAY, number, dr.[start_date])) * 100 +
    DAY(DATEADD(DAY, number, dr.[start_date])) AS date_key,  -- Surrogate date_key (YYYYMMDD)
    CAST(DATEADD(DAY, number, dr.[start_date]) AS DATE) AS [date],
    YEAR(DATEADD(DAY, number, dr.[start_date])) AS [year],
    MONTH(DATEADD(DAY, number, dr.[start_date])) AS [month],
    DATENAME(MONTH, DATEADD(DAY, number, dr.[start_date])) AS month_name,
    DATEPART(QUARTER, DATEADD(DAY, number, dr.[start_date])) AS [quarter],
    DAY(DATEADD(DAY, number, dr.[start_date])) AS day_of_month,
    DATENAME(WEEKDAY, DATEADD(DAY, number, dr.[start_date])) AS weekday_name,
    CASE 
        WHEN DATENAME(WEEKDAY, DATEADD(DAY, number, dr.[start_date])) IN ('Saturday', 'Sunday')
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM date_range dr
JOIN Numbers number
    ON number.number <= DATEDIFF(DAY, dr.[start_date], dr.[end_date]);
GO

-- =============================================================================
-- Create Dimension: gold.fact_expenses
-- =============================================================================
IF OBJECT_ID('gold.fact_expenses', 'V') IS NOT NULL
    DROP VIEW gold.fact_expenses;
GO

CREATE VIEW gold.fact_expenses AS 
SELECT 
expense_key,
dt.date_key AS date_key,
expense_category,
expense_description,
expense_amount 
FROM silver.expenses ep
LEFT JOIN gold.dim_date dt
    ON ep.expense_date = dt.[date]
GO

-- =============================================================================
-- Create Dimension: gold.fact_salaries
-- =============================================================================
IF OBJECT_ID('gold.fact_salaries', 'V') IS NOT NULL
    DROP VIEW gold.fact_salaries;
GO

CREATE VIEW gold.fact_salaries AS 
SELECT 
salary_key,
employee_key,
dt.date_key AS date_key,
salary AS salary_amount
FROM silver.salaries sal
LEFT JOIN gold.dim_date dt
    ON sal.salary_date = dt.[date]
GO

-- =============================================================================
-- Create Dimension: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS 
SELECT 
sale_key AS order_key,
employee_key,
dt.date_key AS date_key, 
sale_service AS [service],
sales AS sales_amount
FROM silver.sales sls
LEFT JOIN gold.dim_date dt
    ON sls.sale_date = dt.[date]
GO
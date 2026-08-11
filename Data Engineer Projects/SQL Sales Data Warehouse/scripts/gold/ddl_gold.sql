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
-- Create Dimension: gold.dim_date
-- =============================================================================
IF OBJECT_ID('gold.dim_date', 'V') IS NOT NULL
    DROP VIEW gold.dim_date;
GO
select * from gold.dim_date
CREATE VIEW gold.dim_date AS
WITH date_range AS
(
    SELECT
        CAST ('2026-01-01' AS DATE) AS [start_date],
        CAST(GETDATE() AS DATE) AS [end_date]
),
numbers AS
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
    DATEPART(QUARTER, DATEADD(DAY, number, dr.[start_date])) AS [quarter],
    YEAR(DATEADD(DAY, number, dr.[start_date])) * 100 
    + MONTH(DATEADD(DAY, number, dr.[start_date])) AS year_month,
    FORMAT(DATEADD(DAY, number, dr.[start_date]), 'MMM yyyy') AS month_year,
    MONTH(DATEADD(DAY, number, dr.[start_date])) AS [month],
    DATENAME(MONTH, DATEADD(DAY, number, dr.[start_date])) AS month_name,
    DAY(DATEADD(DAY, number, dr.[start_date])) AS day_of_month,
    DATENAME(WEEKDAY, DATEADD(DAY, number, dr.[start_date])) AS weekday_name,
    CASE 
        WHEN DATENAME(WEEKDAY, DATEADD(DAY, number, dr.[start_date])) IN ('Saturday', 'Sunday')
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM date_range dr
INNER JOIN numbers number
    ON number.number <= DATEDIFF(DAY, dr.[start_date], dr.[end_date]);
GO

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
FROM silver.employees
GO

-- =============================================================================
-- Create Dimension: gold.dim_services
-- =============================================================================
IF OBJECT_ID('gold.dim_services', 'V') IS NOT NULL
    DROP VIEW gold.dim_services;
GO

CREATE VIEW gold.dim_services AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY sale_service) AS service_key,
    sale_service AS [service_name]
FROM (
    SELECT DISTINCT sale_service
    FROM silver.sales
) AS s -- This is a subquery in the FROM clause and it must have an alias "AS s." This means treat the results of this subquery as a temporary table named s. Then the outer query reads from that temporary table.
GO 

-- =============================================================================
-- Create Dimension: gold.dim_ser_cats
-- =============================================================================
IF OBJECT_ID('gold.dim_ser_cats', 'V') IS NOT NULL
    DROP VIEW gold.dim_ser_cats;
GO

CREATE VIEW gold.dim_ser_cats AS
WITH split_categories AS (
    SELECT
        LEFT(
            TRIM(x.value),
            CHARINDEX(' ', TRIM(x.value) + ' ') - 1
        ) AS category_name
    FROM gold.dim_services AS s
    CROSS APPLY STRING_SPLIT( -- CROSS APPLY is what creates the extra rows
        REPLACE(s.[service_name], ' na ', '|'),
        '|'
    ) AS x
)
SELECT
    ROW_NUMBER() OVER (ORDER BY category_name) AS category_key,
    category_name
FROM split_categories
GROUP BY category_name
GO

-- =============================================================================
-- Create Dimension: gold.bridge_ser_cat
-- =============================================================================
IF OBJECT_ID('gold.bridge_ser_cat', 'V') IS NOT NULL
    DROP VIEW gold.bridge_ser_cat;
GO

CREATE VIEW gold.bridge_ser_cat AS
SELECT
    s.service_key,
    c.category_key
FROM gold.dim_services AS s
CROSS APPLY STRING_SPLIT( -- STRING_SPLIT() creates a temporary table with a column called value.
    REPLACE(s.[service_name], ' na ', '|'), 
    '|') AS x
JOIN gold.dim_ser_cats c 
    ON c.category_name = 
        LEFT(
            TRIM(x.value),
            CHARINDEX(' ', TRIM(x.value) + ' ') - 1
        );
GO

-- =============================================================================
-- Create Dimension: gold.dim_expenses
-- =============================================================================
IF OBJECT_ID('gold.dim_expenses', 'V') IS NOT NULL
    DROP VIEW gold.dim_expenses;
GO

CREATE VIEW gold.dim_expenses AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY expense_name) AS exp_key,
    expense_category,
    expense_subcategory,
    expense_name    
FROM (
    SELECT DISTINCT 
        expense_category,
        expense_subcategory,
        expense_name
    FROM silver.expenses
) AS e -- This is a subquery in the FROM clause and it must have an alias "AS s." This means treat the results of this subquery as a temporary table named s. Then the outer query reads from that temporary table.
GO 

-- =============================================================================
-- Create Fact: gold.fact_expenses
-- =============================================================================
IF OBJECT_ID('gold.fact_expenses', 'V') IS NOT NULL
    DROP VIEW gold.fact_expenses;
GO

CREATE VIEW gold.fact_expenses AS 
SELECT 
    expense_key,
    dt.date_key AS date_key,
    ex.exp_key AS exp_key,
    expense_amount 
FROM silver.expenses ep
LEFT JOIN gold.dim_date dt
    ON ep.expense_date = dt.[date]
LEFT JOIN gold.dim_expenses ex
    ON ep.expense_name = ex.expense_name
GO

-- =============================================================================
-- Create Fact: gold.fact_wages
-- =============================================================================
IF OBJECT_ID('gold.fact_wages', 'V') IS NOT NULL
    DROP VIEW gold.fact_wages;
GO

CREATE VIEW gold.fact_wages AS 
SELECT 
    wage_key,
    employee_key,
    dt.date_key AS date_key,
    wage AS wage_amount
FROM silver.wages sal
LEFT JOIN gold.dim_date dt
    ON sal.wage_date = dt.[date]
GO

-- =============================================================================
-- Create Fact: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS 
SELECT 
    sale_key AS order_key,
    employee_key,
    dt.date_key AS date_key, 
    ser.service_key AS service_key,
    sales AS sales_amount
FROM silver.sales sls
LEFT JOIN gold.dim_date dt
    ON sls.sale_date = dt.[date]
LEFT JOIN gold.dim_services ser
    ON ser.[service_name] = sls.sale_service
GO
CREATE VIEW gold.dim_employees AS 
SELECT 
employee_key,
employee AS employee_name,
employee_position,
employee_phone1,
employee_phone2,
employee_gender
FROM silver.employees emp

CREATE VIEW gold.fact_expenses AS 
SELECT 
expense_key,
expense_date,
expense_type,
expense_category,
expense_amount 
FROM silver.expenses expe

CREATE VIEW gold.fact_salaries AS 
SELECT 
salary_key,
employee_key,
salary_date,
salary
FROM silver.salaries sal

CREATE VIEW gold.fact_sales AS 
SELECT 
sale_key,
employee_key,
sale_date, 
sale_service,
sales
FROM silver.sales sls
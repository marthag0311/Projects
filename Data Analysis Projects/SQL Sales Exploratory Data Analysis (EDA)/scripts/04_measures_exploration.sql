/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends (big numbers) or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
-- Find the total sales
select 
    sum(sales_amount) as total_sales 
from gold.fact_sales;

-- Find the average sale
select 
    avg(sales_amount) as avg_sale 
from gold.fact_sales;

-- Find the total number of orders
select 
    count(order_key) as total_orders 
from gold.fact_sales;

-- Find the total number of services
select 
    count([service_name]) as total_services 
from gold.dim_services; 
--or 
select 
    count([service_key]) as total_services 
from gold.dim_services; 

-- Find the total expenses
select
    sum(expense_amount) as total_expenses
from gold.fact_expenses;

-- Find total number of expenses
select
    count(exp_key) as total_nr_expenses
from gold.dim_expenses;

-- Find the total wages
select 
    sum(salary_amount) as total_wages
from gold.fact_salaries;

-- Generate a report that shows all key metrics of the business
create view gold.report_metrics as
select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'Average Sale', avg(sales_amount) from gold.fact_sales
union all
select 'Total Nr. Orders', count(distinct order_key) from gold.fact_sales
union all
select 'Total Nr. Services', count(service_key) from gold.dim_services 
union all
select 'Total Expenses', sum(expense_amount) from gold.fact_expenses
union all
select 'Total Nr. Expenses', count(exp_key) from gold.dim_expenses
union all
select 'Total Wages', sum(salary_amount) from gold.fact_salaries;
/*
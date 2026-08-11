/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/
-- Find the total number of expenses by category
select 
    expense_category, 
    count(exp_key) as total_nr_expenses
from gold.dim_expenses
group by expense_category
order by total_nr_expenses desc;

-- What is the total expenses incurred in each category
select 
    expense_category, 
    sum(ep.expense_amount) as total_expense
from gold.dim_expenses ex
left join gold.fact_expenses ep
    on ep.exp_key = ex.exp_key
group by expense_category
order by total_expense desc;

-- What is the average expense amount in each category?
select 
    expense_category, 
    avg(ep.expense_amount) as avg_expense
from gold.dim_expenses ex
left join gold.fact_expenses ep
    on ep.exp_key = ex.exp_key
group by expense_category
order by avg_expense desc;

-- Find total number of services by category
select
    c.category_name,
    count(b.service_key) as total_nr_services
from gold.dim_ser_cats c
left join gold.bridge_ser_cat b
    on b.category_key = c.category_key
group by category_name
order by total_nr_services desc;

-- What is the total revenue generated for each service?
select
    [service_name],
    sum(sls.sales_amount) as total_revenue
from gold.dim_services ser
left join gold.fact_sales sls
    on ser.service_key = sls.service_key
group by ser.[service_name]
order by total_revenue desc;

-- What is the total salary for each employee
select
    employee_name,
    sum(sal.wage_amount) as total_wage
from gold.dim_employees emp
left join gold.fact_wages sal
    on sal.employee_key = emp.employee_key
group by employee_name
order by total_wage desc;
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- Explore All positions in the organization
-- Retrieves a list of unique positions in the organization
select distinct 
    employee_position 
from gold.dim_employees
order by employee_position;

-- Explore All Categories "The Major Divisions"
-- Retrieves a list of unique categories and services.
select distinct 
    c.category_name, 
    s.[service_name] 
from gold.dim_ser_cats c
left join gold.bridge_ser_cat b
    on c.category_key = b.category_key
left join gold.dim_services s
    on b.service_key = s.service_key
order by 
    c.category_name, 
    s.[service_name];

-- Explore All Categories in Expenses
-- Retrieves a list of unique categories and expenses.
select distinct 
    expense_category, 
    expense_name 
from gold.dim_expenses
order by 
    expense_category, 
    expense_name;
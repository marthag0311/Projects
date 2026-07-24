/*
================================================
Profit & Loss Statement
=================================================
Purpose: 
	- This report consolidates key service metrics.

Highlights:
	1. Gathers essential fields such as expense_category, expense_subcategory, expense_name and ...
	2. Calculates valuable KPIs:
		- average order revenue (AOR)
		- average monthly revenue
		- revenue
		- expenses
		- cogs
		- gross profit
		- opex
		- ebit
=================================================
*/ 

IF OBJECT_ID('gold.pl_categories', 'V') IS NOT NULL
    DROP VIEW gold.pl_categories;
GO

create view gold.pl_categories as 
select 1 as pl_category_key, 'Revenue' as category,
	'Sales' as subcategory, '' as [name], 
	1 as category_order
union all
select 2 as pl_category_key, 'COGS' as category,
	'Direct labor' as subcategory, 'Wages' as [name],
	2 as category_order
union all
select 3 as pl_category_key, 'Gross Profit' as category,
	'' as subcategory, '' as [name], 3 as category_order
union all
select 4 as pl_category_key, 'OPEX' as category,
	'Rent' as subcategory, 'Rent' as [name],
	4 as category_order
union all
select 5 as pl_category_key, 'OPEX' as category,
	'Staff Meals' as subcategory, 'Staff Meals' as [name],
	4 as category_order
union all
select 6 as pl_category_key, 'OPEX' as category,
	'Utilities' as subcategory, 'Electricity' as [name],
	4 as category_order
union all
select 7 as pl_category_key, 'OPEX' as category,
	'Utilities' as subcategory, 'Water' as [name],
	4 as category_order
union all
select 8 as pl_category_key, 'EBIT' as category,
	'' as subcategory, '' as [name], 5 as category_order;

IF OBJECT_ID('gold.pl_statement', 'V') IS NOT NULL
    DROP VIEW gold.pl_statement;
GO

create view gold.pl_statement as
with pl_base as 
(
    -- Revenue
    select
        sls.date_key as date_key,
        1 AS pl_category_key,
        SUM(sls.sales_amount) as amount
    from gold.fact_sales sls
	where date_key <= '20260410'
    group by date_key
    union all
    -- Expenses
    select
        ep.date_key as date_key,
        pl.pl_category_key as pl_category_key,
        sum(ep.expense_amount) as amount
    from gold.fact_expenses ep
    left join gold.dim_expenses ex
        on ep.exp_key = ex.exp_key
    left join gold.pl_categories pl
        on ex.expense_name = pl.[name]
	where date_key <= '20260410'
    group by date_key, pl_category_key
),
pl_data as
(
	-- Revenue and Expenses
	select
		date_key,
		pl_category_key,
		amount
	from pl_base
	-- Gross Profit
	union all
	select 
		date_key,
		3 as pl_category_key,
		sum(case when pl_category_key = 1 then amount else 0 end) -
		sum(case when pl_category_key = 2 then	amount else 0 end) as amount
	from pl_base
	group by date_key, pl_category_key
	-- EBIT
	union all
	select 
		date_key,
		8 as pl_category_key,
		sum(case when pl_category_key = 1 then amount else 0 end) -
		sum(case when pl_category_key IN (2,4,5,6,7) then	amount else 0 end) as amount
	from pl_base
	group by date_key, pl_category_key
)
select 
	row_number() over (order by date_key, pl_category_key) as pl_key,
    date_key,
    pl_category_key,
    amount
from pl_data;
/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
	- Analyse how an individual part is performing compared to the overall.
    - To evaluate differences between categories.
	- Allowing us to understand which category has the greatest impact on the business.
    - Useful for A/B testing or regional comparisons.

Formula: 
	- (Measure/Total measure) x 100 by dimension
	- (Sales/Total sales) x 100 By category
	- (Quantity/Total quantity) x 100 by country

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Which categories contribute the most to overall expense.
-- Expense categories
with category_expenses as (
	select
	ex.expense_category as expense_category,
	sum(expense_amount) as total_expenses
	from gold.fact_expenses ep
	left join gold.dim_expenses ex
		on ep.exp_key = ex.exp_key 
	group by expense_category
)
select
	expense_category,
	total_expenses,
	sum(total_expenses) over (),
	concat(round((total_expenses / sum(total_expenses) over ()) * 100, 2), '%') as percentage_of_total
from category_expenses
order by total_expenses desc

-- which expenses contribute the most to the overall expense
with expenses as (
	select
	ex.expense_name as expense_name,
	sum(expense_amount) as total_expenses
	from gold.fact_expenses ep
	left join gold.dim_expenses ex
		on ep.exp_key = ex.exp_key 
	group by expense_name
)
select
	expense_name,
	total_expenses,
	sum(total_expenses) over (),
	concat(round((total_expenses / sum(total_expenses) over ()) * 100, 2), '%') as percentage_of_total
from expenses
order by total_expenses desc
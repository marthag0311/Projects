/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
	- Aggregate the data progressively over time.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

Formula:
	- Cumulative Measure By Date Dimension


SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
-- Calculate the total sales per month 
-- and the running total of sales over time
select 
	order_date,
	total_sales,
	sum(total_sales) over (order by order_date) as running_total_sales, -- PARTITION BY is for each year. It resets for a new year.
	avg_sales,
	avg(avg_sales) over (order by order_date) as moving_avg_sales -- PARTITION BY is for each year. It resets for a new year.
from (	-- subquery
	select 
		datetrunc(month, dt.[date]) as order_date,
		sum(sales_amount) as total_sales,
		avg(sales_amount) as avg_sales
	from gold.fact_sales sls
	left join gold.dim_date dt
		on dt.date_key = sls.date_key
	where dt.[date] is not null
	group by datetrunc(month, dt.[date])
) s

-- Calculate the total expenses per month 
-- and the running total of expenses over time
select 
	order_date,
	total_expenses,
	sum(total_expenses) over (order by order_date) as running_total_expenses, -- PARTITION BY is for each year. It resets for a new year.
	avg_expenses,
	avg(avg_expenses) over (order by order_date) as moving_avg_expenses -- PARTITION BY is for each year. It resets for a new year.
from (	-- subquery
	select 
		datetrunc(month, dt.[date]) as order_date,
		sum(expense_amount) as total_expenses,
		avg(expense_amount) as avg_expenses
	from gold.fact_expenses ep
	left join gold.dim_date dt
		on dt.date_key = ep.date_key
	where dt.[date] is not null
	group by datetrunc(month, dt.[date])
) e

-- Calculate the total salaries per month 
-- and the running total of salaries over time
select 
	order_date,
	total_salaries,
	sum(total_salaries) over (order by order_date) as running_total_salaries, -- PARTITION BY is for each year. It resets for a new year.
	avg_salaries,
	avg(avg_salaries) over (order by order_date) as moving_avg_salaries -- PARTITION BY is for each year. It resets for a new year.
from (	-- subquery
	select 
		datetrunc(month, dt.[date]) as order_date,
		sum(salary_amount) as total_salaries,
		avg(salary_amount) as avg_salaries
	from gold.fact_salaries sal
	left join gold.dim_date dt
		on dt.date_key = sal.date_key
	where dt.[date] is not null
	group by datetrunc(month, dt.[date])
) e
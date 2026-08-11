/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
	- Analyze how a measure evolves over time.
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

Formula:
	- Measure By Date Dimension

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- Analyze sales performance over time
-- Quick date functions
select
	year(dt.[date]) as [year],
	month(dt.[date]) as [month],
	sum(sales_amount) as total_sales
from gold.fact_sales sls
left join gold.dim_date dt
	on dt.date_key = sls.date_key
where dt.[date] is not null
group by year([date]), month(dt.[date])
order by year([date]), month(dt.[date])

-- datetrunc()
select
	datetrunc(month, dt.[date]) as order_date,
	sum(sales_amount) as total_sales
from gold.fact_sales sls
left join gold.dim_date dt
	on dt.date_key = sls.date_key
where dt.[date] is not null
group by datetrunc(month, dt.[date])
order by datetrunc(month, dt.[date])

-- format()
select
	format(dt.[date], 'yyyy-MM') as year_month, -- format MMM returns a string, names of months, and it cannot be sorted correctly and MM returns number of the month.
	sum(sales_amount) as total_sales
from gold.fact_sales sls
left join gold.dim_date dt
	on dt.date_key = sls.date_key
where dt.[date] is not null
group by format(dt.[date], 'yyyy-MM')
order by format(dt.[date], 'yyyy-MM')

-- Analyze wage performance over time
-- format()
select
	format(dt.[date], 'yyyy-MM') as year_month, -- format MMM returns a string, names of months, and it cannot be sorted correctly and MM returns number of the month.
	sum(wage_amount) as total_wage
from gold.fact_wages sal
left join gold.dim_date dt
	on dt.date_key = sal.date_key
where dt.[date] is not null
group by format(dt.[date], 'yyyy-MM')
order by format(dt.[date], 'yyyy-MM')

-- Analyze wage performance by employee over time
-- format()
select
	format(dt.[date], 'yyyy-MM') as year_month, -- format MMM returns a string, names of months, and it cannot be sorted correctly and MM returns number of the month.
	emp.employee_name as employee_name,
	sum(wage_amount) as total_wage
from gold.fact_wages sal
left join gold.dim_date dt
	on dt.date_key = sal.date_key
left join gold.dim_employees emp
	on emp.employee_key = sal.employee_key
where dt.[date] is not null
group by format(dt.[date], 'yyyy-MM'), employee_name
order by format(dt.[date], 'yyyy-MM'), employee_name

-- Analyze expense performance over time
-- format()
select
	format(dt.[date], 'yyyy-MM') as year_month, -- format MMM returns a string, names of months, and it cannot be sorted correctly and MM returns number of the month.
	sum(expense_amount) as total_expense
from gold.fact_expenses ep
left join gold.dim_date dt
	on dt.date_key = ep.date_key
where dt.[date] is not null
group by format(dt.[date], 'yyyy-MM')
order by format(dt.[date], 'yyyy-MM')

select
	format(dt.[date], 'yyyy-MM') as year_month, -- format MMM returns a string, names of months, and it cannot be sorted correctly and MM returns number of the month.
	expense_name,
	sum(expense_amount) as total_expense
from gold.fact_expenses ep
left join gold.dim_date dt
	on dt.date_key = ep.date_key
left join gold.dim_expenses ex
	on ex.exp_key = ep.exp_key
where dt.[date] is not null
group by format(dt.[date], 'yyyy-MM'), expense_name
order by format(dt.[date], 'yyyy-MM'), expense_name

-- Analyze expense performance by category over time
-- format()
select
	format(dt.[date], 'yyyy-MM') as year_month, -- format MMM returns a string, names of months, and it cannot be sorted correctly and MM returns number of the month.
	expense_category,
	sum(expense_amount) as total_expense
from gold.fact_expenses ep
left join gold.dim_date dt
	on dt.date_key = ep.date_key
left join gold.dim_expenses ex
	on ex.exp_key = ep.exp_key
where dt.[date] is not null
group by format(dt.[date], 'yyyy-MM'), expense_category
order by format(dt.[date], 'yyyy-MM'), expense_category
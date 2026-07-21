/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
	- Comparing the current value to a target value. 
    - For benchmarking and identifying high-performing entities.
	- Helps measure success and compare performance.
    - To track yearly trends and growth.

Formula:
	- Current Measure - Target Measure
	- Current sales - Average sales
	- Current year sales - Previous year sales => YOY Analysis
	- Current sales - Lowest sales

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Analyse the monthly performance of services by comparing each servise's sales to both its average sales performance and the previous months's sales.
with monthly_service_sales as ( -- CTE
	select 
		month(dt.[date]) as [month],
		ser.[service_name] as [service_name],
		sum(sales_amount) as current_sales
	from gold.fact_sales sls
	left join gold.dim_services ser
		on ser.service_key = sls.service_key
	left join gold.dim_date dt
		on dt.date_key = sls.date_key
	where dt.[date] is not null
	group by
		month(dt.[date]),
		ser.[service_name]
)
select
	[month],
	[service_name],
	current_sales,
	avg(current_sales) over (partition by [service_name]) as avg_sales,
	current_sales - avg(current_sales) over (partition by [service_name]) as diff_avg,
	case when current_sales - avg(current_sales) over (partition by [service_name]) > 0 then 'Above Avg'
		 when current_sales - avg(current_sales) over (partition by [service_name]) < 0 then 'Below Avg'
		 else 'Avg'
	end avg_change,
	-- Month-Over-Month Analysis
	lag(current_sales) over (partition by [service_name] order by [month]) as prev_month_sales,
	current_sales - lag(current_sales) over (partition by [service_name] order by [month]) as diff_sales,
	case when current_sales - lag(current_sales) over (partition by [service_name] order by [month]) > 0 then 'Increase'
		 when current_sales - lag(current_sales) over (partition by [service_name] order by [month]) < 0 then 'Decrease'
		 else 'No Change'
	end avg_change
from monthly_service_sales
order by [service_name], [month]
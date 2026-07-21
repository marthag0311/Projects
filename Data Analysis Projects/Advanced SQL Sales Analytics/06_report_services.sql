/*
================================================
Service Report
=================================================
Purpose: 
	- This report consolidates key service metrics and behaviors.

Highlights:
	1. Gathers essential fields such as service name, category, and ...
	2. Segments services by revenue to identify High-Performers, Mid-Range, or Low-Performer.
	3. Aggregates service-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
=================================================
*/

create view gold.report_services as 
with base_query as (
/*-----------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
------------------------------------------------*/
	select
	dt.[date] as order_date,
	sls.order_key,
	ser.service_key as service_key,
	ser.[service_name] as [service_name],
	sls.sales_amount as sales_amount
	from gold.fact_sales sls
	left join gold.dim_date dt
		on sls.date_key = dt.date_key
	left join gold.dim_services ser
		on sls.service_key = ser.service_key
	where dt.[date] is not null --- only consider valid sales dates
),
service_aggregations as (
/*-----------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
------------------------------------------------*/
select 
	service_key,
	[service_name],
	datediff(month, min(order_date), max(order_date)) as lifespan,
	max(order_date) as last_sale_date,
	count(distinct order_key) as total_orders,
	sum(sales_amount) as total_sales
from base_query
group by 
	service_key,
	[service_name]
)
/*-----------------------------------------------
3) Final Query: Combines all service results into one output
------------------------------------------------*/
select
	service_key,
	[service_name],
	last_sale_date,
	datediff(month, last_sale_date, getdate()) as recency_in_months,
	case
		when total_sales > 500000 then 'High-Performer'
		when total_sales >= 100000 then 'Mid-Range'
		else 'Low-Performer'
	end as service_segment,
	lifespan,
	total_orders,
	total_sales,
	-- average order revenue (aor)
	case
		when total_orders = 0 then 0
		else total_sales/total_orders
	end as avg_order_revenue,
	-- average monthly revenue
	case
		when lifespan = 0 then total_sales
		else total_sales/lifespan
	end as avg_monthly_revenue
from service_aggregations
/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- Which 5 services generate the highest revenue?
select top 5
    [service_name],
    sum(sls.sales_amount) as total_revenue
from gold.dim_services ser
left join gold.fact_sales sls
    on ser.service_key = sls.service_key
group by [service_name]
order by total_revenue desc;

-- Complex but flexibly ranking using window functions.
select *
from (
	select 
	    [service_name],
	    sum(sls.sales_amount) as total_revenue,
	    row_number() over (order by sum(sls.sales_amount) desc) as rank_services
	from gold.dim_services ser
	left join gold.fact_sales sls
	    on ser.service_key = sls.service_key
	group by [service_name]
	) t
where rank_services <= 5;

-- What are the 5 worst-performing services in terms of sales?
select top 5
    [service_name],
    sum(sls.sales_amount) as total_revenue
from gold.dim_services ser
left join gold.fact_sales sls
on ser.service_key = sls.service_key
group by [service_name]
order by total_revenue asc;
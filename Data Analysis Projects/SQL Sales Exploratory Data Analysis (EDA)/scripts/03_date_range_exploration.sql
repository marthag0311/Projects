/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/
-- Determine the first and last order date.
select 
    min([date]) as first_order_date, 
    max([date]) as last_order_date
from gold.fact_sales sls
left join gold.dim_date dt
    on dt.date_key = sls.date_key;

-- Determine the total duration in years and months.
select 
    datediff(year, min([date]), max([date])) as order_range_years,
    datediff(month, min([date]), max([date])) as order_range_months   
from gold.fact_sales sls
left join gold.dim_date dt
    on dt.date_key = sls.date_key;
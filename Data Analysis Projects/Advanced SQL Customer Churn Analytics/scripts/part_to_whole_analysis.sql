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
    - SUM(), Count(): Aggregates values for comparison.
    - Window Functions: SUM(), Count() for total calculations.
===============================================================================
*/
-- How many genders do we have in the gender column?
-- Find the total number of customers by gender.
-- What is the percentage distribution of each gender?
select 
	Gender,
	count(Gender) as total_count,
	count(Gender) * 100.0 / (select count(*) from stage.customers) as per
from stage.customers
group by Gender

-- How many contracts do we have in the contract column?
-- Find the total number of customers by contract.
-- What is the percentage distribution of each contract?
select
	 [Contract],
	 count([Contract]) as total_count,
	 count([Contract]) * 1.0 / (select count(*) from stage.customers) as per
from stage.customers
group by [Contract]

-- How many customer statuses do we have in the customer status column?
-- Finf the total number of customers by customer status?
-- What is revenue distribution of each customer status?
-- What is the percentage revenue distribution of each customer status?
select 
	Customer_Status, 
	count(Customer_Status) as total_count,
	sum(Total_Revenue) as total_revenue, 
	sum(Total_Revenue) / (select sum(Total_Revenue) from stage.customers) * 100 as rev_per
from stage.customers
group by Customer_Status

-- How many items do we have in the state column.
-- What is the count of rows in each item.
-- The percentage distribution of each item.
select
	[State],
	count([State]) as total_count,
	count([State]) * 100.0 / (select count(*) from stage.customers) as per
from stage.customers
group by [State]
order by per desc
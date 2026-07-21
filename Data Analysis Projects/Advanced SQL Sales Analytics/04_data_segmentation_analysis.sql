/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights. To group the data based on a specific range.
    - Helps understand the correlation between two measures.
    - For customer segmentation, product categorization, or regional analysis.

Formula: 
    - Measure by measure
    - Total products by sales range
    - Total customers by age

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- segment services into cost ranges and count how many services fall into each segment.
-- group customers into three segments based on their spending behavior.
-- vip: at least 12 months of history and spending more than £5,000.
-- regular: at least 12 months of history but spending £5,000 or less.
-- new: lifespand less than 12 months.
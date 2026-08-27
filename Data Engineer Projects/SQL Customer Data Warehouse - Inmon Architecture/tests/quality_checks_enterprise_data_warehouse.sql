/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Enterprise Data Warehouse Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'enterprise_data_warehouse.customer_metrics'
-- ====================================================================
-- Check for Uniqueness (NULLs or Duplicates) of customer key in enterprise_data_warehouse.customer_metrics
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM enterprise_data_warehouse.customer_metrics
GROUP BY customer_key
HAVING COUNT(*) > 1 OR customer_key IS NULL;

-- ====================================================================
-- Checking 'enterprise_data_warehouse.demographics'
-- ====================================================================
-- Check for Uniqueness (NULLs or Duplicates) of customer key in enterprise_data_warehouse.demographics
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM enterprise_data_warehouse.demographics
GROUP BY customer_key
HAVING COUNT(*) > 1 OR customer_key IS NULL;

-- ====================================================================
-- Checking 'enterprise_data_warehouse.account'
-- ====================================================================
-- Check for Uniqueness (NULLs or Duplicates) of customer key in enterprise_data_warehouse.account
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM enterprise_data_warehouse.account
GROUP BY customer_key
HAVING COUNT(*) > 1 OR customer_key IS NULL;

-- Check for NULLS in Value Deal
-- Expectation: No Results
SELECT 
	value_deal,
	COUNT(*) 
FROM enterprise_data_warehouse.account
GROUP BY value_deal
HAVING value_deal IS NULL;

-- ====================================================================
-- Checking 'enterprise_data_warehouse.status'
-- ====================================================================
-- Check for Uniqueness of plan key in enterprise_data_warehouse.status
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM enterprise_data_warehouse.[status]
GROUP BY customer_key
HAVING COUNT(*) > 1 OR customer_key IS NULL;

-- Check for NULLS in Churn Category
-- Expectation: No Results
SELECT 
	churn_category,
	COUNT(*) 
FROM enterprise_data_warehouse.[status]
GROUP BY churn_category
HAVING churn_category IS NULL;

-- Check for NULLS in Churn Reason
-- Expectation: No Results
SELECT 
	churn_reason,
	COUNT(*) 
FROM enterprise_data_warehouse.[status]
GROUP BY churn_reason
HAVING churn_reason IS NULL;

-- ====================================================================
-- Checking 'enterprise_data_warehouse.services'
-- ====================================================================
-- Check for Uniqueness of plan key in enterprise_data_warehouse.services
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM enterprise_data_warehouse.[services]
GROUP BY customer_key
HAVING COUNT(*) > 1 OR customer_key IS NULL;

-- Check for NULLS in Unlimited Data
-- Expectation: No Results
SELECT 
	unlimited_data,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY unlimited_data
HAVING unlimited_data IS NULL;

-- Check for NULLS in Internet Type
-- Expectation: No Results
SELECT 
	internet_type,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY internet_type
HAVING internet_type IS NULL;

-- Check for NULLS in Online Security
-- Expectation: No Results
SELECT 
	online_security,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY online_security
HAVING online_security IS NULL;

-- Check for NULLS in Online Backup
-- Expectation: No Results
SELECT 
	online_backup,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY online_backup
HAVING online_backup IS NULL;

-- Check for NULLS in Multiple Lines
-- Expectation: No Results
SELECT 
	multiple_lines,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY multiple_lines
HAVING multiple_lines IS NULL;

-- Check for NULLS in Premium Support
-- Expectation: No Results
SELECT 
	premium_support,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY premium_support
HAVING premium_support IS NULL;

-- Check for NULLS in Device Protection Plan
-- Expectation: No Results
SELECT 
	device_protection_plan,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY device_protection_plan
HAVING device_protection_plan IS NULL;

-- Check for NULLS in Streaming TV
-- Expectation: No Results
SELECT 
	streaming_tv,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY streaming_tv
HAVING streaming_tv IS NULL;

-- Check for NULLS in Streaming Movies
-- Expectation: No Results
SELECT 
	streaming_movies,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY streaming_movies
HAVING streaming_movies IS NULL;

-- Check for NULLS in Streaming Music
-- Expectation: No Results
SELECT 
	streaming_music,
	COUNT(*) 
FROM enterprise_data_warehouse.[services]
GROUP BY streaming_music
HAVING streaming_music IS NULL;
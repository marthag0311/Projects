/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Data Mart Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'data_mart.dim_customers'
-- ====================================================================
-- Check for Uniqueness of customer key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_contract'
-- ====================================================================
-- Check for Uniqueness of contract key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    contract_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_contract
GROUP BY contract_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_device_services'
-- ====================================================================
-- Check for Uniqueness of plan key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    plan_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_device_services
GROUP BY plan_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_internet_services'
-- ====================================================================
-- Check for Uniqueness of plan key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    internet_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_internet_services
GROUP BY internet_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_online_services'
-- ====================================================================
-- Check for Uniqueness of plan key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    online_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_online_services
GROUP BY online_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_phone_services'
-- ====================================================================
-- Check for Uniqueness of plan key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    phone_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_phone_services
GROUP BY phone_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_status'
-- ====================================================================
-- Check for Uniqueness of plan key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    status_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_status
GROUP BY status_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.dim_streaming_services'
-- ====================================================================
-- Check for Uniqueness of plan key in data_mart.dim_customers
-- Expectation: No results 
SELECT 
    streaming_key,
    COUNT(*) AS duplicate_count
FROM data_mart.dim_streaming_services
GROUP BY streaming_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'data_mart.fact'
-- ====================================================================
-- Check for Uniqueness of primary key in data_mart.fact
-- Expectation: No results 
SELECT 
    primary_key,
    COUNT(*) AS duplicate_count
FROM data_mart.fact
GROUP BY primary_key
HAVING COUNT(*) > 1;

-- Check the data model connectivity between fact and dimensions
SELECT
    customer_key,
    phone_key,
    internet_key, 
    online_key, 
    plan_key, 
    streaming_key, 
    contract_key, 
    status_key
FROM data_mart.fact cus
WHERE phone_key IS NULL
  AND internet_key IS NULL
  AND online_key IS NULL
  AND plan_key IS NULL
  AND streaming_key IS NULL
  AND contract_key IS NULL
  AND status_key IS NULL;
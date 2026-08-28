/*
===============================================================================
DDL Script: Create Data Mart Views
===============================================================================
Script Purpose:
    This script creates views for the Data Mart layer in the data warehouse. 
    The Data Mart layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Stage layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
-- =============================================================================
-- Create Dimension: data_mart.dim_customer_metrics
-- =============================================================================
IF OBJECT_ID('data_mart_customer.fact_customer_metrics', 'V') IS NOT NULL
    DROP VIEW data_mart_customer.fact_customer_metrics;
GO

CREATE VIEW data_mart_customer.fact_customer_metrics AS 
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS surrogate_key,
    customer_id,
    number_of_referrals,
    monthly_charge,
    case
        when Monthly_Charge <= 20 then '<=20'
        when Monthly_Charge <= 50 then '21-50'
        when Monthly_Charge <= 100 then '51-100'
        else '>100' 
    end as monthly_charge_status,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue
FROM enterprise_data_warehouse.customer_metrics
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_demographics
-- =============================================================================
IF OBJECT_ID('data_mart_customer.dim_demographics', 'V') IS NOT NULL
    DROP VIEW data_mart_customer.dim_demographics;
GO

CREATE VIEW data_mart_customer.dim_demographics AS 
SELECT
    customer_id,
    gender,
    married,
    age,
    case
        when age <= 20 then '<=20'
        when age <= 35 then '21-35'
        when age <= 50 then '36-50'
        else '>50' 
    end as age_group,
    [state]
FROM enterprise_data_warehouse.demographics
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_account
-- =============================================================================
IF OBJECT_ID('data_mart_customer.dim_account', 'V') IS NOT NULL
    DROP VIEW data_mart_customer.dim_account;
GO

CREATE VIEW data_mart_customer.dim_account AS 
SELECT 
    customer_id,
    tenure_in_months,
    case
        when tenure_in_months <= 6 then '<=6'
        when tenure_in_months <= 12 then '7-12'
        when tenure_in_months <= 18 then '13-18'
        when tenure_in_months <= 24 then '19-24'
        else '>24' 
    end as tenure_group,
    [contract],
    value_deal,
    paperless_billing,
    payment_method
FROM enterprise_data_warehouse.account
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_status
-- =============================================================================
IF OBJECT_ID('data_mart_customer.dim_status', 'V') IS NOT NULL
    DROP VIEW data_mart_customer.dim_status;
GO

CREATE VIEW data_mart_customer.dim_status AS 
SELECT 
    customer_id,
    customer_status,
    case
        when customer_status = 'Churned' then 1
        when customer_status = 'Stayed' then 0
        when customer_status = 'Joined' then 0
        else 0
    end as churn_status,
    churn_category,
    churn_reason
FROM enterprise_data_warehouse.[status]
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_services
-- =============================================================================
IF OBJECT_ID('data_mart_customer.dim_services', 'V') IS NOT NULL
    DROP VIEW data_mart_customer.dim_services;
GO

CREATE VIEW data_mart_customer.dim_services AS 
SELECT 
    customer_id,
    unlimited_data,
    internet_service,
    internet_type,
    online_security,
    online_backup,
    phone_service,
    multiple_lines,
    premium_support,
    device_protection_plan,
    streaming_tv,
    streaming_movies,
    streaming_music
FROM enterprise_data_warehouse.[services]
GO
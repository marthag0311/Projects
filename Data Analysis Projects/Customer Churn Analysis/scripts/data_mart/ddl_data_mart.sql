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
-- Create Dimension: data_mart.dim_customer
-- =============================================================================
IF OBJECT_ID('data_mart.dim_customers', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_customers;
GO

CREATE VIEW data_mart.dim_customers AS 
SELECT 
    Customer_ID as customer_key,
    Gender as gender,
    Married as married,
    Age as age,
    case
        when Age <= 20 then '<=20'
        when Age <= 35 then '21-35'
        when Age <= 50 then '36-50'
        else '>50' 
    end as age_group,
    Tenure_in_Months as tenure_in_months,
    case
        when Tenure_in_Months <= 6 then '<=6'
        when Tenure_in_Months <= 12 then '7-12'
        when Tenure_in_Months <= 18 then '13-18'
        when Tenure_in_Months <= 24 then '19-24'
        else '>24' 
    end as tenure_group,
    [State] as [state]
FROM stage.customers
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_phone_services
-- =============================================================================
IF OBJECT_ID('data_mart.dim_phone_services', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_phone_services;
GO

CREATE VIEW data_mart.dim_phone_services AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Phone_Service) AS phone_key,
    Phone_Service as phone_service,
    ISNULL(Multiple_Lines, 'No') as multiple_lines
FROM (
    select distinct Phone_Service,
        Multiple_Lines
    from stage.customers
) as p
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_internet_services
-- =============================================================================
IF OBJECT_ID('data_mart.dim_internet_services', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_internet_services;
GO

CREATE VIEW data_mart.dim_internet_services AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Internet_Service) AS internet_key,
    Internet_Service as internet_service,
    ISNULL(Internet_Type, 'None') as internet_type
FROM (
    select distinct Internet_Service,
        Internet_Type
    from stage.customers
) as i
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_online_services
-- =============================================================================
IF OBJECT_ID('data_mart.dim_online_services', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_online_services;
GO
 
CREATE VIEW data_mart.dim_online_services AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Online_Security) AS online_key,
    ISNULL(Online_Security, 'N/A') as online_security,
    ISNULL(Online_Backup, 'N/A') as online_backup
FROM (
    select distinct Online_Security,
        Online_Backup
    from stage.customers
) as o
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_device_services
-- =============================================================================
IF OBJECT_ID('data_mart.dim_device_services', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_device_services;
GO

CREATE VIEW data_mart.dim_device_services AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Device_Protection_Plan) AS plan_key,
    ISNULL(Device_Protection_Plan, 'N/A') as device_protection_plan,
    ISNULL(Premium_Support, 'N/A') as premium_support
FROM (
    select distinct Device_Protection_Plan,
        Premium_Support
    from stage.customers
) as d
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_streaming_services
-- =============================================================================
IF OBJECT_ID('data_mart.dim_streaming_services', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_streaming_services;
GO

CREATE VIEW data_mart.dim_streaming_services AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Streaming_TV) AS streaming_key,
    ISNULL(Streaming_TV, 'N/A') as streaming_tv,
    ISNULL(Streaming_Movies, 'N/A') as streaming_movies,
    ISNULL(Streaming_Music, 'N/A') as streaming_music
FROM (
    select distinct Streaming_TV,
        Streaming_Movies,
        Streaming_Music
    from stage.customers
) as s
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_contract
-- =============================================================================
IF OBJECT_ID('data_mart.dim_contract', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_contract;
GO

CREATE VIEW data_mart.dim_contract AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Contract) AS contract_key,
    [Contract] as [contract],
    ISNULL(Value_Deal, 'None') as value_deal,
    ISNULL(Unlimited_Data, 'N/A') as unlimited_data,
    Paperless_Billing as paperless_billing,
    Payment_Method as payment_method
FROM (
    select distinct [Contract],
        Value_Deal,
        Unlimited_Data,
        Paperless_Billing,
        Payment_Method
    from stage.customers
) as c
GO

-- =============================================================================
-- Create Dimension: data_mart.dim_status
-- =============================================================================
IF OBJECT_ID('data_mart.dim_status', 'V') IS NOT NULL
    DROP VIEW data_mart.dim_status;
GO

CREATE VIEW data_mart.dim_status AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Customer_Status) AS status_key,
    Customer_Status as customer_status,
    case
        when Customer_Status = 'Churned' then 1
        when Customer_Status = 'Stayed' then 0
        when Customer_Status = 'Joined' then 0
        else 0
    end as churn_status,
    ISNULL(Churn_Category, 'Other') as churn_category,
    ISNULL(Churn_Reason, 'Other') as churn_reason
FROM (
    select distinct customer_status,
        churn_category,
        churn_reason
    from stage.customers
) as c
GO

-- =============================================================================
-- Create Dimension: data_mart.fact
-- =============================================================================
IF OBJECT_ID('data_mart.fact', 'V') IS NOT NULL
    DROP VIEW data_mart.fact;
GO

CREATE VIEW data_mart.fact AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY Customer_ID) AS surrogate_key,
    Customer_ID as customer_key,
    pho.phone_key as phone_key, -- N/A problem
    inte.internet_key as internet_key, -- N/A problem
    onl.online_key as online_key, -- N/A problem
    dev.plan_key as plan_key, -- N/A problem
    stre.streaming_key as streaming_key, -- N/A problem
    con.contract_key as contract_key, -- N/A problem
    sta.status_key as status_key, -- N/A problem
    Number_of_Referrals as number_of_referrals,
    Monthly_Charge as monthly_charge,
    case
        when Monthly_Charge <= 20 then '<=20'
        when Monthly_Charge <= 50 then '21-50'
        when Monthly_Charge <= 100 then '51-100'
        else '>100' 
    end as monthly_charge_status,
    Total_Charges as total_charges,
    Total_Refunds as total_refunds,
    Total_Extra_Data_Charges as total_extra_data_charges,
    Total_Long_Distance_Charges as total_long_distance_charges,
    Total_Revenue as total_revenue
FROM stage.customers cus
LEFT JOIN data_mart.dim_phone_services pho
    ON cus.Phone_Service = pho.phone_service
    AND ISNULL(cus.Multiple_Lines, 'No') = pho.multiple_lines
LEFT JOIN data_mart.dim_internet_services inte
    ON ISNULL(cus.Internet_Type, 'None') = inte.internet_type
LEFT JOIN data_mart.dim_online_services onl
    ON ISNULL(cus.Online_Security, 'N/A') = onl.online_security 
    AND ISNULL(cus.Online_Backup, 'N/A') = onl.online_backup
LEFT JOIN data_mart.dim_device_services dev
    ON ISNULL(cus.Device_Protection_Plan, 'N/A') = dev.device_protection_plan
    AND ISNULL(cus.Premium_Support, 'N/A') = dev.premium_support
LEFT JOIN data_mart.dim_streaming_services stre 
    ON ISNULL(cus.Streaming_TV, 'N/A') = stre.streaming_tv 
    AND ISNULL(cus.Streaming_Movies, 'N/A') = stre.streaming_movies
    AND ISNULL(cus.Streaming_Music, 'N/A') = stre.streaming_music
LEFT JOIN data_mart.dim_contract con
    ON cus.[Contract] = con.[contract] 
    AND ISNULL(cus.Value_Deal, 'None') = con.value_deal
    AND ISNULL(cus.Unlimited_Data, 'N/A') = con.unlimited_data
    AND cus.Paperless_Billing = con.paperless_billing
    AND cus.Payment_Method = con.payment_method
LEFT JOIN data_mart.dim_status sta
    ON cus.Customer_Status = sta.customer_status
    AND ISNULL(cus.Churn_Category, 'Other') = sta.churn_category
    AND ISNULL(cus.Churn_Reason, 'Other') = sta.churn_reason
GO
IF OBJECT_ID('data_mart_customer.machine_learning', 'V') IS NOT NULL
    DROP VIEW data_mart_customer.machine_learning;
GO

CREATE VIEW data_mart_customer.machine_learning AS 
SELECT 
    f.customer_id as customer_id,
    f.number_of_referrals,
    f.monthly_charge,
    f.monthly_charge_status,
    f.total_charges,
    f.total_refunds,
    f.total_extra_data_charges,
    f.total_long_distance_charges,
    f.total_revenue,

    dem.gender as gender, 
    dem.married as married,
    dem.age as age, 
    dem.age_group as age_group,
    dem.[state] as [state],

    acc.tenure_in_months as tenure_in_months,
    acc.tenure_group as tenure_group,
    acc.[contract] as [contract], 
    acc.value_deal as value_deal, 
    acc.paperless_billing as paperless_billing, 
    acc.payment_method as payment_method,

    sta.customer_status as customer_status, 
    sta.churn_status as churn_status, 
    sta.churn_category as churn_category, 
    sta.churn_reason as churn_reason, 

    ser.unlimited_data as unlimited_data, 
    ser.phone_service as phone_service, 
    ser.multiple_lines as multiple_lines, 
    ser.internet_service as internet_service, 
    ser.internet_type as internet_type,                    
    ser.online_security as online_security, 
    ser.online_backup as online_backup,
    ser.device_protection_plan as device_protection_plan, 
    ser.premium_support as premium_support,
    ser.streaming_tv as streaming_tv,
    ser.streaming_movies as streaming_movies,
    ser.streaming_music as streaming_music                         
FROM data_mart_customer.fact_customer_metrics f
LEFT JOIN data_mart_customer.dim_demographics dem
    ON f.customer_id = dem.customer_id 
LEFT JOIN data_mart_customer.dim_account acc
    ON f.customer_id = acc.customer_id
LEFT JOIN data_mart_customer.dim_status sta
    ON f.customer_id = sta.customer_id
LEFT JOIN data_mart_customer.dim_services ser
    ON f.customer_id = ser.customer_id 
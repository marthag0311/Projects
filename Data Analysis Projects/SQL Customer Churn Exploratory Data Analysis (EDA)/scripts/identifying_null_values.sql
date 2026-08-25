/*
===============================================================================
Data Cleaning
===============================================================================
Purpose:
    - Identifying null values

SQL Functions Used:
    - SUM(): Aggregates values for total null values.
===============================================================================
*/
-- Identify how many columns have null values.
select 
    sum(case when Customer_ID is null then1 else 0 end) as Customer_ID_Null_Count,
    sum(case when Gender is null then1 else 0 end) as Gender_Null_Count,
    sum(case when Age is null then1 else 0 end) as Age_Null_Count,
    sum(case when Married is null then1 else 0 end) as Married_Null_Count,
    sum(case when State is null then1 else 0 end) as State_Null_Count,
    sum(case when Number_of_Referrals is null then1 else 0 end) as Number_of_Referrals_Null_Count,
    sum(case when Tenure_in_Months is null then1 else 0 end) as Tenure_in_Months_Null_Count,
    sum(case when Value_Deal is null then1 else 0 end) as Value_Deal_Null_Count,
    sum(case when Phone_Service is null then1 else 0 end) as Phone_Service_Null_Count,
    sum(case when Multiple_Lines is null then1 else 0 end) as Multiple_Lines_Null_Count,
    sum(case when Internet_Service is null then1 else 0 end) as Internet_Service_Null_Count,
    sum(case when Internet_Type is null then1 else 0 end) as Internet_Type_Null_Count,
    sum(case when Online_Security is null then1 else 0 end) as Online_Security_Null_Count,
    sum(case when Online_Backup is null then1 else 0 end) as Online_Backup_Null_Count,
    sum(case when Device_Protection_Plan is null then1 else 0 end) as Device_Protection_Plan_Null_Count,
    sum(case when Premium_Support is null then1 else 0 end) as Premium_Support_Null_Count,
    sum(case when Streaming_TV is null then1 else 0 end) as Streaming_TV_Null_Count,
    sum(case when Streaming_Movies is null then1 else 0 end) as Streaming_Movies_Null_Count,
    sum(case when Streaming_Music is null then1 else 0 end) as Streaming_Music_Null_Count,
    sum(case when Unlimited_Data is null then1 else 0 end) as Unlimited_Data_Null_Count,
    sum(case when Contract is null then1 else 0 end) as Contract_Null_Count,
    sum(case when Paperless_Billing is null then1 else 0 end) as Paperless_Billing_Null_Count,
    sum(case when Payment_Method is null then1 else 0 end) as Payment_Method_Null_Count,
    sum(case when Monthly_Charge is null then1 else 0 end) as Monthly_Charge_Null_Count,
    sum(case when Total_Charges is null then1 else 0 end) as Total_Charges_Null_Count,
    sum(case when Total_Refunds is null then1 else 0 end) as Total_Refunds_Null_Count,
    sum(case when Total_Extra_Data_Charges is null then1 else 0 end) as Total_Extra_Data_Charges_Null_Count,
    sum(case when Total_Long_Distance_Charges is null then1 else 0 end) as Total_Long_Distance_Charges_Null_Count,
    sum(case when Total_Revenue is null then1 else 0 end) as Total_Revenue_Null_Count,
    sum(case when Customer_Status is null then1 else 0 end) as Customer_Status_Null_Count,
    sum(case when Churn_Category is null then1 else 0 end) as Churn_Category_Null_Count,
    sum(case when Churn_Reason is null then1 else 0 end) as Churn_Reason_Null_Count
FROM stage.customers;
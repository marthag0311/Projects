/*
===============================================================================
DDL Script: Create Stage Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'stage' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'stage' Tables
===============================================================================
*/

IF OBJECT_ID ('stage.customers', 'U') IS NOT NULL
	DROP TABLE stage.customers;
CREATE TABLE stage.customers (
Customer_ID NVARCHAR(50),
Gender NVARCHAR(50),
Age INT,
Married NVARCHAR(50),
[State] NVARCHAR(50), 
Number_of_Referrals INT,
Tenure_in_Months INT,
Value_Deal NVARCHAR(50),
Phone_Service NVARCHAR(50), 
Multiple_Lines NVARCHAR(50),
Internet_Service NVARCHAR(50),
Internet_Type NVARCHAR(50),
Online_Security NVARCHAR(50), 
Online_Backup NVARCHAR(50), 
Device_Protection_Plan NVARCHAR(50), 
Premium_Support NVARCHAR(50), 
Streaming_TV NVARCHAR(50), 
Streaming_Movies NVARCHAR(50), 
Streaming_Music NVARCHAR(50), 
Unlimited_Data NVARCHAR(50), 
[Contract] NVARCHAR(50), 
Paperless_Billing NVARCHAR(50), 
Payment_Method NVARCHAR(50), 
Monthly_Charge DECIMAL(10,2),
Total_Charges DECIMAL(10,2), 
Total_Refunds DECIMAL(10,2),
Total_Extra_Data_Charges INT,
Total_Long_Distance_Charges DECIMAL(10,2),
Total_Revenue DECIMAL(10,2), 
Customer_Status NVARCHAR(50), 
Churn_Category NVARCHAR(50), 
Churn_Reason NVARCHAR(1000)
);
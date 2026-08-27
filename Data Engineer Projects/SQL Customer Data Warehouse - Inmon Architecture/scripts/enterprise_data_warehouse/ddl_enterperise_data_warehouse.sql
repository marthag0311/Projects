/*
===============================================================================
DDL Script: Create Enterprise Data Warehouse Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'Enterprise Data Warehouse' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'Enterprise Data Warehouse' Tables
===============================================================================
*/

IF OBJECT_ID ('enterprise_data_warehouse.customer_metrics', 'U') IS NOT NULL
	DROP TABLE enterprise_data_warehouse.customer_metrics;
CREATE TABLE enterprise_data_warehouse.customer_metrics (
	customer_id NVARCHAR(50),
	number_of_referrals INT, 
	monthly_charge DECIMAL(10,2),
	total_charges DECIMAL(10,2),
	total_refunds DECIMAL(10,2),
	total_extra_data_charges INT,
	total_long_distance_charges DECIMAL(10,2),
	total_revenue DECIMAL(10,2),
	[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('enterprise_data_warehouse.demographics', 'U') IS NOT NULL
	DROP TABLE enterprise_data_warehouse.demographics;
CREATE TABLE enterprise_data_warehouse.demographics (
	customer_id NVARCHAR(50),
	gender NVARCHAR(50),
	married NVARCHAR(50), 
	age INT,
	[state] NVARCHAR(50),
	[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('enterprise_data_warehouse.account', 'U') IS NOT NULL
	DROP TABLE enterprise_data_warehouse.account;
CREATE TABLE enterprise_data_warehouse.account (
	customer_id NVARCHAR(50),
	tenure_in_months INT,
	[contract] NVARCHAR(50), 
	value_deal NVARCHAR(50), 
	paperless_billing NVARCHAR(50), 
	payment_method NVARCHAR(50),
	[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('enterprise_data_warehouse.[status]', 'U') IS NOT NULL
	DROP TABLE enterprise_data_warehouse.[status];
CREATE TABLE enterprise_data_warehouse.[status] (
	customer_id NVARCHAR(50),
	customer_status NVARCHAR(50),
	churn_category NVARCHAR(50), 
	churn_reason NVARCHAR(200),
	[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('enterprise_data_warehouse.[services]', 'U') IS NOT NULL
	DROP TABLE enterprise_data_warehouse.[services];
CREATE TABLE enterprise_data_warehouse.[services] (
	customer_id NVARCHAR(50),
	unlimited_data NVARCHAR(50),
	internet_service NVARCHAR(50),
	internet_type NVARCHAR(50),
	online_security NVARCHAR(50),
	online_backup NVARCHAR(50),
	phone_service NVARCHAR(50),
	multiple_lines NVARCHAR(50),
	premium_support NVARCHAR(50),
	device_protection_plan NVARCHAR(50),
	streaming_tv NVARCHAR(50),
	streaming_movies NVARCHAR(50),
	streaming_music NVARCHAR(50),
	[dwh_create_date] DATETIME2 DEFAULT GETDATE()
);
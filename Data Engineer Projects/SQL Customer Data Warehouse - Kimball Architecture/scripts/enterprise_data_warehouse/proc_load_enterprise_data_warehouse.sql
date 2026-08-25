/*
===============================================================================
Stored Procedure: Load Enterprise Data Warehouse Layer (Stage -> Enterprise Data Warehouse)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'Enterprise Data Warehouse' schema tables from the 'Stage' schema.
	Actions Performed:
		- Truncates Enterprise Data Warehouse tables.
		- Inserts transformed and cleansed data from Stage into Enterprise Data Warehouse tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Enterprise Data Warehouse.load_Enterprise Data Warehouse;
===============================================================================
*/

CREATE OR ALTER PROCEDURE enterprise_data_warehouse.load_enterprise_data_warehouse AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading Enterprise Data Warehouse Layer';
		PRINT '==================================================';

		-- Loading enterprise_data_warehouse.customer_metrics
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: enterprise_data_warehouse.customer_metrics';
		TRUNCATE TABLE enterprise_data_warehouse.customer_metrics;
		PRINT '>> Inserting Data Into: enterprise_data_warehouse.customer_metrics';
		INSERT INTO enterprise_data_warehouse.customer_metrics (
			customer_id,
			number_of_referrals, 
			monthly_charge,
			total_charges,
			total_refunds,
			total_extra_data_charges,
			total_long_distance_charges,
			total_revenue
		)
		SELECT             
			Customer_ID as customer_id,
			Number_of_Referrals AS number_of_referrals, -- Remove unwanted spaces to ensure data consistency and uniformity across all records.
			Monthly_Charge AS monthly_charge,
			Total_Charges AS total_charges,
			Total_Refunds AS total_refunds,
			Total_Extra_Data_Charges AS total_extra_data_charges,
			Total_Long_Distance_Charges as total_long_distance_charges,
			Total_Revenue as total_revenue
		FROM stage.customers  
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading enterprise_data_warehouse.demographics
		SET @start_time = GETDATE();   
		PRINT '>> Truncating Table: enterprise_data_warehouse.demographics';
		TRUNCATE TABLE enterprise_data_warehouse.demographics;
		PRINT '>> Inserting Data Into: enterprise_data_warehouse.demographics';
		INSERT INTO enterprise_data_warehouse.demographics (
			customer_id,
			gender,
			married, 
			age,
			[state]
		)
		SELECT            
			Customer_ID as customer_id,
			Gender as gender, 
			Married as married,
			Age as age,
			[State] as [state]            
		FROM stage.customers
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';
	
		-- Loading enterprise_data_warehouse.account
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: enterprise_data_warehouse.account';
		TRUNCATE TABLE enterprise_data_warehouse.account;
		PRINT '>> Inserting Data Into: enterprise_data_warehouse.account';
		INSERT INTO enterprise_data_warehouse.account (
			customer_id,
			tenure_in_months,
			[contract], 
			value_deal, 
			paperless_billing, 
			payment_method
		)
		SELECT                        
			Customer_ID as customer_id,
			Tenure_in_Months as tenure_in_months,
			[Contract] as [contract],
			ISNULL(Value_Deal, 'None') as value_deal,
			Paperless_Billing as paperless_billing,       
			Payment_Method as payment_method         
		FROM stage.customers
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading enterprise_data_warehouse.[status]
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: enterprise_data_warehouse.[status]';
		TRUNCATE TABLE enterprise_data_warehouse.[status];
		PRINT '>> Inserting Data Into: enterprise_data_warehouse.[status]';
		INSERT INTO enterprise_data_warehouse.[status] (
			customer_id,
			customer_status,
			churn_category, 
			churn_reason
		)                            
		SELECT       
			Customer_ID as customer_id,
			Customer_Status as customer_status, 
			ISNULL(Churn_Category, 'N/A') as churn_category,        
			ISNULL(Churn_Reason, 'N/A') as churn_reason
		FROM stage.customers
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading enterprise_data_warehouse.[services]
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: enterprise_data_warehouse.[services]';
		TRUNCATE TABLE enterprise_data_warehouse.[services];
		PRINT '>> Inserting Data Into: enterprise_data_warehouse.[services]';
		INSERT INTO enterprise_data_warehouse.[services] (
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
		)
		SELECT                                
			Customer_ID as customer_id,
			ISNULL(Unlimited_Data, 'N/A') as unlimited_data,
			Internet_Service as internet_service,
			ISNULL(Internet_Type, 'N/A') as internet_type,
			ISNULL(Online_Security, 'N/A') as online_security,
			ISNULL(Online_Backup, 'N/A') as online_backup,
			Phone_Service as phone_service,
			ISNULL(Multiple_Lines, 'N/A') as multiple_lines,                  
			ISNULL(Premium_Support, 'N/A') as premium_support,
			ISNULL(Device_Protection_Plan, '') as device_protection_plan,
			ISNULL(Streaming_TV, 'N/A') as streaming_tv,
			ISNULL(Streaming_Movies, 'N/A') as streaming_movies,
			ISNULL(Streaming_Music, 'N/A') as streaming_music
		FROM stage.customers
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading Silver Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==================================================';
	END TRY
	BEGIN CATCH
		PRINT '==================================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================';
	END CATCH
END
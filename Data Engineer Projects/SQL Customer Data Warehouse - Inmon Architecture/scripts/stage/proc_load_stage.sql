/*
===============================================================================
Stored Procedure: Load Stage Layer (Source -> Stage)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'stage' schema from external CSV files. 
    It performs the following actions:
    - Truncates the stage tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to stage tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC stage.load_stage;
===============================================================================
*/

CREATE OR ALTER PROCEDURE stage.load_stage AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading stage Layer';
		PRINT '==================================================';

		-- Loading stage.customers
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: stage.customers';
		TRUNCATE TABLE stage.customers; 
		PRINT '>> Inserting Data Into: stage.customers';
		BULK INSERT stage.customers
		FROM 'C:\Projects\Data Analysis Projects\Churn Analysis\data\customers.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading stage Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==================================================';
	END TRY
	BEGIN CATCH
		PRINT '==================================================';
		PRINT 'ERROR OCCURED DURING LOADING stage LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================';
	END CATCH
END
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'==========================================';
		PRINT 'Loading Bronze Layer';
		PRINT'==========================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.employees';
		TRUNCATE TABLE bronze.employees;

		PRINT '>> Inserting Data Into: bronze.employees';
		BULK INSERT bronze.employees
		FROM 'C:\Users\marag\OneDrive\Documents\Home\Martha\Work\Data Engineer Projects\Sales Data Warehouse\employees.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.salaries';
		TRUNCATE TABLE bronze.salaries;

		PRINT '>> Inserting Data Into: bronze.salaries';
		BULK INSERT bronze.salaries
		FROM 'C:\Users\marag\OneDrive\Documents\Home\Martha\Work\Data Engineer Projects\Sales Data Warehouse\salaries.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.expenses';
		TRUNCATE TABLE bronze.expenses;

		PRINT '>> Inserting Data Into: bronze.expenses';
		BULK INSERT bronze.expenses
		FROM 'C:\Users\marag\OneDrive\Documents\Home\Martha\Work\Data Engineer Projects\Sales Data Warehouse\expenses.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.sales';
		TRUNCATE TABLE bronze.sales;

		PRINT '>> Inserting Data Into: bronze.sales';
		BULK INSERT bronze.sales
		FROM 'C:\Users\marag\OneDrive\Documents\Home\Martha\Work\Data Engineer Projects\Sales Data Warehouse\sales.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '=================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=================================================';
	END TRY
	BEGIN CATCH
		PRINT '=================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================';
	END CATCH
END
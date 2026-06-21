/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================================';
		PRINT 'Loading Silver Layer';
		PRINT '==================================================';

		-- Loading silver.employees
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.employees';
		TRUNCATE TABLE silver.employees;
		PRINT '>> Inserting Data Into: silver.employees';
		INSERT INTO silver.employees (
			employee_key,
			employee,
			employee_position, 
			employee_phone1,
			employee_phone2,
			employee_gender 
		)
		SELECT 
			employee_key,
			ISNULL(TRIM(employee), 'N/A') AS employee, -- Remove unwanted spaces to ensure data consistency and uniformity across all records.
			ISNULL(TRIM(employee_position), 'N/A') AS employee_position,
			COALESCE(employee_phone1, 'N/A') AS employee_phone1,
			COALESCE(employee_phone2, 'N/A') AS employee_phone2,
			ISNULL(employee_gender, 'N/A') AS employee_gender
		FROM bronze.employees  
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading silver.expenses
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.expenses';
		TRUNCATE TABLE silver.expenses;
		PRINT '>> Inserting Data Into: silver.expenses';
		INSERT INTO silver.expenses (
			expense_key,
			expense_date,
			expense_category,
			expense_description,
			expense_amount
		)
		SELECT 
			expense_key,
			expense_date, 
			ISNULL(TRIM(expense_category), 'N/A') AS expense_category,
			ISNULL(TRIM(expense_description), 'N/A') AS expense_description, 
			ISNULL(expense_amount, 0) AS expense_amount
		FROM bronze.expenses
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading silver.salaries
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.salaries';
		TRUNCATE TABLE silver.salaries;
		PRINT '>> Inserting Data Into: silver.salaries';
		INSERT INTO silver.salaries (
			salary_key,
			salary_date,
			employee_key,
			salary
		)
		SELECT 
			salary_key,
			salary_date,
			employee_key,
			ISNULL(salary, 0) AS salary
		FROM bronze.salaries
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading silver.sales
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.sales';
		TRUNCATE TABLE silver.sales;
		PRINT '>> Inserting Data Into: silver.sales';
		INSERT INTO silver.sales (
			sale_key,
			sale_date,
			sale_service,
			sales,
			employee_key
		)
		SELECT 
			sale_key,
			sale_date, 
			ISNULL(TRIM(sale_service), 'N/A') AS sale_service,
			ISNULL(sales, 0) AS sales,
			employee_key
		FROM bronze.sales
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
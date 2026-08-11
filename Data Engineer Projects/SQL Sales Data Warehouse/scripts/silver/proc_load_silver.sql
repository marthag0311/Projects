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
			expense_subcategory,
			expense_name,
			expense_amount
		)
		SELECT 
			expense_key,
			expense_date, 
			ISNULL(TRIM(expense_category), 'N/A') AS expense_category,
			ISNULL(TRIM(expense_subcategory), 'N/A') AS expense_subcategory,
			ISNULL(TRIM(expense_name), 'N/A') AS expense_name, 
			ISNULL(expense_amount, 0) AS expense_amount
		FROM bronze.expenses
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';
		
		-- Loading silver.wages
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.wages';
		TRUNCATE TABLE silver.wages;
		PRINT '>> Inserting Data Into: silver.wages';
		INSERT INTO silver.wages (
			wage_key,
			wage_date,
			employee_key,
			wage
		)
		SELECT 
			wage_key,
			wage_date,
			employee_key,
			ISNULL(wage, 0) AS wage
		FROM bronze.wages
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------------------------------';

		-- Loading silver.mapping
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.mapping';
		TRUNCATE TABLE silver.mapping;
		PRINT '>> Inserting Data Into: silver.mapping';
		INSERT INTO silver.mapping (
			old_value,
			new_value
		)
		VALUES
		('02', ''), 
		('4 za plastics 2 na chuma 2', ''),
		('za plastics', ''),
		('za plastic', ''),	
		('kwenye shaft bomba', ''), 
		('propera shaft', 'propeller'), 
		('za kuweka bearing cover', ''),
		('kwenye gear shaft ya katapila', ''),
		('ya motorcycle', ''),
		('ya tepa', ''),
		('(Ngarere)', ''),
		('za kuweka bearing', ''), 
		('kwenye lim', ''),
		('kwenye diff', ''),
		('kwenye shaft', ''),
		('kwenye mswaki', ''),
		('kwenye mabampa', ''), 
		('kwenye bearing', ''),
		('kwenye propera shaft', ''),
		('kwenye bomba', ''),
		('cm 2 kwenye', ''),
		('kwa ajili ya kuingiza bearing', ''),
		('za gari', ''),
		('size 32', ''),
		('upya', ''),
		('ya machine', ''),
		('za french', ''),
		('ya pikipiki', ''),
		('za kwenye bog la skenia', ''),
		('Kuvalisha', 'Kuweka'),
		('nati', 'nut'),
		('tred', 'thread'),
		('plet', 'plate'),
		('propera', 'propeller'),
		('puli', 'pulley'),
		('dif', 'diff'),
		('shafti', 'shaft'),
		('disck', 'disc'),
		('plat', 'plate'),
		('mixaer', 'mixer'),
		('bati', 'plate'),
		('kuchongea', 'kuchonga'),
		('Kufess', 'Kufes'),
		('kurudishia', 'kurudisha'),
		('centa', 'center'),
		('kuungia', 'kuunga'),
		('kuwekea', 'kuweka'),
		('bearing used', 'bearing'), --
		('bearing mpya', 'bearing'), --
		('Kukata propera na kupunguza cm', 'Kupunguza propeller');
		-- propera shaft, bogi, french, doily, nut thread

		-- Create function that loops through the mappings and applies REPLACE() for each one: recursive CTE, cursor, or a scalar function
		IF OBJECT_ID('silver.replace_service', 'FN') IS NOT NULL
		DROP FUNCTION silver.replace_service;
		GO

		CREATE FUNCTION silver.replace_service (
			@text VARCHAR(MAX) -- accepts one input parameter
		)
		RETURNS VARCHAR(MAX) -- the function returns a string
		AS
		BEGIN -- everything between BEGIN and END is the function's logic
			DECLARE @result VARCHAR(MAX) = @text; -- create a variable named @result and initialize it with the input text. This is the string that will be modified.
			DECLARE @old VARCHAR(100), @new VARCHAR(100); -- these cariables temporarily hold one row from the mapping table.

			DECLARE c CURSOR LOCAL FAST_FORWARD FOR -- create a cursor. A cursor lets SQL Server process rows one at a time from the mapping table.
			SELECT old_value, new_value
			FROM silver.mapping
			ORDER BY LEN(old_value) DESC, old_value;

			OPEN c; -- open the cursor. This starts the cursor

			FETCH NEXT FROM c INTO @old, @new; -- read the first row from the mapping table.

			-- Keep looping while there are more mappings
			WHILE @@FETCH_STATUS = 0 -- 0 means the last FETCH succeeded and -1 means there are no more rows
			BEGIN
				SET @result = REPLACE(@result, @old, @new); -- replace the text.

				FETCH NEXT FROM c INTO @old, @new; -- read the next row from the mapping table
			END

			-- clean up spaces after all replacements
			WHILE CHARINDEX('  ', @result) > 0
			BEGIN
				SET @result = REPLACE(@result, '  ', ' ');
			END

			SET @result = TRIM(@result);

			CLOSE c; -- stops reading rows in the mapping table
			DEALLOCATE c; -- remove the cursor and frees the memory used by the cursor

			RETURN @result; -- returns the final text
		END;

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
			--ISNULL(TRIM(sale_service), 'N/A') AS sale_service,
			COALESCE(silver.replace_service(TRIM(sale_service)), 'n/a') AS sale_service,
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
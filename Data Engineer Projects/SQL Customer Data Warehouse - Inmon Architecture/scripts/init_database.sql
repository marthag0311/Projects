/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'CustomersDataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up two schemas 
    within the database: 'stage' and 'data_mart'.
	
WARNING:
    Running this script will drop the entire 'CustomersDataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'CustomersDataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE CustomersDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CustomersDataWarehouse;
END;
GO

-- Create Database 'CustomersDataWarehouse'
CREATE DATABASE CustomersDataWarehouse;
GO
  
USE CustomersDataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA stage;
GO

CREATE SCHEMA enterprise_data_warehouse;
GO
  
CREATE SCHEMA data_mart_customer;
GO
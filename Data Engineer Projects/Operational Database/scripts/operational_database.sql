/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'OperationalDatabase' after checking if it already exists. 
    If the database exists, it is dropped and recreated.
	
WARNING:
    Running this script will drop the entire 'OperationalDatabase' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'OperationalDatabase' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'OperationalDatabase')
BEGIN
    ALTER DATABASE OperationalDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OperationalDatabase;
END;
GO

-- Create database 'OperationalDatabase'
CREATE DATABASE OperationalDatabase;
GO

USE OperationalDatabase;
GO

-- ======================================================
-- Create Table: Customer Address
-- ======================================================
CREATE TABLE [CustomerAddress] (
    [CustomerAddressID] int IDENTITY(1,1)  NOT NULL ,
    [Address] varchar(200)  NOT NULL ,
    [City] varchar(50)  NOT NULL ,
    [Postcode] varchar(20)  NOT NULL ,
    [Country] varchar(50)  NOT NULL ,
    CONSTRAINT [PK_CustomerAddress] PRIMARY KEY CLUSTERED (
        [CustomerAddressID] ASC
    )
);
GO

-- ======================================================
-- Create Table: Customers
-- ======================================================
CREATE TABLE [Customers] (
    [CustomerID] int NOT NULL ,
    [CustomerAddressID] int NOT NULL ,
    [First_name] varchar(50) NOT NULL ,
    [Last_name] varchar(50) NOT NULL ,
    [Type] varchar(20) NOT NULL , -- Wholesale/Retail/Individual
    [Phone] varchar(13) NOT NULL ,
    [Email] varchar(200) NOT NULL ,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED (
        [CustomerID] ASC
    ),
    CONSTRAINT [FK_Employee_CustomerAddress] FOREIGN KEY ([CustomerAddressID])
        REFERENCES [CustomerAddress]([CustomerAddressID])
);
GO

-- ======================================================
-- Create Table: Employee Address
-- ======================================================
CREATE TABLE [EmployeeAddress] (
    [EmployeeAddressID] int IDENTITY(1,1)  NOT NULL ,
    [Address] varchar(200)  NOT NULL ,
    [City] varchar(50)  NOT NULL ,
    [Postcode] varchar(20)  NOT NULL ,
    [Country] varchar(50)  NOT NULL ,
    CONSTRAINT [PK_EmployeeAddress] PRIMARY KEY CLUSTERED (
        [EmployeeAddressID] ASC
    )
);
GO

-- ======================================================
-- Create Table: Employees
-- ======================================================
CREATE TABLE [Employees] (
    [EmployeeID] int  NOT NULL ,
    [EmployeeAddressID] int NOT NULL ,
    [First_name] varchar(50)  NOT NULL ,
    [Last_name] varchar(50)  NOT NULL ,
    [Phone] varchar(13)  NOT NULL ,
    [Email] varchar(200) ,
    [Position] varchar(100)  NOT NULL ,
    [PayRateType] varchar(20) NOT NULL , -- Monthy/Hourly
    [PayRateAmount] decimal(10,2) ,
    [Department] varchar(200) ,
    [Start_date] date ,
    [End_date] date ,
    [Active] BIT NOT NULL,
    [Manager] varchar(50),
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED (
        [EmployeeID] ASC
    ),
    CONSTRAINT [FK_Employee_EmployeeAddress] FOREIGN KEY ([EmployeeAddressID])
        REFERENCES [EmployeeAddress]([EmployeeAddressID])
);
GO

-- ======================================================
-- Create Table: Supplier Address
-- ======================================================
CREATE TABLE [SupplierAddress] (
    [SupplierAddressID] int  NOT NULL ,
    [Address] varchar(200)  NOT NULL ,
    [City] varchar(50)  NOT NULL ,
    [Postcode] varchar(20)  NOT NULL ,
    [Country] varchar(50)  NOT NULL ,
    CONSTRAINT [PK_SupplierAddress] PRIMARY KEY CLUSTERED (
        [SupplierAddressID] ASC
    )
);
GO

-- ======================================================
-- Create Table: Suppliers 
-- ======================================================
CREATE TABLE [Suppliers] (
    [SupplierID] int  NOT NULL ,
    [SupplierAddressID] int ,
    [First_name] varchar(50)  NOT NULL ,
    [Last_name] varchar(50)  NOT NULL ,
    [Phone] varchar(13)  NOT NULL ,
    [Email] varchar(200) ,
    CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED (
        [SupplierID] ASC
    ),
    CONSTRAINT [FK_Employee_SupplierAddress] FOREIGN KEY ([SupplierAddressID])
        REFERENCES [SupplierAddress]([SupplierAddressID])
);
GO

-- ======================================================
-- Create Table: Materials 
-- ======================================================
CREATE TABLE [Materials] (
    [MaterialID] varchar(10)  NOT NULL ,
    [SupplierID] int  NOT NULL ,
    [Name] varchar(200)  NOT NULL ,
    [Weight] int  NOT NULL ,
    [Measure] varchar(20)  NOT NULL , --kg/g
    [Price] decimal(10,2)  NOT NULL ,
    CONSTRAINT [PK_Materials] PRIMARY KEY CLUSTERED (
        [MaterialID] ASC
    ),
    CONSTRAINT [FK_Materials_Suppliers] FOREIGN KEY ([SupplierID])
        REFERENCES [Suppliers]([SupplierID])
);
GO

-- ======================================================
-- Create Table: Products
-- ======================================================
CREATE TABLE [Products] (
    [ProductID] varchar(10)  NOT NULL ,
    [Name] varchar(200)  NOT NULL ,
    [Size] varchar(10) ,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED (
        [ProductID] ASC
    )
);
GO

-- ======================================================
-- Create Table: Unit of Measure
-- ======================================================
CREATE TABLE [UOM] (
    [UomID] int IDENTITY(1,1)  NOT NULL , --1,2
    [Uom_name] varchar(10)  NOT NULL , --Dozen/Piece
    [Uom_multiplier] int  NOT NULL , --12/1
    CONSTRAINT [PK_UOM] PRIMARY KEY CLUSTERED (
        [UomID] ASC
    ),
    CONSTRAINT [UK_UOM_Uom_name] UNIQUE (
        [Uom_name]
    )
);
GO

-- ======================================================
-- Create Table: ProductPrice 
-- ======================================================
CREATE TABLE [ProductPrice] (
    [ProductPriceID] int  NOT NULL ,
    [ProductID] varchar(10)  NOT NULL ,
    [UomID] int  NOT NULL ,
    [Price] decimal(10,2)  NOT NULL ,
    [ValidFrom] date NOT NULL ,
    [ValidTo] date NULL ,
    CONSTRAINT [PK_ProductPrice] PRIMARY KEY CLUSTERED (
        [ProductPriceID] ASC
    ),
    CONSTRAINT [FK_ProductPrice_Products] FOREIGN KEY ([ProductID]) 
        REFERENCES [Products]([ProductID]),
    CONSTRAINT [FK_ProductPrice_UOM] FOREIGN KEY ([UomID]) 
        REFERENCES [UOM]([UomID]),
    CONSTRAINT [UQ_Products_UOM] UNIQUE ([ProductID], [UomID])
);
GO

-- ======================================================
-- Create Table: MaterialInProduct
-- ======================================================
CREATE TABLE [MaterialInProduct] (
    [ProductID] varchar(10)  NOT NULL,
    [MaterialID] varchar(10)  NOT NULL ,
    [Material_quantity] decimal(10,2) ,
    CONSTRAINT [PK_MaterialInProduct] PRIMARY KEY CLUSTERED (
        [ProductID], [MaterialID]
    ),
    CONSTRAINT [FK_MaterialInProduct_Products] FOREIGN KEY ([ProductID]) 
        REFERENCES [Products]([ProductID]),
    CONSTRAINT [FK_MaterialInProduct_Materials] FOREIGN KEY ([MaterialID]) 
        REFERENCES [Materials]([MaterialID])
);
GO

-- ======================================================
-- Create Table: MaterialInventory 
-- ======================================================
CREATE TABLE [MaterialInventory] (
    [MaterialInventoryID] int  NOT NULL ,
    [MaterialID] varchar(10)  NOT NULL ,
    [DateID] int  NOT NULL ,
    [TransactionType] varchar(30) NOT NULL, -- Purchased / Consumed / Adjusted / Wastage
    [Quantity] decimal(10,2)  NOT NULL ,
    CONSTRAINT [PK_MaterialInventory] PRIMARY KEY CLUSTERED (
        [MaterialInventoryID] ASC
    ),
    CONSTRAINT [FK_MaterialInventory_Materials] FOREIGN KEY (MaterialID)
        REFERENCES [Materials](MaterialID),
    CONSTRAINT [FK_MaterialInventory_Date] FOREIGN KEY (DateID)
        REFERENCES [Date](DateID)
);
GO

-- ======================================================
-- Create Table: ProductInventory 
-- ======================================================
CREATE TABLE [ProductInventory] (
    [ProductInventoryID] int  NOT NULL ,
    [ProductID] varchar(10)  NOT NULL ,
    [DateID] int  NOT NULL ,
    [TransactionType] varchar(30) NOT NULL, -- Produced / Sold / Adjusted / Returned / Wastage
    [Quantity] int NOT NULL ,
    CONSTRAINT [PK_ProductInventory] PRIMARY KEY CLUSTERED (
        [ProductInventoryID] ASC
    ),
    CONSTRAINT [FK_ProductInventory_Products] FOREIGN KEY (ProductID)
        REFERENCES [Products](ProductID),
    CONSTRAINT [FK_ProductInventory_Date] FOREIGN KEY (DateID)
        REFERENCES [Date](DateID)
);
GO

-- ======================================================
-- Create Table: OrderStatus
-- ======================================================
CREATE TABLE [OrderStatus] (
    [OrderStatusID] int IDENTITY(1,1)  NOT NULL , --1,2,3,4
    [Status] varchar(20)  NOT NULL ,  -- Pending/Processing/Shipped/Delivered
    CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED (
        [OrderStatusID] ASC
    ),
    CONSTRAINT [UK_OrderStatus_Status] UNIQUE (
        [Status]
    )
);
GO

-- ======================================================
-- Create Table: Orders 
-- ======================================================
CREATE TABLE [Orders] (
    [OrderID] varchar(10)  NOT NULL ,
    [DateID] int  NOT NULL ,
    [CustomerID] int ,
    [EmployeeID] int  NOT NULL ,
    [OrderStatusID] int NOT NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED (
        [OrderID] ASC
    ),
    CONSTRAINT [FK_Orders_Date] FOREIGN KEY ([DateID])
        REFERENCES [Date]([DateID]),
    CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID])
        REFERENCES [Customers]([CustomerID]),
    CONSTRAINT [FK_Orders_Employees] FOREIGN KEY ([EmployeeID])
        REFERENCES [Employees]([EmployeeID]),
    CONSTRAINT [FK_Orders_OrderStatus] FOREIGN KEY ([OrderStatusID])
        REFERENCES [OrderStatus]([OrderStatusID]),
);
GO

-- ======================================================
-- Create Table: OrderLines
-- ======================================================
CREATE TABLE [OrderLines] (
    [OrderLineID] int NOT NULL ,
    [OrderID] varchar(10)  NOT NULL ,
    [ProductID] varchar(10)  NOT NULL ,
    [Quantity] int  NOT NULL ,
    [UnitPrice] decimal(10,2) NOT NULL ,
    CONSTRAINT [PK_OrderLine] PRIMARY KEY CLUSTERED (
        [OrderLineID] ASC
    ),
    CONSTRAINT [FK_Orders_Orders] FOREIGN KEY (OrderID)
        REFERENCES [Orders](OrderID),
    CONSTRAINT [FK_Orders_Products] FOREIGN KEY (ProductID)
        REFERENCES [Products](ProductID),
    CONSTRAINT [FK_Orders_ProductPrice] FOREIGN KEY ([ProductPriceID])
        REFERENCES [ProductPrice]([ProductPriceID])
);
GO
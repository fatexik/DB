CREATE DATABASE VitaliLevin_DB;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);

BACKUP DATABASE VitaliLevin_DB TO DISK='C:\Виталька\Учеба\DB\Lab1\Vitali_Levin_DB.bak';
GO

DROP DATABASE VitaliLevin_DB;
GO

RESTORE DATABASE [VitaliLevin_DB] FROM DISK='C:\Виталька\Учеба\DB\Lab1\Vitali_Levin_DB.bak';
GO
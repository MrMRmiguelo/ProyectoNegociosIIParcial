/*
MIGUEL VALDEZ y Angel Sorto
Proyecto II Parcial - Programacion de negocios
Fecha 03/Julio/2019
*/
USE tempdb
GO 

IF EXISTS (SELECT * FROM sys.databases WHERE name='Parqueo')
BEGIN 
DROP DATABASE Parqueo
END
GO


CREATE DATABASE Parqueo
ON PRIMARY
(
	NAME='Parqueo',
	FILENAME='C:\Users\Miguel\Source\Repos\Sistema de control de estacionamientos\Sistema de control de estacionamientos\Parqueo.mdf',
	SIZE=10MB,
	MAXSIZE=10GB,
	FILEGROWTH=1MB
)
LOG ON
(
	NAME='Parqueo__LOG',
	FILENAME='C:\Users\Miguel\Source\Repos\Sistema de control de estacionamientos\Sistema de control de estacionamientos\Parqueo_LOG.ldf',
	SIZE=10MB,
	MAXSIZE=1GB,
	FILEGROWTH=5MB
)
GO
GO

USE Parqueo
GO

CREATE SCHEMA Parking
GO

CREATE TABLE Parking.Vehiculo
(
Id INT IDENTITY(1,1) CONSTRAINT PK_Parking_Vehiculo_Id PRIMARY KEY NONCLUSTERED NOT NULL,
Placa NVARCHAR (7) NOT NULL,
TipoVehiculo NVARCHAR(50) NOT NULL,
ColorVehiculo NVARCHAR(20) NOT NULL
)
GO

CREATE TABLE Parking.Registro
(
IdEntrada INT IDENTITY(00001,1) CONSTRAINT PK_Parking_Vehiculo_IdEntrada PRIMARY KEY NONCLUSTERED NOT NULL,
HoraEntrada  DATETIME2 DEFAULT GETDATE() NOT NULL,
Fecha_Ingreso DATETIME2 DEFAULT GETDATE() NOT NULL
)
GO
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
GO

USE Parqueo
GO

CREATE SCHEMA ESTACIONAMIENTO
GO

CREATE TABLE ESTACIONAMIENTO.TipoVehiculo(
id INT NOT NULL  IDENTITY(1,1) 
CONSTRAINT PK_id_Tipo_Vehiculo PRIMARY KEY CLUSTERED,
tipoCarro NVARCHAR(30) NOT NULL,
)
GO

INSERT INTO ESTACIONAMIENTO.TipoVehiculo(tipoCarro)
VALUES('LIVIANO'),
('PESADO'),
('MOTOCICLETA')
GO
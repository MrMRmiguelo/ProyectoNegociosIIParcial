/*
MIGUEL VALDEZ y Angel Sorto
Proyecto II Parcial - Programacion de negocios
Fecha 12/Julio/2019
*/
USE tempdb
GO
IF not EXISTS(SELECT * FROM sys.databases WHERE [name] = 'Estacionamiento')
	BEGIN
		CREATE DATABASE Estacionamiento
	END
GO


USE Estacionamiento
go

CREATE SCHEMA Vehiculos
GO


CREATE TABLE Vehiculos.vehiculo(
ID NUMERIC (9) NOT NULL,
idVehiculoE INT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
numPlacaE NVARCHAR(7) NOT NULL,
tipoVehiculoE NVARCHAR(30)NULL,
horaEntrada  DATETIME NULL,
horaSalida  DATETIME NULL
)
GO
CREATE TABLE Vehiculos.vehiculoR(
idVehiculoR INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED,
numPlacaR NVARCHAR(7) NOT NULL,
tipoVehiculoR NVARCHAR(30)NOT NULL,
horaEntradaR TIME DEFAULT GETDATE(),
)
GO

CREATE TABLE Vehiculos.vehiculoSalida
(
idVehiculoS INT IDENTITY(1,1)NOT NULL,
numPlacaS NVARCHAR(7)NOT NULL,
HoraSalida TIME DEFAULT GETDATE()
)
GO

CREATE PROCEDURE Vehiculos.SP_AGREGAR_VEHICULO @numPlaca NVARCHAR(7),@tipoVehiculo NVARCHAR(30)
AS
BEGIN TRANSACTION
     BEGIN TRY
		  IF EXISTS(SELECT * FROM Vehiculos.vehiculo WHERE numPlacaE=@numPlaca)
		     BEGIN
			 PRINT 'LA PLACA YA EXISTE'
			   END
		 ELSE
		 BEGIN
		       INSERT INTO Vehiculos.vehiculo(numPlacaE,tipoVehiculoE)
			   VALUES(@numPlaca,@tipoVehiculo)
			   INSERT INTO Vehiculos.vehiculoR(numPlacaR,tipoVehiculoR)
			   VALUES(@numPlaca,@tipoVehiculo)
		 END
			  COMMIT
		 END TRY
    BEGIN CATCH
	  ROLLBACK TRANSACTION
	END CATCH
GO



CREATE PROCEDURE Vehiculos.SP_AGREGAR_SALIDA(@numPlacaES NVARCHAR(7))
AS
BEGIN TRANSACTION
     BEGIN TRY 
	IF EXISTS(SELECT * FROM Vehiculos.vehiculo WHERE numPlacaE=@numPlacaES)
		     BEGIN
				 INSERT INTO Vehiculos.vehiculoSalida(numPlacaS)
				 VALUES(@numPlacaES)
				 DELETE FROM Vehiculos.vehiculo WHERE numPlacaE=@numPlacaES
			 PRINT 'LA PLACA YA EXISTE'
   END
   ELSE
   BEGIN
   PRINT 'LA PLACA NO EXISTE'
   END
			  COMMIT
		 END TRY
    BEGIN CATCH
	  ROLLBACK TRANSACTION
	END CATCH
GO



CREATE PROC Vehiculos.SP_REPORTE
AS
BEGIN
SELECT a.numPlacaR as 'NUMERO DE PLACA',a.tipoVehiculoR AS 'TIPO DE VEHICULO',a.horaEntradaR as 'HORA DE ENTRADA',b.horaSalida AS 'HORA DE SALIDA',CONCAT(DATEDIFF(HOUR,a.horaEntradaR,b.horaSalida),DATEDIFF(MINUTE,a.horaEntradaR,b.horaSalida),DATEDIFF(SECOND,a.horaEntradaR,b.horaSalida))  AS 'HORA-MINUTOS-SEGUNDOS'
FROM Vehiculos.vehiculoR a INNER JOIN Vehiculos.vehiculoSalida b
ON a.numPlacaR=b.numPlacaS
END
GO

SELECT COUNT(*) idVehiculoR FROM Vehiculos.vehiculoR




SELECT * FROM Vehiculos.vehiculo
SELECT * FROM Vehiculos.vehiculoR
SELECT * FROM Vehiculos.vehiculoSalida
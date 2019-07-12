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
idVehiculoE INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED,
numPlacaE NVARCHAR(7) NOT NULL,
tipoVehiculoE NVARCHAR(30)NOT NULL,
horaEntrada TIME DEFAULT GETDATE()
)
GO
CREATE TABLE Vehiculos.vehiculoR(
idVehiculoR INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED,
numPlacaR NVARCHAR(7) NOT NULL,
tipoVehiculoR NVARCHAR(30)NOT NULL,
horaEntradaR TIME DEFAULT GETDATE()
)
GO

CREATE TABLE Vehiculos.vehiculoSalida(
idVehiculoS INT IDENTITY(1,1)NOT NULL,
numPlacaS NVARCHAR(7)NOT NULL,
horaSalida TIME DEFAULT GETDATE()
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

CREATE PROC Vehiculos.SP_PLACA_HORA_ENTRADA_SALIDA
AS
BEGIN
SELECT a.numPlacaR as placa,a.horaEntradaR as horaE,b.horaSalida
FROM Vehiculos.vehiculoR a INNER JOIN Vehiculos.vehiculoSalida b
ON a.numPlacaR=b.numPlacaS
END
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

EXEC Vehiculos.SP_AGREGAR_VEHICULO 'PER5352' ,'PESADO'
GO
EXEC Vehiculos.SP_AGREGAR_SALIDA 'PER5351'
GO

EXEC Vehiculos.SP_PLACA_HORA_ENTRADA_SALIDA
GO

SELECT * FROM Vehiculos.vehiculo
SELECT * FROM Vehiculos.vehiculoR
SELECT * FROM Vehiculos.vehiculoSalida
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

CREATE PROC Vehiculos.SP_PLACA_HORA_ENTRADA_SALIDA
AS
BEGIN
SELECT a.numPlacaR as placa,a.horaEntradaR as horaE,horaSalida
FROM Vehiculos.vehiculoR a INNER JOIN Vehiculos.vehiculoSalida HoraSalida
ON a.numPlacaR=numPlacaS
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

CREATE PROCEDURE Vehiculos.SP_HorasEntradaYSalida
@id numeric(9)=0,
@Placa NVARCHAR(7)
AS

    DECLARE @Verifica NUMERIC(9) 
   
    DECLARE @resultado VARCHAR(20)
    SET @Verifica = isnull((SELECT top 1 idVehiculoE FROM Vehiculos.vehiculo
        WHERE ID = @id AND horaSalida IS NULL
        AND datediff(d,horaEntrada,getdate())<1
        ),0)
    
    IF @Verifica=0
     
    BEGIN
        INSERT INTO Vehiculos.vehiculo(ID,numPlacaE,horaEntrada,horaSalida)
        VALUES (@id,@Placa,getdate(),NULL)
        SET @resultado = 'Hora Entrada'
    END
    ELSE
    BEGIN
        
        UPDATE Vehiculos.vehiculo
        SET
            horaSalida = getdate()
        WHERE idVehiculoE=@Verifica
        SET @resultado = 'Hora Salida'
 
    END
    IF @@error<>0
    BEGIN
        SET @resultado = 'Error'
    END	
GO

EXEC Vehiculos.SP_HorasEntradaYSalida 1,'PER5399'
GO
SELECT * FROM Vehiculos.vehiculo
EXEC Vehiculos.SP_HorasEntradaYSalida 2,'PER5339'
GO
SELECT * FROM Vehiculos.vehiculo
EXEC Vehiculos.SP_HorasEntradaYSalida 1,'PER5399'
GO
SELECT * FROM Vehiculos.vehiculo


SELECT * FROM Vehiculos.vehiculo
SELECT * FROM Vehiculos.vehiculoR
SELECT * FROM Vehiculos.vehiculoSalida
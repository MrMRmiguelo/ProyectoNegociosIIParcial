/*
MIGUEL VALDEZ y Angel Sorto
Proyecto II Parcial - Programacion de negocios
Fecha 12/Julio/2019
*/
USE tempdb
GO
-- UNA CONDICION PARA VERIFICAR SI EXISTE LA BASE DE DATOS
IF not EXISTS(SELECT * FROM sys.databases WHERE [name] = 'Estacionamiento')
	BEGIN
		CREATE DATABASE Estacionamiento
	END
GO


USE Estacionamiento
GO
--CREACION DE SCHEMAS

CREATE SCHEMA Vehiculos
GO

CREATE SCHEMA Pagos
GO
--CREACION DE TABLAS
CREATE TABLE Pagos.Pagos
(
ID_Pago INT IDENTITY (1,1)CONSTRAINT PK_Id_Cobro PRIMARY KEY CLUSTERED,
ID_Vehiculo INT NOT NULL,
HoraIngreso TIME (0)  DEFAULT GETDATE() NOT NULL,
	HoraSalida TIME (0),
	Fecha DATE DEFAULT GETDATE() NOT NULL,
	Pago DECIMAL(10,2)
	)
GO


CREATE TABLE Vehiculos.vehiculo
(
ID NUMERIC (20) NOT NULL,
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
ALTER TABLE Vehiculos.vehiculo
	ADD CONSTRAINT
	FK_Un_Vehiculo_Tiene_Varios_Tipos
	FOREIGN KEY (ID) REFERENCES Vehiculos.Vehiculo(ID)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
GO
INSERT INTO Vehiculos.vehiculoR(numPlacaR,tipoVehiculoR)
VALUES
	('BAC1334','Liviano'),
	('RUT2215','Liviano'),
	('SED5555','Liviano'),
	('AMD0000','Liviano'),
	('PNG3333','Liviano'),
	('COR4444','Liviano'),
	('DEL5555','Liviano'),
	('SNG1234','Liviano'),
	('USA5678','Liviano'),
	('MEC1111','Liviano'),
	('NUL2222','Motocicleta'),
	('PKD3333','Motocicleta'),
	('RED4444','Liviano'),
	('QND5555','Liviano'),
	('BUL6666','Liviano'),
	('RED7777','Liviano'),
	('YND2020','Pesado'),
	('XDQ1010','Pesado'),
	('ZDA6512','Pesado'),
	('UND6112','Pesado')

GO
INSERT INTO Vehiculos.Vehiculo(numPlacaE,ID,tipoVehiculoE,horaEntrada)
VALUES
	('BAC1334',1,'Liviano',GETDATE()),
	('RUT2215',2,'Liviano',GETDATE()),
	('SED5555',3,'Liviano',GETDATE()),
	('AMD0000',4,'Liviano',GETDATE()),
	('PNG3333',5,'Liviano',GETDATE()),
	('COR4444',6,'Liviano',GETDATE()),
	('DEL5555',7,'Liviano',GETDATE()),
	('SNG1234',8,'Liviano',GETDATE()),
	('USA5678',9,'Liviano',GETDATE()),
	('MEC1111',10,'Liviano',GETDATE()),
	('NUL2222',11,'Motocicleta',GETDATE()),
	('PKD3333',12,'Motocicleta',GETDATE()),
	('RED4444',13,'Liviano',GETDATE()),
	('QND5555',14,'Liviano',GETDATE()),
	('BUL6666',15,'Liviano',GETDATE()),
	('RED7777',16,'Liviano',GETDATE()),
	('YND2020',17,'Pesado',GETDATE()),
	('XDQ1010',18,'Pesado',GETDATE()),
	('ZDA6512',19,'Pesado',GETDATE()),
	('UND6112',20,'Pesado',GETDATE())

GO

INSERT INTO Pagos.Pagos(Id_Vehiculo,HoraIngreso,HoraSalida)
	VALUES
	(1,'2:00',NULL),
	(5,'4:00',NULL)

GO
INSERT INTO Pagos.Pagos(ID_Vehiculo,HoraSalida)
    VALUES	
	(1,'4:00'),
	(5,'6:00')
GO

--CREACION DE PROCEDIMIENTO AGREGAR VEHICULO
CREATE PROCEDURE Vehiculos.SP_AGREGAR_VEHICULO
@numPlaca NVARCHAR(7),
@tipoVehiculo NVARCHAR(30)
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
--CREACION DE PROCEDURA PARA VER HORA ENTRADA Y SALIDA
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
CREATE PROC Vehiculos.SP_REPORTE
AS
BEGIN
SELECT a.numPlacaR as 'NUMERO DE PLACA',a.tipoVehiculoR AS 'TIPO DE VEHICULO',a.horaEntradaR as 'HORA DE ENTRADA',b.horaSalida AS 'HORA DE SALIDA',CONCAT(DATEDIFF(HOUR,a.horaEntradaR,b.horaSalida),DATEDIFF(MINUTE,a.horaEntradaR,b.horaSalida),DATEDIFF(SECOND,a.horaEntradaR,b.horaSalida))  AS 'HORA-MINUTOS-SEGUNDOS'
FROM Vehiculos.vehiculoR a INNER JOIN Vehiculos.vehiculoSalida b
ON a.numPlacaR=b.numPlacaS
END
GO
CREATE PROCEDURE Vehiculos.SP_HorasEntradaYSalida
@id numeric(9)=0,
@Placa NVARCHAR(7)
AS

    DECLARE @Verifica NUMERIC(9)    
    DECLARE @resultado VARCHAR(20)
	
    SET @Verifica  = ISNULL((SELECT top 1 idVehiculoE FROM Vehiculos.vehiculo
        WHERE ID = @id AND horaSalida IS NULL
        AND  DATEDIFF(d,horaEntrada,GETDATE())<1
        ),0)


     
    IF @Verifica=0
     
    BEGIN
        INSERT INTO Vehiculos.vehiculo(ID,numPlacaE,horaEntrada,horaSalida)
        VALUES (@id,@Placa,GETDATE(),NULL)
        SET @resultado = 'Hora Entrada'
		
    END
    ELSE
    BEGIN
        
        UPDATE Vehiculos.vehiculo
        SET
            horaSalida = GETDATE()
        WHERE idVehiculoE=@Verifica
        SET @resultado = 'Hora Salida'
		

 
    END
    IF @@error<>0
    BEGIN
        SET @resultado = 'Error'
    END	
GO


--EJECUTAMOS LOS STORED PROCEDURES
EXEC Pagos.SP_PAGAR 'AMD5399'
GO
EXEC Vehiculos.SP_HorasEntradaYSalida 1,'AMD5399'
GO
SELECT * FROM Vehiculos.vehiculo
EXEC Vehiculos.SP_HorasEntradaYSalida 2,'AMD5339'
GO
SELECT * FROM Vehiculos.vehiculo
EXEC Vehiculos.SP_HorasEntradaYSalida 1,'AMD5399'
GO

--EJECUTAMOS LAS TABLAS 
SELECT * FROM Pagos.Pagos
SELECT * FROM Vehiculos.vehiculo
SELECT * FROM Vehiculos.vehiculo
SELECT * FROM Vehiculos.vehiculoR
SELECT * FROM Vehiculos.vehiculoSalida
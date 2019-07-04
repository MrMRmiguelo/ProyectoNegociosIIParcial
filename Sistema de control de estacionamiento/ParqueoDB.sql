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
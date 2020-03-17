-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-02-2020 a las 21:55:30
-- Versión del servidor: 10.4.10-MariaDB
-- Versión de PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `campodeportivo`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `createViews` ()  BEGIN

DROP VIEW IF EXISTS vwSocios;
CREATE VIEW vwSocios AS
SELECT s.id, s.idSocioTitular, s.nombre, s.apellido, s.dni, s.fechaNacimiento, s.telefono, s.hash, st.codTipoSocio, st.nroAfiliado, st.fechaIngreso, s.codParentesco, d.valor as "parentesco", dd.valor as "tipoAfiliado", s.activo
FROM Socios AS s
INNER JOIN SociosTitulares AS st
ON s.idSocioTitular = st.id
INNER JOIN Diccionario AS d
ON d.clave = s.codParentesco
INNER JOIN Diccionario dd
ON dd.clave = st.codTipoSocio;


DROP VIEW IF EXISTS vwValores;
CREATE VIEW vwValores AS
SELECT v.id, d.valor as "tipoSocio", dd.valor as "prestacion", re.descripcion as "edad", dddd.valor as "dia"
FROM Valores AS v
INNER JOIN Diccionario AS d
ON v.codTipoSocio = d.clave
INNER JOIN Diccionario AS dd
ON v.codPrestacion = dd.clave
INNER JOIN RangoEdad AS re
ON v.codEdad = re.codEdad
INNER JOIN Diccionario AS dddd
ON v.codDia = dddd.clave;


DROP VIEW IF EXISTS vwBonos;
CREATE VIEW vwBonos AS
SELECT b.id, s.apellido, s.nombre, s.hash, st.codTipoSocio, b.idSocio, b.monto, b.fechaEmision, b.fechaAsignacion, b.horaAsignacion, b.horaFin, b.codPrestacion, d.valor as "prestacion", b.detalle, b.codEstadoBono, dd.valor as "estado", ddd.valor as "parentesco", dddd.valor as "tipoSocio" 
FROM Bonos AS b
INNER JOIN Socios AS s
ON b.idSocio = s.id
INNER JOIN Diccionario AS d
ON b.codPrestacion = d.clave
INNER JOIN Diccionario AS dd
ON b.codEstadoBono = dd.clave
INNER JOIN Diccionario AS ddd
ON s.codParentesco = ddd.clave
INNER JOIN SociosTitulares AS st
ON s.idSocioTitular = st.id
INNER JOIN Diccionario AS dddd
ON st.codTipoSocio = dddd.clave;

DROP VIEW IF EXISTS vwCuotas;
CREATE VIEW vwCuotas AS
SELECT c.id, c.fechaPago, c.fechaVencimiento, c.monto, c.descripcion, s.apellido, s.nombre, s.id AS 'idSocio', s.idSocioTitular
FROM Cuotas AS c
INNER JOIN 
(SELECT * FROM Socios WHERE codParentesco = 'cod_parentesco_1') AS s
ON c.idSocioTitular = s.idSocioTitular;

DROP VIEW IF EXISTS vwIngresos;
CREATE VIEW vwIngresos AS
SELECT i.*, s.apellido, s.nombre
FROM Ingresos AS i
INNER JOIN Socios AS s
ON s.id = i.idSocio
ORDER BY fecha DESC, hora DESC;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSocio` (IN `p_codTipoSocio` VARCHAR(50), IN `p_nroAfiliado` INT, IN `p_fechaIngreso` DATE, IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_dni` INT, IN `p_fechaNacimiento` DATE, IN `p_telefono` INT, IN `p_codParentesco` VARCHAR(50), IN `p_activo` INT, IN `p_hash` VARCHAR(100))  BEGIN
    INSERT INTO SociosTitulares(
        codTipoSocio, 
        nroAfiliado,
        fechaIngreso) 
    VALUES (
        p_codTipoSocio,
        p_nroAfiliado,
        p_fechaIngreso);
    
    INSERT INTO Socios(
        idSocioTitular,
        nombre,
        apellido,
        dni,
        fechaNacimiento,
        telefono,
        codParentesco,
        activo,
        hash)
    VALUES (
        LAST_INSERT_ID(),
        p_nombre,
        p_apellido,
        p_dni,
        p_fechaNacimiento,
        p_telefono,
        p_codParentesco,
        p_activo,
        p_hash);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `restoreDB` ()  BEGIN

		DROP TABLE IF EXISTS Usuarios;
		DROP TABLE IF EXISTS SociosTitulares;
		DROP TABLE IF EXISTS Socios;
		DROP TABLE IF EXISTS Bonos;
		DROP TABLE IF EXISTS Valores;
		DROP TABLE IF EXISTS RangoEdad;
		DROP TABLE IF EXISTS Diccionario;
		DROP TABLE IF EXISTS Ingresos;
		DROP TABLE IF EXISTS Cuotas;
		DROP TABLE IF EXISTS Funcionalidades;


		CREATE TABLE Usuarios(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			usuario VARCHAR(50) NOT NULL,
			password VARCHAR(50) NOT NULL,
			codRole VARCHAR(20) NOT NULL 
		);

		INSERT INTO Usuarios(usuario, password, codRole) VALUES
		("pepusa", "1234", "cod_role_1"),
		("daniel", "1234", "cod_role_2"),
		("jonatan","1234", "cod_role_2");

		CREATE TABLE SociosTitulares(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			codTipoSocio VARCHAR(20) NOT NULL,
			nroAfiliado INT,
			fechaIngreso DATE NOT NULL
		);

		-- INSERT INTO SociosTitulares(codTipoSocio, nroAfiliado, fechaIngreso) VALUES
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_2", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_3", 8116, "2019-12-31"),
		-- ("cod_tipo_socio_1", 8116, "2019-12-31");

		CREATE TABLE Socios(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			idSocioTitular INT NOT NULL,
			nombre VARCHAR(50) NOT NULL,
			apellido VARCHAR(50) NOT NULL,
			dni INT NOT NULL,
			fechaNacimiento DATE NOT NULL,
			telefono INT,
			codParentesco VARCHAR(20) NOT NULL,
			hash VARCHAR(100) NOT NULL,
			activo INT DEFAULT 1
		);
		
		ALTER TABLE Socios AUTO_INCREMENT=1001;

		-- INSERT INTO Socios(idSocioTitular, nombre, apellido, dni, fechaNacimiento, telefono, codParentesco, hash) VALUES
		-- (1, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (1, "Pablo", "Valenzuela", 37558497, "1993/05/04", 1123896955, "cod_parentesco_2", "asd123"),
		-- (1, "Leandro", "Sperzagni", 37558497, "1993/05/04", 1123896955, "cod_parentesco_3", "asd123"),
		-- (1, "Mario", "Bonino", 37558497, "1993/05/04", 1123896955, "cod_parentesco_2", "asd123"),
		-- (1, "Leonardo", "Alfaro", 37558497, "1993/05/04", 1123896955, "cod_parentesco_3", "asd123"),
		-- (2, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (3, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (3, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_3", "asd123"),
		-- (4, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (5, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (6, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (7, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (8, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (9, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (10, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (11, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (12, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (13, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (14, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (15, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (16, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (17, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (18, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (19, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (20, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (21, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (22, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123"),
		-- (23, "Mariano", "Wilson", 37558497, "1993/05/04", 1123896955, "cod_parentesco_1", "asd123");

		CREATE TABLE Bonos(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			idSocio INT NOT NULL,
			monto DECIMAL(9,2) NOT NULL,
			fechaEmision DATE NOT NULL,
			fechaAsignacion DATE NOT NULL,
			horaAsignacion TIME,
			horaFin TIME,
			codPrestacion VARCHAR(20) NOT NULL,
			detalle VARCHAR(100),
			codEstadoBono VARCHAR(20)
		);

		-- INSERT INTO Bonos(idSocio, monto, fechaEmision, fechaAsignacion, horaAsignacion, horaFin, codPrestacion, detalle, codEstadoBono) VALUES
		-- (1, 100, "2019-12-17", "2019-12-17", "19:00:00", "20:00:00", "cod_prestacion_1", "Para usar en el mes de Diciembre", "cod_estado_bono_1"),
		-- (1, 100, "2019-12-17", "2019-12-17", "17:00:00", "18:00:00", "cod_prestacion_1", "Para usar en el mes de Diciembre", "cod_estado_bono_1"),
		-- (1, 100, "2019-12-17", "2019-12-17", "20:00:00", "21:00:00", "cod_prestacion_1", "Para usar en el mes de Diciembre", "cod_estado_bono_1");

		CREATE TABLE Valores(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			codTipoSocio VARCHAR(20) NOT NULL,
			codParentesco VARCHAR(20) NOT NULL,
			codPrestacion VARCHAR(20) NOT NULL,
			codEdad VARCHAR(20) NOT NULL,
			codDia VARCHAR(20) NOT NULL,
			valor DECIMAL(9,2)
		);

		INSERT INTO Valores(codTipoSocio, codParentesco, codPrestacion, codEdad, codDia, valor) VALUES

		-- AFILIADO TITULAR
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", "MEN", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", "MEN", "cod_dia_1", 2500),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", "MEN", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", "MEN", "cod_dia_1", 200),

		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", "MAY", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", "MAY", "cod_dia_1", 2500),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", "MAY", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", "MAY", "cod_dia_1", 200),

		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", "JUB", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", "JUB", "cod_dia_1", 2500),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", "JUB", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", "JUB", "cod_dia_1", 200),

		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", "MEN", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", "MEN", "cod_dia_2", 2500),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", "MEN", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", "MEN", "cod_dia_2", 200),

		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", "MAY", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", "MAY", "cod_dia_2", 2500),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", "MAY", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", "MAY", "cod_dia_2", 200),

		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", "JUB", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", "JUB", "cod_dia_2", 2500),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", "JUB", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", "JUB", "cod_dia_2", 200),

		-- AFILIADO FAMILIAR
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", "MEN", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", "MEN", "cod_dia_1", 2500),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", "MEN", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", "MEN", "cod_dia_1", 200),

		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", "MAY", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", "MAY", "cod_dia_1", 2500),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", "MAY", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", "MAY", "cod_dia_1", 200),

		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", "JUB", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", "JUB", "cod_dia_1", 2500),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", "JUB", "cod_dia_1", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", "JUB", "cod_dia_1", 200),

		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", "MEN", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", "MEN", "cod_dia_2", 2500),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", "MEN", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", "MEN", "cod_dia_2", 200),

		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", "MAY", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", "MAY", "cod_dia_2", 2500),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", "MAY", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", "MAY", "cod_dia_2", 200),

		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", "JUB", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", "JUB", "cod_dia_2", 2500),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", "JUB", "cod_dia_2", 200),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", "JUB", "cod_dia_2", 200),

		-- AFILIADO INVITADO
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", "MEN", "cod_dia_1", 50),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", "MAY", "cod_dia_1", 50),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", "JUB", "cod_dia_1", 50),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", "MEN", "cod_dia_2", 50),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", "MAY", "cod_dia_2", 50),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", "JUB", "cod_dia_2", 50),

		-- ADHERENTE TITULAR
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", "MEN", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", "MEN", "cod_dia_1", 3000),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", "MEN", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", "MEN", "cod_dia_1", 300),

		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", "MAY", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", "MAY", "cod_dia_1", 3000),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", "MAY", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", "MAY", "cod_dia_1", 300),

		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", "JUB", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", "JUB", "cod_dia_1", 3000),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", "JUB", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", "JUB", "cod_dia_1", 300),

		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", "MEN", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", "MEN", "cod_dia_2", 3000),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", "MEN", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", "MEN", "cod_dia_2", 300),

		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", "MAY", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", "MAY", "cod_dia_2", 3000),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", "MAY", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", "MAY", "cod_dia_2", 300),

		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", "JUB", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", "JUB", "cod_dia_2", 3000),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", "JUB", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", "JUB", "cod_dia_2", 300),

		-- ADHERENTE FAMILIAR
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", "MEN", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", "MEN", "cod_dia_1", 3000),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", "MEN", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", "MEN", "cod_dia_1", 300),

		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", "MAY", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", "MAY", "cod_dia_1", 3000),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", "MAY", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", "MAY", "cod_dia_1", 300),

		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", "JUB", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", "JUB", "cod_dia_1", 3000),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", "JUB", "cod_dia_1", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", "JUB", "cod_dia_1", 300),

		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", "MEN", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", "MEN", "cod_dia_2", 3000),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", "MEN", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", "MEN", "cod_dia_2", 300),

		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", "MAY", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", "MAY", "cod_dia_2", 3000),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", "MAY", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", "MAY", "cod_dia_2", 300),

		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", "JUB", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", "JUB", "cod_dia_2", 3000),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", "JUB", "cod_dia_2", 300),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", "JUB", "cod_dia_2", 300),

		-- ADHERENTE INVITADO
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", "MEN", "cod_dia_1", 50),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", "MAY", "cod_dia_1", 100),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", "JUB", "cod_dia_1", 100),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", "MEN", "cod_dia_2", 50),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", "MAY", "cod_dia_2", 100),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", "JUB", "cod_dia_2", 100),

		-- EXTERNO
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_1", "MEN", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_1", "MAY", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_1", "JUB", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_4", "MEN", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_4", "MAY", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_4", "JUB", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_5", "MEN", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_5", "MAY", "cod_dia_1", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_5", "JUB", "cod_dia_1", 1600),

		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_1", "MEN", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_1", "MAY", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_1", "JUB", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_4", "MEN", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_4", "MAY", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_4", "JUB", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_5", "MEN", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_5", "MAY", "cod_dia_2", 1600),
		("cod_tipo_socio_3", "cod_parentesco_1", "cod_prestacion_5", "JUB", "cod_dia_2", 1600);




		CREATE TABLE RangoEdad(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			codEdad VARCHAR(20) NOT NULL,
			edadMin INT NOT NULL,
			edadMax INT NOT NULL,
			descripcion VARCHAR(50) NOT NULL
		);

		INSERT INTO RangoEdad(codEdad, edadMin, edadMax, descripcion) VALUES
		("MEN", 1, 12, "Menores de 12 años"),
		("MAY", 13, 65, "Adultos"),
		("JUB", 66, 150, "Jubilados");

		CREATE TABLE Diccionario(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			clave VARCHAR(20) NOT NULL,
			valor VARCHAR(20) NOT NULL
		);

		INSERT INTO Diccionario(clave, valor) VALUES
		("cod_parentesco_1", "Titular"),
		("cod_parentesco_2", "Familiar"),
		("cod_parentesco_3", "Invitado"),
		("cod_tipo_socio_1", "Afiliado Sindicato"),
		("cod_tipo_socio_2", "Socio Adherente"),
		("cod_tipo_socio_3", "Externo"),
		("cod_dia_1", "Lunes a Viernes"),
		("cod_dia_2", "Sabados, Domingos y Feriados"),
		("cod_prestacion_1", "Cancha 1 (5)"),
		("cod_prestacion_2", "Quincho"),
		("cod_prestacion_3", "Predio"),
		("cod_prestacion_4", "Cancha 2 (5)"),
		("cod_prestacion_5", "Cancha 3 (7)"),
		("cod_role_1", "Administrador"),
		("cod_role_2", "Usuario"),
		("cod_estado_bono_1", "Activo"),
		("cod_estado_bono_2", "Anulado"),
		("cod_valor_cuota", "500"),
		("cod_funcionalidad_1", "Familiares a cargo"),
		("cod_funcionalidad_2", "Pago de cuotas"),
		("cod_funcionalidad_3", "Emisión de carnet");

		CREATE TABLE Ingresos(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			idSocio INT NOT NULL,
			fecha DATE NOT NULL,
			hora TIME NOT NULL
		);

		-- INSERT INTO Ingresos(idSocio, fecha, hora) VALUES
		-- (1, "2020-01-09", "16:34"),
		-- (2, "2020-01-08", "18:00");

		CREATE TABLE Cuotas(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			idSocioTitular INT NOT NULL,
			fechaPago DATE NOT NULL,
			fechaVencimiento DATE NOT NULL,
			monto DECIMAL(9,2) NOT NULL,	
			descripcion VARCHAR(50)
		);

		-- INSERT INTO Cuotas(idSocioTitular, fechaPago, fechaVencimiento, monto, descripcion) VALUES
		-- (1, "2019-12-31", "2020-01-31", 500, "Pago mes de Diciembre"),
		-- (1, "2019-12-31", "2020-03-31", 500, "Pago mes de Diciembre"),
		-- (1, "2019-12-31", "2020-03-31", 500, "Pago mes de Diciembre"),
		-- (2, "2020-01-08", "2020-03-30", 500, "Pago mes de Enero"),
		-- (7, "2019-12-31", "2020-03-31", 500, "Pago mes de Diciembre");

		CREATE TABLE Funcionalidades(
			id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			codTipoSocio VARCHAR(20) NOT NULL,
			codParentesco VARCHAR(20),
			codFuncionalidad VARCHAR(50) NOT NULL,
			habilitado INT NOT NULL
		);

		INSERT INTO Funcionalidades(codTipoSocio, codParentesco, codFuncionalidad, habilitado) VALUES

		-- AFILIADO FUNCIONALIDADES
		("cod_tipo_socio_1", "", "cod_funcionalidad_1", 1),
		("cod_tipo_socio_1", "", "cod_funcionalidad_2", 0),
		("cod_tipo_socio_1", "", "cod_funcionalidad_3", 1),

		-- AFILIADO PRESTACIONES TITULAR
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_1", 1),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_2", 1),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_3", 0), 
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_4", 1),
		("cod_tipo_socio_1", "cod_parentesco_1", "cod_prestacion_5", 1),

		-- AFILIADO PRESTACIONES FAMILIAR
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_1", 1),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_2", 1),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_3", 0), 
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_4", 1),
		("cod_tipo_socio_1", "cod_parentesco_2", "cod_prestacion_5", 1),

		-- AFILIADO PRESTACIONES INVITADO
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_1", 0),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_2", 0),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_3", 1), 
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_4", 0),
		("cod_tipo_socio_1", "cod_parentesco_3", "cod_prestacion_5", 0),

		-- ADHERENTE FUNCIONALIDADES
		("cod_tipo_socio_2", "", "cod_funcionalidad_1", 1),
		("cod_tipo_socio_2", "", "cod_funcionalidad_2", 1),
		("cod_tipo_socio_2", "", "cod_funcionalidad_3", 1),

		-- ADHERENTE PRESTACIONES TITULAR
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_1", 1),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_2", 1),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_3", 0), 
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_4", 1),
		("cod_tipo_socio_2", "cod_parentesco_1", "cod_prestacion_5", 1),

		-- ADHERENTE PRESTACIONES FAMILIAR
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_1", 1),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_2", 1),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_3", 0),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_4", 1),
		("cod_tipo_socio_2", "cod_parentesco_2", "cod_prestacion_5", 1), 

		-- ADHERENTE PRESTACIONES INVITADOS
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_1", 0),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_2", 0),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_3", 1), 
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_4", 0),
		("cod_tipo_socio_2", "cod_parentesco_3", "cod_prestacion_5", 0),


		-- EXTERNO FUNCIONALIDADES
		("cod_tipo_socio_4", "", "cod_funcionalidad_1", 0),
		("cod_tipo_socio_4", "", "cod_funcionalidad_2", 0),
		("cod_tipo_socio_4", "", "cod_funcionalidad_3", 0),

		-- EXTERNO PRESTACIONES
		("cod_tipo_socio_4", "", "cod_prestacion_1", 1),
		("cod_tipo_socio_4", "", "cod_prestacion_2", 0),
		("cod_tipo_socio_4", "", "cod_prestacion_3", 0),
		("cod_tipo_socio_4", "", "cod_prestacion_4", 1),
		("cod_tipo_socio_4", "", "cod_prestacion_5", 1);

		END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetPagedWithOptionalFilter` (IN `view_name` VARCHAR(80), IN `column_1` VARCHAR(80), IN `text_to_find_1` VARCHAR(80), IN `is_strict` BOOLEAN, IN `column_2` VARCHAR(80), IN `text_to_find_2` VARCHAR(80), IN `rows_quantity` INT, IN `page` INT, OUT `total_rows` INT)  BEGIN
	set max_sp_recursion_depth=255;
	drop table if exists my_temp;
	
	set @sql = CONCAT( "create temporary table my_temp SELECT * FROM ", view_name );
	
	IF  column_1 is not null and length(column_1) > 1 THEN 

		IF is_strict = 1 THEN
			set @sql = CONCAT( @sql, " where ", column_1, " = '", text_to_find_1 , "'" );
		ELSE
			set @final_text_1 = CONCAT ( "%", text_to_find_1, "%" );
			set @sql = CONCAT( @sql, " where ", column_1, " like '", @final_text_1 , "'" );
		END IF;
		IF  column_2 is not null and length(column_2) > 1 THEN 
			set @final_text_2 = CONCAT ( "%", text_to_find_2, "%" );		
			set @sql = CONCAT( @sql, " and ", column_2, " like '", @final_text_2 , "'" );
		END IF;
    END IF;
	
	-- cierro la query con  ";"
	set @sql = CONCAT (@sql, ";");
	
	-- ejecuto la query , se crea tabla temporal
	prepare stmt1 FROM @sql;
	execute stmt1;	
	
	set total_rows  = (select COUNT(*) FROM my_temp);
		
	-- aplico paginado a la tabla temporal
	call spGetViewWithPaged ("my_temp", rows_quantity, page);
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSocioTitularByIdSocio` (IN `id_socio` INT)  BEGIN

	SELECT idSocioTitular INTO @idSocioTitular
	FROM socios 
	WHERE id = id_socio;

	SELECT s.*, st.codTipoSocio 
	FROM socios AS s
	INNER JOIN sociosTitulares AS st
	ON s.idSocioTitular = st.id
	WHERE idSocioTitular = @idSocioTitular
	AND codParentesco = 'cod_parentesco_1';

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetViewWithPaged` (IN `view_name` VARCHAR(80), IN `rows_quantity` INT, IN `page` INT)  BEGIN

	set max_sp_recursion_depth = 255;

	-- calculo el offset para la query
	set @calculated_page = rows_quantity * page;

		
	-- ejecuta la consulta parametrizada
	set @sql = CONCAT('select * from ', view_name ,' limit ', rows_quantity , ' offset ', @calculated_page);
	prepare stmt1 FROM @sql;
	execute stmt1;

		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSocio` (IN `p_id` INT, IN `p_idSocioTitular` INT, IN `p_codTipoSocio` VARCHAR(50), IN `p_nroAfiliado` INT, IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_dni` INT, IN `p_fechaNacimiento` DATE, IN `p_telefono` INT, IN `p_codParentesco` VARCHAR(50), IN `p_activo` INT)  BEGIN
    UPDATE SociosTitulares SET 
        codTipoSocio = p_codTipoSocio,
        nroAfiliado = p_nroAfiliado
    WHERE id = p_idSocioTitular;
    
    UPDATE Socios SET 
        nombre = p_nombre,
        apellido = p_apellido,
        dni = p_dni,
        fechaNacimiento = p_fechaNacimiento,
        telefono = p_telefono,
        codParentesco = p_codParentesco,
        activo = p_activo
    WHERE id = p_id;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bonos`
--

CREATE TABLE `bonos` (
  `id` int(10) UNSIGNED NOT NULL,
  `idSocio` int(11) NOT NULL,
  `monto` decimal(9,2) NOT NULL,
  `fechaEmision` date NOT NULL,
  `fechaAsignacion` date NOT NULL,
  `horaAsignacion` time DEFAULT NULL,
  `horaFin` time DEFAULT NULL,
  `codPrestacion` varchar(20) NOT NULL,
  `detalle` varchar(100) DEFAULT NULL,
  `codEstadoBono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuotas`
--

CREATE TABLE `cuotas` (
  `id` int(10) UNSIGNED NOT NULL,
  `idSocioTitular` int(11) NOT NULL,
  `fechaPago` date NOT NULL,
  `fechaVencimiento` date NOT NULL,
  `monto` decimal(9,2) NOT NULL,
  `descripcion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `diccionario`
--

CREATE TABLE `diccionario` (
  `id` int(10) UNSIGNED NOT NULL,
  `clave` varchar(20) NOT NULL,
  `valor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `diccionario`
--

INSERT INTO `diccionario` (`id`, `clave`, `valor`) VALUES
(1, 'cod_parentesco_1', 'Titular'),
(2, 'cod_parentesco_2', 'Familiar'),
(3, 'cod_parentesco_3', 'Invitado'),
(4, 'cod_tipo_socio_1', 'Afiliado Sindicato'),
(5, 'cod_tipo_socio_2', 'Socio Adherente'),
(6, 'cod_tipo_socio_3', 'Externo'),
(7, 'cod_dia_1', 'Lunes a Viernes'),
(8, 'cod_dia_2', 'Sabados, Domingos y '),
(9, 'cod_prestacion_1', 'Cancha 1 (5)'),
(10, 'cod_prestacion_2', 'Quincho'),
(11, 'cod_prestacion_3', 'Predio'),
(12, 'cod_prestacion_4', 'Cancha 2 (5)'),
(13, 'cod_prestacion_5', 'Cancha 3 (7)'),
(14, 'cod_role_1', 'Administrador'),
(15, 'cod_role_2', 'Usuario'),
(16, 'cod_estado_bono_1', 'Activo'),
(17, 'cod_estado_bono_2', 'Anulado'),
(18, 'cod_valor_cuota', '500'),
(19, 'cod_funcionalidad_1', 'Familiares a cargo'),
(20, 'cod_funcionalidad_2', 'Pago de cuotas'),
(21, 'cod_funcionalidad_3', 'Emisión de carnet');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `funcionalidades`
--

CREATE TABLE `funcionalidades` (
  `id` int(10) UNSIGNED NOT NULL,
  `codTipoSocio` varchar(20) NOT NULL,
  `codParentesco` varchar(20) DEFAULT NULL,
  `codFuncionalidad` varchar(50) NOT NULL,
  `habilitado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `funcionalidades`
--

INSERT INTO `funcionalidades` (`id`, `codTipoSocio`, `codParentesco`, `codFuncionalidad`, `habilitado`) VALUES
(1, 'cod_tipo_socio_1', '', 'cod_funcionalidad_1', 1),
(2, 'cod_tipo_socio_1', '', 'cod_funcionalidad_2', 0),
(3, 'cod_tipo_socio_1', '', 'cod_funcionalidad_3', 1),
(4, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 1),
(5, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 1),
(6, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_3', 0),
(7, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 1),
(8, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 1),
(9, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 1),
(10, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 1),
(11, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_3', 0),
(12, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 1),
(13, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 1),
(14, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_1', 0),
(15, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_2', 0),
(16, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 1),
(17, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_4', 0),
(18, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_5', 0),
(19, 'cod_tipo_socio_2', '', 'cod_funcionalidad_1', 1),
(20, 'cod_tipo_socio_2', '', 'cod_funcionalidad_2', 1),
(21, 'cod_tipo_socio_2', '', 'cod_funcionalidad_3', 1),
(22, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 1),
(23, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 1),
(24, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_3', 0),
(25, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 1),
(26, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 1),
(27, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 1),
(28, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 1),
(29, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_3', 0),
(30, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 1),
(31, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 1),
(32, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_1', 0),
(33, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_2', 0),
(34, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 1),
(35, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_4', 0),
(36, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_5', 0),
(37, 'cod_tipo_socio_4', '', 'cod_funcionalidad_1', 0),
(38, 'cod_tipo_socio_4', '', 'cod_funcionalidad_2', 0),
(39, 'cod_tipo_socio_4', '', 'cod_funcionalidad_3', 0),
(40, 'cod_tipo_socio_4', '', 'cod_prestacion_1', 1),
(41, 'cod_tipo_socio_4', '', 'cod_prestacion_2', 0),
(42, 'cod_tipo_socio_4', '', 'cod_prestacion_3', 0),
(43, 'cod_tipo_socio_4', '', 'cod_prestacion_4', 1),
(44, 'cod_tipo_socio_4', '', 'cod_prestacion_5', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingresos`
--

CREATE TABLE `ingresos` (
  `id` int(10) UNSIGNED NOT NULL,
  `idSocio` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rangoedad`
--

CREATE TABLE `rangoedad` (
  `id` int(10) UNSIGNED NOT NULL,
  `codEdad` varchar(20) NOT NULL,
  `edadMin` int(11) NOT NULL,
  `edadMax` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `rangoedad`
--

INSERT INTO `rangoedad` (`id`, `codEdad`, `edadMin`, `edadMax`, `descripcion`) VALUES
(1, 'MEN', 1, 12, 'Menores de 12 años'),
(2, 'MAY', 13, 65, 'Adultos'),
(3, 'JUB', 66, 150, 'Jubilados');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socios`
--

CREATE TABLE `socios` (
  `id` int(10) UNSIGNED NOT NULL,
  `idSocioTitular` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `dni` int(11) NOT NULL,
  `fechaNacimiento` date NOT NULL,
  `telefono` int(11) DEFAULT NULL,
  `codParentesco` varchar(20) NOT NULL,
  `hash` varchar(100) NOT NULL,
  `activo` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sociostitulares`
--

CREATE TABLE `sociostitulares` (
  `id` int(10) UNSIGNED NOT NULL,
  `codTipoSocio` varchar(20) NOT NULL,
  `nroAfiliado` int(11) DEFAULT NULL,
  `fechaIngreso` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(10) UNSIGNED NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `codRole` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `password`, `codRole`) VALUES
(1, 'pepusa', '1234', 'cod_role_1'),
(2, 'daniel', '1234', 'cod_role_2'),
(3, 'jonatan', '1234', 'cod_role_2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `valores`
--

CREATE TABLE `valores` (
  `id` int(10) UNSIGNED NOT NULL,
  `codTipoSocio` varchar(20) NOT NULL,
  `codParentesco` varchar(20) NOT NULL,
  `codPrestacion` varchar(20) NOT NULL,
  `codEdad` varchar(20) NOT NULL,
  `codDia` varchar(20) NOT NULL,
  `valor` decimal(9,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `valores`
--

INSERT INTO `valores` (`id`, `codTipoSocio`, `codParentesco`, `codPrestacion`, `codEdad`, `codDia`, `valor`) VALUES
(1, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 'MEN', 'cod_dia_1', '200.00'),
(2, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 'MEN', 'cod_dia_1', '2500.00'),
(3, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 'MEN', 'cod_dia_1', '200.00'),
(4, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 'MEN', 'cod_dia_1', '200.00'),
(5, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 'MAY', 'cod_dia_1', '200.00'),
(6, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 'MAY', 'cod_dia_1', '2500.00'),
(7, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 'MAY', 'cod_dia_1', '200.00'),
(8, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 'MAY', 'cod_dia_1', '200.00'),
(9, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 'JUB', 'cod_dia_1', '200.00'),
(10, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 'JUB', 'cod_dia_1', '2500.00'),
(11, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 'JUB', 'cod_dia_1', '200.00'),
(12, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 'JUB', 'cod_dia_1', '200.00'),
(13, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 'MEN', 'cod_dia_2', '200.00'),
(14, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 'MEN', 'cod_dia_2', '2500.00'),
(15, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 'MEN', 'cod_dia_2', '200.00'),
(16, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 'MEN', 'cod_dia_2', '200.00'),
(17, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 'MAY', 'cod_dia_2', '200.00'),
(18, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 'MAY', 'cod_dia_2', '2500.00'),
(19, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 'MAY', 'cod_dia_2', '200.00'),
(20, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 'MAY', 'cod_dia_2', '200.00'),
(21, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_1', 'JUB', 'cod_dia_2', '200.00'),
(22, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_2', 'JUB', 'cod_dia_2', '2500.00'),
(23, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_4', 'JUB', 'cod_dia_2', '200.00'),
(24, 'cod_tipo_socio_1', 'cod_parentesco_1', 'cod_prestacion_5', 'JUB', 'cod_dia_2', '200.00'),
(25, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 'MEN', 'cod_dia_1', '200.00'),
(26, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 'MEN', 'cod_dia_1', '2500.00'),
(27, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 'MEN', 'cod_dia_1', '200.00'),
(28, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 'MEN', 'cod_dia_1', '200.00'),
(29, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 'MAY', 'cod_dia_1', '200.00'),
(30, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 'MAY', 'cod_dia_1', '2500.00'),
(31, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 'MAY', 'cod_dia_1', '200.00'),
(32, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 'MAY', 'cod_dia_1', '200.00'),
(33, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 'JUB', 'cod_dia_1', '200.00'),
(34, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 'JUB', 'cod_dia_1', '2500.00'),
(35, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 'JUB', 'cod_dia_1', '200.00'),
(36, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 'JUB', 'cod_dia_1', '200.00'),
(37, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 'MEN', 'cod_dia_2', '200.00'),
(38, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 'MEN', 'cod_dia_2', '2500.00'),
(39, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 'MEN', 'cod_dia_2', '200.00'),
(40, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 'MEN', 'cod_dia_2', '200.00'),
(41, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 'MAY', 'cod_dia_2', '200.00'),
(42, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 'MAY', 'cod_dia_2', '2500.00'),
(43, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 'MAY', 'cod_dia_2', '200.00'),
(44, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 'MAY', 'cod_dia_2', '200.00'),
(45, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_1', 'JUB', 'cod_dia_2', '200.00'),
(46, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_2', 'JUB', 'cod_dia_2', '2500.00'),
(47, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_4', 'JUB', 'cod_dia_2', '200.00'),
(48, 'cod_tipo_socio_1', 'cod_parentesco_2', 'cod_prestacion_5', 'JUB', 'cod_dia_2', '200.00'),
(49, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 'MEN', 'cod_dia_1', '50.00'),
(50, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 'MAY', 'cod_dia_1', '50.00'),
(51, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 'JUB', 'cod_dia_1', '50.00'),
(52, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 'MEN', 'cod_dia_2', '50.00'),
(53, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 'MAY', 'cod_dia_2', '50.00'),
(54, 'cod_tipo_socio_1', 'cod_parentesco_3', 'cod_prestacion_3', 'JUB', 'cod_dia_2', '50.00'),
(55, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 'MEN', 'cod_dia_1', '300.00'),
(56, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 'MEN', 'cod_dia_1', '3000.00'),
(57, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 'MEN', 'cod_dia_1', '300.00'),
(58, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 'MEN', 'cod_dia_1', '300.00'),
(59, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 'MAY', 'cod_dia_1', '300.00'),
(60, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 'MAY', 'cod_dia_1', '3000.00'),
(61, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 'MAY', 'cod_dia_1', '300.00'),
(62, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 'MAY', 'cod_dia_1', '300.00'),
(63, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 'JUB', 'cod_dia_1', '300.00'),
(64, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 'JUB', 'cod_dia_1', '3000.00'),
(65, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 'JUB', 'cod_dia_1', '300.00'),
(66, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 'JUB', 'cod_dia_1', '300.00'),
(67, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 'MEN', 'cod_dia_2', '300.00'),
(68, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 'MEN', 'cod_dia_2', '3000.00'),
(69, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 'MEN', 'cod_dia_2', '300.00'),
(70, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 'MEN', 'cod_dia_2', '300.00'),
(71, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 'MAY', 'cod_dia_2', '300.00'),
(72, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 'MAY', 'cod_dia_2', '3000.00'),
(73, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 'MAY', 'cod_dia_2', '300.00'),
(74, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 'MAY', 'cod_dia_2', '300.00'),
(75, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_1', 'JUB', 'cod_dia_2', '300.00'),
(76, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_2', 'JUB', 'cod_dia_2', '3000.00'),
(77, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_4', 'JUB', 'cod_dia_2', '300.00'),
(78, 'cod_tipo_socio_2', 'cod_parentesco_1', 'cod_prestacion_5', 'JUB', 'cod_dia_2', '300.00'),
(79, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 'MEN', 'cod_dia_1', '300.00'),
(80, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 'MEN', 'cod_dia_1', '3000.00'),
(81, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 'MEN', 'cod_dia_1', '300.00'),
(82, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 'MEN', 'cod_dia_1', '300.00'),
(83, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 'MAY', 'cod_dia_1', '300.00'),
(84, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 'MAY', 'cod_dia_1', '3000.00'),
(85, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 'MAY', 'cod_dia_1', '300.00'),
(86, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 'MAY', 'cod_dia_1', '300.00'),
(87, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 'JUB', 'cod_dia_1', '300.00'),
(88, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 'JUB', 'cod_dia_1', '3000.00'),
(89, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 'JUB', 'cod_dia_1', '300.00'),
(90, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 'JUB', 'cod_dia_1', '300.00'),
(91, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 'MEN', 'cod_dia_2', '300.00'),
(92, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 'MEN', 'cod_dia_2', '3000.00'),
(93, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 'MEN', 'cod_dia_2', '300.00'),
(94, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 'MEN', 'cod_dia_2', '300.00'),
(95, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 'MAY', 'cod_dia_2', '300.00'),
(96, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 'MAY', 'cod_dia_2', '3000.00'),
(97, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 'MAY', 'cod_dia_2', '300.00'),
(98, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 'MAY', 'cod_dia_2', '300.00'),
(99, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_1', 'JUB', 'cod_dia_2', '300.00'),
(100, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_2', 'JUB', 'cod_dia_2', '3000.00'),
(101, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_4', 'JUB', 'cod_dia_2', '300.00'),
(102, 'cod_tipo_socio_2', 'cod_parentesco_2', 'cod_prestacion_5', 'JUB', 'cod_dia_2', '300.00'),
(103, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 'MEN', 'cod_dia_1', '50.00'),
(104, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 'MAY', 'cod_dia_1', '100.00'),
(105, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 'JUB', 'cod_dia_1', '100.00'),
(106, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 'MEN', 'cod_dia_2', '50.00'),
(107, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 'MAY', 'cod_dia_2', '100.00'),
(108, 'cod_tipo_socio_2', 'cod_parentesco_3', 'cod_prestacion_3', 'JUB', 'cod_dia_2', '100.00'),
(109, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_1', 'MEN', 'cod_dia_1', '1600.00'),
(110, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_1', 'MAY', 'cod_dia_1', '1600.00'),
(111, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_1', 'JUB', 'cod_dia_1', '1600.00'),
(112, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_4', 'MEN', 'cod_dia_1', '1600.00'),
(113, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_4', 'MAY', 'cod_dia_1', '1600.00'),
(114, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_4', 'JUB', 'cod_dia_1', '1600.00'),
(115, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_5', 'MEN', 'cod_dia_1', '1600.00'),
(116, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_5', 'MAY', 'cod_dia_1', '1600.00'),
(117, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_5', 'JUB', 'cod_dia_1', '1600.00'),
(118, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_1', 'MEN', 'cod_dia_2', '1600.00'),
(119, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_1', 'MAY', 'cod_dia_2', '1600.00'),
(120, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_1', 'JUB', 'cod_dia_2', '1600.00'),
(121, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_4', 'MEN', 'cod_dia_2', '1600.00'),
(122, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_4', 'MAY', 'cod_dia_2', '1600.00'),
(123, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_4', 'JUB', 'cod_dia_2', '1600.00'),
(124, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_5', 'MEN', 'cod_dia_2', '1600.00'),
(125, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_5', 'MAY', 'cod_dia_2', '1600.00'),
(126, 'cod_tipo_socio_3', 'cod_parentesco_1', 'cod_prestacion_5', 'JUB', 'cod_dia_2', '1600.00');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwbonos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwbonos` (
`id` int(10) unsigned
,`apellido` varchar(50)
,`nombre` varchar(50)
,`hash` varchar(100)
,`codTipoSocio` varchar(20)
,`idSocio` int(11)
,`monto` decimal(9,2)
,`fechaEmision` date
,`fechaAsignacion` date
,`horaAsignacion` time
,`horaFin` time
,`codPrestacion` varchar(20)
,`prestacion` varchar(20)
,`detalle` varchar(100)
,`codEstadoBono` varchar(20)
,`estado` varchar(20)
,`parentesco` varchar(20)
,`tipoSocio` varchar(20)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwcuotas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwcuotas` (
`id` int(10) unsigned
,`fechaPago` date
,`fechaVencimiento` date
,`monto` decimal(9,2)
,`descripcion` varchar(50)
,`apellido` varchar(50)
,`nombre` varchar(50)
,`idSocio` int(10) unsigned
,`idSocioTitular` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwingresos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwingresos` (
`id` int(10) unsigned
,`idSocio` int(11)
,`fecha` date
,`hora` time
,`apellido` varchar(50)
,`nombre` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwsocios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwsocios` (
`id` int(10) unsigned
,`idSocioTitular` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`dni` int(11)
,`fechaNacimiento` date
,`telefono` int(11)
,`hash` varchar(100)
,`codTipoSocio` varchar(20)
,`nroAfiliado` int(11)
,`fechaIngreso` date
,`codParentesco` varchar(20)
,`parentesco` varchar(20)
,`tipoAfiliado` varchar(20)
,`activo` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vwvalores`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vwvalores` (
`id` int(10) unsigned
,`tipoSocio` varchar(20)
,`prestacion` varchar(20)
,`edad` varchar(50)
,`dia` varchar(20)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vwbonos`
--
DROP TABLE IF EXISTS `vwbonos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwbonos`  AS  select `b`.`id` AS `id`,`s`.`apellido` AS `apellido`,`s`.`nombre` AS `nombre`,`s`.`hash` AS `hash`,`st`.`codTipoSocio` AS `codTipoSocio`,`b`.`idSocio` AS `idSocio`,`b`.`monto` AS `monto`,`b`.`fechaEmision` AS `fechaEmision`,`b`.`fechaAsignacion` AS `fechaAsignacion`,`b`.`horaAsignacion` AS `horaAsignacion`,`b`.`horaFin` AS `horaFin`,`b`.`codPrestacion` AS `codPrestacion`,`d`.`valor` AS `prestacion`,`b`.`detalle` AS `detalle`,`b`.`codEstadoBono` AS `codEstadoBono`,`dd`.`valor` AS `estado`,`ddd`.`valor` AS `parentesco`,`dddd`.`valor` AS `tipoSocio` from ((((((`bonos` `b` join `socios` `s` on(`b`.`idSocio` = `s`.`id`)) join `diccionario` `d` on(`b`.`codPrestacion` = `d`.`clave`)) join `diccionario` `dd` on(`b`.`codEstadoBono` = `dd`.`clave`)) join `diccionario` `ddd` on(`s`.`codParentesco` = `ddd`.`clave`)) join `sociostitulares` `st` on(`s`.`idSocioTitular` = `st`.`id`)) join `diccionario` `dddd` on(`st`.`codTipoSocio` = `dddd`.`clave`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwcuotas`
--
DROP TABLE IF EXISTS `vwcuotas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwcuotas`  AS  select `c`.`id` AS `id`,`c`.`fechaPago` AS `fechaPago`,`c`.`fechaVencimiento` AS `fechaVencimiento`,`c`.`monto` AS `monto`,`c`.`descripcion` AS `descripcion`,`s`.`apellido` AS `apellido`,`s`.`nombre` AS `nombre`,`s`.`id` AS `idSocio`,`s`.`idSocioTitular` AS `idSocioTitular` from (`cuotas` `c` join (select `socios`.`id` AS `id`,`socios`.`idSocioTitular` AS `idSocioTitular`,`socios`.`nombre` AS `nombre`,`socios`.`apellido` AS `apellido`,`socios`.`dni` AS `dni`,`socios`.`fechaNacimiento` AS `fechaNacimiento`,`socios`.`telefono` AS `telefono`,`socios`.`codParentesco` AS `codParentesco`,`socios`.`hash` AS `hash`,`socios`.`activo` AS `activo` from `socios` where `socios`.`codParentesco` = 'cod_parentesco_1') `s` on(`c`.`idSocioTitular` = `s`.`idSocioTitular`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwingresos`
--
DROP TABLE IF EXISTS `vwingresos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwingresos`  AS  select `i`.`id` AS `id`,`i`.`idSocio` AS `idSocio`,`i`.`fecha` AS `fecha`,`i`.`hora` AS `hora`,`s`.`apellido` AS `apellido`,`s`.`nombre` AS `nombre` from (`ingresos` `i` join `socios` `s` on(`s`.`id` = `i`.`idSocio`)) order by `i`.`fecha` desc,`i`.`hora` desc ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwsocios`
--
DROP TABLE IF EXISTS `vwsocios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwsocios`  AS  select `s`.`id` AS `id`,`s`.`idSocioTitular` AS `idSocioTitular`,`s`.`nombre` AS `nombre`,`s`.`apellido` AS `apellido`,`s`.`dni` AS `dni`,`s`.`fechaNacimiento` AS `fechaNacimiento`,`s`.`telefono` AS `telefono`,`s`.`hash` AS `hash`,`st`.`codTipoSocio` AS `codTipoSocio`,`st`.`nroAfiliado` AS `nroAfiliado`,`st`.`fechaIngreso` AS `fechaIngreso`,`s`.`codParentesco` AS `codParentesco`,`d`.`valor` AS `parentesco`,`dd`.`valor` AS `tipoAfiliado`,`s`.`activo` AS `activo` from (((`socios` `s` join `sociostitulares` `st` on(`s`.`idSocioTitular` = `st`.`id`)) join `diccionario` `d` on(`d`.`clave` = `s`.`codParentesco`)) join `diccionario` `dd` on(`dd`.`clave` = `st`.`codTipoSocio`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vwvalores`
--
DROP TABLE IF EXISTS `vwvalores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwvalores`  AS  select `v`.`id` AS `id`,`d`.`valor` AS `tipoSocio`,`dd`.`valor` AS `prestacion`,`re`.`descripcion` AS `edad`,`dddd`.`valor` AS `dia` from ((((`valores` `v` join `diccionario` `d` on(`v`.`codTipoSocio` = `d`.`clave`)) join `diccionario` `dd` on(`v`.`codPrestacion` = `dd`.`clave`)) join `rangoedad` `re` on(`v`.`codEdad` = `re`.`codEdad`)) join `diccionario` `dddd` on(`v`.`codDia` = `dddd`.`clave`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bonos`
--
ALTER TABLE `bonos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cuotas`
--
ALTER TABLE `cuotas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `diccionario`
--
ALTER TABLE `diccionario`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `funcionalidades`
--
ALTER TABLE `funcionalidades`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ingresos`
--
ALTER TABLE `ingresos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rangoedad`
--
ALTER TABLE `rangoedad`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `socios`
--
ALTER TABLE `socios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `sociostitulares`
--
ALTER TABLE `sociostitulares`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `valores`
--
ALTER TABLE `valores`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bonos`
--
ALTER TABLE `bonos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cuotas`
--
ALTER TABLE `cuotas`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `diccionario`
--
ALTER TABLE `diccionario`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `funcionalidades`
--
ALTER TABLE `funcionalidades`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de la tabla `ingresos`
--
ALTER TABLE `ingresos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rangoedad`
--
ALTER TABLE `rangoedad`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `socios`
--
ALTER TABLE `socios`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- AUTO_INCREMENT de la tabla `sociostitulares`
--
ALTER TABLE `sociostitulares`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `valores`
--
ALTER TABLE `valores`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

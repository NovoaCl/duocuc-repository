/* =========================================================
   EVALUACIÓN PARCIAL N°2
   BASE DE DATOS APLICADA II
   EMPRESA: URBAN WHEELS Ltda.
   MOTOR: ORACLE
   ========================================================= */


/* =========================================================
   REQUERIMIENTO 1
   PERFILAMIENTO DE USUARIOS Y ASIGNACIÓN DE PERMISOS
   ========================================================= */


/* =========================================================
   1.1 CREACIÓN DE ROLES
   ========================================================= */

CREATE ROLE ROL_ADMIN_URBAN;

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE SEQUENCE,
    CREATE VIEW,
    CREATE INDEX,
    CREATE PUBLIC SYNONYM,
    CREATE PROCEDURE
TO ROL_ADMIN_URBAN;



CREATE ROLE ROL_REPORTES_URBAN;

GRANT
    CREATE SESSION,
    CREATE VIEW,
    CREATE MATERIALIZED VIEW
TO ROL_REPORTES_URBAN;


/* =========================================================
   1.2 CREACIÓN DE USUARIOS
   ========================================================= */

CREATE USER URBANW_SQL
IDENTIFIED BY UrbanWheels2025
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

CREATE USER HLUO_REPORT
IDENTIFIED BY "HLUO_REPORT.practica.EV2" 
DEFAULT TABLESPACE "USERS" 
TEMPORARY TABLESPACE "TEMP";


CREATE USER REPORTE_WHEELS
IDENTIFIED BY ReporteWheels2025
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;


/* =========================================================
   1.3 ASIGNACIÓN DE ROLES
   ========================================================= */

GRANT ROL_ADMIN_URBAN TO URBANW_SQL;

GRANT ROL_REPORTES_URBAN TO REPORTE_WHEELS;


/* =========================================================
   1.4 PRIVILEGIOS SOBRE OBJETOS
   ========================================================= */

/* PRIVILEGIOS DE CONSULTA */

GRANT SELECT ON URBANW_SQL.VEHICULO_ELECTRICO
TO REPORTE_WHEELS;

GRANT SELECT ON URBANW_SQL.TIPO_VEHICULO
TO REPORTE_WHEELS;

GRANT SELECT ON URBANW_SQL.FABRICANTE
TO REPORTE_WHEELS;


/* PRIVILEGIOS DML */

GRANT INSERT, UPDATE, DELETE
ON URBANW_SQL.CLIENTE
TO REPORTE_WHEELS;

GRANT INSERT, UPDATE, DELETE
ON URBANW_SQL.EMPLEADO
TO REPORTE_WHEELS;

GRANT INSERT, UPDATE, DELETE
ON URBANW_SQL.REGION
TO REPORTE_WHEELS;

GRANT INSERT, UPDATE, DELETE
ON URBANW_SQL.PORC_BONIF_30_ANNOS
TO REPORTE_WHEELS;



/* =========================================================
   REQUERIMIENTO 2
   REAJUSTE TARIFA VALOR GARANTÍA
   ========================================================= */

/*
   Actualizar el valor_garantia_dia a 5500
   para vehículos:
   - fabricados antes de 2023
   - autonomía menor al promedio
*/

UPDATE VEHICULO_ELECTRICO
SET VALOR_GARANTIA_DIA = 5500
WHERE ANNO_FAB < 2023
AND AUTONOMIA_KM < (
    SELECT AVG(AUTONOMIA_KM)
    FROM VEHICULO_ELECTRICO
);

COMMIT;


/* =========================================================
   CONSULTA DE VERIFICACIÓN
   ========================================================= */

SELECT
    COD_VEHICULO,
    COLOR,
    MODELO,
    AUTONOMIA_KM,
    ANNO_FAB,
    VALOR_ARRIENDO_DIA,
    VALOR_GARANTIA_DIA
FROM VEHICULO_ELECTRICO
ORDER BY COD_VEHICULO;



/* =========================================================
   REQUERIMIENTO 3
   REPORTE MENSUAL DE INGRESOS POR TIPO DE VEHÍCULO
   ========================================================= */

/*
   Vista automatizada para el año anterior
*/

CREATE OR REPLACE VIEW VW_REPORTE_INGRESOS_VEHICULO AS
SELECT
    TV.NOMBRE_TIPO_VEHICULO,
    COUNT(A.COD_ARRIENDO) AS CANTIDAD_ARRIENDOS,
    SUM(A.DIAS_SOLICITADOS) AS TOTAL_DIAS,
    SUM(
        A.DIAS_SOLICITADOS * VE.VALOR_ARRIENDO_DIA
    ) AS INGRESOS_TOTALES
FROM ARRIENDO A
INNER JOIN VEHICULO_ELECTRICO VE
    ON A.COD_VEHICULO = VE.COD_VEHICULO
INNER JOIN TIPO_VEHICULO TV
    ON VE.ID_TIPO_VEHICULO = TV.ID_TIPO_VEHICULO
WHERE EXTRACT(YEAR FROM A.FECHA_INICIO_ARRIENDO) =
      EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY TV.NOMBRE_TIPO_VEHICULO
ORDER BY INGRESOS_TOTALES DESC;


/* =========================================================
   CONSULTA DE LA VISTA
   ========================================================= */

SELECT *
FROM VW_REPORTE_INGRESOS_VEHICULO;



/* =========================================================
   REQUERIMIENTO 4
   OPTIMIZACIÓN DE SENTENCIAS SQL
   ========================================================= */

/* =========================================================
   CONSULTA ORIGINAL
   ========================================================= */

SELECT
    C.NUMRUN_CLI || '-' || C.DVRUN_CLI AS RUT_CLIENTE,
    C.PNOMBRE_CLI || ' ' || C.APPATERNO_CLI AS NOMBRE_COMPLETO,
    C.RENTA,
    TC.NOMBRE_TIPO_CLI AS CATEGORIA
FROM CLIENTE C
INNER JOIN TIPO_CLIENTE TC
    ON C.ID_TIPO_CLI = TC.ID_TIPO_CLI
WHERE EXTRACT(YEAR FROM C.FECHA_NAC_CLI) = 1980
ORDER BY C.RENTA DESC;


/* =========================================================
   CREACIÓN DE ÍNDICE PARA OPTIMIZACIÓN
   ========================================================= */

/*
   Índice basado en función
*/

CREATE INDEX IDX_CLIENTE_FECHA_NAC
ON CLIENTE (
    EXTRACT(YEAR FROM FECHA_NAC_CLI)
);


/* =========================================================
   CONSULTA OPTIMIZADA
   ========================================================= */

SELECT
    C.NUMRUN_CLI || '-' || C.DVRUN_CLI AS RUT_CLIENTE,
    C.PNOMBRE_CLI || ' ' || C.APPATERNO_CLI AS NOMBRE_COMPLETO,
    C.RENTA,
    TC.NOMBRE_TIPO_CLI AS CATEGORIA
FROM CLIENTE C
INNER JOIN TIPO_CLIENTE TC
    ON C.ID_TIPO_CLI = TC.ID_TIPO_CLI
WHERE EXTRACT(YEAR FROM C.FECHA_NAC_CLI) = 1980
ORDER BY C.RENTA DESC;



/* =========================================================
   VISUALIZAR PLAN DE EJECUCIÓN
   ========================================================= */

EXPLAIN PLAN FOR
SELECT
    C.NUMRUN_CLI || '-' || C.DVRUN_CLI AS RUT_CLIENTE,
    C.PNOMBRE_CLI || ' ' || C.APPATERNO_CLI AS NOMBRE_COMPLETO,
    C.RENTA,
    TC.NOMBRE_TIPO_CLI AS CATEGORIA
FROM CLIENTE C
INNER JOIN TIPO_CLIENTE TC
    ON C.ID_TIPO_CLI = TC.ID_TIPO_CLI
WHERE EXTRACT(YEAR FROM C.FECHA_NAC_CLI) = 1980
ORDER BY C.RENTA DESC;


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

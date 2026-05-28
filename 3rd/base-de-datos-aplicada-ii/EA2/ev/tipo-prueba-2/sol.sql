/* =========================================================
   EVALUACIÓN PARCIAL N°2
   CASO HOTEL HLUO
   MOTOR : ORACLE
   ========================================================= */


/* =========================================================
   REQUERIMIENTO 1
   CREACIÓN DE USUARIOS, ROLES Y PRIVILEGIOS
   ========================================================= */


/* =========================================================
   1.1 CREACIÓN DE ROLES
   ========================================================= */

CREATE ROLE ROL_MARKETING_HLUO;

GRANT
    CREATE SESSION,
    CREATE VIEW,
    CREATE SYNONYM
TO ROL_MARKETING_HLUO;



CREATE ROLE ROL_ADMIN_HLUO;

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE VIEW,
    CREATE SEQUENCE,
    CREATE PROCEDURE,
    CREATE TRIGGER,
    CREATE SYNONYM
TO ROL_ADMIN_HLUO;


/* =========================================================
   1.2 CREACIÓN DE USUARIOS
   ========================================================= */

CREATE USER MARKETING_HLUO
IDENTIFIED BY Marketing2025
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;


CREATE USER ADMIN_HLUO
IDENTIFIED BY Admin2025
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;


/* =========================================================
   1.3 ASIGNACIÓN DE ROLES
   ========================================================= */

GRANT ROL_MARKETING_HLUO TO MARKETING_HLUO;

GRANT ROL_ADMIN_HLUO TO ADMIN_HLUO;


/* =========================================================
   1.4 PRIVILEGIOS SOBRE TABLAS
   ========================================================= */

/* PRIVILEGIOS DE CONSULTA */

GRANT SELECT ON HUESPED TO MARKETING_HLUO;
GRANT SELECT ON PROCEDENCIA TO MARKETING_HLUO;
GRANT SELECT ON REGION TO MARKETING_HLUO;
GRANT SELECT ON RESERVA TO MARKETING_HLUO;
GRANT SELECT ON CONSUMO TO MARKETING_HLUO;
GRANT SELECT ON TOUR TO MARKETING_HLUO;


/* PRIVILEGIOS DML */

GRANT INSERT, UPDATE, DELETE
ON INCENTIVOS
TO ADMIN_HLUO;

GRANT INSERT, UPDATE, DELETE
ON DETALLE_DIARIO_HUESPEDES
TO ADMIN_HLUO;


/* =========================================================
   REQUERIMIENTO 2
   ACTUALIZACIÓN DE INCENTIVOS
   ========================================================= */

/*
   Incrementar incentivos de empleados
   pertenecientes a categorías con
   sueldo base bajo el promedio.
*/

UPDATE INCENTIVOS I
SET
    I.ASIGNACION = NVL(I.ASIGNACION,0) + 50000,
    I.BONO = NVL(I.BONO,0) + 25000
WHERE I.RUN_EMPLEADO IN (
    SELECT E.RUN_EMPLEADO
    FROM EMPLEADO E
    WHERE E.SUELDO_BASE < (
        SELECT AVG(SUELDO_BASE)
        FROM EMPLEADO
    )
);

COMMIT;


/* =========================================================
   CONSULTA DE VERIFICACIÓN
   ========================================================= */

SELECT
    I.RUN_EMPLEADO,
    I.FECHA,
    I.ASIGNACION,
    I.BONO
FROM INCENTIVOS I
ORDER BY I.RUN_EMPLEADO;


/* =========================================================
   REQUERIMIENTO 3
   VISTA PARA MARKETING
   ========================================================= */

/*
   Vista para visualizar huéspedes
   por país/región y movimiento
   de reservas.
*/

CREATE OR REPLACE VIEW VW_MOVIMIENTO_HUESPEDES AS
SELECT
    R.NOM_REGION,
    P.NOM_PROCEDENCIA,
    COUNT(H.ID_HUESPED) AS TOTAL_HUESPEDES,
    COUNT(RE.ID_RESERVA) AS TOTAL_RESERVAS
FROM HUESPED H

INNER JOIN PROCEDENCIA P
    ON H.ID_PROCEDENCIA = P.ID_PROCEDENCIA

INNER JOIN REGION R
    ON P.ID_REGION = R.ID_REGION

LEFT JOIN RESERVA RE
    ON H.ID_HUESPED = RE.ID_HUESPED

GROUP BY
    R.NOM_REGION,
    P.NOM_PROCEDENCIA

ORDER BY
    TOTAL_HUESPEDES DESC;


/* =========================================================
   CONSULTA DE LA VISTA
   ========================================================= */

SELECT *
FROM VW_MOVIMIENTO_HUESPEDES;


/* =========================================================
   REQUERIMIENTO 3.2
   VISTA DE DESCUENTOS PARA MARKETING
   ========================================================= */

CREATE OR REPLACE VIEW VW_DESCUENTOS_HUESPEDES AS
SELECT
    H.ID_HUESPED,
    H.NOM_HUESPED || ' ' ||
    H.APPAT_HUESPED AS NOMBRE_COMPLETO,

    TC.MONTO_CONSUMOS,

    ROUND(
        TC.MONTO_CONSUMOS * 0.15
    ) AS DESCUENTO_APLICADO

FROM HUESPED H

INNER JOIN TOTAL_CONSUMOS TC
    ON H.ID_HUESPED = TC.ID_HUESPED

WHERE TC.MONTO_CONSUMOS > (
    SELECT AVG(MONTO_CONSUMOS)
    FROM TOTAL_CONSUMOS
);


/* =========================================================
   CONSULTA DE VALIDACIÓN
   ========================================================= */

SELECT *
FROM VW_DESCUENTOS_HUESPEDES;


/* =========================================================
   REQUERIMIENTO 4
   OPTIMIZACIÓN DE CONSULTAS
   ========================================================= */

/*
   Crear índices para acelerar
   búsquedas frecuentes.
*/


/* =========================================================
   ÍNDICE SOBRE APELLIDO DE HUÉSPED
   ========================================================= */

CREATE INDEX IDX_HUESPED_APELLIDO
ON HUESPED(APPAT_HUESPED);


/* =========================================================
   ÍNDICE SOBRE FECHA DE RESERVA
   ========================================================= */

CREATE INDEX IDX_RESERVA_INGRESO
ON RESERVA(INGRESO);


/* =========================================================
   ÍNDICE SOBRE PROCEDENCIA
   ========================================================= */

CREATE INDEX IDX_HUESPED_PROCEDENCIA
ON HUESPED(ID_PROCEDENCIA);


/* =========================================================
   CONSULTA OPTIMIZADA
   ========================================================= */

SELECT
    H.ID_HUESPED,
    H.NOM_HUESPED,
    H.APPAT_HUESPED,
    P.NOM_PROCEDENCIA,
    R.NOM_REGION
FROM HUESPED H

INNER JOIN PROCEDENCIA P
    ON H.ID_PROCEDENCIA = P.ID_PROCEDENCIA

INNER JOIN REGION R
    ON P.ID_REGION = R.ID_REGION

WHERE H.APPAT_HUESPED LIKE 'A%';


/* =========================================================
   EXPLAIN PLAN
   ========================================================= */

EXPLAIN PLAN FOR

SELECT
    H.ID_HUESPED,
    H.NOM_HUESPED,
    H.APPAT_HUESPED,
    P.NOM_PROCEDENCIA,
    R.NOM_REGION
FROM HUESPED H

INNER JOIN PROCEDENCIA P
    ON H.ID_PROCEDENCIA = P.ID_PROCEDENCIA

INNER JOIN REGION R
    ON P.ID_REGION = R.ID_REGION

WHERE H.APPAT_HUESPED LIKE 'A%';


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY());



/* =========================================================
   REPORTE EXTRA — DETALLE FINANCIERO
   ========================================================= */

SELECT
    H.ID_HUESPED,

    H.NOM_HUESPED || ' ' ||
    H.APPAT_HUESPED AS NOMBRE_COMPLETO,

    DDH.ALOJAMIENTO,
    DDH.CONSUMOS,
    DDH.TOURS,
    DDH.SUBTOTAL_PAGO,
    DDH.DESCUENTO_CONSUMOS,
    DDH.TOTAL

FROM DETALLE_DIARIO_HUESPEDES DDH

INNER JOIN HUESPED H
    ON DDH.ID_HUESPED = H.ID_HUESPED

ORDER BY DDH.TOTAL DESC;



/* =========================================================
   FIN SCRIPT
   ========================================================= */
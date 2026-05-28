-- ==============================================================================
-- REQ 1: CREACIÓN DE USUARIOS, ROLES Y PRIVILEGIOS
-- ==============================================================================

-- 1. Creación de Usuarios
CREATE USER HLUO_ADMIN IDENTIFIED BY "Admin_Hluo2026" 
    DEFAULT TABLESPACE USERS 
    TEMPORARY TABLESPACE TEMP;

CREATE USER HLUO_REPORT IDENTIFIED BY "Report_Hluo2026" 
    DEFAULT TABLESPACE USERS 
    TEMPORARY TABLESPACE TEMP;

-- Otorgar cuotas de espacio en el tablespace
ALTER USER HLUO_ADMIN QUOTA UNLIMITED ON USERS;
ALTER USER HLUO_REPORT QUOTA UNLIMITED ON USERS;

-- Privilegios de conexión para que puedan iniciar sesión
GRANT CREATE SESSION TO HLUO_ADMIN, HLUO_REPORT;

-- 2. Privilegios para HLUO_ADMIN (Dueño del Modelo)
-- Nota: Al crear las tablas en su esquema, automáticamente tiene los derechos
-- para modificarlas (ALTER) o eliminarlas (DROP).
GRANT CREATE TABLE, CREATE SEQUENCE, CREATE INDEX, CREATE SYNONYM TO HLUO_ADMIN;

-- Privilegios para HLUO_REPORT (Desarrollador de Sistemas)
GRANT CREATE PROCEDURE, CREATE MATERIALIZED VIEW TO HLUO_REPORT;

-- 3. Creación y asignación del Rol HLUO_ROL_DEV
CREATE ROLE HLUO_ROL_DEV;
GRANT CREATE SEQUENCE, CREATE VIEW, CREATE INDEX TO HLUO_ROL_DEV;

-- 4. Asignación de Accesos a Datos (De HLUO_ADMIN hacia HLUO_REPORT)
-- Permisos de solo lectura (Consultar)
GRANT SELECT ON HLUO_ADMIN.AGENCIA TO HLUO_REPORT;
GRANT SELECT ON HLUO_ADMIN.CATEGORIA TO HLUO_REPORT;
GRANT SELECT ON HLUO_ADMIN.DETALLE_DIARIO_HUESPEDES TO HLUO_REPORT;
GRANT SELECT ON HLUO_ADMIN.HUESPED TO HLUO_REPORT;
GRANT SELECT ON HLUO_ADMIN.HUESPED_TOUR TO HLUO_REPORT;

-- Permisos de escritura (Modificar, Insertar, Eliminar)
-- Nota: HUESPED_TOUR se solicitó tanto para consulta como para DML.
GRANT INSERT, UPDATE, DELETE ON HLUO_ADMIN.HUESPED_TOUR TO HLUO_REPORT;
GRANT INSERT, UPDATE, DELETE ON HLUO_ADMIN.TOTAL_CONSUMOS TO HLUO_REPORT;
GRANT INSERT, UPDATE, DELETE ON HLUO_ADMIN.CONSUMO TO HLUO_REPORT;
GRANT INSERT, UPDATE, DELETE ON HLUO_ADMIN.INCENTIVOS TO HLUO_REPORT;



-- ==============================================================================
-- REQ 2: INSERCIÓN MASIVA DE INCENTIVOS
-- ==============================================================================
-- Este script procesa el bono para empleados con sueldo base mayor a $350.000.
-- Se recomienda ejecutarlo bajo el esquema dueño de las tablas (HLUO_ADMIN).

INSERT INTO HLUO_ADMIN.INCENTIVOS (RUN_EMPLEADO, FECHA, ASIGNACION, BONO)
SELECT 
    RUN_EMPLEADO,
    TO_CHAR(SYSDATE, 'YYYYMM') AS FECHA, -- Obtiene la fecha de procesamiento en formato YYYYMM
    CASE 
        -- Si existe comisión registrada, se asigna el 15% del sueldo
        WHEN COMISION IS NOT NULL AND COMISION > 0 THEN ROUND(SUELDO_BASE * 0.15)
        -- Si no tiene comisión, se asigna el 7%
        ELSE ROUND(SUELDO_BASE * 0.07)
    END AS ASIGNACION,
    30000 AS BONO -- Bono único y fijo
FROM 
    HLUO_ADMIN.EMPLEADO
WHERE 
    SUELDO_BASE > 350000;

COMMIT;




-- ==============================================================================
-- REQ 3: VISTA DE DESCUENTOS PARA CLIENTES FRECUENTES
-- ==============================================================================
-- Ejecutar conectado como HLUO_REPORT o un usuario con permisos de CREATE ANY VIEW

CREATE OR REPLACE VIEW HLUO_REPORT.V_DESCUENTOS AS
SELECT 
    h.ID_HUESPED,
    -- Concatenación para formato: Nombre Apellido P.
    h.NOM_HUESPED || ' ' || h.APPAT_HUESPED || ' ' || SUBSTR(h.APMAT_HUESPED, 1, 1) || '.' AS HUESPED,
    a.NOM_AGENCIA AS AGENCIA,
    p.NOM_PAIS AS PROCEDENCIA,
    MIN(r.INGRESO) AS PRIMERA_RESERVA,
    MAX(r.INGRESO) AS ULTIMA_RESERVA,
    COUNT(r.ID_RESERVA) AS NRO__RESERVAS,
    -- 20 dólares por cada reserva
    (COUNT(r.ID_RESERVA) * 20) AS DOLARES_DEL_PERIODO,
    -- Conversión a pesos ($980)
    (COUNT(r.ID_RESERVA) * 20 * 980) AS MONTO_EN_PESOS
FROM 
    HLUO_ADMIN.HUESPED h
JOIN 
    HLUO_ADMIN.RESERVA r ON h.ID_HUESPED = r.ID_HUESPED
JOIN 
    HLUO_ADMIN.AGENCIA a ON r.ID_AGENCIA = a.ID_AGENCIA
JOIN 
    HLUO_ADMIN.PAIS p ON h.ID_PAIS = p.ID_PAIS -- Asumiendo relación de procedencia
GROUP BY 
    h.ID_HUESPED, 
    h.NOM_HUESPED, 
    h.APPAT_HUESPED, 
    h.APMAT_HUESPED, 
    a.NOM_AGENCIA, 
    p.NOM_PAIS
HAVING 
    COUNT(r.ID_RESERVA) > 4
WITH READ ONLY; -- Asegura que la vista no permita operaciones DML por seguridad





-- ==============================================================================
-- REQ 4: OPTIMIZACIÓN MEDIANTE ÍNDICES
-- ==============================================================================
-- Ejecutar bajo el esquema HLUO_ADMIN

-- Optimización 1:
-- El plan de ejecución fallaba porque se filtraba por "h.appat_huesped LIKE 'M%'".
-- Creamos un índice normal sobre la columna afectada para cambiar a RANGE SCAN.
CREATE INDEX idx_huesped_cov 
ON HLUO_ADMIN.HUESPED(appat_huesped);

-- Optimización 2:
-- El filtro original utiliza la transformación de las columnas: 
-- to_char(ingreso + estadia, 'MM/YYYY')
-- Para evitar el FULL TABLE SCAN en la tabla RESERVA, creamos un índice basado 
-- exactamente en la misma función matemática/de fecha empleada en el WHERE.
CREATE INDEX IDX_FECRESERVA 
ON HLUO_ADMIN.RESERVA( TO_CHAR(ingreso + estadia, 'MM/YYYY') );
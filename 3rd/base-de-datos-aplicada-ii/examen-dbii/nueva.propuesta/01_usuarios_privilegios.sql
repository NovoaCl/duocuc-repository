-- ============================================================================
-- BDY1102 - BASE DE DATOS APLICADA II
-- EVALUACION FINAL TRANSVERSAL - FORMA D
-- CASO: EVALUACION DE SOLICITUDES DE CREDITO HIPOTECARIO - BANCO AUSTRAL
--
-- PUNTO 1 (enunciado seccion 2): PERFILAMIENTO DE USUARIOS Y ASIGNACION DE
-- PERMISOS
--
-- Orden de ejecucion:
--   1) La seccion "CREACION DE INFRAESTRUCTURA Y USUARIOS" se ejecuta
--      conectado como un usuario con privilegios de administrador (ej. SYSTEM).
--   2) Luego se deben ejecutar base_de_datos.sql y poblado_tablas.sql
--      conectado como BDY1102_ET_FD (segun se indica en esos mismos scripts).
--   3) Finalmente, la seccion "PRIVILEGIOS DE OBJETOS" de este script se
--      ejecuta conectado como BDY1102_ET_FD, ya que es el dueno de las
--      tablas y debe otorgar los privilegios sobre sus propios objetos.
-- ============================================================================


-- ############################################################################
-- SECCION A: CREACION DE INFRAESTRUCTURA Y USUARIOS (conectado como DBA)
-- ############################################################################

-- ----------------------------------------------------------------------------
-- A.1 GESTION DE ESPACIO: TABLESPACES Y CUOTAS
-- ----------------------------------------------------------------------------
CREATE TABLESPACE TBS_BDY1102_DATOS
  DATAFILE 'tbs_bdy1102_datos01.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

CREATE TABLESPACE TBS_BDY1102_DES
  DATAFILE 'tbs_bdy1102_des01.dbf' SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 200M;

-- ----------------------------------------------------------------------------
-- A.2 GESTION DE CONTRASENAS Y LIMITES DE RECURSOS: PROFILES
-- ----------------------------------------------------------------------------

-- Perfil para el usuario dueno del modelo (mayor exigencia de seguridad,
-- ya que administra la estructura completa de la base de datos).
CREATE PROFILE PERF_BDY1102_ET_FD LIMIT
  FAILED_LOGIN_ATTEMPTS   3
  PASSWORD_LOCK_TIME      1
  PASSWORD_LIFE_TIME      60
  PASSWORD_GRACE_TIME     5
  PASSWORD_REUSE_TIME     365
  PASSWORD_REUSE_MAX      5
  SESSIONS_PER_USER       3
  CONNECT_TIME            480
  IDLE_TIME                30
  CPU_PER_SESSION      UNLIMITED;

-- Perfil para el usuario generico del desarrollador.
CREATE PROFILE PERF_BDY1102_ET_FD_DES LIMIT
  FAILED_LOGIN_ATTEMPTS   5
  PASSWORD_LOCK_TIME      1
  PASSWORD_LIFE_TIME      90
  PASSWORD_GRACE_TIME     7
  PASSWORD_REUSE_TIME     180
  PASSWORD_REUSE_MAX      3
  SESSIONS_PER_USER       5
  CONNECT_TIME            600
  IDLE_TIME                60
  CPU_PER_SESSION      UNLIMITED;

-- ----------------------------------------------------------------------------
-- A.3 CREACION DE USUARIOS Y GESTION DEL ESTADO DE LA CUENTA
-- ----------------------------------------------------------------------------
CREATE USER BDY1102_ET_FD
  IDENTIFIED BY "Austral_2026*FD"
  DEFAULT TABLESPACE TBS_BDY1102_DATOS
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FD
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FD QUOTA UNLIMITED ON TBS_BDY1102_DATOS;

CREATE USER BDY1102_ET_FD_DES
  IDENTIFIED BY "Austral_2026*DES"
  DEFAULT TABLESPACE TBS_BDY1102_DES
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FD_DES
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FD_DES QUOTA 200M ON TBS_BDY1102_DES;

-- Se obliga a cambiar la clave en el primer inicio de sesion.
ALTER USER BDY1102_ET_FD PASSWORD EXPIRE;
ALTER USER BDY1102_ET_FD_DES PASSWORD EXPIRE;

-- ----------------------------------------------------------------------------
-- A.4 PRIVILEGIOS DE SISTEMA
-- ----------------------------------------------------------------------------

-- BDY1102_ET_FD: dueno del modelo. Nota: crear un indice sobre una tabla
-- propia no requiere un privilegio de sistema adicional (basta con ser el
-- dueno de la tabla), por eso no se otorga "CREATE INDEX" de forma explicita.
GRANT CREATE SESSION   TO BDY1102_ET_FD;
GRANT CREATE TABLE     TO BDY1102_ET_FD;
GRANT CREATE SEQUENCE  TO BDY1102_ET_FD;
-- CREATE PROCEDURE se otorga unicamente para poder crear el procedimiento
-- auxiliar SP_TRUNCAR_TABLAS_RESULTADO (ver seccion B.3 mas abajo), que
-- encapsula el TRUNCATE de las tablas de resultado sin exponer privilegios
-- de sistema amplios (como DROP ANY TABLE) al usuario BDY1102_ET_FD_DES.
GRANT CREATE PROCEDURE TO BDY1102_ET_FD;

-- BDY1102_ET_FD_DES: usuario generico del desarrollador. Requiere crear
-- vistas y vistas materializadas (requerimiento 3) y, para el proceso
-- PL/SQL (requerimiento 4), poder ejecutar bloques anonimos (no requiere
-- privilegio adicional) e insertar en tablas de registro de errores.
GRANT CREATE SESSION            TO BDY1102_ET_FD_DES;
GRANT CREATE VIEW               TO BDY1102_ET_FD_DES;
GRANT CREATE MATERIALIZED VIEW  TO BDY1102_ET_FD_DES;


-- ############################################################################
-- SECCION B: PRIVILEGIOS DE OBJETOS (conectado como BDY1102_ET_FD, una vez
-- ejecutados base_de_datos.sql y poblado_tablas.sql)
-- ############################################################################

-- ----------------------------------------------------------------------------
-- B.1 CONSULTA DE DATOS (SELECT) - PRIVILEGIOS DIRECTOS, NO POR ROL
-- ----------------------------------------------------------------------------
-- Aunque el conjunto de tablas es "relacionado" (lo que en general sugiere
-- usar un ROL para simplificar la administracion), en este caso puntual la
-- asignacion debe ser DIRECTA (individual) por una razon tecnica de Oracle:
-- los privilegios de objeto recibidos a traves de un ROL NO se consideran
-- validos al COMPILAR una vista, una vista materializada o un procedimiento
-- almacenado sobre objetos de otro esquema (solo se validan en sentencias
-- SQL sueltas ejecutadas dentro de la sesion). Como BDY1102_ET_FD_DES debe
-- crear una vista (requerimiento 3) sobre estas tablas, otorgar el SELECT
-- via ROL provocaria el error ORA-01031 (insufficient privileges) al
-- intentar compilarla. Por eso se aplica el principio de menor privilegio
-- de forma directa, en vez de agrupar en un ROL.
GRANT SELECT ON ANTECEDENTES_CLIENTE      TO BDY1102_ET_FD_DES;
GRANT SELECT ON ANTECEDENTES_LABORALES    TO BDY1102_ET_FD_DES;
GRANT SELECT ON COMUNA                    TO BDY1102_ET_FD_DES;
GRANT SELECT ON PROPIEDAD                 TO BDY1102_ET_FD_DES;
GRANT SELECT ON PROYECTO_INMOBILIARIO     TO BDY1102_ET_FD_DES;
GRANT SELECT ON PTJE_ANNOS_ANTIGUEDAD     TO BDY1102_ET_FD_DES;
GRANT SELECT ON PTJE_TIPO_PROPIEDAD       TO BDY1102_ET_FD_DES;
GRANT SELECT ON PTJE_TIPO_TRABAJADOR      TO BDY1102_ET_FD_DES;
GRANT SELECT ON REGION                    TO BDY1102_ET_FD_DES;
GRANT SELECT ON SOLICITUD_CREDITO         TO BDY1102_ET_FD_DES;
GRANT SELECT ON SUCURSAL                  TO BDY1102_ET_FD_DES;
GRANT SELECT ON TIPO_PROPIEDAD            TO BDY1102_ET_FD_DES;
GRANT SELECT ON TIPO_TRABAJADOR           TO BDY1102_ET_FD_DES;

-- ----------------------------------------------------------------------------
-- B.2 MANTENCION DE RESULTADOS (SELECT / INSERT / UPDATE / DELETE)
-- ----------------------------------------------------------------------------
-- Estas tablas son exclusivas de BDY1102_ET_FD_DES (nadie mas las usa), por
-- lo que crear un rol tampoco aporta reutilizacion; se otorgan de forma
-- individual, cumpliendo el principio de menor privilegio.
GRANT SELECT, INSERT, UPDATE, DELETE ON DETALLE_PUNTAJE_SOLICITUD TO BDY1102_ET_FD_DES;
GRANT SELECT, INSERT, UPDATE, DELETE ON RESULTADO_SOLICITUD        TO BDY1102_ET_FD_DES;

-- ----------------------------------------------------------------------------
-- B.3 SOPORTE PARA EL TRUNCATE DE TABLAS DE RESULTADO (requerimiento 4.1.1)
-- ----------------------------------------------------------------------------
-- TRUNCATE es una sentencia DDL: para truncar una tabla ajena se necesitaria
-- el privilegio de sistema DROP ANY TABLE, demasiado amplio para
-- BDY1102_ET_FD_DES (violaria el principio de menor privilegio, ya que le
-- permitiria eliminar CUALQUIER tabla de CUALQUIER esquema). En su lugar, el
-- dueno del modelo (BDY1102_ET_FD) expone un procedimiento puntual con
-- derechos de definidor (AUTHID DEFINER, comportamiento por defecto), y solo
-- se otorga EXECUTE sobre ese procedimiento especifico.
CREATE OR REPLACE PROCEDURE BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO
IS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PUNTAJE_SOLICITUD';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESULTADO_SOLICITUD';
END SP_TRUNCAR_TABLAS_RESULTADO;
/

GRANT EXECUTE ON BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO TO BDY1102_ET_FD_DES;

-- ----------------------------------------------------------------------------
-- B.4 REGISTRO DE ERRORES DEL PROCESO (requerimiento 4)
-- ----------------------------------------------------------------------------
GRANT INSERT ON ERROR_PROCESO TO BDY1102_ET_FD_DES;
GRANT SELECT ON SEQ_ERROR     TO BDY1102_ET_FD_DES;

COMMIT;

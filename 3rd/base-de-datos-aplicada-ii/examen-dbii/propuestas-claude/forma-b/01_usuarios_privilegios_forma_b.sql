-- ============================================================================
-- BDY1102 - BASE DE DATOS APLICADA II
-- EVALUACION FINAL TRANSVERSAL - FORMA B
-- CASO: BECA DE ESPECIALIDAD MEDICA EN EL EXTRANJERO PARA PROFESIONALES DE
-- LA SALUD PUBLICA - ANID / INFOSOFT
--
-- PUNTO 1 (seccion 1 del enunciado): PERFILAMIENTO DE USUARIOS Y ASIGNACION
-- DE PERMISOS
--
-- NOTA: este script cubre unicamente lo que la semana 17 entrega (contexto
-- + creacion de usuarios y privilegios). Las tablas referenciadas en la
-- seccion B (ANTECEDENTES_LABORALES, ANTECEDENTES_PERSONALES, INSTITUCION,
-- ESPECIALIDAD, PAIS, PROGRAMA_ESPECIALIZACION, POSTULACION_PROGRAMA_ESPEC,
-- PTJE_ANNOS_EXPERIENCIA, PTJE_HORAS_TRABAJO, PTJE_RANKING_INST, REGION,
-- SERVICIO_SALUD, DETALLE_PUNTAJE_POSTULACION, RESULTADO_POSTULACION) deben
-- existir previamente, creadas por BDY1102_ET_FB al ejecutar
-- script_crea_tablas_becas_medicos.sql (entregado en semana 18, segun
-- ANEXO_B_MODELO_BECAS_MEDICOS).
--
-- Orden de ejecucion:
--   1) SECCION A se ejecuta conectado como un usuario con privilegios de
--      administrador (ej. SYSTEM).
--   2) Luego se ejecuta script_crea_tablas_becas_medicos.sql conectado como
--      BDY1102_ET_FB (dueno del modelo).
--   3) Finalmente, la SECCION B de este script se ejecuta conectado como
--      BDY1102_ET_FB, ya que es el dueno de las tablas y debe otorgar los
--      privilegios sobre sus propios objetos.
-- ============================================================================


-- ############################################################################
-- SECCION A: CREACION DE INFRAESTRUCTURA Y USUARIOS (conectado como DBA)
-- ############################################################################

-- ----------------------------------------------------------------------------
-- A.1 GESTION DE ESPACIO: TABLESPACES Y CUOTAS
-- ----------------------------------------------------------------------------
CREATE TABLESPACE TBS_BDY1102_FB_DATOS
  DATAFILE 'tbs_bdy1102_fb_datos01.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

CREATE TABLESPACE TBS_BDY1102_FB_DES
  DATAFILE 'tbs_bdy1102_fb_des01.dbf' SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 200M;

-- ----------------------------------------------------------------------------
-- A.2 GESTION DE CONTRASENAS Y LIMITES DE RECURSOS: PROFILES
-- ----------------------------------------------------------------------------

-- Perfil para el usuario dueno del modelo (mayor exigencia de seguridad,
-- ya que administra la estructura completa de la base de datos).
CREATE PROFILE PERF_BDY1102_ET_FB LIMIT
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
CREATE PROFILE PERF_BDY1102_ET_FB_DES LIMIT
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
CREATE USER BDY1102_ET_FB
  IDENTIFIED BY "Infosoft_2026*FB"
  DEFAULT TABLESPACE TBS_BDY1102_FB_DATOS
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FB
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FB QUOTA UNLIMITED ON TBS_BDY1102_FB_DATOS;

CREATE USER BDY1102_ET_FB_DES
  IDENTIFIED BY "Infosoft_2026*DES"
  DEFAULT TABLESPACE TBS_BDY1102_FB_DES
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FB_DES
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FB_DES QUOTA 200M ON TBS_BDY1102_FB_DES;

-- Se obliga a cambiar la clave en el primer inicio de sesion.
ALTER USER BDY1102_ET_FB PASSWORD EXPIRE;
ALTER USER BDY1102_ET_FB_DES PASSWORD EXPIRE;

-- ----------------------------------------------------------------------------
-- A.4 PRIVILEGIOS DE SISTEMA
-- ----------------------------------------------------------------------------

-- BDY1102_ET_FB: dueno del modelo. Nota: crear un indice sobre una tabla
-- propia no requiere un privilegio de sistema adicional (basta con ser el
-- dueno de la tabla), por eso no se otorga "CREATE INDEX" de forma explicita.
GRANT CREATE SESSION   TO BDY1102_ET_FB;
GRANT CREATE TABLE     TO BDY1102_ET_FB;
GRANT CREATE SEQUENCE  TO BDY1102_ET_FB;
-- CREATE PROCEDURE se otorga de forma preventiva por si el requerimiento 4
-- exige encapsular el TRUNCATE de las tablas de resultado en un
-- procedimiento del dueno (mismo patron utilizado en Forma D), sin exponer
-- privilegios de sistema amplios (como DROP ANY TABLE) al usuario
-- BDY1102_ET_FB_DES. Se debe confirmar/ajustar con el enunciado completo de
-- semana 18.
GRANT CREATE PROCEDURE TO BDY1102_ET_FB;

-- BDY1102_ET_FB_DES: usuario generico del desarrollador. Requiere crear
-- vistas y vistas materializadas (requerimiento 3).
GRANT CREATE SESSION            TO BDY1102_ET_FB_DES;
GRANT CREATE VIEW               TO BDY1102_ET_FB_DES;
GRANT CREATE MATERIALIZED VIEW  TO BDY1102_ET_FB_DES;


-- ############################################################################
-- SECCION B: PRIVILEGIOS DE OBJETOS (conectado como BDY1102_ET_FB, una vez
-- ejecutado script_crea_tablas_becas_medicos.sql)
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
-- SQL sueltas ejecutadas dentro de la sesion). Como BDY1102_ET_FB_DES debe
-- crear una vista (requerimiento 3) sobre estas tablas, otorgar el SELECT
-- via ROL provocaria el error ORA-01031 (insufficient privileges) al
-- intentar compilarla. Por eso se aplica el principio de menor privilegio
-- de forma directa, en vez de agrupar en un ROL.
GRANT SELECT ON ANTECEDENTES_LABORALES        TO BDY1102_ET_FB_DES;
GRANT SELECT ON ANTECEDENTES_PERSONALES       TO BDY1102_ET_FB_DES;
GRANT SELECT ON INSTITUCION                   TO BDY1102_ET_FB_DES;
GRANT SELECT ON ESPECIALIDAD                  TO BDY1102_ET_FB_DES;
GRANT SELECT ON PAIS                          TO BDY1102_ET_FB_DES;
GRANT SELECT ON PROGRAMA_ESPECIALIZACION      TO BDY1102_ET_FB_DES;
GRANT SELECT ON POSTULACION_PROGRAMA_ESPEC    TO BDY1102_ET_FB_DES;
GRANT SELECT ON PTJE_ANNOS_EXPERIENCIA        TO BDY1102_ET_FB_DES;
GRANT SELECT ON PTJE_HORAS_TRABAJO            TO BDY1102_ET_FB_DES;
GRANT SELECT ON PTJE_RANKING_INST             TO BDY1102_ET_FB_DES;
GRANT SELECT ON REGION                        TO BDY1102_ET_FB_DES;
GRANT SELECT ON SERVICIO_SALUD                TO BDY1102_ET_FB_DES;

-- ----------------------------------------------------------------------------
-- B.2 MANTENCION DE RESULTADOS (SELECT / INSERT / UPDATE / DELETE)
-- ----------------------------------------------------------------------------
-- Estas tablas son exclusivas de BDY1102_ET_FB_DES (nadie mas las usa), por
-- lo que crear un rol tampoco aporta reutilizacion; se otorgan de forma
-- individual, cumpliendo el principio de menor privilegio.
GRANT SELECT, INSERT, UPDATE, DELETE ON DETALLE_PUNTAJE_POSTULACION TO BDY1102_ET_FB_DES;
GRANT SELECT, INSERT, UPDATE, DELETE ON RESULTADO_POSTULACION        TO BDY1102_ET_FB_DES;

COMMIT;

-- ============================================================================
-- PENDIENTE PARA COMPLETAR EL EXAMEN (se resuelve con el material de semana 18):
--
-- * Confirmar si el modelo de datos incluye una tabla de registro de errores
--   (equivalente a ERROR_PROCESO en Forma D) y su secuencia asociada, para
--   otorgar los INSERT/SELECT correspondientes a BDY1102_ET_FB_DES.
-- * Confirmar si el requerimiento 4 exige truncar DETALLE_PUNTAJE_POSTULACION
--   y RESULTADO_POSTULACION; de ser asi, replicar el patron de Forma D:
--   procedimiento SP_TRUNCAR_TABLAS_RESULTADO_POSTULACION creado por
--   BDY1102_ET_FB (AUTHID DEFINER) con EXECUTE otorgado a BDY1102_ET_FB_DES,
--   en vez de otorgar DROP ANY TABLE.
-- * Con las reglas de negocio de puntaje (horas de trabajo, anos de
--   experiencia, ranking de la institucion) se construiran los scripts 2, 3
--   y 4 analogos a los de Forma D (informe de postulantes, proceso PL/SQL de
--   puntaje, e informe de revision con EXPLAIN PLAN e indices).
-- ============================================================================

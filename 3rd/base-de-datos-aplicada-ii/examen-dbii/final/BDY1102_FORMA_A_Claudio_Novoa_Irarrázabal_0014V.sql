-- Claudio Novoa Irarrázabal
-------------------------------------------------------------
-- 1. Generacion de usuarios

-- TableSpace

CREATE TABLESPACE TBS_BDY1102_DATOS
  DATAFILE 'tbs_bdy1102_datos01.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
  
CREATE TABLESPACE TBS_BDY1102_DES
  DATAFILE 'tbs_bdy1102_des01.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

-- Creacion de perfiles y limites de recursos

CREATE PROFILE PERF_BDY1102_ET_FA LIMIT
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

  CREATE PROFILE PERF_BDY1102_ET_FA_DES LIMIT
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
 
  
-- Creacion de usuario y modificacion de la cuota

-- Dueño de la db
CREATE USER BDY1102_ET_FD
  IDENTIFIED BY "123456"
  DEFAULT TABLESPACE TBS_BDY1102_DATOS
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FD
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FD QUOTA UNLIMITED ON TBS_BDY1102_DATOS;
ALTER USER BDY1102_ET_FD PASSWORD EXPIRE; -- pide un cmabio de contraseÃ±a al iniciar

-- Desarrollador
CREATE USER BDY1102_ET_FD_DES
  IDENTIFIED BY "123456"
  DEFAULT TABLESPACE TBS_BDY1102_DES
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FD_DES
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FD QUOTA UNLIMITED ON TBS_BDY1102_DATOS;
ALTER USER BDY1102_ET_FD PASSWORD EXPIRE; -- pide un cmabio de contraseÃ±a al iniciar

-- Privilegios por usuario:

-- DueÃ±o de la base de datos
GRANT CREATE SESSION   TO BDY1102_ET_FD;
GRANT CREATE TABLE     TO BDY1102_ET_FD;
GRANT CREATE SEQUENCE  TO BDY1102_ET_FD;

GRANT CREATE PROCEDURE TO BDY1102_ET_FD;

-- Usuario generico para desarrollo.

GRANT CREATE SESSION            TO BDY1102_ET_FD_DES;
GRANT CREATE VIEW               TO BDY1102_ET_FD_DES;
GRANT CREATE MATERIALIZED VIEW  TO BDY1102_ET_FD_DES;

-- Permisos necesarios para el desarrollo
GRANT SELECT ON ANTECEDENTES_LABORALES       TO BDY1102_ET_FD_DES;
GRANT SELECT ON ANTECEDENTES_PERSONALES      TO BDY1102_ET_FD_DES;
GRANT SELECT ON INSTITUCION                  TO BDY1102_ET_FD_DES;
GRANT SELECT ON PAIS                         TO BDY1102_ET_FD_DES;
GRANT SELECT ON PASANTIA_PERFECCIONAMIENTO   TO BDY1102_ET_FD_DES;
GRANT SELECT ON POSTULACION_PASANTIA_PERFEC  TO BDY1102_ET_FD_DES;
GRANT SELECT ON PTJE_ANNOS_EXPERIENCIA       TO BDY1102_ET_FD_DES;
GRANT SELECT ON PTJE_PAIS_POSTULA            TO BDY1102_ET_FD_DES;
GRANT SELECT ON PTJE_PUEBLO_INDIGENA         TO BDY1102_ET_FD_DES;
GRANT SELECT ON PUEBLO_INDIGENA              TO BDY1102_ET_FD_DES;
GRANT SELECT ON REGION                       TO BDY1102_ET_FD_DES;
GRANT SELECT ON SERVICIO_LOCAL_EDUCP         TO BDY1102_ET_FD_DES;


GRANT SELECT, INSERT, UPDATE, DELETE ON DETALLE_PUNTAJE_POSTULACION  TO BDY1102_ET_FD_DES;
GRANT SELECT, INSERT, UPDATE, DELETE ON RESULTADO_POSTULACION        TO BDY1102_ET_FA_DES;

-- Control de errores
GRANT INSERT ON ERROR_PROCESO TO BDY1102_ET_FD_DES;
GRANT SELECT ON SEQ_ERROR     TO BDY1102_ET_FD_DES;


-- Truncamiento de tablas y permiso al dev para ejecutarla
CREATE OR REPLACE PROCEDURE BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO
IS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PUNTAJE_POSTULACION';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESULTADO_POSTULACION';
END SP_TRUNCAR_TABLAS_RESULTADO;
/

GRANT EXECUTE ON BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO TO BDY1102_ET_FD_DES;


---------------------------------------------------------------------------------------------
-- 2. Generacion de informe con vistas:
-- IMPORTANTE: Correr desde el perfil de desarrollador.

CREATE OR REPLACE VIEW VW_INFORME_SOLICITANTES AS
SELECT
    ap.numrun || '-' || ap.dvrun                                    AS run_dv,
    ap.apaterno,
    ap.amaterno,
    ap.pnombre || NVL2(ap.snombre, ' ' || ap.snombre, '')           AS nombres,
    ap.fecha_nacimiento,
    pi.nombre_pueblo_ind,
    instituciones.cant_instituciones,
    SUBSTR(ap.numrun, 4) 
    || TRUNC(EXTRACT(YEAR FROM ap.fecha_nacimiento) * 0.70)         
    || (SUBSTR(ap.numrun, -3, 3) - 1) 
    ||
    CASE WHEN ap.cod_pueblo_ind = null                       
             THEN UPPER(SUBSTR(ap.apaterno, 1, 2))
             ELSE SUBSTR(ap.amaterno, 1, 2)
    END
    || '@direduca.edu'                                            AS correo
    
FROM BDY1102_ET_FD.ANTECEDENTES_PERSONALES ap
JOIN BDY1102_ET_FD.PUEBLO_INDIGENA pi
  ON pi.cod_pueblo_ind = ap.cod_pueblo_ind
JOIN (
    SELECT numrun, COUNT(*) AS cant_instituciones
    FROM   BDY1102_ET_FD.ANTECEDENTES_LABORALES
    GROUP BY numrun
) instituciones
  ON instituciones.numrun = ap.numrun
ORDER BY ap.apaterno, ap.amaterno, ap.pnombre;


---------------------------------------------------------------------------------------
-- 3. Bloque anonimo

SET SERVEROUTPUT ON;

DECLARE

    CURSOR cur_solicitantes IS
        SELECT ap.numrun,
               ap.dvrun,
               ap.pnombre,
               ap.snombre,
               ap.apaterno,
               ap.amaterno,
               ap.fecha_nacimiento,
               ap.cod_pueblo_ind,
               pp.cod_programa
        FROM   ANTECEDENTES_PERSONALES ap
        JOIN   POSTULACION_PASANTIA_PERFEC pp ON ap.numrun = pp.numrun;

    v_run_postulante       VARCHAR2(13);
    v_nombre_postulante    VARCHAR2(60);
    v_ptje_pueblo_ind      PTJE_PUEBLO_INDIGENA.ptje_pueblo_ind%TYPE;
    v_fecha_contrato_min   ANTECEDENTES_LABORALES.fecha_contrato%TYPE;
    v_anios_antiguedad     NUMBER;
    v_ptje_experiencia      PTJE_ANNOS_EXPERIENCIA.ptje_experiencia%TYPE;
    v_ptje_pais            PTJE_PAIS_POSTULA.ptje_pais%TYPE;
    v_edad                 NUMBER;
    v_ptje_extra           NUMBER := 0;
    v_ptje_final           NUMBER;
    v_resultado            VARCHAR2(20);
    v_msj_error            VARCHAR2(200);


BEGIN
-- Hay un PROCEDURE en la seccion de la creacion de usuarios. Desde ahi se truncan las tablas
    BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO;

    FOR sol IN cur_solicitantes LOOP

        BEGIN 

            v_ptje_extra := 0;

            v_run_postulante    := sol.numrun || '-' || sol.dvrun;
            v_nombre_postulante := SUBSTR(
                                   sol.pnombre || NVL2(sol.snombre, ' ' || sol.snombre, '')
                                   || ' ' || sol.apaterno || ' ' || sol.amaterno,
                                   1, 60);

            SELECT ptje_pueblo_ind
            INTO   v_ptje_pueblo_ind
            FROM   BDY1102_ET_FD.PTJE_PUEBLO_INDIGENA
            WHERE  cod_pueblo_ind = sol.cod_pueblo_ind;

 
            SELECT MIN(fecha_contrato)
            INTO   v_fecha_contrato_min
            FROM   BDY1102_ET_FD.ANTECEDENTES_LABORALES
            WHERE  numrun = sol.numrun;

            v_anios_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_contrato_min) / 12);

            SELECT ptje_experiencia
            INTO   v_ptje_experiencia
            FROM   BDY1102_ET_FD.PTJE_ANNOS_EXPERIENCIA
            WHERE  v_anios_antiguedad BETWEEN rango_annos_ini AND rango_annos_ter;


            SELECT  pp.ptje_pais
            INTO    v_ptje_pais
            FROM   BDY1102_ET_FD.PTJE_PAIS_POSTULA pp
            JOIN   PROYECTO_INMOBILIARIO pi ON pi.cod_tipo_prop = pt.cod_tipo_prop
            JOIN   PAIS p             ON p.cod_pais= pi.cod_pais
            WHERE  p.cod_pais= sol.cod_pais;


            SELECT pt.ptje_tipo_prop
            INTO   v_ptje_tipo_prop
            FROM   BDY1102_ET_FD.PTJE_TIPO_PROPIEDAD pt
            JOIN   PROYECTO_INMOBILIARIO pi ON pi.cod_tipo_prop = pt.cod_tipo_prop
            JOIN   PROPIEDAD pr             ON pr.cod_proyecto  = pi.cod_proyecto
            WHERE  pr.cod_propiedad = sol.cod_propiedad;

            v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, sol.fecha_nacimiento) / 12);

            IF v_edad >= 55 THEN
                v_ptje_extra := ROUND((ptje_pueblo_ind + ptje_experiencia + ptje_pais) * 0.15);
            ELSE
                v_ptje_extra := 0;
            END IF;

        
            v_ptje_final := ROUND(ptje_pueblo_ind + ptje_experiencia + ptje_pais + v_ptje_extra);

            IF v_ptje_final >= 2400 THEN
                v_resultado := 'SELECCIONADO';
            ELSE
                v_resultado := 'NO SELECCIONADO';
            END IF;

            INSERT INTO BDY1102_ET_FD.DETALLE_PUNTAJE_POSTULACION
                (run_postulante, nombre_postulante, ptje_pueblo_ind,
                 ptje_experiencia, ptje_pais, ptje_extra)
            VALUES
                (v_run_postulante, v_nombre_postulante, v_ptje_pueblo_ind,
                 v_ptje_experiencia, v_ptje_pais, v_ptje_extra);

            INSERT INTO BDY1102_ET_FD.RESULTADO_POSTULACION
                (run_postulante, ptje_final_sol, resultado_sol)
            VALUES
                (v_run_postulante, v_ptje_final, v_resultado);


        EXCEPTION
            WHEN OTHERS THEN
                v_msj_error := SUBSTR(SQLERRM, 1, 200);
                INSERT INTO BDY1102_ET_FD.ERROR_PROCESO(id_error, rutina_error, descrip_error)
                VALUES (SEQ_ERROR.NEXTVAL,
                        'Calculo',
                        'Error procesando cliente RUN ' || sol.numrun || '-' || sol.dvrun ||
                        ': ' || v_msj_error);
        END;

    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso de calculo finalizado.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_msj_error := SUBSTR(SQLERRM, 1, 200);
        INSERT INTO BDY1102_ET_FD.ERROR_PROCESO(id_error, rutina_error, descrip_error)
        VALUES (SEQ_ERROR.NEXTVAL, 'SP_CALCULO_PUNTAJE',
                'Error general del proceso: ' ||v_msj_error);
        COMMIT;
END;
/

-- No alcance a resolver como llamar pais ni el informe final... Saludos profesor




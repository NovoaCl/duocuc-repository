-- Creación de usuario:

ALTER SESSION SET CONTAINER = XEPDB1;

CREATE USER clnov 
IDENTIFIED BY "123456" 
DEFAULT TABLESPACE "USERS" 
TEMPORARY TABLESPACE "TEMP";

ALTER USER clnov QUOTA UNLIMITED ON USERS;


GRANT CREATE SESSION TO clnov;
GRANT "RESOURCE" TO clnov;
ALTER USER clnov DEFAULT ROLE "RESOURCE";

-- TableSpace

CREATE TABLESPACE TBS_BDY1102_DATOS
  DATAFILE 'tbs_bdy1102_datos01.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

-- Creación de perfiles y limites de recursos

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

-- Creación de usuario y modificación de l a cuota

CREATE USER BDY1102_ET_FD
  IDENTIFIED BY "Austral_2026*FD"
  DEFAULT TABLESPACE TBS_BDY1102_DATOS
  TEMPORARY TABLESPACE TEMP
  PROFILE PERF_BDY1102_ET_FD
  ACCOUNT UNLOCK;

ALTER USER BDY1102_ET_FD QUOTA UNLIMITED ON TBS_BDY1102_DATOS;
ALTER USER BDY1102_ET_FD PASSWORD EXPIRE; -- pide un cmabio de contraseña al iniciar

-- Privilegios por usuario:

-- Dueño de la base de datos
GRANT CREATE SESSION   TO BDY1102_ET_FD;
GRANT CREATE TABLE     TO BDY1102_ET_FD;
GRANT CREATE SEQUENCE  TO BDY1102_ET_FD;

GRANT CREATE PROCEDURE TO BDY1102_ET_FD;

-- Usuario generico para desarrollo.

GRANT CREATE SESSION            TO BDY1102_ET_FD_DES;
GRANT CREATE VIEW               TO BDY1102_ET_FD_DES;
GRANT CREATE MATERIALIZED VIEW  TO BDY1102_ET_FD_DES;

-- Permisos necesarios
GRANT SELECT ON ANTECEDENTES_CLIENTE      TO BDY1102_ET_FD_DES;
--
--
--
GRANT SELECT, INSERT, UPDATE, DELETE ON DETALLE_PUNTAJE_SOLICITUD TO BDY1102_ET_FD_DES;
GRANT SELECT, INSERT, UPDATE, DELETE ON RESULTADO_POSTULACION        TO BDY1102_ET_FA_DES;
-- Control de errores
GRANT INSERT ON ERROR_PROCESO TO BDY1102_ET_FD_DES;
GRANT SELECT ON SEQ_ERROR     TO BDY1102_ET_FD_DES;


-- Truncamiento de tablas y permiso al dev para ejecutarla
CREATE OR REPLACE PROCEDURE BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO
IS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PUNTAJE_SOLICITUD';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESULTADO_SOLICITUD';
END SP_TRUNCAR_TABLAS_RESULTADO;
/

GRANT EXECUTE ON BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO TO BDY1102_ET_FD_DES;

------------------------------------------------------------------------------------------------------

-- 2. Generacion de informe con vistas:

CREATE OR REPLACE VIEW VW_INFORME_SOLICITANTES AS
SELECT
    ac.numrun || '-' || ac.dvrun                                    AS run_dv,
    ac.apaterno,
    ac.amaterno,
    ac.pnombre || NVL2(ac.snombre, ' ' || ac.snombre, '')           AS nombres,
    ac.fecha_nacimiento,
    tt.desc_tipo_trab,
    empleos.cant_empleos,
    LOWER(
        CASE WHEN ac.cod_tipo_trab IN (10, 20)                       -- dependiente
             THEN SUBSTR(ac.apaterno, 1, 3)
             ELSE SUBSTR(ac.amaterno, 1, 3)
        END
    )
    || '-'
    || TRUNC(EXTRACT(YEAR FROM ac.fecha_nacimiento) * 1.25)          -- anno nac. + 25%, truncado
    || '-'
    || TO_CHAR(MOD(ac.numrun, 100) + 2)                              -- 2 ultimos digitos del run + 2
    || '@bancoaustral.cl'                                            AS correo_banca_linea
FROM BDY1102_ET_FD.ANTECEDENTES_CLIENTE ac
JOIN BDY1102_ET_FD.TIPO_TRABAJADOR tt
  ON tt.cod_tipo_trab = ac.cod_tipo_trab
JOIN (
    SELECT numrun, COUNT(*) AS cant_empleos
    FROM   BDY1102_ET_FD.ANTECEDENTES_LABORALES
    GROUP BY numrun
) empleos
  ON empleos.numrun = ac.numrun
ORDER BY ac.apaterno, ac.amaterno, ac.pnombre;

--------------------------------------------------------------------------
-- 3. Bloque anonimo 

SET SERVEROUTPUT ON;

DECLARE

    CURSOR cur_solicitantes IS
        SELECT ac.numrun,
               ac.dvrun,
               ac.pnombre,
               ac.snombre,
               ac.apaterno,
               ac.amaterno,
               ac.fecha_nacimiento,
               ac.cod_tipo_trab,
               sc.cod_propiedad
        FROM   BDY1102_ET_FD.ANTECEDENTES_CLIENTE ac
        JOIN   BDY1102_ET_FD.SOLICITUD_CREDITO sc ON sc.numrun = ac.numrun;

    v_run_cliente         VARCHAR2(13);
    v_nombre_cliente       VARCHAR2(60);
    v_ptje_tipo_trab       BDY1102_ET_FD.PTJE_TIPO_TRABAJADOR.ptje_tipo_trab%TYPE;
    v_fecha_contrato_min   BDY1102_ET_FD.ANTECEDENTES_LABORALES.fecha_contrato%TYPE;
    v_anios_antiguedad     NUMBER;
    v_ptje_antiguedad      BDY1102_ET_FD.PTJE_ANNOS_ANTIGUEDAD.ptje_antiguedad%TYPE;
    v_ptje_tipo_prop       BDY1102_ET_FD.PTJE_TIPO_PROPIEDAD.ptje_tipo_prop%TYPE;
    v_edad                 NUMBER;
    v_ptje_extra           NUMBER := 0;
    v_ptje_final           NUMBER;
    v_resultado            VARCHAR2(20);
    v_msj_error            VARCHAR2(200);

BEGIN

    BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO;

    FOR sol IN cur_solicitantes LOOP

        BEGIN 

            v_ptje_extra := 0;

            v_run_cliente    := sol.numrun || '-' || sol.dvrun;
            v_nombre_cliente := SUBSTR(
                                   sol.pnombre || NVL2(sol.snombre, ' ' || sol.snombre, '')
                                   || ' ' || sol.apaterno || ' ' || sol.amaterno,
                                   1, 60);

            SELECT ptje_tipo_trab
            INTO   v_ptje_tipo_trab
            FROM   BDY1102_ET_FD.PTJE_TIPO_TRABAJADOR
            WHERE  cod_tipo_trab = sol.cod_tipo_trab;


            SELECT MIN(fecha_contrato)
            INTO   v_fecha_contrato_min
            FROM   BDY1102_ET_FD.ANTECEDENTES_LABORALES
            WHERE  numrun = sol.numrun;

            v_anios_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_contrato_min) / 12);

            SELECT ptje_antiguedad
            INTO   v_ptje_antiguedad
            FROM   BDY1102_ET_FD.PTJE_ANNOS_ANTIGUEDAD
            WHERE  v_anios_antiguedad BETWEEN rango_annos_ini AND rango_annos_ter;

            SELECT pt.ptje_tipo_prop
            INTO   v_ptje_tipo_prop
            FROM   BDY1102_ET_FD.PTJE_TIPO_PROPIEDAD pt
            JOIN   BDY1102_ET_FD.PROYECTO_INMOBILIARIO pi ON pi.cod_tipo_prop = pt.cod_tipo_prop
            JOIN   BDY1102_ET_FD.PROPIEDAD pr             ON pr.cod_proyecto  = pi.cod_proyecto
            WHERE  pr.cod_propiedad = sol.cod_propiedad;

            v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, sol.fecha_nacimiento) / 12);

            IF v_edad <= 40 THEN
                v_ptje_extra := ROUND((v_ptje_tipo_trab + v_ptje_antiguedad + v_ptje_tipo_prop) * 0.12);
            ELSE
                v_ptje_extra := 0;
            END IF;

        
            v_ptje_final := ROUND(v_ptje_tipo_trab + v_ptje_antiguedad + v_ptje_tipo_prop + v_ptje_extra);

            IF v_ptje_final >= 2500 THEN
                v_resultado := 'APROBADO';
            ELSE
                v_resultado := 'RECHAZADO';
            END IF;

            INSERT INTO BDY1102_ET_FD.DETALLE_PUNTAJE_SOLICITUD
                (run_cliente, nombre_cliente, ptje_tipo_trabajador,
                 ptje_antiguedad_lab, ptje_tipo_propiedad, ptje_extra)
            VALUES
                (v_run_cliente, v_nombre_cliente, v_ptje_tipo_trab,
                 v_ptje_antiguedad, v_ptje_tipo_prop, v_ptje_extra);

            INSERT INTO BDY1102_ET_FD.RESULTADO_SOLICITUD
                (run_cliente, ptje_final_sol, resultado_sol)
            VALUES
                (v_run_cliente, v_ptje_final, v_resultado);

        EXCEPTION
            WHEN OTHERS THEN
                v_msj_error := SUBSTR(SQLERRM, 1, 200);
                INSERT INTO BDY1102_ET_FD.ERROR_PROCESO(id_error, rutina_error, descrip_error)
                VALUES (BDY1102_ET_FD.SEQ_ERROR.NEXTVAL,
                        'SP_CALCULO_PUNTAJE_PREAPROBACION',
                        'Error procesando cliente RUN ' || sol.numrun || '-' || sol.dvrun ||
                        ': ' || v_mens_error);
        END;

    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso de calculo de puntaje de pre-aprobacion finalizado.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_msj_error := SUBSTR(SQLERRM, 1, 200);
        INSERT INTO BDY1102_ET_FD.ERROR_PROCESO(id_error, rutina_error, descrip_error)
        VALUES (BDY1102_ET_FD.SEQ_ERROR.NEXTVAL, 'SP_CALCULO_PUNTAJE_PREAPROBACION',
                'Error general del proceso: ' || v_menj_error);
        COMMIT;
END;
/


----------------------------------------------------------------------------------------------------------

-- 4. Planes e indices para su optimizacion:

EXPLAIN PLAN FOR
SELECT ac.apaterno,
       ac.amaterno,
       ac.pnombre || NVL2(ac.snombre, ' ' || ac.snombre, '') AS nombre_cliente,
       rs.ptje_final_sol,
       dp.ptje_tipo_trabajador,
       dp.ptje_antiguedad_lab,
       dp.ptje_tipo_propiedad,
       dp.ptje_extra
FROM   RESULTADO_SOLICITUD rs
JOIN   DETALLE_PUNTAJE_SOLICITUD dp
       ON dp.run_cliente = rs.run_cliente
JOIN   ANTECEDENTES_CLIENTE ac
       ON (ac.numrun || '-' || ac.dvrun) = rs.run_cliente
WHERE  rs.ptje_final_sol > (SELECT AVG(ptje_final_sol) FROM RESULTADO_SOLICITUD)
ORDER  BY rs.ptje_final_sol DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


CREATE INDEX IX_RESULTADO_SOL_RUN ON RESULTADO_SOLICITUD(run_cliente);
CREATE INDEX IX_DETALLE_PTJE_RUN  ON DETALLE_PUNTAJE_SOLICITUD(run_cliente);


CREATE INDEX IX_RESULTADO_SOL_PTJE ON RESULTADO_SOLICITUD(ptje_final_sol);


CREATE INDEX IX_ANTCLI_RUN_DV_FBI ON ANTECEDENTES_CLIENTE(numrun || '-' || dvrun);




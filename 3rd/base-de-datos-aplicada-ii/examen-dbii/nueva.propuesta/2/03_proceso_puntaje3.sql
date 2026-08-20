-- ============================================================================
-- BDY1102 - BASE DE DATOS APLICADA II
-- EVALUACION FINAL TRANSVERSAL - FORMA D
-- CASO: EVALUACION DE SOLICITUDES DE CREDITO HIPOTECARIO - BANCO AUSTRAL
--
-- PUNTO 3 (enunciado seccion 4.1): PROCESO PL/SQL - CALCULO DEL PUNTAJE DE
-- PRE-APROBACION
-- Ejecutar conectado como BDY1102_ET_FD_DES
-- ============================================================================

SET SERVEROUTPUT ON;

DECLARE

    -- NOTA IMPORTANTE: todas las tablas de este bloque se referencian
    -- calificadas con el esquema BDY1102_ET_FD (su dueno). El privilegio
    -- SELECT otorgado a BDY1102_ET_FD_DES no crea un sinonimo ni cambia la
    -- resolucion de nombres; sin el prefijo de esquema, Oracle busca la
    -- tabla en el esquema del usuario conectado (BDY1102_ET_FD_DES), donde
    -- no existe, y arroja ORA-00942. Ver 02_informe_solicitantes.sql para
    -- el mismo detalle aplicado a la vista.

    -- Cursor con todos los clientes que registran una solicitud de credito
    -- hipotecario (regla 4.1.1: se procesan todos los clientes con solicitud)
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

    -- Se truncan las tablas de resultado del proceso (regla 4.1.1) a traves
    -- del procedimiento del dueno del modelo (BDY1102_ET_FD_DES no tiene
    -- privilegios de sistema para truncar tablas ajenas; ver
    -- 01_usuarios_privilegios.sql, seccion B.3).
    BDY1102_ET_FD.SP_TRUNCAR_TABLAS_RESULTADO;

    FOR sol IN cur_solicitantes LOOP

        BEGIN -- Bloque interno: un error en un solicitante no detiene el proceso completo

            v_ptje_extra := 0;

            v_run_cliente    := sol.numrun || '-' || sol.dvrun;
            v_nombre_cliente := SUBSTR(
                                   sol.pnombre || NVL2(sol.snombre, ' ' || sol.snombre, '')
                                   || ' ' || sol.apaterno || ' ' || sol.amaterno,
                                   1, 60);

            -- 1) Puntaje por tipo de trabajador (regla 1.1) - SELECT individual
            SELECT ptje_tipo_trab
            INTO   v_ptje_tipo_trab
            FROM   BDY1102_ET_FD.PTJE_TIPO_TRABAJADOR
            WHERE  cod_tipo_trab = sol.cod_tipo_trab;

            -- 2) Puntaje por antiguedad laboral (regla 1.2) - SELECT individual
            --    Se considera siempre la fecha de contrato mas antigua entre
            --    todos los empleos que el cliente haya registrado.
            SELECT MIN(fecha_contrato)
            INTO   v_fecha_contrato_min
            FROM   BDY1102_ET_FD.ANTECEDENTES_LABORALES
            WHERE  numrun = sol.numrun;

            v_anios_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_contrato_min) / 12);

            SELECT ptje_antiguedad
            INTO   v_ptje_antiguedad
            FROM   BDY1102_ET_FD.PTJE_ANNOS_ANTIGUEDAD
            WHERE  v_anios_antiguedad BETWEEN rango_annos_ini AND rango_annos_ter;

            -- 3) Puntaje por tipo de propiedad (regla 1.3) - SELECT individual
            SELECT pt.ptje_tipo_prop
            INTO   v_ptje_tipo_prop
            FROM   BDY1102_ET_FD.PTJE_TIPO_PROPIEDAD pt
            JOIN   BDY1102_ET_FD.PROYECTO_INMOBILIARIO pi ON pi.cod_tipo_prop = pt.cod_tipo_prop
            JOIN   BDY1102_ET_FD.PROPIEDAD pr             ON pr.cod_proyecto  = pi.cod_proyecto
            WHERE  pr.cod_propiedad = sol.cod_propiedad;

            -- 4) Puntaje adicional por edad <= 40 (regla 1.4): 12% de la suma
            --    de los 3 puntajes anteriores, redondeado.
            v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, sol.fecha_nacimiento) / 12);

            IF v_edad <= 40 THEN
                v_ptje_extra := ROUND((v_ptje_tipo_trab + v_ptje_antiguedad + v_ptje_tipo_prop) * 0.12);
            ELSE
                v_ptje_extra := 0;
            END IF;

            -- Puntaje final (todos los calculos redondeados, regla 4.1.1)
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
                -- SQLERRM es una funcion exclusiva de PL/SQL: no puede
                -- invocarse directamente dentro de una sentencia SQL (como
                -- el INSERT de abajo), porque el motor SQL la interpreta
                -- como un nombre de columna inexistente (ORA-00984). Por
                -- eso se captura primero en una variable PL/SQL.
                v_msj_error := SUBSTR(SQLERRM, 1, 200);
                INSERT INTO BDY1102_ET_FD.ERROR_PROCESO(id_error, rutina_error, descrip_error)
                VALUES (BDY1102_ET_FD.SEQ_ERROR.NEXTVAL,
                        'SP_CALCULO_PUNTAJE_PREAPROBACION',
                        'Error procesando cliente RUN ' || sol.numrun || '-' || sol.dvrun ||
                        ': ' || v_msj_error);
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
                'Error general del proceso: ' || v_msj_error);
        COMMIT;
END;
/

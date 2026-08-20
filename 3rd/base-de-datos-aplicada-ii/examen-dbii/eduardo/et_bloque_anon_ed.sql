--ALTER SESSION SET CURRENT_SCHEMA = BDY1102_ET_FD;

--SELECT * FROM SOLICITUD_CREDITO sc;
--SELECT * FROM ANTECEDENTES_LABORALES al;
--SELECT * FROM ANTECEDENTES_LABORALES al;
--SELECT * FROM ANTECEDENTES_CLIENTE ac;
--SELECT * FROM PTJE_TIPO_TRABAJADOR ptt;
--SELECT * FROM PTJE_ANNOS_ANTIGUEDAD paa;
--SELECT * FROM PTJE_TIPO_PROPIEDAD ptp;
--SELECT * FROM RESULTADO_SOLICITUD rs;

-- Buscar: cod_tipo_trab, antiguedad laboral, tipo propiedad, edad
--SELECT
--  cod_tipo_trab
--  ,TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nacimiento) / 12) AS "EDAD"
--FROM ANTECEDENTES_CLIENTE WHERE numrun = '12456789';
--SELECT MIN(FECHA_CONTRATO) FROM antecedentes_laborales WHERE numrun = '12456789';
--SELECT pi.cod_tipo_prop FROM SOLICITUD_CREDITO sc
--  JOIN PROPIEDAD p ON p.cod_propiedad = sc.cod_propiedad
--  JOIN PROYECTO_INMOBILIARIO pi ON pi.cod_proyecto = p.cod_proyecto
--WHERE sc.numrun = '12456789';

DECLARE
  CURSOR c_solicitudes IS
    SELECT numrun FROM BDY1102_ET_FD.SOLICITUD_CREDITO;

  v_run_cliente VARCHAR2(10);
  v_nombre_cliente VARCHAR2(255);
  
  v_ptje_tipo_trab NUMERIC;
  v_ptje_antiguedad NUMERIC;
  v_ptje_tipo_prop NUMERIC;
  v_ptje_extra NUMERIC;
  
  v_tipo_trab BDY1102_ET_FD.ANTECEDENTES_CLIENTE.COD_TIPO_TRAB%TYPE;
  v_tipo_prop BDY1102_ET_FD.PROYECTO_INMOBILIARIO.COD_TIPO_PROP%TYPE;
  v_edad NUMERIC(3);
  v_antiguedad NUMERIC(2);
  v_puntaje NUMERIC;
  v_resultado_solicitud VARCHAR(10);
  
  v_puntaje_aprobacion NUMERIC:=2500;
BEGIN
  EXECUTE IMMEDIATE 'truncate table BDY1102_ET_FD.DETALLE_PUNTAJE_SOLICITUD';
  EXECUTE IMMEDIATE 'truncate table BDY1102_ET_FD.RESULTADO_SOLICITUD';

  OPEN c_solicitudes;
  LOOP
    FETCH c_solicitudes INTO v_run_cliente;
    EXIT WHEN c_solicitudes%NOTFOUND;
      
    DBMS_OUTPUT.PUT_LINE('Procesando run: ' || v_run_cliente);
  
    -- Referencias -----------------------------
    
    SELECT
      cod_tipo_trab
      ,apaterno||' '||amaterno||' '||pnombre||' '||snombre
      ,TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nacimiento) / 12) AS "EDAD"
    INTO
      v_tipo_trab
      ,v_nombre_cliente
      ,v_edad
    FROM BDY1102_ET_FD.ANTECEDENTES_CLIENTE WHERE numrun = v_run_cliente;
    
    SELECT COALESCE(TRUNC(MONTHS_BETWEEN(SYSDATE, MIN(FECHA_CONTRATO)) / 12), 0)
    INTO v_antiguedad
    FROM BDY1102_ET_FD.antecedentes_laborales WHERE numrun = v_run_cliente;
    
    SELECT pi.cod_tipo_prop
    INTO v_tipo_prop
    FROM BDY1102_ET_FD.SOLICITUD_CREDITO sc
      JOIN BDY1102_ET_FD.PROPIEDAD p ON p.cod_propiedad = sc.cod_propiedad
      JOIN BDY1102_ET_FD.PROYECTO_INMOBILIARIO pi ON pi.cod_proyecto = p.cod_proyecto
    WHERE sc.numrun = v_run_cliente;
    
    -- Puntajes -----------------------------
    
    SELECT ptje_tipo_trab INTO v_ptje_tipo_trab
    FROM BDY1102_ET_FD.PTJE_TIPO_TRABAJADOR
    WHERE cod_tipo_trab = v_tipo_trab;
    
    SELECT ptje_antiguedad INTO v_ptje_antiguedad
    FROM BDY1102_ET_FD.PTJE_ANNOS_ANTIGUEDAD
    WHERE v_antiguedad BETWEEN RANGO_ANNOS_INI AND RANGO_ANNOS_TER;
    
    SELECT ptje_tipo_prop INTO v_ptje_tipo_prop
    FROM BDY1102_ET_FD.PTJE_TIPO_PROPIEDAD
    WHERE COD_TIPO_PROP = v_tipo_prop;
    
    v_puntaje := v_ptje_tipo_trab + v_ptje_antiguedad + v_ptje_tipo_prop;
    
    v_ptje_extra := CASE
      WHEN v_edad <= 40 THEN ROUND(v_puntaje * 0.12)
      ELSE 0
    END;
    
    v_puntaje := v_puntaje + v_ptje_extra;
    v_resultado_solicitud := CASE
      WHEN v_puntaje >= v_puntaje_aprobacion THEN 'APROBADO'
      ELSE 'RECHAZADO'
    END;
    
    -- Inserts -----------------------------
    INSERT INTO BDY1102_ET_FD.DETALLE_PUNTAJE_SOLICITUD
    VALUES (
      v_run_cliente
      ,v_nombre_cliente
      ,v_ptje_tipo_trab
      ,v_ptje_antiguedad
      ,v_ptje_tipo_prop
      ,v_ptje_extra
    );
    
    INSERT INTO BDY1102_ET_FD.RESULTADO_SOLICITUD
    VALUES (
      v_run_cliente
      ,v_puntaje
      ,v_resultado_solicitud
    );
    
  END LOOP;
  CLOSE c_solicitudes;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Fin del proceso');
    
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error crítico: ' || SQLERRM);
END;


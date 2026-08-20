DECLARE

    v_anno          CONSTANT NUMBER(4) := 2025;
     -- variables del cursor
    v_cod_vehiculo          equipo_camping.cod_vehiculo%TYPE;
    v_id_tipo_vehiculo      vehiculo_camping.id_tipo_vehiculo%TYPE;
    v_modelo                vehiculo_camping.modelo%TYPE;
    v_cantidad_arriendos    NUMERIC;
    v_total_dias            NUMERIC;
   
    
    -- variables del negocio
    v_promedio_dias                NUMERIC;
    v_ingreso_arriendo             NUMERIC;
    v_clasificacion_demanda        VARCHAR2(15);
    
    
    -- cursor
    CURSOR vehiculo_electrico IS 
        SELECT
            ve.cod_vehiculo
            ,v_anno as anno_proceso
            ,ve.id_tipo_vehiculo
            ,ve.modelo
            ,COUNT(av.cod_vehiculo) as cantidad_arriendos
            ,nvl(SUM(av.dias_solicitados),0) as total_dias
        FROM vehiculo_electrico ve ec
            LEFT JOIN arriendo_vehiculo av ON ve.cod_vehiculo = av.cod_vehiculo
        GROUP BY
            ve.cod_vehiculo
            ,ve.id_tipo_vehiculo
            ,ve.modelo
    ;
    
BEGIN
    -- Limpiar la tabla de resultados en tiempo de ejecucion
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_ANUAL_VEHICULO';
 
 
    OPEN c_rentabilidad;
        LOOP
            FETCH c_rentabilidad INTO
                v_cod_vehiculo
                ,v_anno_proceso
                ,v_id_tipo_vehiculo
                ,v_modelo
                ,v_cantidad_arriendos
                ,v_total_dias
                ;
            
            EXIT WHEN c_rentabilidad%NOTFOUND;
            
            -- PROMEDIO_DIAS
            
            SELECT
                ROUND(v_total_dias / nvl(SUM(av.dias_solicitados),0))
                INTO v_promedio_dias
            FROM arriendo_vehiculo av
            ;
            -- INGRESO_ARRIENDO
            
            SELECT 
                ve.valor_arriendo_dia * av.dias_solicitados
                INTO v_ingreso_arriendo
            FROM vehiculo_electrico ve
            JOIN arriendo_vehiculo av ON ve.cod_vehiculo = av.cod_vehiculo
            ;
            
            -- CLASIFICACIÓN DEMANDA
            CASE
                WHEN v_cantidad_arriendos >= 6 THEN 'ALTA'
                WHEN v_cantidad_arriendos BETWEEN 3 AND 5 THEN 'MEDIA'
                WHEN v_cantidad_arriendos BETWEEN 1 AND 2 THEN 'BAJA'
                ELSE 'SIN DEMANDA'
            END;
            
            -- INSERCION EN LA TABLA RESUMEN_ANUAL_VEHICULO
            INSERT INTO RESUMEN_ANUAL_VEHICULO (
                    cod_vehiculo,
                    anno_proceso,
                    id_tipo_vehiculo,
                    modelo,
                    cantidad_arriendos,
                    total_dias,
                    promedio_dias,
                    ingreso_arriendo,
                    clasificacion_demanda
                ) VALUES (
                    v_cod_vehiculo,
                    v_anno_proceso,
                    v_id_tipo_vehiculo,
                    v_modelo,
                    v_cantidad_arriendos,
                    v_total_dias,
                    v_promedio_dias,
                    v_ingreso_arriendo,
                    v_cladificacion_demanda
                );
                
            DBMS_OUTPUT.put_line('registrado');
        END LOOP;
    CLOSE c_rentabilidad;
    
    commit;
    DBMS_OUTPUT.put_line('FIN');
END;

-- SALUDOS (:
DECLARE
    -- variables del cursor
    v_id_tipo_equipo        VARCHAR2(2);
    v_anio                  NUMERIC;
    v_total_arriendo        NUMERIC;
    v_nombre_tipo_equipo    VARCHAR2(255);    
    v_dias_arrendados       NUMERIC;
    v_total_ingreso         NUMERIC;
    v_total_costo           NUMERIC;
    
    -- variables del negocio
    v_cantidad_equipos      NUMERIC;
    v_total_utilidad        NUMERIC;
    v_margen_promedio       NUMERIC(4,2);
    v_clasificacion         VARCHAR2(255);
    
    
    -- cursor
    CURSOR c_resultado_a IS 
            SELECT
                ec.id_tipo_equipo,
                extract(year from sysdate) AS anio,
                COUNT(*) AS total_arriendo,
                te.nombre_tipo_equipo,
                SUM(aec.dias_solicitados) AS dias_arrendados
                ,SUM(ec.valor_arriendo_dia*aec.dias_solicitados) as total_ingreso
                ,SUM(aec.dias_solicitados)*cm.costo_dia AS total_costo
            FROM equipo_camping ec
                JOIN arriendo_equipo_camping aec
                    ON ec.cod_equipo = aec.cod_equipo
                JOIN tipo_equipo te
                    ON te.id_tipo_equipo = ec.id_tipo_equipo
                JOIN costo_mantencion cm ON cm.id_tipo_equipo = ec.id_tipo_equipo
            GROUP BY 
                ec.id_tipo_equipo
                ,extract(year from sysdate)
                ,te.nombre_tipo_equipo
                ,cm.costo_dia
                ;
    
BEGIN
    EXECUTE IMMEDIATE('TRUNCATE TABLE rentabilidad_por_tipo');
 
 
    OPEN c_resultado_a;
        LOOP
            FETCH c_resultado_a 
            INTO
            v_id_tipo_equipo
            ,v_anio
            ,v_total_arriendo
            ,v_nombre_tipo_equipo
            ,v_dias_arrendados
            ,v_total_ingreso
            ,v_total_costo;
            
            EXIT WHEN c_resultado_a%NOTFOUND;
            
            
            --- negocio
            SELECT 
                COUNT(*)
            INTO 
                v_cantidad_equipos
            FROM equipo_camping
            WHERE id_tipo_equipo = v_id_tipo_equipo
            group by id_tipo_equipo;
            
        v_total_utilidad := v_total_ingreso-v_total_costo;
        v_margen_promedio := ROUND((v_total_utilidad/v_total_ingreso)*100);
        
        --v_total_utilidad := 0;
        
        v_clasificacion := 
        CASE 
            WHEN v_total_utilidad > 1500000 THEN 'alta'
            WHEN v_total_utilidad BETWEEN 500000 AND 1499999 THEN 'media'
            WHEN v_total_utilidad BETWEEN 1 AND 499999 THEN 'baja'
            ELSE 'sin movimiento'
        END;
        DBMS_OUTPUT.put_line('v '||v_id_tipo_equipo);
        
        --- insert into xxxxx
        
        INSERT INTO rentabilidad_por_tipo (
            id_tipo_equipo,
            anno_proceso,
            nombre_tipo,
            cantidad_equipos,
            total_arriendos,
            total_ingreso,
            total_costo,
            total_utilidad,
            margen_promedio,
            clasificacion
        ) VALUES (
            v_id_tipo_equipo,
            v_anio,
            v_nombre_tipo_equipo,
            v_cantidad_equipos,
            v_total_arriendo,
            v_total_ingreso,
            v_total_costo,
            v_total_utilidad,
            v_margen_promedio,
            v_clasificacion
        );
        
        
        END LOOP;
    CLOSE c_resultado_a;
    DBMS_OUTPUT.put_line('FIN');
END;
 
 
 
 
DECLARE
    -- Anio de proceso
    v_anno          CONSTANT NUMBER(4) := 2026;
 
 
    -- Cursor explicito SIN parametros: SOLO datos basicos del equipo,
    -- ordenado por codigo de equipo (requisito de almacenamiento).
    CURSOR c_equipos IS
        SELECT cod_equipo,
               descripcion,
               id_tipo_equipo,
               valor_arriendo_dia
          FROM equipo_camping
         ORDER BY cod_equipo;
 
 
    -- Variables de trabajo
    v_costo_dia     costo_mantencion.costo_dia%TYPE;   -- costo mantencion diario del tipo
    v_cant_arr      NUMBER(5);                          -- cantidad de arriendos (COUNT)
    v_total_dias    NUMBER(6);                          -- total de dias arrendados (SUM)
    v_ingreso       NUMBER(12);                         -- ingreso por arriendo
    v_costo_mant    NUMBER(12);                         -- costo de mantencion
    v_utilidad      NUMBER(12);                         -- utilidad
    v_margen        NUMBER(5);                          -- margen (%)
    v_clasif        VARCHAR2(15);                       -- clasificacion de rentabilidad
BEGIN
    -- Limpiar la tabla de resultados en tiempo de ejecucion
    EXECUTE IMMEDIATE 'TRUNCATE TABLE equipo_rentabilidad';
 
 
    FOR reg IN c_equipos LOOP
 
 
        -- 1) Costo de mantencion diario del tipo, en SELECT por separado
        SELECT costo_dia
          INTO v_costo_dia
          FROM costo_mantencion
         WHERE id_tipo_equipo = reg.id_tipo_equipo;
 
 
        -- 2) Cantidad de arriendos del equipo en el anio (COUNT), SELECT por separado
        SELECT COUNT(*)
          INTO v_cant_arr
          FROM arriendo_equipo_camping
         WHERE cod_equipo = reg.cod_equipo
           AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno;
 
 
        -- 3) Total de dias arrendados del equipo en el anio (SUM), SELECT por separado
        SELECT NVL(SUM(dias_solicitados), 0)
          INTO v_total_dias
          FROM arriendo_equipo_camping
         WHERE cod_equipo = reg.cod_equipo
           AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno;
 
 
        -- 4) Calculos en PL/SQL (redondeados a entero)
        v_ingreso    := ROUND(reg.valor_arriendo_dia * v_total_dias);
        v_costo_mant := ROUND(v_costo_dia * v_total_dias);
        v_utilidad   := v_ingreso - v_costo_mant;
 
 
        -- Margen (%): utilidad / ingreso * 100, redondeado; 0 si no hubo ingresos
        IF v_ingreso > 0 THEN
            v_margen := ROUND(v_utilidad / v_ingreso * 100);
        ELSE
            v_margen := 0;
        END IF;
 
 
        -- 5) Clasificacion de rentabilidad mediante estructura de control
        IF v_utilidad >= 300000 THEN
            v_clasif := 'Alta';
        ELSIF v_utilidad >= 100000 THEN
            v_clasif := 'Media';
        ELSIF v_utilidad >= 1 THEN
            v_clasif := 'Baja';
        ELSE
            v_clasif := 'Sin movimiento';
        END IF;
 
 
        -- 6) Almacenar resultado
        INSERT INTO equipo_rentabilidad
            (cod_equipo, anno_proceso, id_tipo_equipo, descripcion,
             cantidad_arriendos, total_dias, ingreso_arriendo,
             costo_mantencion, utilidad, margen_pct, clasificacion)
        VALUES
            (reg.cod_equipo, v_anno, reg.id_tipo_equipo, reg.descripcion,
             v_cant_arr, v_total_dias, v_ingreso,
             v_costo_mant, v_utilidad, v_margen, v_clasif);
 
 
    END LOOP;
 
 
    COMMIT;
 
 
    DBMS_OUTPUT.PUT_LINE('Proceso de rentabilidad por equipo finalizado para el anio ' || v_anno);
END;
/
 
 
-- Verificacion del resultado
SELECT * FROM equipo_rentabilidad ORDER BY cod_equipo;
DECLARE
    -- variables del cursor
    v_cod_equipo            equipo_camping.cod_equipo%TYPE;
    v_anno_proceso          NUMERIC;
    v_id_tipo_equipo        equipo_camping.id_tipo_equipo%TYPE;
    v_descripcion           equipo_camping.descripcion%TYPE;
    v_cantidad_arriendos    NUMERIC;
    v_total_dias            NUMERIC;
    v_valor_arriendo_dia    equipo_camping.valor_arriendo_dia%TYPE;
    v_valor_deposito_dia    equipo_camping.valor_deposito_dia%TYPE;
    
    -- variables del negocio
    v_costo_dia             costo_mantencion.costo_dia%TYPE;
    v_ingreso_arriendo      NUMERIC;
    v_costo_mantencion      NUMERIC;
    v_utilidad              NUMERIC;
    v_margen_ptc            NUMERIC;
    v_clasificacion         VARCHAR2(15);
    
    -- cursor
    CURSOR c_rentabilidad IS 
        SELECT
            ec.cod_equipo
            ,EXTRACT(YEAR FROM SYSDATE) as anno_proceso
            ,ec.id_tipo_equipo
            ,ec.descripcion
            ,COUNT(aec.cod_equipo) as cantidad_arriendos
            ,nvl(SUM(aec.dias_solicitados),0) as total_dias
            ,ec.valor_arriendo_dia
            ,ec.valor_deposito_dia
        FROM equipo_camping ec
            LEFT JOIN arriendo_equipo_camping aec ON ec.cod_equipo = aec.cod_equipo
        GROUP BY
            ec.cod_equipo
            ,ec.id_tipo_equipo
            ,ec.descripcion
            ,ec.valor_arriendo_dia
            ,ec.valor_deposito_dia
    ;
    
BEGIN
    EXECUTE IMMEDIATE('TRUNCATE TABLE EQUIPO_RENTABILIDAD');
    
    OPEN c_rentabilidad;
        LOOP
            FETCH c_rentabilidad INTO
                v_cod_equipo
                ,v_anno_proceso
                ,v_id_tipo_equipo
                ,v_descripcion
                ,v_cantidad_arriendos
                ,v_total_dias
                ,v_valor_arriendo_dia
                ,v_valor_deposito_dia
                ;
            
            EXIT WHEN c_rentabilidad%NOTFOUND;
            
            -- realizamos el negocio
            v_ingreso_arriendo := v_valor_arriendo_dia * v_total_dias;
            
            
            select
                costo_dia
            INTO
                v_costo_dia
            from costo_mantencion
            WHERE id_tipo_equipo = v_id_tipo_equipo;
            
            v_costo_mantencion := v_total_dias * v_costo_dia;
            
            v_utilidad := v_ingreso_arriendo - v_costo_mantencion;
            
            BEGIN
                v_margen_ptc := ROUND( v_utilidad / v_ingreso_arriendo *100 );
            EXCEPTION WHEN OTHERS THEN
                v_margen_ptc := 0;
            END;
            
            v_clasificacion := 
            CASE
                WHEN v_utilidad >= 300000 THEN 'ALTA'
                WHEN v_utilidad BETWEEN 100000 AND 299999 THEN 'MEDIA'
                WHEN v_utilidad BETWEEN 1 AND 99999 THEN 'BAJA'
                ELSE 'SIN MOVIMIENTO'
            END;
            
            -- realizamos el insert
            INSERT INTO equipo_rentabilidad (
                cod_equipo,
                anno_proceso,
                id_tipo_equipo,
                descripcion,
                cantidad_arriendos,
                total_dias,
                ingreso_arriendo,
                costo_mantencion,
                utilidad,
                margen_pct,
                clasificacion
            ) VALUES (
                v_cod_equipo,
                v_anno_proceso,
                v_id_tipo_equipo,
                v_descripcion,
                v_cantidad_arriendos,
                v_total_dias,
                v_ingreso_arriendo,
                v_costo_mantencion,
                v_utilidad,
                v_margen_ptc,
                v_clasificacion
            );
            
            
            DBMS_OUTPUT.put_line('registrado');
        END LOOP;
    CLOSE c_rentabilidad;
    
    commit;
    DBMS_OUTPUT.put_line('FIN');
END;
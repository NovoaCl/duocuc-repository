-- ============================================================================
-- BDY1102 - BASE DE DATOS APLICADA II
-- EVALUACION FINAL TRANSVERSAL - FORMA D
-- CASO: EVALUACION DE SOLICITUDES DE CREDITO HIPOTECARIO - BANCO AUSTRAL
--
-- PUNTO 4 (enunciado seccion 4.2): INFORME PARA REVISION Y OPTIMIZACION DE
-- CONSULTA
-- Ejecutar conectado como BDY1102_ET_FD_DES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1) CONSULTA SOLICITADA
--    Clientes cuyo puntaje final es mayor al promedio del puntaje final de
--    todos los solicitantes del proceso. Se muestra apellido paterno,
--    materno, nombre, puntaje final y el detalle de como se calculo ese
--    puntaje. Ordenado por puntaje total descendente.
-- ----------------------------------------------------------------------------
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


-- ----------------------------------------------------------------------------
-- 2) PLAN DE EJECUCION ANTES DE OPTIMIZAR
-- ----------------------------------------------------------------------------
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

-- Diagnostico esperado del plan:
-- * RESULTADO_SOLICITUD y DETALLE_PUNTAJE_SOLICITUD no tienen PRIMARY KEY ni
--   ningun indice declarado en base_de_datos.sql (ver definicion de ambas
--   tablas), por lo que el join entre ellas y la subconsulta del promedio
--   fuerzan un FULL TABLE SCAN de ambas.
-- * El join contra ANTECEDENTES_CLIENTE se hace sobre una EXPRESION
--   (ac.numrun || '-' || ac.dvrun), no sobre la columna numrun (PK). Un
--   indice normal sobre numrun NO puede usarse para resolver ese predicado,
--   por lo que tambien se produce un FULL TABLE SCAN sobre esa tabla.


-- ----------------------------------------------------------------------------
-- 3) INDICES PARA OPTIMIZAR LA CONSULTA
-- ----------------------------------------------------------------------------

-- 3.1 Soportan el join entre RESULTADO_SOLICITUD y DETALLE_PUNTAJE_SOLICITUD
CREATE INDEX IX_RESULTADO_SOL_RUN ON RESULTADO_SOLICITUD(run_cliente);
CREATE INDEX IX_DETALLE_PTJE_RUN  ON DETALLE_PUNTAJE_SOLICITUD(run_cliente);

-- 3.2 Soporta el filtro (ptje_final_sol > promedio) y el ORDER BY descendente;
--     ademas permite calcular el AVG() de la subconsulta mediante un
--     INDEX FULL SCAN en vez de un FULL TABLE SCAN (el indice es mas
--     liviano que la tabla completa).
CREATE INDEX IX_RESULTADO_SOL_PTJE ON RESULTADO_SOLICITUD(ptje_final_sol);

-- 3.3 INDICE BASADO EN FUNCION (function-based index): dado que el join con
--     ANTECEDENTES_CLIENTE se realiza por la expresion numrun || '-' || dvrun
--     y no por la columna numrun, un indice comun no es utilizable para ese
--     predicado. Se crea un indice sobre la EXPRESION exacta usada en el
--     join, para que el optimizador pueda resolverlo con un INDEX
--     RANGE/UNIQUE SCAN en lugar de un FULL TABLE SCAN.
CREATE INDEX IX_ANTCLI_RUN_DV_FBI ON ANTECEDENTES_CLIENTE(numrun || '-' || dvrun);


-- ----------------------------------------------------------------------------
-- 4) PLAN DE EJECUCION DESPUES DE OPTIMIZAR (para comparar)
-- ----------------------------------------------------------------------------
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

-- Resultado esperado tras la creacion de los indices: los FULL TABLE SCAN
-- sobre RESULTADO_SOLICITUD, DETALLE_PUNTAJE_SOLICITUD y ANTECEDENTES_CLIENTE
-- deberian ser reemplazados por INDEX RANGE/UNIQUE SCAN + TABLE ACCESS BY
-- ROWID (o, si la cardinalidad estimada lo justifica, un INDEX FAST FULL
-- SCAN sobre IX_RESULTADO_SOL_PTJE para el AVG de la subconsulta), reduciendo
-- de forma significativa el costo (COST) y el numero de bloques logicos
-- leidos (Card/Bytes/Cost) reportados por DBMS_XPLAN.

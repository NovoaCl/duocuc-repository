-- LLAMAR TODOS LOS REGISTROS DE LA TABLA CLIENTE --
SELECT * FROM cliente;

-- DESARROLLO GUIA 1.3

---- CASO 1 ----
SELECT 
    TO_CHAR(cl.numrun, '999g999g999') || '-' || cl.dvrun AS "RUN CLIENTE",
    cl.pnombre || ' ' || cl.appaterno || ' ' || cl.apmaterno AS "NOMBRE CLIENTE",
    pf.nombre_prof_ofic AS "PROFESION/OFICIO",
    TO_CHAR(EXTRACT (DAY FROM cl.fecha_nacimiento), '09') || ' de ' || TO_CHAR(cl.fecha_nacimiento ,'MONTH') AS "DIA DE CUMPLEAÑOS"
    
FROM cliente cl
    JOIN profesion_oficio pf ON(pf.cod_prof_ofic = cl.cod_prof_ofic)
WHERE 
    EXTRACT (MONTH FROM cl.fecha_nacimiento) > EXTRACT (MONTH FROM SYSDATE) OR
    EXTRACT (DAY FROM cl.fecha_nacimiento) > EXTRACT (DAY FROM SYSDATE)
ORDER BY EXTRACT (MONTH FROM cl.fecha_nacimiento), EXTRACT (DAY FROM cl.fecha_nacimiento)
;

---- CASO 2 ----
SELECT 
    TO_CHAR(cl.numrun, '999g999g999') || '-' || cl.dvrun AS "RUN CLIENTE",
    cl.pnombre || ' ' || cl.appaterno || ' ' || cl.apmaterno AS "NOMBRE CLIENTE",
    TO_CHAR(SUM(cc.monto_solicitado), '$999g999g999') AS "MONTO SOLICITADO CREDITOS",
    TO_CHAR( (SUM(cc.monto_solicitado)/100000)*1200,'$999g999g999' ) AS "TOTAL PESOS TODOSUMA"
    
FROM credito_cliente cc
    JOIN cliente cl ON (cl.nro_cliente = cc.nro_cliente) 
GROUP BY TO_CHAR(cl.numrun, '999g999g999') || '-' || cl.dvrun, cl.pnombre || ' ' || cl.appaterno || ' ' || cl.apmaterno
-- GROUP BY TO_CHAR(cl.numrun, '999g999g999') || '-' || cl.dvrun, cl.pnombre || ' ' || cl.appaterno || ' ' || cl.apmaterno 
ORDER BY SUM(cc.monto_solicitado) ASC
;

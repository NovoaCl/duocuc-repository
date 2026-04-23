-- Requerimiento 1:

select
    tp.nombre_tipo_moto as "tipo moto",
    m.placa as "Placa",
    m.color as "Color",
    m.modelo as "Modelo",
    m.cilindrada as "Cilindrada",
    m.anio_fab as "Anio Fab.",
    TO_CHAR(m.valor_arriendo_dia,'$999g999g999')    AS "Arriendo/Dia",
    TO_CHAR(m.valor_garantia_dia,'$999g999g999')    AS "Garantía/Dia",
    TO_CHAR(m.valor_arriendo_dia + m.valor_garantia_dia,'$999g999g999') AS "Total/Dia",
    SUBSTR(e.numrun_emp,3,1)
    ||  CASE 
            WHEN tp.nombre_tipo_moto = 'Depotiva' THEN SUBSTR(e.apmaterno_emp,1,1)|| SUBSTR(e.apmaterno_emp,3,1)
            WHEN tp.nombre_tipo_moto = 'Naked' THEN SUBSTR(e.apmaterno_emp,2,1)|| SUBSTR(e.apmaterno_emp,-1,1)
            WHEN tp.nombre_tipo_moto = 'Scooter' THEN SUBSTR(e.apmaterno_emp,1,1)|| SUBSTR(e.apmaterno_emp,2,1)
        ELSE
            SUBSTR(e.apmaterno_emp,2,1)|| SUBSTR(e.apmaterno_emp,3,1)
        END
    || '@motorent.cl' AS "Correo Encargado"

from motocicleta m
    join tipo_moto tp on m.id_tipo_moto = tp.id_tipo_moto
    join empleado e on m.numrun_emp = e.numrun_emp

order by
    tp.nombre_tipo_moto ASC,
    m.valor_arriendo_dia DESC,
    m.valor_garantia_dia ASC,
    m.placa ASC
;

-- Requerimiento 2:

select
    e.numrun_emp ||'-'|| e.dvrun_emp as "RUN",
    e.pnombre_emp ||' '|| e.snombre_emp ||' '|| e.appaterno_emp ||' '|| e.apmaterno_emp AS "Nombre Completo",
    e.fecha_contrato as "fecha Contrato",
    ec.nombre_estado_civil as "Estado Civil",
    TO_CHAR(e.sueldo_base,'$999g999g999') as "Sueldo Base",
    TO_CHAR(e.sueldo_base * porc.porcentaje / 100) as "Monto Bono 30 años",
    porc.porcentaje || '%' as "% Sueldo Base"
FROM empleado e
    JOIN estado_civil ec ON ec.id_estado_civil = e.id_estado_civil
    JOIN PORC_BONIF_30_ANNOS porc ON e.sueldo_base between porc.sueldo_desde AND porc.sueldo_hasta
WHERE
    EXTRACT(MONTH FROM e.fecha_contrato) = EXTRACT(MONTH FROM SYSDATE)
    
order by
    e.fecha_contrato ASC,
    e.appaterno_emp
;

-- Requerimiento 3:


INSERT INTO HIST_ARRIENDO_ANUAL_MOTO
(placa, modelo, anno_proceso, cant_arriendos, total_dias)

SELECT
    am.placa,
    m.modelo,
    EXTRACT(YEAR FROM am.fecha_ini_arriendo),
    COUNT(*),
    SUM(am.dias_solicitados)

FROM arriendo_moto am
JOIN motocicleta m ON m.placa = am.placa

WHERE EXTRACT(YEAR FROM am.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)

GROUP BY
    am.placa,
    m.modelo,
    EXTRACT(YEAR FROM am.fecha_ini_arriendo);

-- Requerimiento 4:

SELECT
     e.numrun_emp || '-' || e.dvrun_emp AS "RUN",
     e.pnombre_emp || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp AS "Nombre Completo",
     am.total_arriendos AS "Total Arriendos Mes",
     am.total_arriendos || '%' AS "% Bonif.",
     TO_CHAR(e.sueldo_base * am.total_arriendos / 100, '$999g999g999') AS "Monto Bonificacion"

FROM empleado e

JOIN (
     SELECT
         am.numrun_emp,
         COUNT(*) AS total_arriendos
     FROM arriendo_moto am
     WHERE EXTRACT(MONTH FROM am.fecha_ini_arriendo) = EXTRACT(MONTH FROM SYSDATE)
       AND EXTRACT(YEAR FROM am.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
     GROUP BY am.numrun_emp
     HAVING COUNT(*) > 1
) am
ON e.numrun_emp = am.numrun_emp

ORDER BY e.appaterno_emp DESC;



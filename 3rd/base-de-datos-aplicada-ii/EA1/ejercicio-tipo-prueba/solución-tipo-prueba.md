### Caso 1:

```sql
SELECT
    te.nombre_tipo_emb      AS "Tipo Embarcacion",
    e.matricula             AS "Matricula",
    e.color                 AS "Color",
    e.eslora                AS "Eslora (m)",
    e.motor                 AS "Motor",
    e.anio_fab              AS "Anio Fab",
    TO_CHAR(e.valor_arriendo_dia,'$999g999g999')    AS "Arriendo/Dia",
    TO_CHAR(e.valor_garantia_dia,'$999g999g999')    AS "Garantía/Dia",
    TO_CHAR(e.valor_arriendo_dia + e.valor_garantia_dia,'$999g999g999') AS "Total/Dia",
    SUBSTR(e.numrun_emp,3,1)
    || ROUND(EXTRACT(YEAR FROM em.fecha_contrato)*1.2)
    || TO_NUMBER(SUBSTR(e.numrun_emp,-2,2)-2)
    || '@marineexpress.cl' AS "Correo Encargado"
FROM embarcacion e
    JOIN tipo_embarcacion te ON te.id_tipo_emb = e.id_tipo_emb
    JOIN empleado em ON em.numrun_emp = e.numrun_emp
ORDER BY
    te.nombre_tipo_emb ASC,
    e.valor_arriendo_dia DESC,
    e.valor_garantia_dia ASC,
    e.matricula ASC
;
```

### Caso 2:

```sql
SELECT
    e.numrun_emp ||'-'|| e.dvrun_emp AS "RUN",
    e.pnombre_emp ||' '|| e.snombre_emp ||' '|| e.appaterno_emp ||' '|| e.apmaterno_emp AS "Nombre Completo",
    e.fecha_contrato,
    ec.nombre_estado_civil,
    e.sueldo_base,
    e.sueldo_base * porc.porcentaje/100,
    porc.porcentaje || '%'
FROM empleado e
    JOIN estado_civil ec ON ec.id_estado_civil = e.id_estado_civil
    JOIN porc_bonif_30_annos porc  
            ON e.sueldo_base between porc.sueldo_desde AND porc.sueldo_hasta
WHERE
    EXTRACT(MONTH FROM e.fecha_contrato) = EXTRACT(MONTH FROM SYSDATE)
;

```

### Caso 3:

```sql
INSERT INTO HIST_ARRIENDO_ANUAL_EMBARCACION 
(matricula, anno_proceso,cant_arriendos,total_dias )
select
    matricula
    ,EXTRACT(YEAR FROM fecha_ini_arriendo) AS anno_proceso
    ,COUNT(*) AS cant_arriendos
    ,SUM(dias_solicitados) AS total_dias
from ARRIENDO_EMBARCACION
WHERE
    EXTRACT(YEAR FROM fecha_ini_arriendo) = 2026
GROUP BY
    matricula
    --,fecha_ini_arriendo
    ,EXTRACT(YEAR FROM fecha_ini_arriendo)
--HAVING COUNT(*) = 1
;

```

### Caso 4:

```sql
SELECT 
    e.run,
    e.nombre,
    e.ap_paterno,
    a.total_arriendos,
    a.total_arriendos AS porcentaje_bonificacion,
    (e.sueldo_base * a.total_arriendos / 100) AS monto_bonificacion

FROM EMPLEADO e

JOIN (
    SELECT 
        run_empleado,
        COUNT(*) AS total_arriendos
    FROM ARRIENDO
    WHERE EXTRACT(MONTH FROM fecha_arriendo) = EXTRACT(MONTH FROM CURRENT_DATE)
      AND EXTRACT(YEAR FROM fecha_arriendo) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY run_empleado
    HAVING COUNT(*) > 1
) a
ON e.run = a.run_empleado

ORDER BY e.ap_paterno DESC
;

```




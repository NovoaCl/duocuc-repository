-- Caso 1:

INSERT INTO MEDICOS_SERVICIO_COMUNIDAD
(unidad, medico, telefono, correo_medico, atenciones_medicas)

select
    u.nombre as "UNIDAD",
    m.apaterno ||' '|| m.amaterno ||' '|| m.pnombre ||' '|| m.snombre as "MEDICO",
    m.telefono as "TELEFONO",
    substr(u.nombre, 1, 2) || substr(m.apaterno, -3, 2)
    || substr(m.telefono, -3, 3) || extract(day from m.fecha_contrato) 
    || extract(month from m.fecha_contrato) || '@medicocktk.cl' AS "CORREO_MEDICO",
    count(a.fecha_atencion) as "ATENCIONES_MEDICAS"
    
from medico m
    join unidad u on u.uni_id = m.uni_id
    join atencion a on a.med_run = m.med_run
    
group by
    a.fecha_atencion,
    u.nombre

order by
    u.nombre DESC,
    m.apaterno DESC
;

-- Caso 2:

select
    extract(year from a.fecha_atencion) || '/' || extract(month from a.fecha_atencion) as "AÑO Y MES",
     count(a.fecha_atencion) as "TOTAL DE ATENCIONES",
     sum(pa.monto_atencion) as "VALOR TOTAL DE LAS ATENCIONES"
     
from atencion a
    join pago_atencion pa on a.ate_id = pa.ate_id
 where extract(year from a.fecha_atencion) = extract(year from sysdate)
       or extract(year from a.fecha_atencion) = (extract(year from sysdate) - 1)
       or extract(year from a.fecha_atencion) = (extract(year from sysdate) - 2)

group by a.fecha_atencion

order by a.fecha_atencion ASC
;



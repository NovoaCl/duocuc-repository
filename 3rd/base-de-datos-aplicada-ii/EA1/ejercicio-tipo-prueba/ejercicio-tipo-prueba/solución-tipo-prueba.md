### Caso 1:

```sql

select 
    te.nombre_tipo_emb as "Tipo Embarcacion",
    e.matricula as "Matricula",
    e.color as "Color",
    e.eslora as "Eslora(m)",
    e.motor as "Motor",
    e.anio_fab as "Anio Fabricacion",
    to_char(e.valor_arriendo_dia, '$999g999g999') as "Arriendo/Dia",
    to_char(e.valor_garantia_dia,'$999g999g999') as "Garantia/Dia",
    to_char((e.valor_arriendo_dia + e.valor_garantia_dia), '$999g999g999') as "Total/Dia"
    
from embarcacion e
    join tipo_embarcacion te on e.id_tipo_emb = te.id_tipo_emb    
;


select 
    substr(e.numrun_emp, 3, 1)
    ||round(extract(year from e.fecha_contrato) * 1.2)
    ||(substr(e.numrun_emp, -2, 2) - 2)
    ||'@marineexpress.cl'
from empleado e   
    join tipo_embarcacion
order by e.tipo_embarcacion
    
;
```

### Caso 2:

```sql

```

### Caso 3:

```sql

```

### Caso 4:

```sql

```

### Funciones:

- to_char(var, ''formato)
- substr(var, posición de inicio, cantidad  de caracteres)
- extract(parte from var)
- round() 
-
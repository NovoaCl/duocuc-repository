SELECT
    SUM(salario),
    MIN(salario),
    MAX(salario),
    --ROUND(AVG(salario),2),
    AVG(salario),
    COUNT(nombre)
FROM empleado
;

SELECT
    salario,
    COUNT(salario)
FROM empleado
GROUP BY
    salario
ORDER BY COUNT(salario) DESC
;

SELECT
    salario,
    id_estcivil,
    COUNT(salario)
FROM empleado
WHERE id_estcivil <> 6 -- NO FILTRA AGRUPADOS (COUNT)
GROUP BY
    salario,
    id_estcivil
HAVING -- FILTRA EL AGRUPADO (COUNT)
    COUNT(salario) > 1
ORDER BY 2
;

SELECT 
    SALARIO,
    ID_ESTCIVIL,
    COUNT(SALARIO)
FROM EMPLEADO
WHERE ID_ESTCIVIL <> 6
GROUP BY
    SALARIO,
    ID_ESTCIVIL
HAVING
    COUNT(SALARIO) > 1
ORDER BY 2
;
    
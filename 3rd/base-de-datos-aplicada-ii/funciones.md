## 📊 Funciones y cláusulas SQL agrupadas por categoría

### 🔤 Funciones de formato y manipulación de datos

| Elemento                        | Descripción                                              | Ejemplo de uso                 | Resultado      |
| ------------------------------- | -------------------------------------------------------- | ------------------------------ | -------------- |
| `TO_CHAR(var, 'formato')`       | Convierte un valor (fecha o número) a texto con formato. | `TO_CHAR(fecha, 'YYYY-MM-DD')` | `'2026-04-15'` |
| `SUBSTR(var, inicio, cantidad)` | Extrae parte de un texto desde una posición.             | `SUBSTR('Hola mundo', 1, 4)`   | `'Hola'`       |
| `INITCAP(texto)`                | Convierte la primera letra de cada palabra en mayúscula. | `INITCAP('hola mundo')`        | `'Hola Mundo'` |

---

### 📅 Funciones de fecha

| Elemento                  | Descripción                               | Ejemplo de uso             | Resultado |
| ------------------------- | ----------------------------------------- | -------------------------- | --------- |
| `EXTRACT(parte FROM var)` | Extrae una parte específica de una fecha. | `EXTRACT(YEAR FROM fecha)` | `2026`    |

---

### 🔢 Funciones numéricas

| Elemento                   | Descripción                                        | Ejemplo de uso     | Resultado |
| -------------------------- | -------------------------------------------------- | ------------------ | --------- |
| `ROUND(numero, decimales)` | Redondea un número a cierta cantidad de decimales. | `ROUND(3.1416, 2)` | `3.14`    |

---

### 📊 Funciones de agregación

| Elemento       | Descripción                            | Ejemplo de uso                        | Resultado          |
| -------------- | -------------------------------------- | ------------------------------------- | ------------------ |
| `COUNT(*)`     | Cuenta todas las filas (incluye NULL). | `SELECT COUNT(*) FROM empleados;`     | Total de registros |
| `SUM(columna)` | Suma valores de una columna.           | `SELECT SUM(salario) FROM empleados;` | Total              |
| `AVG(columna)` | Calcula el promedio.                   | `SELECT AVG(salario) FROM empleados;` | Promedio           |

---

### 🧩 Manejo de valores nulos

| Elemento                        | Descripción                        | Ejemplo de uso            | Resultado    |
| ------------------------------- | ---------------------------------- | ------------------------- | ------------ |
| `COALESCE(valor1, valor2, ...)` | Retorna el primer valor no nulo.   | `COALESCE(NULL, 'Texto')` | `'Texto'`    |
| `NVL(valor, reemplazo)`         | Reemplaza NULL (propio de Oracle). | `NVL(NULL, 'Sin dato')`   | `'Sin dato'` |

---

### 🧮 Agrupación de datos

| Elemento           | Descripción                                    | Ejemplo de uso                                          | Resultado        |
| ------------------ | ---------------------------------------------- | ------------------------------------------------------- | ---------------- |
| `GROUP BY columna` | Agrupa filas para aplicar funciones agregadas. | `SELECT depto, COUNT(*) FROM empleados GROUP BY depto;` | Conteo por grupo |

---

### 🔎 Filtrado y condiciones

| Elemento                                 | Descripción                                       | Ejemplo de uso                                         | Resultado       |
| ---------------------------------------- | ------------------------------------------------- | ------------------------------------------------------ | --------------- |
| `WHERE condición`                        | Filtra filas antes de agrupar o procesar.         | `SELECT * FROM empleados WHERE salario > 1000;`        | Filas filtradas |
| `CASE WHEN condición THEN valor ... END` | Permite lógica condicional dentro de la consulta. | `CASE WHEN salario > 1000 THEN 'Alto' ELSE 'Bajo' END` | Clasificación   |

---

### 🔗 Combinación de tablas

| Elemento | Descripción                                        | Ejemplo de uso                                         | Resultado        |
| -------- | -------------------------------------------------- | ------------------------------------------------------ | ---------------- |
| `JOIN`   | Une filas de dos o más tablas según una condición. | `SELECT * FROM emp e JOIN dept d ON e.dept_id = d.id;` | Datos combinados |

---

## 🧠 Notas profesionales (importantes de verdad)

* `JOIN` tiene variantes: `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` — cambia completamente el resultado si no lo manejas bien.
* `WHERE` filtra antes del `GROUP BY`, mientras que `HAVING` (no lo pediste, pero te lo dejo como tip) filtra después de agrupar.
* `CASE WHEN` es la forma correcta (no existe `WHEN` solo en SQL).
* `COALESCE` es estándar (funciona en PostgreSQL, MySQL, SQL Server), mientras que `NVL` es específico de Oracle Database.
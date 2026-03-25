-- Script: creacion_datos_tecnofuturo.sql
-- Descripción: Creación de tablas e inserción de datos para el caso "TecnoFuturo Ltda."
-- Contiene 100 empleados, departamentos, proyectos y asignaciones coherentes.

-- Deshabilitar la salida del servidor y errores para un script más limpio
SET SERVEROUTPUT ON;
SET FEEDBACK OFF;
SET ECHO OFF;

-- Eliminar tablas si existen para asegurar una ejecución limpia
DROP TABLE ASIGNACIONES CASCADE CONSTRAINTS;
DROP TABLE EMPLEADOS CASCADE CONSTRAINTS;
DROP TABLE PROYECTOS CASCADE CONSTRAINTS;
DROP TABLE DEPARTAMENTOS CASCADE CONSTRAINTS;

-- 1. Creación de la tabla DEPARTAMENTOS
CREATE TABLE DEPARTAMENTOS (
    id_departamento NUMBER(5) PRIMARY KEY,
    nombre_departamento VARCHAR2(100) NOT NULL UNIQUE,
    ubicacion VARCHAR2(100)
);

-- 2. Creación de la tabla EMPLEADOS
CREATE TABLE EMPLEADOS (
    id_empleado NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    apellido VARCHAR2(50) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario NUMBER(10, 2) NOT NULL,
    id_departamento NUMBER(5),
    id_jefe NUMBER(10), -- Puede ser NULL si es el CEO o no tiene jefe directo en el sistema
    CONSTRAINT fk_departamento
        FOREIGN KEY (id_departamento)
        REFERENCES DEPARTAMENTOS(id_departamento),
    CONSTRAINT fk_jefe
        FOREIGN KEY (id_jefe)
        REFERENCES EMPLEADOS(id_empleado),
    CONSTRAINT chk_salario CHECK (salario >= 0)
);

-- 3. Creación de la tabla PROYECTOS
CREATE TABLE PROYECTOS (
    id_proyecto NUMBER(10) PRIMARY KEY,
    nombre_proyecto VARCHAR2(100) NOT NULL UNIQUE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    presupuesto NUMBER(15, 2) NOT NULL,
    id_departamento_responsable NUMBER(5) NOT NULL,
    CONSTRAINT fk_departamento_responsable
        FOREIGN KEY (id_departamento_responsable)
        REFERENCES DEPARTAMENTOS(id_departamento),
    CONSTRAINT chk_fechas_proyecto CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT chk_presupuesto CHECK (presupuesto >= 0)
);

-- 4. Creación de la tabla ASIGNACIONES
CREATE TABLE ASIGNACIONES (
    id_asignacion NUMBER(10) PRIMARY KEY,
    id_empleado NUMBER(10) NOT NULL,
    id_proyecto NUMBER(10) NOT NULL,
    horas_dedicadas NUMBER(4, 1) NOT NULL,
    fecha_asignacion DATE NOT NULL,
    CONSTRAINT fk_empleado_asignacion
        FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADOS(id_empleado),
    CONSTRAINT fk_proyecto_asignacion
        FOREIGN KEY (id_proyecto)
        REFERENCES PROYECTOS(id_proyecto),
    CONSTRAINT chk_horas_dedicadas CHECK (horas_dedicadas > 0),
    CONSTRAINT uq_empleado_proyecto UNIQUE (id_empleado, id_proyecto) -- Un empleado solo se asigna una vez a un proyecto
);

-- Secuencias para IDs autoincrementales
CREATE SEQUENCE seq_id_departamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_empleado START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_proyecto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_asignacion START WITH 1 INCREMENT BY 1;

-- Triggers para autoincrementar IDs (opcional, se puede manejar con PL/SQL en los INSERT)
-- Para DEPARTAMENTOS
CREATE OR REPLACE TRIGGER trg_departamentos_id
BEFORE INSERT ON DEPARTAMENTOS
FOR EACH ROW
BEGIN
    SELECT seq_id_departamento.NEXTVAL INTO :NEW.id_departamento FROM DUAL;
END;
/

-- Para EMPLEADOS
CREATE OR REPLACE TRIGGER trg_empleados_id
BEFORE INSERT ON EMPLEADOS
FOR EACH ROW
BEGIN
    SELECT seq_id_empleado.NEXTVAL INTO :NEW.id_empleado FROM DUAL;
END;
/

-- Para PROYECTOS
CREATE OR REPLACE TRIGGER trg_proyectos_id
BEFORE INSERT ON PROYECTOS
FOR EACH ROW
BEGIN
    SELECT seq_id_proyecto.NEXTVAL INTO :NEW.id_proyecto FROM DUAL;
END;
/

-- Para ASIGNACIONES
CREATE OR REPLACE TRIGGER trg_asignaciones_id
BEFORE INSERT ON ASIGNACIONES
FOR EACH ROW
BEGIN
    SELECT seq_id_asignacion.NEXTVAL INTO :NEW.id_asignacion FROM DUAL;
END;
/

-- Inserción de datos en DEPARTAMENTOS
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Recursos Humanos', 'Edificio A, Piso 1');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Desarrollo', 'Edificio B, Piso 3');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Calidad', 'Edificio B, Piso 2');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Marketing', 'Edificio A, Piso 2');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Finanzas', 'Edificio A, Piso 1');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Soporte Técnico', 'Edificio C, Piso 1');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Ventas', 'Edificio A, Piso 2');
INSERT INTO DEPARTAMENTOS (nombre_departamento, ubicacion) VALUES ('Innovación', 'Edificio B, Piso 4');
COMMIT;

-- Inserción de datos en EMPLEADOS (100 empleados)
-- Insertar un CEO primero para que pueda ser jefe
INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
VALUES ('Ana', 'García', TO_DATE('15/01/2015', 'DD/MM/YYYY'), 2500000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Recursos Humanos'), NULL);
COMMIT;

-- Variable para el ID del CEO
DECLARE
    v_id_ceo NUMBER;
    v_id_rh NUMBER;
    v_id_desarrollo NUMBER;
    v_id_calidad NUMBER;
    v_id_marketing NUMBER;
    v_id_finanzas NUMBER;
    v_id_soporte NUMBER;
    v_id_ventas NUMBER;
    v_id_innovacion NUMBER;
BEGIN
    SELECT id_empleado INTO v_id_ceo FROM EMPLEADOS WHERE nombre = 'Ana' AND apellido = 'García';
    SELECT id_departamento INTO v_id_rh FROM DEPARTAMENTOS WHERE nombre_departamento = 'Recursos Humanos';
    SELECT id_departamento INTO v_id_desarrollo FROM DEPARTAMENTOS WHERE nombre_departamento = 'Desarrollo';
    SELECT id_departamento INTO v_id_calidad FROM DEPARTAMENTOS WHERE nombre_departamento = 'Calidad';
    SELECT id_departamento INTO v_id_marketing FROM DEPARTAMENTOS WHERE nombre_departamento = 'Marketing';
    SELECT id_departamento INTO v_id_finanzas FROM DEPARTAMENTOS WHERE nombre_departamento = 'Finanzas';
    SELECT id_departamento INTO v_id_soporte FROM DEPARTAMENTOS WHERE nombre_departamento = 'Soporte Técnico';
    SELECT id_departamento INTO v_id_ventas FROM DEPARTAMENTOS WHERE nombre_departamento = 'Ventas';
    SELECT id_departamento INTO v_id_innovacion FROM DEPARTAMENTOS WHERE nombre_departamento = 'Innovación';

    -- Jefes de Departamento (id_jefe será el CEO)
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Carlos', 'Pérez', TO_DATE('01/03/2016', 'DD/MM/YYYY'), 1500000.00, v_id_rh, v_id_ceo); -- Jefe RH
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Elena', 'Díaz', TO_DATE('10/05/2017', 'DD/MM/YYYY'), 1800000.00, v_id_desarrollo, v_id_ceo); -- Jefe Desarrollo
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Fernando', 'López', TO_DATE('20/07/2018', 'DD/MM/YYYY'), 1600000.00, v_id_calidad, v_id_ceo); -- Jefe Calidad
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Laura', 'Martínez', TO_DATE('05/09/2019', 'DD/MM/YYYY'), 1400000.00, v_id_marketing, v_id_ceo); -- Jefe Marketing
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Miguel', 'Sánchez', TO_DATE('12/11/2019', 'DD/MM/YYYY'), 1700000.00, v_id_finanzas, v_id_ceo); -- Jefe Finanzas
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Sofía', 'Ramírez', TO_DATE('01/02/2020', 'DD/MM/YYYY'), 1300000.00, v_id_soporte, v_id_ceo); -- Jefe Soporte
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Juan', 'Herrera', TO_DATE('25/04/2020', 'DD/MM/YYYY'), 1450000.00, v_id_ventas, v_id_ceo); -- Jefe Ventas
    INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
    VALUES ('Isabel', 'Vargas', TO_DATE('08/06/2021', 'DD/MM/YYYY'), 1650000.00, v_id_innovacion, v_id_ceo); -- Jefe Innovación
    COMMIT;

    -- Otros empleados (90 restantes para llegar a 100)
    -- Asignación de jefes y departamentos de forma rotativa o aleatoria para variedad
    FOR i IN 1..90 LOOP
        DECLARE
            v_rand_dept_id NUMBER;
            v_rand_salario NUMBER;
            v_rand_jefe_id NUMBER;
            v_fecha_contratacion DATE;
            v_nombre VARCHAR2(50);
            v_apellido VARCHAR2(50);
        BEGIN
            -- Generar nombres y apellidos aleatorios (simplificado para el ejemplo)
            SELECT 'Empleado' || i INTO v_nombre FROM DUAL;
            SELECT 'Apellido' || i INTO v_apellido FROM DUAL;

            -- Generar salario aleatorio
            v_rand_salario := ROUND(DBMS_RANDOM.VALUE(400000, 1200000), -3); -- Salarios entre 400k y 1.2M, redondeado a miles

            -- Seleccionar departamento aleatorio
            SELECT id_departamento INTO v_rand_dept_id
            FROM (SELECT id_departamento FROM DEPARTAMENTOS ORDER BY DBMS_RANDOM.VALUE)
            WHERE ROWNUM = 1;

            -- Seleccionar jefe aleatorio (cualquier empleado existente incluyendo los jefes de departamento y CEO)
            SELECT id_empleado INTO v_rand_jefe_id
            FROM (SELECT id_empleado FROM EMPLEADOS ORDER BY DBMS_RANDOM.VALUE)
            WHERE ROWNUM = 1;

            -- Fecha de contratación (desde 2020 en adelante para algunos, o más antiguas)
            -- Asegurarse de tener empleados contratados después de 2020 para el requerimiento 1.1
            IF i <= 40 THEN -- 40 empleados contratados después de 2020
                v_fecha_contratacion := TO_DATE('01/01/2021', 'DD/MM/YYYY') + DBMS_RANDOM.VALUE(0, 730); -- Últimos 2 años
            ELSE -- El resto puede ser más antiguo o reciente
                v_fecha_contratacion := TO_DATE('01/01/2018', 'DD/MM/YYYY') + DBMS_RANDOM.VALUE(0, 1825); -- Últimos 5 años
            END IF;

            INSERT INTO EMPLEADOS (nombre, apellido, fecha_contratacion, salario, id_departamento, id_jefe)
            VALUES (v_nombre, v_apellido, v_fecha_contratacion, v_rand_salario, v_rand_dept_id, v_rand_jefe_id);
        END;
    END LOOP;
    COMMIT;
END;
/

-- Inserción de datos en PROYECTOS
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Sistema de Gestión de Clientes', TO_DATE('01/01/2022', 'DD/MM/YYYY'), TO_DATE('30/06/2023', 'DD/MM/YYYY'), 50000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Desarrollo'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Actualización de Infraestructura', TO_DATE('15/03/2022', 'DD/MM/YYYY'), TO_DATE('15/09/2023', 'DD/MM/YYYY'), 75000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Soporte Técnico'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Campaña de Marketing Digital 2023', TO_DATE('01/01/2023', 'DD/MM/YYYY'), TO_DATE('31/12/2023', 'DD/MM/YYYY'), 20000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Marketing'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Desarrollo de App Móvil', TO_DATE('01/07/2023', 'DD/MM/YYYY'), NULL, 60000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Desarrollo'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Auditoría Financiera Anual', TO_DATE('01/02/2023', 'DD/MM/YYYY'), TO_DATE('31/03/2023', 'DD/MM/YYYY'), 10000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Finanzas'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Implementación ISO 9001', TO_DATE('01/09/2022', 'DD/MM/YYYY'), NULL, 30000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Calidad'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Expansión Mercado LatAm', TO_DATE('01/04/2023', 'DD/MM/YYYY'), NULL, 80000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Ventas'));
INSERT INTO PROYECTOS (nombre_proyecto, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES ('Investigación IA Generativa', TO_DATE('10/01/2023', 'DD/MM/YYYY'), NULL, 45000000.00, (SELECT id_departamento FROM DEPARTAMENTOS WHERE nombre_departamento = 'Innovación'));
COMMIT;

-- Inserción de datos en ASIGNACIONES
DECLARE
    CURSOR c_empleados IS SELECT id_empleado FROM EMPLEADOS ORDER BY id_empleado;
    CURSOR c_proyectos IS SELECT id_proyecto FROM PROYECTOS ORDER BY id_proyecto;
    v_id_empleado NUMBER;
    v_id_proyecto NUMBER;
    v_horas_dedicadas NUMBER(4,1);
    v_fecha_asignacion DATE;
    v_count NUMBER;
BEGIN
    OPEN c_empleados;
    LOOP
        FETCH c_empleados INTO v_id_empleado;
        EXIT WHEN c_empleados%NOTFOUND;

        -- Asignar cada empleado a 1-3 proyectos aleatorios
        FOR i IN 1..ROUND(DBMS_RANDOM.VALUE(1, 3)) LOOP
            SELECT id_proyecto INTO v_id_proyecto
            FROM (SELECT id_proyecto FROM PROYECTOS ORDER BY DBMS_RANDOM.VALUE)
            WHERE ROWNUM = 1;

            -- Verificar si la asignación ya existe
            SELECT COUNT(*) INTO v_count FROM ASIGNACIONES WHERE id_empleado = v_id_empleado AND id_proyecto = v_id_proyecto;

            IF v_count = 0 THEN
                v_horas_dedicadas := ROUND(DBMS_RANDOM.VALUE(10, 160), 1); -- Horas dedicadas por proyecto (ej: mensual)
                v_fecha_asignacion := TO_DATE('01/01/2022', 'DD/MM/YYYY') + DBMS_RANDOM.VALUE(0, 500); -- Fechas de asignación
                INSERT INTO ASIGNACIONES (id_empleado, id_proyecto, horas_dedicadas, fecha_asignacion)
                VALUES (v_id_empleado, v_id_proyecto, v_horas_dedicadas, v_fecha_asignacion);
            END IF;
        END LOOP;
    END LOOP;
    CLOSE c_empleados;
    COMMIT;
END;
/

-- Confirmación de datos cargados
SELECT 'Departamentos cargados: ' || COUNT(*) FROM DEPARTAMENTOS;
SELECT 'Empleados cargados: ' || COUNT(*) FROM EMPLEADOS;
SELECT 'Proyectos cargados: ' || COUNT(*) FROM PROYECTOS;
SELECT 'Asignaciones cargadas: ' || COUNT(*) FROM ASIGNACIONES;

SET FEEDBACK ON;
SET ECHO ON;
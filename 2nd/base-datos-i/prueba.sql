CREATE TABLE CATEGORIA
	(
	id_categoria NUMBER (1) NOR NULL,
	nombre_categoria VARCHAR2 (20) NOT NULL,
	porc NUMBER (5,2) NOT NULL,
	CONSTRAINT CATEGORIA_PK PRIMARY KEY (id_categoria
	);

CREATE TABLE VENDEDOR
	(
	id_vendedor NUMBER (6) NOT NULL,
	rut_vendedor VATCHAR2 (10) NOT NULL,
	nombre VARCHAR2 (25) NOT NULL,
	apellido_paterno VARCHAR2 (15) NOT NULL,
	apellido_materno VARCHAR2 (15) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	fecha_contrato DATE NOT NULL,
	sueldo NUMBER NOT NULL
	comision NUMBER NOT NULL,
	categoria_id_categoria NUMBER (1) NOT NULL,
	zona_id_zona NUMBER (1) NOT NULL,
	CONSTRAINT VENDEDOR_PK PRIMARY KEY (id_vendedor),
	CONSTRAINT VENDEDOR_CATEGORIA_FK FOREING KEY (categoria_id_categoria)
	REFERENCES CATEGORIA (id_categoria) NOT DEFERRABLE
	);
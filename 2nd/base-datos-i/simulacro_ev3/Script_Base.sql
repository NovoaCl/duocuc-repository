CREATE TABLE zona (
    id_zona      NUMBER(1) NOT NULL,
    nom_zona     VARCHAR2(10) NOT NULL,
    porc         NUMBER (5,2)NOT NULL
);
ALTER TABLE zona ADD CONSTRAINT pk_zona PRIMARY KEY ( id_zona );

CREATE TABLE marca (
    id_marca      NUMBER(4) NOT NULL,
    nom_marca     VARCHAR2(10) NOT NULL
);
ALTER TABLE marca ADD CONSTRAINT pk_marca PRIMARY KEY ( id_marca );


CREATE TABLE categoria (
    id_categoria      NUMBER(1) NOT NULL,
    nom_categoria     VARCHAR2(20) NOT NULL,
    porcentaje        NUMBER NOT NULL
);
ALTER TABLE categoria ADD CONSTRAINT pk_categoria PRIMARY KEY ( id_categoria );

CREATE TABLE comuna (
    id_comuna      NUMBER(3) NOT NULL,
    nom_comuna    VARCHAR2(60) NOT NULL
);
ALTER TABLE comuna ADD CONSTRAINT pk_comuna PRIMARY KEY ( id_comuna );


INSERT INTO comuna (id_comuna,nom_comuna)VALUES(100,'Providencia');
INSERT INTO comuna (id_comuna,nom_comuna)VALUES(105,'Santiago');
INSERT INTO comuna (id_comuna,nom_comuna)VALUES(110,'Ñuñoa');
INSERT INTO comuna (id_comuna,nom_comuna)VALUES(115,'La Florida');
INSERT INTO comuna (id_comuna,nom_comuna)VALUES(120,'Maipú');

INSERT INTO zona (id_zona,nom_zona,porc)VALUES(1,'Norte',8.56);
INSERT INTO zona (id_zona,nom_zona,porc)VALUES(2,'Sur',10.48);
INSERT INTO zona (id_zona,nom_zona,porc)VALUES(3,'Oriente',11.27);
INSERT INTO zona (id_zona,nom_zona,porc)VALUES(4,'Poniente',7.24);
INSERT INTO zona (id_zona,nom_zona,porc)VALUES(5,'Centro',7.24);

INSERT INTO categoria (id_categoria,nom_categoria,porcentaje)VALUES(1,'Categoria A',17.5);
INSERT INTO categoria (id_categoria,nom_categoria,porcentaje)VALUES(2,'Categoria B',12.6);
INSERT INTO categoria (id_categoria,nom_categoria,porcentaje)VALUES(3,'Categoria C',9.4);
INSERT INTO categoria (id_categoria,nom_categoria,porcentaje)VALUES(4,'Categoria D',7.2);
INSERT INTO categoria (id_categoria,nom_categoria,porcentaje)VALUES(5,'Categoria E',5.4);

INSERT INTO marca (id_marca,nom_marca)VALUES(1000,'Familand');
INSERT INTO marca (id_marca,nom_marca)VALUES(1100,'Nivea');
INSERT INTO marca (id_marca,nom_marca)VALUES(1200,'Dove');
INSERT INTO marca (id_marca,nom_marca)VALUES(1300,'Gillette');
INSERT INTO marca (id_marca,nom_marca)VALUES(1400,'Monterrey');

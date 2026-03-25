CREATE TABLE vendedor
    (
     id_vendedor            NUMBER (6)  NOT NULL ,
     rut_vendedor           VARCHAR2 (10)  NOT NULL ,
     nombre                 VARCHAR2 (25)  NOT NULL ,
     apellido_paterno       VARCHAR2 (15)  NOT NULL ,
     apellido_materno       VARCHAR2 (15) ,
     fecnac                 DATE  NOT NULL ,
     feccontar              DATE  NOT NULL ,
     sueldo                 NUMBER  NOT NULL ,
     comision               NUMBER  NOT NULL ,
     categoria_id_categoria NUMBER (1)  NOT NULL ,
     zona_id_zona           NUMBER (1)  NOT NULL
    )
    LOGGING
;

ALTER TABLE vendedor
    ADD CONSTRAINT vendedor_PK PRIMARY KEY ( id_vendedor ) ;

ALTER TABLE vendedor
    ADD CONSTRAINT vendedor__UN UNIQUE ( rut_vendedor ) ;

CREATE TABLE categoria
    (
     id_categoria  NUMBER (1)  NOT NULL ,
     nom_categoria VARCHAR2 (20)  NOT NULL ,
     porcentaje    NUMBER  NOT NULL
    )
    LOGGING
;

ALTER TABLE categoria
    ADD CONSTRAINT pk_categoria PRIMARY KEY ( id_categoria ) ;

ALTER TABLE vendedor
    ADD CONSTRAINT vendedor_categoria_FK FOREIGN KEY
    (
     categoria_id_categoria
    )
    REFERENCES categoria
    (
     id_categoria
    )
    NOT DEFERRABLE
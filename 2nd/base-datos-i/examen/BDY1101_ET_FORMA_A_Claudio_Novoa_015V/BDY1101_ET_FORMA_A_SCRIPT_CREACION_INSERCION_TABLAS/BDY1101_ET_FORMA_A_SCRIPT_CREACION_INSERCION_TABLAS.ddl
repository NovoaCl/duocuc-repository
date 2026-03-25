CREATE TABLE comuna (
    id_comuna NUMBER(20) NOT NULL,
    nombre    VARCHAR2(50) NOT NULL,
    id_region NUMBER(20) NOT NULL
);

ALTER TABLE comuna ADD CONSTRAINT comuna_pk PRIMARY KEY ( id_comuna );

CREATE TABLE contrato (
    id               NUMBER(20)  GENERATED ALWAYS  IDENTITY 
(START WITH 1 INCREMENT BY 1)  NOT NULL,
    numero_folio     NUMBER(20) NOT NULL,
    afp              VARCHAR2(50),
    isapre           VARCHAR2(50),
    sueldo_base      VARCHAR2(50),
    valor_hora       VARCHAR2(50),
    horas_mensuales  VARCHAR2(50),
    id_tipo_contrato NUMBER(20) NOT NULL,
    id_formulario    NUMBER(20) NOT NULL,
    id_personal      NUMBER(20) NOT NULL,
    id_tipo_titulo   NUMBER(20) NOT NULL,
    id_escuela       NUMBER(20) NOT NULL
);



ALTER TABLE contrato ADD CONSTRAINT contrato_pk PRIMARY KEY ( id );

CREATE TABLE detalle_inversion (
    id_detalle_inversion NUMBER(20) GENERATED ALWAYS IDENTITY 
(START WITH 1 INCREMENT BY 1)  NOT NULL,
    monto_solicitado_uf  NUMBER(20),
    nombre_proyecto      VARCHAR2(50),
    id_tipo_inversion    NUMBER(20)
);

ALTER TABLE detalle_inversion ADD CONSTRAINT detalle_inversion_pk PRIMARY KEY ( id_detalle_inversion );

CREATE TABLE director (
    id_director      NUMBER(20) NOT NULL,
    rut              NUMBER(20),
    dv               VARCHAR2(1) NOT NULL,
    apellido_paterno VARCHAR2(50) NOT NULL,
    apellido_materno VARCHAR2(50),
    nombres          VARCHAR2(50) NOT NULL,
    id_telefonos     VARCHAR2(50),
    nacionalidad     VARCHAR2(50) NOT NULL,
    id_profesion     NUMBER(20) NOT NULL,
    estado_civil     VARCHAR2(50),
    firma            BLOB,
    fecha_solicitud  DATE,
    id_comuna        NUMBER(20) NOT NULL
);

ALTER TABLE director ADD CONSTRAINT director_pk PRIMARY KEY ( id_director );

CREATE TABLE escuela_deportiva (
    id_escuela            NUMBER(20) NOT NULL,
    id_comuna             NUMBER(20) NOT NULL,
    ubicacion             VARCHAR2(50),
    nombre_club           VARCHAR2(50),
    id_ramas_deportivas   NUMBER(20) NOT NULL,
    sitio_web             VARCHAR2(50),
    n_inscripcion_comunal VARCHAR2(50),
    fecha_resolucion      DATE NOT NULL,
    id_recinto            NUMBER(20) NOT NULL,
    id_director           NUMBER(20) NOT NULL
);

ALTER TABLE escuela_deportiva ADD CONSTRAINT escuela_deportiva_pk PRIMARY KEY ( id_escuela );

CREATE TABLE formulario (
    id_formulario        NUMBER(20) NOT NULL,
    numero_folio         NUMBER(20) NOT NULL,
    id_recursos          NUMBER(20) NOT NULL,
    id_detalle_inversion NUMBER(20) NOT NULL,
    id_tipo_formulario   NUMBER NOT NULL,
    id_director          NUMBER(20) NOT NULL
);

ALTER TABLE formulario ADD CONSTRAINT formulario_postulacion_pk PRIMARY KEY ( id_formulario );

CREATE TABLE municipalidad (
    id_municipalidad NUMBER NOT NULL,
    id_comuna        NUMBER(20) NOT NULL
);

ALTER TABLE municipalidad ADD CONSTRAINT municipalidad_pk PRIMARY KEY ( id_municipalidad );

ALTER TABLE municipalidad ADD CONSTRAINT municipalidad__un UNIQUE ( id_comuna );

CREATE TABLE pais (
    pais_id NUMBER(20) NOT NULL,
    nombre  VARCHAR2(50)
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( pais_id );

CREATE TABLE personal (
    id_personal           NUMBER(20) NOT NULL,
    rut                   NUMBER(20) NOT NULL,
    dv                    VARCHAR2(1) NOT NULL,
    nombre                VARCHAR2(50) NOT NULL,
    apellido_paterno      VARCHAR2(50) NOT NULL,
    apellido_materno      VARCHAR2(50) NOT NULL,
    id_especialidad       NUMBER(20) NOT NULL,
    universidad_instituto VARCHAR2(50),
    ubicacion             VARCHAR2(50)
);

ALTER TABLE personal ADD CONSTRAINT personal_pk PRIMARY KEY ( id_personal );

CREATE TABLE recinto_deportivo (
    id_recinto       NUMBER(20) NOT NULL,
    nombre           VARCHAR2(50),
    id_municipalidad NUMBER NOT NULL
);

ALTER TABLE recinto_deportivo ADD CONSTRAINT recinto_deportivo_pk PRIMARY KEY ( id_recinto );

CREATE TABLE recursos (
    id_recursos    NUMBER(20) NOT NULL,
    puntaje        NUMBER(20),
    monto_asignado NUMBER(20)
);

ALTER TABLE recursos ADD CONSTRAINT recursos_pk PRIMARY KEY ( id_recursos );

CREATE TABLE region (
    nombre       VARCHAR2(50),
    id_region    NUMBER(20) NOT NULL,
    pais_pais_id NUMBER(20) NOT NULL
);

ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY ( id_region );

CREATE TABLE tipo_contrato (
    id_tipo_contrato NUMBER(20) NOT NULL,
    nombre           VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN tipo_contrato.nombre IS
    'planta/honorario';

ALTER TABLE tipo_contrato ADD CONSTRAINT tipo_contrato_pk PRIMARY KEY ( id_tipo_contrato );

CREATE TABLE tipo_titulo (
    id_tipo_titulo NUMBER(20) NOT NULL,
    nombre         VARCHAR2(50)
);

ALTER TABLE tipo_titulo ADD CONSTRAINT tipo_titulo_pk PRIMARY KEY ( id_tipo_titulo );

CREATE TABLE tipo_turno (
    id_tipo_turno NUMBER(20) NOT NULL,
    nombre        VARCHAR2(50),
    id_personal   NUMBER(20) NOT NULL
);

ALTER TABLE tipo_turno ADD CONSTRAINT tipo_turno_pk PRIMARY KEY ( id_tipo_turno );

ALTER TABLE comuna
    ADD CONSTRAINT comuna_region_fk FOREIGN KEY ( id_region )
        REFERENCES region ( id_region );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_personal_fk FOREIGN KEY ( id_personal )
        REFERENCES personal ( id_personal );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_tipo_contrato_fk FOREIGN KEY ( id_tipo_contrato )
        REFERENCES tipo_contrato ( id_tipo_contrato );

ALTER TABLE contrato
    ADD CONSTRAINT contrato_tipo_titulo_fk FOREIGN KEY ( id_tipo_titulo )
        REFERENCES tipo_titulo ( id_tipo_titulo );

ALTER TABLE formulario
    ADD CONSTRAINT detalle_inversion_fk FOREIGN KEY ( id_detalle_inversion )
        REFERENCES detalle_inversion ( id_detalle_inversion );

ALTER TABLE director
    ADD CONSTRAINT director_comuna_fk FOREIGN KEY ( id_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE escuela_deportiva
    ADD CONSTRAINT director_fk FOREIGN KEY ( id_director )
        REFERENCES director ( id_director );

ALTER TABLE contrato
    ADD CONSTRAINT escuela_deportiva_fk FOREIGN KEY ( id_escuela )
        REFERENCES escuela_deportiva ( id_escuela );

ALTER TABLE formulario
    ADD CONSTRAINT formulario_director_fk FOREIGN KEY ( id_director )
        REFERENCES director ( id_director );

ALTER TABLE municipalidad
    ADD CONSTRAINT municipalidad_comuna_fk FOREIGN KEY ( id_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE recinto_deportivo
    ADD CONSTRAINT municipalidad_fk FOREIGN KEY ( id_municipalidad )
        REFERENCES municipalidad ( id_municipalidad );

ALTER TABLE contrato
    ADD CONSTRAINT postulacion_fk FOREIGN KEY ( id_formulario )
        REFERENCES formulario ( id_formulario );

ALTER TABLE escuela_deportiva
    ADD CONSTRAINT recinto_deportivo_fk FOREIGN KEY ( id_recinto )
        REFERENCES recinto_deportivo ( id_recinto );

ALTER TABLE formulario
    ADD CONSTRAINT recursos_fk FOREIGN KEY ( id_recursos )
        REFERENCES recursos ( id_recursos );

ALTER TABLE region
    ADD CONSTRAINT region_pais_fk FOREIGN KEY ( pais_pais_id )
        REFERENCES pais ( pais_id );

ALTER TABLE tipo_turno
    ADD CONSTRAINT tipo_turno_personal_fk FOREIGN KEY ( id_personal )
        REFERENCES personal ( id_personal );




Buenas noches Chat, que tal estas?

Necesito que actues como un desarrollador profesional.

Necesito que me ayudes a configurar sql developer para que reciba otro formato de fecha.

Estoy intentando ejecutar un script inmenso que me dieron en clases y me arrojo más de 1600 errores porque no le gusta el formato de fecha.
Te adjunto el error completo:

Error starting at line : 1,612 in command -
INSERT INTO CUOTA_CREDITO_CLIENTE VALUES('3008','36','23/12'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)+2),'272222',null,null,null,null)
Error at Command Line : 1,612 Column : 62
Error report -
SQL Error: ORA-01843: not a valid month

https://docs.oracle.com/error-help/db/ora-01843/01843. 00000 -  "An invalid month was specified."
*Cause:    You specified a date with an invalid month.
*Action:   Enter a valid month value using either the correctly spelled full
           month name or valid short month code.

Necesito que me des ideas de como puedo configurar sql developer para que reciba este formato de fecha:

CREATE TABLE CLIENTE
(nro_cliente NUMBER(5) NOT NULL,
 numrun NUMBER(10) NOT NULL,
 dvrun VARCHAR2(1) NOT NULL,
 pnombre VARCHAR2(50) NOT NULL, 
 snombre VARCHAR2(50), 
 appaterno VARCHAR2(50) NOT NULL, 
 apmaterno VARCHAR2(50),
 fecha_nacimiento DATE NOT NULL,
 fecha_inscripcion DATE NOT NULL,
 correo VARCHAR2(20),
 fono_contacto NUMBER(10),
 direccion VARCHAR2(50) NOT NULL,
 cod_region  NUMBER(3) NOT NULL,
 cod_provincia NUMBER(3) NOT NULL,
 cod_comuna NUMBER(3) NOT NULL,
 cod_prof_ofic  NUMBER(3) NOT NULL,
 cod_tipo_cliente  NUMBER(3) NOT NULL,
 CONSTRAINT PK_CLIENTE PRIMARY KEY(nro_cliente),
 CONSTRAINT FK_CLIENTE_COMUNA FOREIGN KEY(cod_region, cod_provincia,cod_comuna) REFERENCES COMUNA(cod_region,cod_provincia,cod_comuna),
 CONSTRAINT FK_CLIENTE_PROFESION_OFICIO FOREIGN KEY(cod_prof_ofic) REFERENCES PROFESION_OFICIO(cod_prof_ofic),
 CONSTRAINT FK_CLIENTE_TIPO_CLIENTE FOREIGN KEY(cod_tipo_cliente) REFERENCES TIPO_CLIENTE(cod_tipo_cliente)); 

INSERT INTO CLIENTE VALUES('18','17613770','3','MARIA','JESUS','VALLADARES','CARCAMO','09/08'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-35),'09/10'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-14),null,null,'Pedro de Valdivia 63','1','1','1','15','1');

Espero puedas ayudarme ):


Error starting at line : 1,110 in command -
INSERT INTO CUOTA_CREDITO_CLIENTE VALUES('2001','17','22/05'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)+1),'57292',null,null,null,null)
Error report -
ORA-02291: restricción de integridad (MDY2131_P3.FK_CUOCREDCLI_CREDCLI) violada - clave principal no encontrada

https://docs.oracle.com/error-help/db/ora-02291/

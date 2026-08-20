--ALTER SESSION SET CURRENT_SCHEMA = BDY1102_ET_FD;

CREATE OR REPLACE VIEW BDY1102_ET_FD_DES.V_INFORME_SOLICITANTES AS
SELECT
  ac.numrun || '-' || ac.dvrun AS "RUN"
  ,ac.apaterno||' '||ac.amaterno||' '||ac.pnombre||' '||ac.snombre AS "NOMBRE"
  ,ac.fecha_nacimiento
  ,tt.desc_tipo_trab AS TIPO_TRABAJADOR
  ,SUBSTR(
    CASE
      WHEN ac.cod_tipo_trab IN (10, 20) THEN LOWER(apaterno)
      ELSE LOWER(amaterno)
    END, 0, 3)
    || '-'
    || TRUNC(EXTRACT(YEAR FROM ac.fecha_nacimiento) * 1.25)
    ||(SUBSTR(ac.numrun, -2, 2) + 2)
    || '@bancoaustral.cl'
    AS "CORREO"
    ,COUNT(al.numrun) AS "CANT_EMPLEOS"
FROM BDY1102_ET_FD.antecedentes_cliente ac
  JOIN BDY1102_ET_FD.tipo_trabajador tt ON tt.cod_tipo_trab = ac.cod_tipo_trab
  JOIN BDY1102_ET_FD.antecedentes_laborales al ON al.numrun = ac.numrun
GROUP BY
  ac.numrun
  ,ac.dvrun
  ,ac.apaterno
  ,ac.amaterno
  ,ac.pnombre
  ,ac.snombre
  ,ac.fecha_nacimiento
  ,ac.cod_tipo_trab
  ,tt.desc_tipo_trab
ORDER BY
  ac.apaterno
  ,ac.amaterno
  ,ac.pnombre
  ,ac.snombre
;

SELECT * FROM BDY1102_ET_FD_DES.V_INFORME_SOLICITANTES;

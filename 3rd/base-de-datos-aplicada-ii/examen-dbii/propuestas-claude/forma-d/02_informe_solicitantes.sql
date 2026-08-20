-- ============================================================================
-- BDY1102 - BASE DE DATOS APLICADA II
-- EVALUACION FINAL TRANSVERSAL - FORMA D
-- CASO: EVALUACION DE SOLICITUDES DE CREDITO HIPOTECARIO - BANCO AUSTRAL
--
-- PUNTO 2 (enunciado seccion 3): GENERACION DE INFORME DE LOS SOLICITANTES
-- Ejecutar conectado como BDY1102_ET_FD_DES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Analisis de alternativa: VIEW vs. MATERIALIZED VIEW
-- ----------------------------------------------------------------------------
-- Se elige una VISTA (VIEW) y no una vista materializada:
--
-- * Una VIEW no almacena datos: cada vez que se consulta, Oracle vuelve a
--   ejecutar el SELECT que la define, por lo que el resultado SIEMPRE
--   refleja el estado actual de ANTECEDENTES_CLIENTE y ANTECEDENTES_LABORALES,
--   sin ningun proceso adicional de actualizacion. Esto cumple exactamente
--   el requerimiento: "que se vaya actualizando a medida que se van
--   registrando solicitantes".
--
-- * Una vista materializada SI almacena los datos fisicamente y exige un
--   REFRESH (manual, por job, o ON COMMIT) para reflejar los cambios. Ademas,
--   el informe usa una funcion de agregacion (COUNT) sobre un JOIN; lograr
--   un FAST REFRESH (el unico que no impacta el rendimiento de forma
--   relevante) exigiria crear MATERIALIZED VIEW LOGS adicionales con
--   clausulas especiales para agregaciones, aumentando la complejidad sin
--   un beneficio real dado el volumen de datos del caso.
--
-- Por lo tanto, la VISTA es la alternativa que mejor se adecua.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE VIEW VW_INFORME_SOLICITANTES AS
SELECT
    ac.numrun || '-' || ac.dvrun                                    AS run_dv,
    ac.apaterno,
    ac.amaterno,
    ac.pnombre || NVL2(ac.snombre, ' ' || ac.snombre, '')           AS nombres,
    ac.fecha_nacimiento,
    tt.desc_tipo_trab,
    empleos.cant_empleos,
    LOWER(
        CASE WHEN ac.cod_tipo_trab IN (10, 20)                       -- dependiente
             THEN SUBSTR(ac.apaterno, 1, 3)
             ELSE SUBSTR(ac.amaterno, 1, 3)
        END
    )
    || '-'
    || TRUNC(EXTRACT(YEAR FROM ac.fecha_nacimiento) * 1.25)          -- anno nac. + 25%, truncado
    || '-'
    || TO_CHAR(MOD(ac.numrun, 100) + 2)                              -- 2 ultimos digitos del run + 2
    || '@bancoaustral.cl'                                            AS correo_banca_linea
FROM ANTECEDENTES_CLIENTE ac
JOIN TIPO_TRABAJADOR tt
  ON tt.cod_tipo_trab = ac.cod_tipo_trab
JOIN (
    SELECT numrun, COUNT(*) AS cant_empleos
    FROM   ANTECEDENTES_LABORALES
    GROUP BY numrun
) empleos
  ON empleos.numrun = ac.numrun
ORDER BY ac.apaterno, ac.amaterno, ac.pnombre;

-- Prueba de la vista (equivalente a lo que exportaba antes la Gerencia a Excel)
SELECT * FROM VW_INFORME_SOLICITANTES;

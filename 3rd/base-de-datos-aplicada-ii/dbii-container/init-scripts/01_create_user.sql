-- ================================================
-- SCRIPT PARA clnov
-- Este script se ejecuta automáticamente la primera
-- vez que el contenedor crea la base de datos.
--
-- NOTA: el nombre clnov lleva un guion, por lo
-- que en Oracle DEBE ir entre comillas dobles siempre
-- que se lo mencione (en el CREATE, en GRANTs, en
-- consultas, y también al conectarte en SQL Developer).
-- ================================================

-- 1. Cambiar al PDB (XEPDB1)
ALTER SESSION SET CONTAINER = XEPDB1;

-- 2. Crear usuario local
CREATE USER clnov IDENTIFIED BY "123456"
  DEFAULT TABLESPACE "USERS"
  TEMPORARY TABLESPACE "TEMP";

-- 3. Asignar cuota
ALTER USER clnov QUOTA UNLIMITED ON USERS;

-- 4. Otorgar permisos básicos
GRANT CREATE SESSION TO clnov;
GRANT "RESOURCE" TO clnov;
ALTER USER clnov DEFAULT ROLE "RESOURCE";

-- 5. Verificar creación (opcional)
SELECT username, account_status, default_tablespace
FROM dba_users
WHERE username = 'clnov';

-- ================================================
-- ALTERNATIVA sin guion (opcional, más simple de usar):
-- Si prefieres evitar comillas en el día a día, descomenta
-- estas líneas y comenta el bloque de arriba.
-- ================================================
-- CREATE USER TIPOPRUEBA IDENTIFIED BY "123456"
--   DEFAULT TABLESPACE "USERS"
--   TEMPORARY TABLESPACE "TEMP";
-- ALTER USER TIPOPRUEBA QUOTA UNLIMITED ON USERS;
-- GRANT CREATE SESSION TO TIPOPRUEBA;
-- GRANT "RESOURCE" TO TIPOPRUEBA;
-- ALTER USER TIPOPRUEBA DEFAULT ROLE "RESOURCE";

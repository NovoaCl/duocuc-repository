-- ================================================
-- SCRIPT PARA MDY2131_P8
-- PRÁCTICA: P8
-- ================================================

-- 1. Cambiar al PDB (XEPDB1)
ALTER SESSION SET CONTAINER = XEPDB1;

-- 2. Crear usuario local
CREATE USER MDY2131_P8 
IDENTIFIED BY "MDY2131.practica_p8" 
DEFAULT TABLESPACE "USERS" 
TEMPORARY TABLESPACE "TEMP";

-- 3. Asignar cuota
ALTER USER MDY2131_P8 QUOTA UNLIMITED ON USERS;

-- 4. Otorgar permisos básicos
GRANT CREATE SESSION TO MDY2131_P8;
GRANT "RESOURCE" TO MDY2131_P8;
ALTER USER MDY2131_P8 DEFAULT ROLE "RESOURCE";

GRANT CREATE VIEW TO MDY2131_P8;
GRANT CREATE INDEXTYPE TO MDY2131_P8;


-- 5. Verificar creación (opcional)
SELECT username, account_status, default_tablespace 
FROM dba_users 
WHERE username = 'MDY2131_P8';

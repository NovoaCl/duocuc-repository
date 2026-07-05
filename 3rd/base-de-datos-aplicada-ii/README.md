# Oracle XE en Docker — MDY2131_P1

## 1. Requisitos previos
- Tener **Docker** y **Docker Compose** instalados y corriendo.
- Al menos ~4 GB de RAM libres (Oracle XE consume bastante al arrancar).

## 2. Estructura de archivos
```
oracle-docker/
├── docker-compose.yml
└── init-scripts/
    └── 01_create_user.sql   <- tu script de creación de usuario
```

## 3. Levantar el contenedor
Desde la carpeta `oracle-docker/`, ejecuta:

```bash
docker compose up -d
```

⚠️ **Importante:** la primera vez que se crea la base de datos (no cada vez que
arranca el contenedor), Oracle tarda entre 3 y 8 minutos en inicializarse
porque construye internamente la base. Es en ese primer arranque cuando se
ejecuta automáticamente tu script `01_create_user.sql`.

Puedes ver el progreso con:
```bash
docker logs -f oracle-xe-mdy2131
```
Vas a ver el mensaje `DATABASE IS READY TO USE!` cuando ya esté lista.

## 4. Datos de conexión

| Dato              | Valor                        |
|-------------------|-------------------------------|
| Host              | localhost (o `127.0.0.1`)     |
| Puerto            | 1521                          |
| Service Name      | XEPDB1                        |
| Usuario admin     | system                        |
| Password admin    | TuPasswordAdmin123 (la que pusiste en el `docker-compose.yml`) |
| Usuario práctica  | MDY2131_P1                    |
| Password práctica | MDY2131.practica_p1           |

## 5. Conectarse desde SQL Developer
1. Abre SQL Developer y crea una **nueva conexión** (ícono verde "+").
2. Completa:
   - **Name**: cualquier nombre descriptivo, ej. `Oracle Docker Local`
   - **Username**: `MDY2131_P1`
   - **Password**: `MDY2131.practica_p1`
   - **Connection Type**: Basic
   - **Hostname**: `localhost`
   - **Port**: `1521`
   - **Service name** (⚠️ no "SID"): `XEPDB1`
3. Click en **Test** — debería decir "Success".
4. Click en **Connect**.

Si quieres conectarte como administrador (para ver todos los usuarios, dar
permisos, etc.), crea otra conexión igual pero con:
   - **Username**: `system`
   - **Password**: la que definiste en `ORACLE_PASSWORD`
   - **Role**: default (no necesitas SYSDBA para `system`)

## 6. Comandos útiles
```bash
# Ver estado del contenedor
docker ps

# Detener el contenedor (los datos persisten en el volumen)
docker compose stop

# Volver a iniciar
docker compose start

# Eliminar contenedor y volumen (esto SÍ borra todos los datos)
docker compose down -v
```

## 7. Notas técnicas
- **XEPDB1** es un *Pluggable Database (PDB)*, no un SID — así funciona la
  arquitectura *multitenant* de Oracle desde la versión 12c en adelante.
- Los scripts dentro de `init-scripts/` solo se ejecutan **una vez**, al
  crear la base de datos por primera vez. Si ya levantaste el contenedor
  antes y quieres que se vuelva a ejecutar el script, tienes que borrar el
  volumen con `docker compose down -v` y volver a levantar todo.
- Cambia `TuPasswordAdmin123` por una password real antes de usarlo en
  cualquier entorno que no sea 100% local/práctica.

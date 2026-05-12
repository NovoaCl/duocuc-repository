# Análisis de Arquitectura de Software

## Caso:  “Agencia de Viajes On Tour”

---

# 1. Identificación de los Componentes del Software

## 1.1 Análisis General del Caso

La agencia necesita una plataforma web centralizada que permita:

* Gestionar contratos de giras de estudio.
* Controlar aportes económicos por curso y alumno.
* Transparentar la información hacia apoderados y ejecutivos.
* Publicar documentación digital.
* Gestionar seguros y servicios externos.
* Automatizar notificaciones por correo electrónico.
* Generar reportes de avance financiero.

Debido a estos requerimientos, se propone una arquitectura basada en capas bajo el patrón **MVC (Model – View – Controller)**, permitiendo modularidad, escalabilidad y mantenimiento del sistema.

---

# 1.2 Componentes Principales del Software

## A. Módulo de Gestión de Usuarios

### Responsabilidad

Administrar los distintos tipos de usuarios del sistema.

### Usuarios identificados

* Dueño de la agencia
* Ejecutivo de ventas
* Representante del curso
* Apoderados
* Administrador del sistema

### Funcionalidades

* Inicio de sesión
* Gestión de permisos y roles
* Administración de usuarios
* Recuperación de contraseña

---

## B. Módulo de Gestión de Contratos

### Responsabilidad

Registrar y administrar los contratos de giras de estudio.

### Funcionalidades

* Registro de contratos
* Asociación de cursos y colegios
* Gestión de destinos
* Registro de servicios contratados
* Gestión de fechas importantes
* Generación de documentos PDF

### Datos relevantes

* Colegio
* Curso
* Cantidad de alumnos
* Destino
* Fecha de viaje
* Servicios adicionales
* Seguros contratados

---

## C. Módulo de Gestión Financiera

### Responsabilidad

Controlar los aportes monetarios y el avance económico.

### Funcionalidades

* Registro de depósitos
* Control de aportes individuales
* Control de aportes grupales
* Cálculo de saldo pendiente
* Seguimiento de meta económica
* Consulta de estado de cuenta

### Incluye

* Cuenta del curso
* Cuenta individual del alumno
* Historial de depósitos

---

## D. Módulo de Actividades del Curso

### Responsabilidad

Gestionar actividades para recaudar fondos.

### Funcionalidades

* Registro de rifas
* Registro de fiestas
* Registro de ganancias
* Prorrateo automático entre alumnos
* Seguimiento del aporte por actividad

---

## E. Módulo de Notificaciones

### Responsabilidad

Mantener informados a todos los involucrados.

### Funcionalidades

* Envío de correos automáticos
* Notificación de depósitos
* Avisos de cambios importantes
* Confirmaciones de carga de documentos

### Destinatarios

* Apoderados
* Representantes de curso
* Ejecutivos de ventas

---

## F. Módulo de Gestión Documental

### Responsabilidad

Administrar documentos digitales del proceso.

### Funcionalidades

* Subida de archivos
* Descarga de contratos
* Descarga de pólizas
* Publicación de información relevante
* Generación de PDFs

---

## G. Módulo de Seguros

### Responsabilidad

Gestionar seguros contratados con aseguradoras externas.

### Funcionalidades

* Registro de aseguradoras
* Comparación de ofertas
* Asociación de seguros a contratos
* Generación de pólizas individuales
* Consulta de coberturas

---

## H. Módulo de Reportes y Estadísticas

### Responsabilidad

Entregar información estratégica y operacional.

### Funcionalidades

* Reportes de avance por curso
* Reportes por colegio
* Porcentaje de cumplimiento de metas
* Reportes de depósitos
* Reportes financieros

---

# 1.3 Interfaces de Integración Entre Componentes

| Componente             | Se Integra Con     | Objetivo                        |
| ---------------------- | ------------------ | ------------------------------- |
| Gestión de Contratos   | Gestión Financiera | Asociar pagos a contratos       |
| Gestión Financiera     | Notificaciones     | Avisar depósitos realizados     |
| Gestión Financiera     | Reportes           | Obtener estados de avance       |
| Gestión de Actividades | Gestión Financiera | Distribuir ganancias            |
| Gestión de Seguros     | Gestión Documental | Generar pólizas PDF             |
| Gestión Documental     | Notificaciones     | Informar documentos disponibles |
| Usuarios               | Todos los módulos  | Control de acceso y permisos    |
| Reportes               | Base de Datos      | Obtener indicadores             |

---

# 1.4 Arquitectura por Capas (MVC)

La solución propuesta utiliza el patrón arquitectónico **MVC**, organizado en tres capas principales.

---

# A. Capa View (Vista)

### Responsabilidad

Interacción con el usuario.

### Incluye

* Portal web para apoderados
* Portal administrativo
* Panel ejecutivo
* Formularios
* Reportes visuales

### Tecnologías sugeridas

* HTML5
* CSS3
* JavaScript
* Bootstrap o React

---

# B. Capa Controller (Controlador)

### Responsabilidad

Gestionar la lógica de negocio y el flujo de datos.

### Incluye

* Validación de información
* Procesamiento de depósitos
* Generación de reportes
* Gestión de autenticación
* Integración con correo electrónico

### Tecnologías sugeridas

* Spring Boot
* Django
* ASP.NET Core

---

# C. Capa Model (Modelo)

### Responsabilidad

Administrar datos y reglas de negocio.

### Entidades principales

* Usuario
* Colegio
* Curso
* Alumno
* Contrato
* Seguro
* Actividad
* Depósito
* Póliza
* Reporte

### Tecnologías sugeridas

* PostgreSQL
* MySQL

---

# 2. Diagrama de Arquitectura Física del Software

## 2.1 Descripción de la Arquitectura Física

La arquitectura física propuesta considera una solución web centralizada con acceso remoto desde cualquier dispositivo conectado a internet.

La solución se compone de:

* Clientes Web
* Servidor Web / Aplicación
* Servidor de Base de Datos
* Servicio de Correos
* Servicios externos de aseguradoras
* Almacenamiento documental

---

# 2.2 Componentes Físicos

| Nodo                 | Función                     |
| -------------------- | --------------------------- |
| Cliente Web          | Acceso de usuarios          |
| Servidor Web         | Interfaz y lógica MVC       |
| Servidor Aplicación  | Procesamiento de negocio    |
| Base de Datos        | Persistencia de información |
| Servidor de Archivos | Documentos PDF y pólizas    |
| Servicio SMTP        | Envío de correos            |
| Servicios Externos   | Aseguradoras                |

---

# 2.3 Diagrama UML – Vista Física

```text
                    +----------------------------------+
                    |         Usuarios Web             |
                    |----------------------------------|
                    | - Apoderados                    |
                    | - Ejecutivos                    |
                    | - Administradores               |
                    | - Dueño Agencia                 |
                    +----------------+----------------+
                                     |
                                     | HTTPS
                                     v
                 +--------------------------------------+
                 |         Servidor Web MVC             |
                 |--------------------------------------|
                 | View Layer                           |
                 | Controller Layer                     |
                 | Authentication                       |
                 | API REST                             |
                 +----------------+---------------------+
                                  |
                                  |
                                  v
                 +--------------------------------------+
                 |      Servidor de Aplicaciones        |
                 |--------------------------------------|
                 | Gestión Contratos                    |
                 | Gestión Financiera                   |
                 | Gestión Actividades                  |
                 | Gestión Seguros                      |
                 | Gestión Reportes                     |
                 | Notificaciones Email                 |
                 +---------+--------------+-------------+
                           |              |
                           |              |
            +--------------+              +----------------+
            |                                                |
            v                                                v

+---------------------------+             +--------------------------------+
|    Base de Datos SQL      |             |  Servidor de Documentos PDF    |
|---------------------------|             |--------------------------------|
| Usuarios                  |             | Contratos                      |
| Contratos                 |             | Pólizas                        |
| Cursos                    |             | Reportes                       |
| Depósitos                 |             | Archivos Adjuntos              |
| Seguros                   |             +--------------------------------+
| Actividades               |
+---------------------------+

            |
            |
            v

+-----------------------------------+
|     Servicios Externos            |
|-----------------------------------|
| - SMTP / Correo Electrónico       |
| - API Aseguradoras                |
+-----------------------------------+
```

---

# 2.4 Justificación Técnica de la Arquitectura

## Escalabilidad

La separación por módulos permite agregar nuevas funcionalidades sin afectar el sistema completo.

## Mantenibilidad

MVC facilita el mantenimiento y la reutilización del código.

## Seguridad

La arquitectura centralizada permite:

* Control de accesos
* Gestión de roles
* Protección de documentos
* Validación de autenticación

## Disponibilidad

Al ser web, el sistema puede ser utilizado:

* En cualquier momento
* Desde cualquier lugar
* Desde distintos dispositivos

## Integración

Permite conectarse fácilmente con:

* Servicios SMTP
* APIs externas
* Sistemas bancarios futuros
* Plataformas aseguradoras

---

# Conclusión

La arquitectura propuesta satisface los requerimientos funcionales y operacionales del caso “Agencia de Viajes On Tour”  mediante una solución modular basada en MVC, capaz de gestionar contratos, aportes económicos, seguros, documentación y notificaciones automáticas.

El modelo físico propuesto permite una solución escalable, segura y preparada para futuras integraciones tecnológicas, mejorando significativamente la transparencia y comunicación entre la agencia, los cursos y los apoderados.

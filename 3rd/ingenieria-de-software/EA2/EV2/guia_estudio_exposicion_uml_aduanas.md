# Guía de Estudio — Exposición UML Caso Aduanas

## Introducción
Esta guía fue desarrollada para apoyar la exposición de los diagramas UML generados para el caso del Sistema de Aduanas Terrestres presentado en el documento FormaB.

El objetivo principal del sistema es modernizar y automatizar los procesos de control fronterizo terrestre entre Chile y países limítrofes, disminuyendo tiempos de espera, mejorando la trazabilidad y fortaleciendo la integración entre organismos.

---

# Documento 1 — Guía de Estudio del Diagrama de Clases (Vista Lógica)

## 1. Base usada para construir el diagrama

El diagrama de clases fue construido tomando como referencia:

- Los problemas identificados en el caso:
  - largas esperas en aduanas
  - exceso de documentación manual
  - falta de integración entre organismos
  - lentitud en revisión de pasajeros y vehículos

- Las funcionalidades solicitadas:
  - automatización documental
  - control de menores de edad
  - gestión de vehículos
  - integración con SAG y PDI
  - generación de reportes
  - autenticación de usuarios
  - intercambio de información con aduanas extranjeras

- Los actores y entidades principales del negocio:
  - pasajeros
  - menores de edad
  - vehículos
  - documentos
  - funcionarios
  - controles migratorios
  - organismos externos

La vista lógica representa la estructura interna del sistema y cómo se relacionan los objetos principales del negocio.

---

## 2. Cómo se explica cada flujo

### Flujo 1 — Inicio de sesión

El flujo comienza con la clase Usuario.

- El usuario posee credenciales.
- El sistema valida autenticación.
- Solo usuarios habilitados pueden acceder.

Esto responde directamente al requerimiento:

> “Los usuarios solo podrán ingresar al sistema si poseen una cuenta habilitada”.

---

### Flujo 2 — Registro de pasajeros

La clase Pasajero representa a las personas que cruzan la frontera.

El pasajero:

- registra información personal
- presenta documentos
- puede asociarse a un vehículo
- completa declaraciones SAG

Este flujo busca disminuir el tiempo manual de atención.

---

### Flujo 3 — Validación de menores de edad

La clase MenorEdad hereda características de Pasajero.

Se agrega:

- validación de autorización notarial
- control de permisos
- revisión legal

Esto responde al requerimiento de automatizar salida y entrada de menores.

---

### Flujo 4 — Gestión vehicular

La clase Vehiculo almacena:

- patente
- país de origen
- tipo de vehículo

Permite:

- registrar salidas temporales
- validar documentación
- controlar permanencia autorizada

Este flujo automatiza trámites actualmente manuales.

---

### Flujo 5 — Declaración SAG

La clase DeclaracionSAG controla:

- ingreso de alimentos
- productos animales o vegetales
- declaraciones juradas

El sistema permite digitalizar formularios y reducir tiempos de revisión.

---

### Flujo 6 — Fiscalización y control

Existen dos clases:

- ControlMigratorio
- ControlAduana

Estas representan:

- revisión de personas
- revisión documental
- fiscalización vehicular
- validación de ingreso y salida

Aquí se modela la interacción con PDI y Aduanas.

---

### Flujo 7 — Integración internacional

La clase SistemaIntegrado representa:

- intercambio de información
- sincronización de datos
- comunicación con aduanas extranjeras

Esto responde al requerimiento:

> “Integración de los sistemas para la obtención de información y datos entre las aduanas de países limítrofes”.

---

### Flujo 8 — Generación de reportes

La clase Reporte permite:

- generar estadísticas
- exportar PDF
- exportar Excel

Esto responde a:

- análisis estadístico
- control de flujo fronterizo
- trazabilidad

---

## 3. Decisiones importantes del diagrama

### Uso de herencia

Se decidió que MenorEdad herede de Pasajero porque:

- comparte atributos comunes
- evita duplicar información
- mejora reutilización
- facilita mantenimiento

---

### Separación entre control migratorio y control aduanero

Se modelaron como componentes separados porque:

- representan procesos distintos
- pueden operar de forma independiente
- permiten escalabilidad futura
- reflejan la realidad del negocio

---

### Inclusión de SistemaIntegrado

Fue agregado porque el caso enfatiza:

- integración internacional
- interoperabilidad
- intercambio de datos

Sin esta clase, el modelo quedaría incompleto.

---

### Modelo centrado en automatización

El diseño prioriza:

- reducción de tiempos
- digitalización
- trazabilidad
- eficiencia operativa

Todas las clases apoyan esos objetivos.

---

## 4. Explicación oral sugerida

### Introducción sugerida

“Este diagrama representa la vista lógica del sistema de Aduanas. Su objetivo es mostrar las entidades principales del negocio y cómo se relacionan para automatizar el proceso fronterizo.”

---

### Explicación sugerida del flujo

“Todo comienza con un usuario autenticado que ingresa al sistema. Luego se registra la información del pasajero, sus documentos y eventualmente su vehículo.

Si el pasajero es menor de edad, el sistema valida permisos notariales.

Posteriormente se realizan controles migratorios y aduaneros, además de las validaciones del SAG.

Finalmente, toda la información puede integrarse con sistemas extranjeros y utilizarse para generar reportes estadísticos.”

---

### Cierre sugerido

“En conclusión, el modelo busca representar una solución moderna, integrada y automatizada que reduzca tiempos de espera y mejore la eficiencia del proceso aduanero.”

---

## 5. Posibles preguntas y respuestas del profesor

### Pregunta:
¿Por qué usar herencia entre Pasajero y MenorEdad?

### Respuesta:
Porque un menor de edad sigue siendo un pasajero, pero con reglas adicionales de validación.

---

### Pregunta:
¿Por qué separar ControlMigratorio y ControlAduana?

### Respuesta:
Porque representan responsabilidades distintas dentro del proceso fronterizo y permiten modularidad.

---

### Pregunta:
¿Qué ventaja tiene SistemaIntegrado?

### Respuesta:
Permite interoperabilidad con aduanas extranjeras y reduce duplicidad de información.

---

### Pregunta:
¿Qué problema principal resuelve el sistema?

### Respuesta:
Reduce tiempos de espera mediante automatización y digitalización de procesos.

---

### Pregunta:
¿Por qué generar reportes en PDF y Excel?

### Respuesta:
Porque el requerimiento funcional lo solicita y facilita análisis estadístico y trazabilidad.

---

# Documento 2 — Guía de Estudio del Diagrama de Componentes / Despliegue

## 1. Base usada para construir el diagrama

El diagrama de componentes fue construido considerando:

- arquitectura modular
- integración entre organismos
- automatización de procesos
- seguridad de acceso
- almacenamiento centralizado

El objetivo de esta vista es mostrar:

- cómo se divide el sistema
- cómo interactúan los módulos
- cómo fluye la información
- cómo se integra la solución tecnológica

---

## 2. Cómo se explica cada flujo

### Flujo 1 — Acceso al sistema

Todo comienza desde:

- Portal Web Aduana

El usuario accede mediante navegador.

El portal se conecta con:

- Módulo de Autenticación

Aquí se validan:

- credenciales
- permisos
- accesos habilitados

---

### Flujo 2 — Gestión de pasajeros

El módulo Gestión Pasajeros:

- registra viajeros
- valida datos
- procesa documentación
- coordina controles

Este componente centraliza la lógica de personas.

---

### Flujo 3 — Gestión de vehículos

El módulo Gestión Vehículos:

- registra vehículos
- controla salidas temporales
- valida permanencias
- procesa documentación vehicular

Automatiza procesos actualmente manuales.

---

### Flujo 4 — Gestión documental

El componente Gestión Documentos:

- almacena formularios
- valida documentos
- procesa autorizaciones
- registra declaraciones

Este módulo reduce uso de papel.

---

### Flujo 5 — Integración con SAG y PDI

Existen módulos independientes:

- Control SAG
- Control PDI

Esto representa:

- interoperabilidad
- validaciones externas
- controles especializados

---

### Flujo 6 — Base de datos central

Todos los componentes almacenan información en:

- Base de Datos Central

Aquí se guarda:

- pasajeros
- vehículos
- documentos
- reportes
- registros históricos

---

### Flujo 7 — Integración internacional

El componente Integración Aduanas Extranjeras:

- sincroniza datos
- comparte información
- valida registros internacionales

Esto mejora trazabilidad y velocidad.

---

### Flujo 8 — Generación de reportes

El Motor Reportes obtiene información desde la base central.

Permite:

- generar estadísticas
- exportar PDF
- exportar Excel
- analizar flujos migratorios

---

## 3. Decisiones importantes del diagrama

### Arquitectura modular

El sistema fue dividido en componentes porque:

- facilita mantenimiento
- mejora escalabilidad
- permite reemplazar módulos
- simplifica futuras mejoras

---

### Base de datos centralizada

Se decidió usar una base central para:

- mantener consistencia
- evitar duplicidad
- mejorar trazabilidad
- facilitar reportes

---

### Separación de SAG y PDI

Se mantuvieron separados porque:

- representan organismos distintos
- tienen reglas independientes
- pueden evolucionar por separado

---

### Portal web único

Se utiliza un único portal porque:

- simplifica experiencia de usuario
- reduce complejidad
- centraliza acceso

---

## 4. Explicación oral sugerida

### Introducción sugerida

“Este diagrama representa la vista de componentes y despliegue del sistema. Aquí se muestra cómo se divide técnicamente la solución y cómo interactúan los módulos internos.”

---

### Explicación sugerida del flujo

“El usuario accede al Portal Web de Aduanas y primero pasa por el módulo de autenticación.

Luego el sistema deriva la información hacia los módulos de pasajeros, vehículos y documentos.

Los controles especializados se integran mediante módulos independientes del SAG y la PDI.

Toda la información se almacena en una base de datos centralizada.

Finalmente, el sistema puede generar reportes y compartir información con aduanas extranjeras.”

---

### Cierre sugerido

“En resumen, la arquitectura propuesta busca ser modular, escalable y segura, permitiendo automatizar el proceso fronterizo y mejorar la eficiencia operativa.”

---

## 5. Posibles preguntas y respuestas del profesor

### Pregunta:
¿Por qué usar arquitectura modular?

### Respuesta:
Porque facilita mantenimiento, escalabilidad y separación de responsabilidades.

---

### Pregunta:
¿Por qué centralizar la base de datos?

### Respuesta:
Porque mejora consistencia de datos y facilita generación de reportes.

---

### Pregunta:
¿Por qué separar SAG y PDI?

### Respuesta:
Porque son organismos independientes con procesos distintos.

---

### Pregunta:
¿Qué ventaja tiene integrar aduanas extranjeras?

### Respuesta:
Permite compartir información en tiempo real y acelerar validaciones.

---

### Pregunta:
¿Cómo ayuda esta arquitectura a reducir tiempos de espera?

### Respuesta:
Mediante automatización, digitalización y centralización de procesos.

---

# Recomendaciones Finales para la Exposición

## Consejos importantes

- Explicar primero el problema del caso.
- Relacionar cada componente con un requerimiento.
- Hablar de automatización constantemente.
- Destacar reducción de tiempos de espera.
- Explicar que UML representa soluciones antes de programar.

---

## Forma recomendada de exponer

1. Problema actual.
2. Objetivo del sistema.
3. Explicación del diagrama.
4. Decisiones técnicas.
5. Beneficios del diseño.
6. Conclusión.

---

## Frase final sugerida

“Los diagramas permiten visualizar de manera anticipada cómo funcionará el sistema, facilitando el análisis, la organización y la implementación de una solución tecnológica eficiente.”


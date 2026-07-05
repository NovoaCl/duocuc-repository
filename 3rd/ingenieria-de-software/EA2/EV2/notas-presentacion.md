Muy buenas tardes a todos, en esta oportunidad les presentaré el diagrama de clases propuesto para el caso de aduanas aduanas fronterizas.

## Diagrama de clases


### 1. Usuario - Inicio de sesión

- Permite registrar al usuario y darle credenciales para su autenticación para poder hacer ingreso al sistema.

---

### 2. Pasajero - Registro de pasajeros

- Registra información personal del pasajero  y su ingreso

---

### 3. Validación de menores de edad

- Control y validacion de permisos con autorización notarial

---

### 4. Validación de documentos

- Se valida la autenticidad de los documentos proporcionados por el pasajero.

---

### 5. Declaración SAG

- Genera declaraciones juradas y controla ingreso de alimentos

---

### 6. Gestión vehicular

- Permite registrar datos del vehiculo, salidas temporales y validar documentación

---

### 7. Fiscalización y control

Aquí se modela la interacción con PDI y Aduanas.

ControlMigratorio:
- revisión de personas y documental

ControlAduana:
- fiscalización vehicular y validación de ingreso y salida

---

### 7 — Integración internacional

- Representa comunicación con aduanas extranjeras, elintercambio de información y sincronización de datos.

---

### 8 — Generación de reportes

- Generar estadísticas en excel y pdf para su analisis
- Esto mejoraria el control del flujo fronteriso

---

## Diagrama de componentes

---

### 1 — Acceso al sistema

**Portal Web Aduana:** El usuario accede mediante navegador.

**Módulo de Autenticación:** se validan credenciales, permisos y accesos habilitados.

---

### 2 — Gestión de pasajeros

- Registra viajeros, valida sus datos, procesa documentación y coordina controles

---

### 3 — Integración con  PDI

- Controles especializados para revisión de personas y documentos

---

### 4 — Base de datos central

- Todos los componentes terminan almacenando información en la Base de datos central

---

### 5 — Integración internacional

- Comparte información, sincroniza datos y valida registros internacionales

---

### 6 — Gestión de vehículos

- Registra vehículos, controla salidas temporales, valida permanencias y procesa documentación vehicular

---

### 7 — Gestión documental

- Almacena formularios, valida documentos, procesa autorizaciones y registra declaraciones

---

### 8 — Integración con SAG

- Genera declaraciones juradas y controla ingreso de alimentos

---

### 9 — Generación de reportes
- Generar estadísticas en excel y pdf para su analisis
- Esto mejoraria el control del flujo fronteriso

---

## Para concluir
Automatiza procesos actualmente manuales.
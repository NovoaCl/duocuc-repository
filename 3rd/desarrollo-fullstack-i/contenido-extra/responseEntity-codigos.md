200 OK
Uso: Solicitud exitosa (GET, PUT, DELETE).

Ejemplo de código:

return ResponseEntity.ok(data);



201 Created
Uso: Recurso creado (POST).

Ejemplo de código:

return ResponseEntity.status(201).body(nuevo);



400 Bad Request
Uso: Datos inválidos o error en la solicitud.

Ejemplo de código:

return ResponseEntity.badRequest().body("Datos inválidos");



401 Unauthorized
Uso: No autenticado (falta token o credenciales).

Ejemplo de código:

return ResponseEntity.status(401).body("No autorizado");



403 Forbidden
Uso: Sin permisos para acceder al recurso.

Ejemplo de código:

return ResponseEntity.status(403).body("Acceso denegado");



404 Not Found
Uso: Recurso no encontrado.

Ejemplo de código:

return ResponseEntity.status(404).body("No encontrado");



500 Internal Server Error
Uso: Error interno del servidor.

Ejemplo de código:

return ResponseEntity.status(500).body("Error interno");
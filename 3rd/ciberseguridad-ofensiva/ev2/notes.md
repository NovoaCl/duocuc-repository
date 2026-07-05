Técnicas de explotación de vulnerabilidades

Acontinuación,sedescribenalgunasdelastécnicasmáscomunesutilizadasparaexplotarvulnerabilidadesensistemasyaplicaciones.

• Desbordamiento de Buffer (BufferOverflow):
Ocurre cuando un programa escribe más datos en un buffer de los que puede contener, sobrescribiendo así la memoria adyacente.

• RemoteCodeExecution(RCE):Ejecucióndecódigoarbitrarioenunsistemaremoto,debidoaunavulnerabilidadenelsoftware
•
BypassdeAutenticación:Accesonoautorizadoaunsistema,eludiendolosmecanismosdeautenticación.
Explotación de vulnerabilidades

Password cracking:
Consiste en la recuperación de contraseñas desde data cifrada u ofuscada, a
través de técnicas alternativas a la autenticación tradicional.
Las principales técnicas utilizadas para este efecto son:
• Ataque de diccionario: que intenta probar muchas combinaciones de
contraseñas establecidas en una base de datos.
• Ataque de fuerza bruta: que intenta probar combinaciones de caracteres a
una alta tasa, hasta obtener la contraseña.

Ataque de diccionario
Es un método para descifrar contraseñas, probando combinaciones
predefinidas de palabras comunes, frases o términos almacenados en un
archivo llamado diccionario.
Los atacantes asumen que los usuarios suelen utilizar contraseñas sencillas o
palabras comunes.
Es más rápido que un ataque de fuerza bruta porque no prueba todas las
combinaciones posibles, sino solo palabras probables.

Ataque de fuerza bruta
Es un método de descifrado en el que un atacante prueba todas las
combinaciones posibles de contraseñas hasta encontrar la correcta. Se
basa en un enfoque exhaustivo, pero es lento y requiere muchos recursos,
especialmente para contraseñas largas o complejas.
• Efectivo contra contraseñas simples o cortas.
• Utiliza herramientas automatizadas para probar combinaciones
rápidamente.
• Factores como el tamaño del conjunto de caracteres y la longitud de la
contraseña determinan el tiempo requerido.

Ataque rainbow
El ataque de tablas rainbow es un método utilizado para recuperar
contraseñas a partir de valores hash. En lugar de intentar adivinar
contraseñas mediante fuerza bruta o ataques de diccionario, este enfoque se
basa en tablas precomputadas que permiten encontrar rápidamente la
contraseña original correspondiente a un hash dado.

min 45
- Levantar ambas maquinas
- Desde Kali correr en la terminal msfconsole
- Obtener la direccion IP de meta 
- Hacemos un nmap con la IP de meta


Comandos para Metasploit
- search — buscar exploit por CVE, nombre de software o plataforma"
- use — seleccionar el módulo"
- show options — ver qué parámetros requiere"
- set — configurar los parámetros (RHOSTS, LHOST, payload, etc.)"
- run
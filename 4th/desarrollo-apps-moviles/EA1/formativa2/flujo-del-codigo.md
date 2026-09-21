# Flujo del Codigo - Sistema de Gestion de Entradas

Explicacion detallada de como funciona el programa paso a paso.

---

## Ejecucion del Programa

El programa inicia en la funcion `main()` y ejecuta 4 bloques principales en orden secuencial.

---

### Bloque 1: Creacion de la Lista de Entradas

```kotlin
val listaDeEntradas: MutableList<Entrada> =
    mutableListOf(
        EntradaGeneral(id ="GEN01", precio = 2000.0, ubicacion = "PLatea Alta"),
        EntradaGeneral(id = "GEN02", precio = 2000.0, ubicacion = "PLatea Alta"),
        EntradaVip(id = "GEN03", precio = 20000.0, ubicacion = "PLatea Alta", beneficiosExtra = "Juguito"),
        EntradaVip(id = "GEN04", precio = 20000.0, ubicacion = "PLatea Alta", beneficiosExtra = "Juguito")
    )
```

**Que pasa:**
- Se crea una lista mutable llamada `listaDeEntradas`
- Se agregan 4 objetos: 2 de tipo `EntradaGeneral` y 2 de tipo `EntradaVip`
- El tipo de la lista es `MutableList<Entrada>`, lo que permite polimorfismo
- Cada objeto se construye con sus parametros correspondientes

**Resultado en memoria:**
```
listaDeEntradas = [
    EntradaGeneral { id="GEN01", precio=2000.0, ubicacion="PLatea Alta" },
    EntradaGeneral { id="GEN02", precio=2000.0, ubicacion="PLatea Alta" },
    EntradaVip    { id="GEN03", precio=20000.0, ubicacion="PLatea Alta", beneficiosExtra="Juguito" },
    EntradaVip    { id="GEN04", precio=20000.0, ubicacion="PLatea Alta", beneficiosExtra="Juguito" }
]
```

---

### Bloque 2: Calculo del Ingreso Total

```kotlin
var ingresos = calcularIngresoTotal(listaDeEntradas)
println("Ingreso total: $ingresos")
```

**Ejecucion de `calcularIngresoTotal()`:**

```kotlin
fun calcularIngresoTotal(listaDeEntradas: MutableList<Entrada>): Double {
    var total = 0.0
    listaDeEntradas.forEach {
        total += it.precio
    }
    return total
}
```

**Que pasa:**
1. Se inicializa `total = 0.0`
2. Se recorre la lista con `forEach`, accediendo al `precio` de cada entrada
3. Se suma cada precio al acumulador

**Iteracion paso a paso:**
```
Iteracion 1: it = EntradaGeneral(GEN01) -> it.precio = 2000.0  -> total = 0.0 + 2000.0  = 2000.0
Iteracion 2: it = EntradaGeneral(GEN02) -> it.precio = 2000.0  -> total = 2000.0 + 2000.0 = 4000.0
Iteracion 3: it = EntradaVip(GEN03)     -> it.precio = 20000.0 -> total = 4000.0 + 20000.0 = 24000.0
Iteracion 4: it = EntradaVip(GEN04)     -> it.precio = 20000.0 -> total = 24000.0 + 20000.0 = 44000.0
```

**Salida en consola:**
```
Ingreso total: 44000.0
```

---

### Bloque 3: Conteo de Entradas VIP

```kotlin
var cantidadVips = contarVips(listaDeEntradas)
println("Cantidad de entradas VIP: $cantidadVips")
```

**Ejecucion de `contarVips()`:**

```kotlin
fun contarVips(listaDeEntradas: MutableList<Entrada>): Int {
    val entradaVip = listaDeEntradas.filter {
        it is EntradaVip
    }
    return entradaVip.size
}
```

**Que pasa:**
1. Se aplica `filter` con el operador `is` para verificar el tipo de cada elemento
2. Solo pasan los objetos que son instancia de `EntradaVip`
3. Se retorna el tamano de la lista filtrada

**Filtro paso a paso:**
```
it = EntradaGeneral(GEN01) -> it is EntradaVip? = false -> NO se agrega
it = EntradaGeneral(GEN02) -> it is EntradaVip? = false -> NO se agrega
it = EntradaVip(GEN03)     -> it is EntradaVip? = true  -> SE agrega
it = EntradaVip(GEN04)     -> it is EntradaVip? = true  -> SE agrega
```

**Resultado:**
```
entradaVip = [ EntradaVip(GEN03), EntradaVip(GEN04) ]
entradaVip.size = 2
```

**Salida en consola:**
```
Cantidad de entradas VIP: 2
```

---

### Bloque 4: Validacion Asincrona con Corrutinas

```kotlin
runBlocking {
    val estadoFinal = validarEntrada(id = "GEN01", listaDeEntradas)
    when (estadoFinal) {
        is EstadoValidacion.Validando -> println("Validando...")
        is EstadoValidacion.NoValida -> println(estadoFinal.mensaje)
        is EstadoValidacion.Valida -> println("Entrada ${estadoFinal.entrada.id} es valida")
    }
}
```

Este es el bloque mas importante. Funciona en 3 fases:

#### Fase 4.1: `runBlocking`

```kotlin
runBlocking { ... }
```

**Que pasa:**
- `runBlocking` bloquea el hilo de ejecucion principal
- Crea un scope de corrutinas
- Permite usar funciones `suspend` dentro del bloque
- Espera a que todas las corrutinas terminen antes de continuar

#### Fase 4.2: `validarEntrada()` - Funcion Suspend

```kotlin
suspend fun validarEntrada(id: String, listaDeEntradas: MutableList<Entrada>): EstadoValidacion {
    println("Procesando entradas")
    delay(2000L)

    val entradaEncontrada: Entrada? = listaDeEntradas.find{ it.id == id }

    if (entradaEncontrada != null) {
        return EstadoValidacion.Valida(entradaEncontrada)
    } else {
        return EstadoValidacion.NoValida("Error: Entrada no encontrada")
    }
}
```

**Que pasa:**

1. **`println("Procesando entradas")`** - Muestra mensaje de inicio
2. **`delay(2000L)`** - Pausa la ejecucion 2 segundos sin bloquear el hilo (caracteristica de corrutinas)
3. **`listaDeEntradas.find{ it.id == id }`** - Busca la entrada cuyo `id` coincida con el parametro
4. **`EstadoValidacion?`** - El resultado puede ser `null` si no se encontro

**Busqueda paso a paso:**
```
Buscando id = "GEN01"
Comparando: "GEN01" == "GEN01" -> MATCH -> retorna EntradaGeneral(GEN01)
```

**Retorno:**
- Si lo encontro: `EstadoValidacion.Valida(EntradaGeneral(GEN01))`
- Si no encontro: `EstadoValidacion.NoValida("Error: Entrada no encontrada")`

#### Fase 4.3: `when` - Manejo de Estados

```kotlin
when (estadoFinal) {
    is EstadoValidacion.Validando -> println("Validando...")
    is EstadoValidacion.NoValida -> println(estadoFinal.mensaje)
    is EstadoValidacion.Valida -> println("Entrada ${estadoFinal.entrada.id} es valida")
}
```

**Que pasa:**
- La expresion `when` evalua el tipo de `estadoFinal`
- Usa `is` para verificar a que subclase pertenece
- Se ejecuta solo la rama que coincide

**Con el ejemplo (id = "GEN01"):**
```
estadoFinal = EstadoValidacion.Valida(EntradaGeneral(GEN01))

when (estadoFinal) {
    is EstadoValidacion.Validando -> NO coincide
    is EstadoValidacion.NoValida   -> NO coincide
    is EstadoValidacion.Valida     -> SI coincide -> imprime "Entrada GEN01 es valida"
}
```

**Salida en consola:**
```
Procesando entradas
(espera 2 segundos)
Entrada GEN01 es valida
```

---

## Salida Completa del Programa

```
Ingreso total: 44000.0
Cantidad de entradas VIP: 2
Procesando entradas
(2 segundos de espera)
Entrada GEN01 es valida
```

---

## Diagrama de Flujo General

```
main()
    │
    ▼
Crear listaDeEntradas (2 General + 2 VIP)
    │
    ▼
calcularIngresoTotal() ──► forEach suma precios ──► return 44000.0
    │
    ▼
Imprimir "Ingreso total: 44000.0"
    │
    ▼
contarVips() ──► filter con is EntradaVip ──► return 2
    │
    ▼
Imprimir "Cantidad de entradas VIP: 2"
    │
    ▼
runBlocking
    │
    ▼
validarEntrada("GEN01")
    │
    ├─► println("Procesando entradas")
    │
    ├─► delay(2000L)  ──► pausa 2 segundos
    │
    ├─► find { it.id == "GEN01" }  ──► encuentra EntradaGeneral(GEN01)
    │
    └─► return EstadoValidacion.Valida(entrada)
    │
    ▼
when (estadoFinal)
    │
    └─► is Valida ──► println("Entrada GEN01 es valida")
    │
    ▼
Fin del programa
```

---

## Conceptos Clave Aplicados

| Concepto             | Donde se aplica                                    |
|----------------------|----------------------------------------------------|
| **Herencia**         | `EntradaGeneral` y `EntradaVip` heredan de `Entrada` |
| **Polimorfismo**     | Lista `MutableList<Entrada>` almacena ambos tipos  |
| **Override**         | Ambas clases sobrescriben `mostrarDetalle()`       |
| **Sealed Class**     | `EstadoValidacion` con 3 estados tipados           |
| **Corrutinas**       | `suspend fun`, `delay()`, `runBlocking`            |
| **Colecciones**      | `forEach`, `filter`, `find`, `sumOf`               |
| **Null Safety**      | `Entrada?` con verificacion `!= null`              |
| **Operador is**      | Verificacion de tipo en `filter` y `when`          |

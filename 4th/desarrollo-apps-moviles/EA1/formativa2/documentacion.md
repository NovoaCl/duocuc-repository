# Documentacion del Proyecto - Sistema de Gestion de Entradas

Proyecto de consola en Kotlin que modela un sistema de gestion de eventos con OOP, colecciones y corrutinas.

---

## 1. Entrada (Clase Base)

**Archivo:** `src/main/kotlin/Entrada.kt`

Clase base open que representa una entrada generica para un evento.

### Propiedades

| Propiedad  | Tipo     | Descripcion              |
|------------|----------|--------------------------|
| `id`       | `String` | Identificador unico      |
| `precio`   | `Double` | Precio de la entrada     |
| `ubicacion`| `String` | Ubicacion en el recinto  |

### Metodos

| Metodo              | Retorno   | Descripcion                            |
|---------------------|-----------|----------------------------------------|
| `mostrarDetalle()`  | `String`  | Devuelve informacion general de la entrada |

### Codigo fuente

```kotlin
open class Entrada(
    val id: String,
    val precio: Double,
    val ubicacion: String) {

    open fun mostrarDetalle(): String {
        return "La entrada $id tiene precio $precio y se ubica en $ubicacion"
    }
}
```

---

## 2. EntradaGeneral (Clase Derivada)

**Archivo:** `src/main/kotlin/EntradaGeneral.kt`

Clase que hereda de `Entrada`. Representa una entrada de tipo general.

### Hereda de

`Entrada`

### Metodos

| Metodo              | Retorno   | Descripcion                                    |
|---------------------|-----------|------------------------------------------------|
| `mostrarDetalle()`  | `String`  | Sobrescribe el metodo base con info general    |

### Codigo fuente

```kotlin
class EntradaGeneral(
    id: String,
    precio: Double,
    ubicacion: String): Entrada(id, precio, ubicacion){

    override fun mostrarDetalle(): String {
        return "Esta entrada general " +
                "$id tiene precio: $precio " +
                "y se ubica en $ubicacion"
    }
}
```

---

## 3. EntradaVip (Clase Derivada)

**Archivo:** `src/main/kotlin/EntradaVIP.kt`

Clase que hereda de `Entrada`. Representa una entrada VIP con beneficios adicionales.

### Hereda de

`Entrada`

### Propiedades adicionales

| Propiedad       | Tipo     | Descripcion                     |
|-----------------|----------|---------------------------------|
| `beneficiosExtra`| `String`| Beneficios exclusivos VIP       |

### Metodos

| Metodo              | Retorno   | Descripcion                                           |
|---------------------|-----------|-------------------------------------------------------|
| `mostrarDetalle()`  | `String`  | Sobrescribe el metodo base con info VIP y beneficios  |

### Codigo fuente

```kotlin
class EntradaVip(
    id: String,
    precio: Double,
    ubicacion: String,
    val beneficiosExtra: String) : Entrada(id, precio, ubicacion) {

    override fun mostrarDetalle(): String {
        return "Esta entrada general $id " +
                "tiene precio: $precio" +
                "y se ubica en $ubicacion " +
                "y tiene los siguientes beneficios: $beneficiosExtra"
    }
}
```

---

## 4. EstadoValidacion (Sealed Class)

**Archivo:** `src/main/kotlin/EstadoValidacion.kt`

Clase sellada que representa los tres estados posibles de la validacion de una entrada.

### Estados

| Estado      | Tipo     | Datos adicionales             | Descripcion                     |
|-------------|----------|-------------------------------|---------------------------------|
| `Validando` | `object` | Ninguno                       | Estado de procesamiento         |
| `Valida`    | `class`  | `entrada: Entrada`            | La entrada fue validada         |
| `NoValida`  | `class`  | `mensaje: String`             | La entrada no es valida         |

### Codigo fuente

```kotlin
sealed class EstadoValidacion {
    object Validando : EstadoValidacion()
    class Valida(val entrada: Entrada) : EstadoValidacion()
    class NoValida(val mensaje: String) : EstadoValidacion()
}
```

---

## 5. Funciones y Punto de Entrada

**Archivo:** `src/main/kotlin/Main.kt`

### Funciones

| Funcion                          | Retorno            | Descripcion                                             |
|----------------------------------|--------------------|---------------------------------------------------------|
| `main()`                         | `Unit`             | Punto de entrada, crea lista y ejecuta validacion       |
| `calcularIngresoTotal()`         | `Double`           | Suma el precio de todas las entradas con forEach         |
| `calcularIngreso()`              | `Double`           | Suma el precio de todas las entradas con sumOf           |
| `contarVips()`                   | `Int`              | Filtra y cuenta las entradas de tipo EntradaVip          |
| `validarEntrada()`               | `EstadoValidacion` | Busca entrada por id con delay de 2s (suspend fun)      |

### Diagrama de flujo de main()

```
1. Crear lista de entradas (2 General + 2 VIP)
2. Calcular e imprimir ingreso total
3. Contar e imprimir cantidad de VIP
4. runBlocking -> validarEntrada("GEN01")
   - Simula delay de 2 segundos
   - Busca la entrada por id
   - Devuelve Valida o NoValida
5. Manejar resultado con when
```

### Codigo fuente

```kotlin
import kotlinx.coroutines.*

fun main() {

    val listaDeEntradas: MutableList<Entrada> =
        mutableListOf(
            EntradaGeneral(id ="GEN01", precio = 2000.0, ubicacion = "PLatea Alta"),
            EntradaGeneral(id = "GEN02", precio = 2000.0, ubicacion = "PLatea Alta"),
            EntradaVip(id = "GEN03", precio = 20000.0, ubicacion = "PLatea Alta", beneficiosExtra = "Juguito"),
            EntradaVip(id = "GEN04", precio = 20000.0, ubicacion = "PLatea Alta", beneficiosExtra = "Juguito")
        )

    var ingresos = calcularIngresoTotal(listaDeEntradas)
    println("Ingreso total: $ingresos")

    var cantidadVips = contarVips(listaDeEntradas)
    println("Cantidad de entradas VIP: $cantidadVips")

    runBlocking {
        val estadoFinal = validarEntrada(id = "GEN01", listaDeEntradas)
        when (estadoFinal) {
            is EstadoValidacion.Validando -> println("Validando...")
            is EstadoValidacion.NoValida -> println(estadoFinal.mensaje)
            is EstadoValidacion.Valida -> println("Entrada ${estadoFinal.entrada.id} es valida")
        }
    }
}

fun calcularIngresoTotal(listaDeEntradas: MutableList<Entrada>): Double {
    var total = 0.0
    listaDeEntradas.forEach {
        total += it.precio
    }
    return total
}

fun calcularIngreso(listaDeEntradas: MutableList<Entrada>): Double {
    var total = listaDeEntradas.sumOf {
        it.precio
    }
    return total
}

fun contarVips(listaDeEntradas: MutableList<Entrada>): Int {
    val entradaVip = listaDeEntradas.filter {
        it is EntradaVip
    }
    return entradaVip.size
}

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

---

## 6. Dependencias (pom.xml)

| Dependencia                | GrupoId                      | Version | Scope  |
|----------------------------|------------------------------|---------|--------|
| `kotlin-test-junit5`       | `org.jetbrains.kotlin`       | 2.2.20  | test   |
| `junit-jupiter`            | `org.junit.jupiter`          | 5.10.0  | test   |
| `kotlin-stdlib`            | `org.jetbrains.kotlin`       | 2.2.20  | compile|
| `kotlinx-coroutines-core`  | `org.jetbrains.kotlinx`      | 1.7.3   | compile|

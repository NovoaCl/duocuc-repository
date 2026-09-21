## 1. Entrada (Clase Base)

open class Entrada(
    val id: String,
    val precio: Double,
    val ubicacion: String) {

    open fun mostrarDetalle(): String {
        return "La entrada $id tiene precio $precio y se ubica en $ubicacion"
    }
}

## 2. EntradaGeneral (Clase Derivada)

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

## 3. EntradaVip (Clase Derivada)

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

## 4. EstadoValidacion (Sealed Class)

sealed class EstadoValidacion {
    object Validando : EstadoValidacion()
    class Valida(val entrada: Entrada) : EstadoValidacion()
    class NoValida(val mensaje: String) : EstadoValidacion()
}

## 5. Funciones y Punto de Entrada (Main)

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

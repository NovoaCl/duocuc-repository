import kotlinx.coroutines.*

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
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
    delay(2000L) // retrasa el resultado 2 segundos

    val entradaEncontrada: Entrada? = listaDeEntradas.find{ it.id == id } // El ? indica que la variable puede ser null

    if (entradaEncontrada != null) {
        return EstadoValidacion.Valida(entradaEncontrada)
    } else {
        return EstadoValidacion.NoValida("Error: Entrada no encontrada")
    }
}
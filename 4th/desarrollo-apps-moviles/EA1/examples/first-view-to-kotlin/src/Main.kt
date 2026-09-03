//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main() {

    var a: Int = 4
    var b: Int = 2

    when(a){
        5 -> println("Hola")
        else -> println("Adios")
    }

    var c: Int = a + b

    println("c = $c")

    val name = "Mimi"
    //TIP Press <shortcut actionId="ShowIntentionActions"/> with your caret at the highlighted text
    // to see how IntelliJ IDEA suggests fixing it.
    println("Hello, " + name + "!")

    for (i in 1..5) {
        //TIP Press <shortcut actionId="Debug"/> to start debugging your code. We have set one <icon src="AllIcons.Debugger.Db_set_breakpoint"/> breakpoint
        // for you, but you can always add more by pressing <shortcut actionId="ToggleLineBreakpoint"/>.
        println("i = $i")
    }
    
    val datos = listOf("A", "b", "c") 
    
    datos.forEach {
        item -> println("Procesando :$item")
    }

    //Funciones de orden superior
    // Filter
    var numeros = listOf(1, 2, 3, 4, 5)
    val pares = numeros.filter { it % 2 == 0 && it > 3
    }
    println(pares)
    //Map (transformacion)
    //var numeros = listOf(1, 2, 3)
    val multiplicados = numeros.map {it * 10}
    println(multiplicados)

    //Chaining
    /*
    data class Usuario(val name: String, val age: Int)

    val nombresAdultos: List<String> = usuarios
        .filter {it.edad >= 18}
        .map { it.nombre }
    */

    //Dowhile

    var i = 20
    do {
        println("Hola")
    } while (i <= 18)


    }
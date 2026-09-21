open class Entrada(
    val id: String,
    val precio: Double,
    val ubicacion: String) {

    open fun mostrarDetalle(): String {
        return "La entrada $id tiene precio $precio y se ubica en $ubicacion"
    }

}

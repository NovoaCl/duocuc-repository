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
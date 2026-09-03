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
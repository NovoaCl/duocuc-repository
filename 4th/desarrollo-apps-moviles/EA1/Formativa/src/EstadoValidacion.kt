sealed class EstadoValidacion {
    object Validando : EstadoValidacion()
    class Valida(val entrada: Entrada) : EstadoValidacion()
    class NoValida(val mensaje: String) : EstadoValidacion()
}
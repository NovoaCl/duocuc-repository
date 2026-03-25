package cl.duoc.MicroservicioPersona.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Persona {

    private int rut;
    private char dv;
    private String nombre;

}

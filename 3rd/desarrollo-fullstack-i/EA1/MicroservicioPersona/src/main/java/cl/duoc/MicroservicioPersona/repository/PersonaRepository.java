package cl.duoc.MicroservicioPersona.repository;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import cl.duoc.MicroservicioPersona.model.Persona;

@Repository
public class PersonaRepository {
    private List<Persona> listaPersonas = new ArrayList<>();

    public List<Persona> getPersonas() {
        return new ArrayList<>(listaPersonas);
    }

    public Persona getByRut(int rut) {
        for (Persona persona : listaPersonas) {
            if ( persona.getRut() == rut){
                return persona;
            }
        }
        throw new RuntimeException("Persona no encontrada...");
    }

    public Object createPersona(Persona persona) {
        Persona user = getByRut(persona.getRut());
        if (user != null) {
           throw new RuntimeException("Persona no encontrada...");
        }
        listaPersonas.add(persona);
        return persona;
    }

    public Persona updatePersona(Persona persona) {
       for (Persona p : listaPersonas) {
            if (p.getRut() == persona.getRut()) {
                p.setNombre(persona.getNombre());
                return p;
            }        
       } 
       throw new RuntimeException("Persona no encontrada...");
    }

    public Boolean deletePersona(int rut) {
        Persona persona = getByRut(rut);
        if (persona != null) {
            listaPersonas.remove(persona);
            return true;
        }
        return false;
    }
}

package cl.duoc.MicroservicioPersona.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cl.duoc.MicroservicioPersona.model.Persona;
import cl.duoc.MicroservicioPersona.repository.PersonaRepository;

@Service
public class PersonaService {

    @Autowired
    private PersonaRepository personaRepository;

    public List<Persona> getAllPersonas() {
        return personaRepository.getPersonas();
    }

    public Persona savePersona(Persona persona) {
        return personaRepository.createPersona(persona);
    }

    public Boolean deletePersona(Int rut) {
        
    }

    

    
}

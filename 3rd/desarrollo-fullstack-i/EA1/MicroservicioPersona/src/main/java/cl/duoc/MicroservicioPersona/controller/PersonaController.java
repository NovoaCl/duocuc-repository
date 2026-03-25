package cl.duoc.MicroservicioPersona.controller;

import cl.duoc.MicroservicioPersona.MicroservicioPersonaApplication;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cl.duoc.MicroservicioPersona.model.Persona;
import cl.duoc.MicroservicioPersona.service.PersonaService;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;




@RestController
@RequestMapping("/api/v1/personas")
public class PersonaController {

    @Autowired
    private PersonaService personaService;

  
    @GetMapping
    public List<Persona> listaPersonas() {
        return personaService.getAllPersonas();
    }    

    @PostMapping
    public Persona guadarPersona(@RequestBody Persona persona) {
        return personaService.savePersona(persona);
    }

    @DeleteMapping("/{rut}")
    public boolean eliminarPersona(@PathVariable int rut) {
        return personaService.deletePersona(rut);
    }

    @PutMapping("/{rut}")
    public Persona updatePersona(@PathVariable int rut, @RequestBody Persona persona) {
        persona.setRut(rut);
        return personaService.updatePersona(persona);
    }
}

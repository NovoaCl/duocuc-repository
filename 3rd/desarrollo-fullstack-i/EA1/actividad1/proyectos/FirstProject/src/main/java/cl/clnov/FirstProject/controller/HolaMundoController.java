package cl.clnov.FirstProject.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaMundoController {
    
    @GetMapping("/holaMundo")
    public String hola() {
        return "Hola Mundo";
    }
}

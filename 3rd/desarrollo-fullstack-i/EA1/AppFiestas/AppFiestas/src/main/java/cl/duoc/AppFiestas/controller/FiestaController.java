package cl.duoc.AppFiestas.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cl.duoc.AppFiestas.model.Party;

@RestController
@RequestMapping("/api/v1/fiestas")
public class FiestaController {

  
    @GetMapping("/getFiestas")
    public List<Party> getFiestas(){
        return partysList;
    }

    @PostMapping("/createParty")
    
}

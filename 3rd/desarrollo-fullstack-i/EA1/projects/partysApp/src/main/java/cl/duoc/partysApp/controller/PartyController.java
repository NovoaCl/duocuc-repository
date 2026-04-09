package cl.duoc.partysApp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cl.duoc.partysApp.dto.response.PartyResponse;
import cl.duoc.partysApp.service.PartyService;

@RestController
@RequestMapping("/api/v1/party")
public class PartyController {
    @Autowired
    private PartyService partyService;

    //Get party Endpoint
    @GetMapping("{id}")
    public ResposeEntity<PartyResponse> searchById(@PathVariable Integer id) {
        PartyResponse party = partyService.searchPartyById(id);
        if (party == null) {
            return ResponseEntity.notFound().build(); // Dvuelve el error 404 sin cuerpo o mensaje
        }
        return ResponseEntity.ok(party); // Devuelve 200 y su json
    }

    // Get all the parties
    @GetMapping("parties")
    public ResponseEntity<List<PartyResponse>> listAllParties() {
        List<PartyResponse> parties = partyService.
    }
}

package cl.duoc.partysApp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/party")
public class PartyController {
    @Autowired
    private PartyService partyService;

}

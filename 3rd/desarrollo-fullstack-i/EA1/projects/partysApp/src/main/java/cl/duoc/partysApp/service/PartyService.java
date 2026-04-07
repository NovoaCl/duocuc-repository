package cl.duoc.partysApp.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;

import cl.duoc.partysApp.dto.request.CreatePartyRequest;
import cl.duoc.partysApp.dto.response.PartyResponse;
import cl.duoc.partysApp.model.Party;
import cl.duoc.partysApp.repository.PartyRepository;

public class PartyService {

    @Autowired
    private PartyRepository partyRepository;

    // Create a party
    public PartyResponse saveParty(CreatePartyRequest request) {
        Party party = new Party();

        party.setId(request.getId());
        party.setName(request.getName());
        party.setTypeOfParty(request.getTypeOfParty());
        party.setDate(request.getDate());
        party.setLocation(request.getLocation());
        party.setNumberOfGuests(request.getNumberOfGuests());

        Optional<Party> searchPartyById = partyRepository.searchPartyById(party.getId());

        if (searchPartyById.isPresent()) {
            return null;
        }

        Party savedParty = partyRepository.saveParty(party);
        return new PartyResponse(
                party.getId(),
                savedParty.getName(),
                savedParty.getTypeOfParty(),
                savedParty.getDate(),
                savedParty.getLocation(),
                savedParty.getNumberOfGuests());
    }

    //Search a party by id
    public PartyResponse searchPartyById(Integer id) {
        Party party = partyRepository.searchPartyById(id).orElse(null);

        if (party == null) {
            return null;
        }

        return new PartyResponse(
            party.getId(),
            party.getName(),
            party.getTypeOfParty(),
            party.getDate(),
            party.getLocation(),
            party.getNumberOfGuests()
        );
    }

    // Update a party
    public PartyResponse updateParty(Integer id, CreatePartyRequest request) {
        Party party = new Party();

        party.setId(id);
        party.setName(request.getName());
        party.setTypeOfParty(request.getTypeOfParty());
        party.setDate(request.getDate());
        party.setLocation(request.getLocation());
        party.setNumberOfGuests(request.getNumberOfGuests());

        Party updatedParty = partyRepository.updateParty(party);

        if (updatedParty == null) {
            return null;
        }

        return new PartyResponse(
            party.getId(),
            updatedParty.getName(),
            updatedParty.getTypeOfParty(),
            updatedParty.getDate(),
            updatedParty.getLocation(),
            updatedParty.getNumberOfGuests()
        );
    }

    // Delete a party
    public Boolean deteleParty(Integer id) {
        return partyRepository.deleteParty(id);
    }
} 

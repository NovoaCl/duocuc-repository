package cl.duoc.partysApp.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import cl.duoc.partysApp.model.Party;

@Repository
public class PartyRepository {

    // data array
    private final List<Party> partyList = new ArrayList<>();

    // Save on partyList
    public Party saveParty(Party party) {
        partyList.add(party);
        return party;
    }

    // List method
    public List<Party> getParties() {
        return new ArrayList<>(partyList);
    }

    // List one party
    public Optional<Party> searchPartyById(Integer id) {
        for (Party p : partyList) {
            if (id.equals(p.getId())) {
                return Optional.of(p);
            }
        }
        return Optional.empty();
    }

    // Update a party
    public Party updateParty(Party update) {
        for (Party p : partyList) {
            if (update.getId().equals(p.getId())) {
                p.setName(update.getName());
                p.setTypeOfParty(update.getTypeOfParty());
                p.setDate(update.getDate());
                p.setLocation(update.getLocation());
                return p;
            }
        }
        return null;
    }

    // Delete a party
    public Boolean deleteParty(Integer id) {
        for (Party p : partyList) {
            if (id.equals(p.getId())) {
                partyList.remove(p);
                return true;
            }
        }
        return false;
    }
}

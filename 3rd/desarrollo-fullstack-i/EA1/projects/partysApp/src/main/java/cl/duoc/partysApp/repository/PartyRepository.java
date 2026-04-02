package cl.duoc.partysApp.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import cl.duoc.partysApp.model.Party;

@Repository
public class PartyRepository {

    private final List<Party> partyList = new ArrayList<>();

    public Party saveParty(Party party) {
        partyList.add(party);
        return party;
    }

    //List
    public List<Party> getParties() {
        return new ArrayList<>(partyList);
    }

    //GET
    public Optional<Party> searchPartyById(Integer id) {
        for (Party p : partyList) {
            if (id.equals(p.getId())) {
                return Optional.of(p);
            }
        }
        return Optional.empty();
    }

    pu

}

package cl.duoc.AppFiestas.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import cl.duoc.AppFiestas.model.Party;

@Repository
public class FiestaRepository {
    
    private final List<Party> partysList = new ArrayList<>();

    public List<Party> getPartys() {
        return new ArrayList<>(partysList);
    }

    public Optional<Party> searchById(Integer id) {
        for (Party party: partysList) {
            if (party.getId() == id){
                return Optional.of(party);
            }
        }
        return Optional.empty();
    }
}

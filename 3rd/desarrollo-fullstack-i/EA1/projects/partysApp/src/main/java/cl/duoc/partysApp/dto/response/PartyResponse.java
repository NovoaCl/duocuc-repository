package cl.duoc.partysApp.dto.response;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PartyResponse {
    
    private Integer id;
    private String name;
    private String typeOfParty;
    private LocalDate date;
    private String location;
    private Integer numberOfGuest;
}

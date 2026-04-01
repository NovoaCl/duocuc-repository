package cl.duoc.partysApp.model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Party {

    private Integer id;
    private String name;
    private String partysType;
    private LocalDate date;
    private String location;
    private Integer numberOfGuests;

}

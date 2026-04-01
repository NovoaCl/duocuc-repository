package cl.duoc.AppFiestas.model;

import java.util.Date;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Party {

    @NotNull
    private Integer id;

    @NotBlank
    private String name;

    @NotBlank
    private String partyType;

    @Future
    private Date date;

    @NotBlank
    private String location;

    @NotNull
    private Integer numberOfGuests;
}

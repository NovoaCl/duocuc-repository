package cl.duoc.partysApp.dto.request;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreatePartyRequest {
    
    @Positive(message = "The id must be greater than 0")
    private Integer id;

    @NotBlank(message = "The name is mandatory")
    @Size(min = 3, max = 100, message = "The name must be between 3 and 100 characters long")
    private String name;

    @NotBlank(message = "The type of party is mandatory")
    @Size(max = 50, message = "The party type cannot be longer than 50 characters")
    private String typeOfParty;

    @NotNull(message = "The date is mandatory")
    @FutureOrPresent(message = "The date must be today or in the future")
    @JsonFormat(pattern = "dd-MM-yyyy")
    private LocalDate date;

    @NotBlank(message =  "The location is mandatory")
    @Size(max = 150, message = "The location cannot exceed 150 characters")
    private String location;

    @Positive(message = "The number of guests must be greater than 0")
    @Max(value = 100000, message = "Exceeded capacity")
    private Integer numberOfGuests;

}

package cl.duoc.partysApp.model;

import java.time.LocalDate;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "party")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Party {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Generates the id automatically, trigger
    private Integer id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String typeOfParty;

    @Column(name = "relization_date", nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private String location;

    @Column(nullable = false)
    private Integer numberOfGuests;

}

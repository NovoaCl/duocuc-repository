package biblioteca.salas.duoc.biblioteca.salas.duoc.controller;

import biblioteca.salas.duoc.biblioteca.salas.duoc.assemblers.CarreraModelAssembler;
import biblioteca.salas.duoc.biblioteca.salas.duoc.model.Carrera;
import biblioteca.salas.duoc.biblioteca.salas.duoc.service.CarreraService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.MediaTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*;

@RestController
@RequestMapping("/api/v2/carreras")
public class CarreraControllerV2 {

    @Autowired
    private CarreraService carreraService;

    @Autowired
    private CarreraModelAssembler assembler;

    @GetMapping(produces = MediaTypes.HAL_JSON_VALUE)
    public CollectionModel<EntityModel<Carrera>> getAllCarreras() {
        List<EntityModel<Carrera>> carreras = carreraService.findAll().stream()
                .map(assembler::toModel)
                .collect(Collectors.toList());

        return CollectionModel.of(carreras,
                linkTo(methodOn(CarreraControllerV2.class).getAllCarreras()).withSelfRel());
    }

    @GetMapping(value = "/{codigo}", produces = MediaTypes.HAL_JSON_VALUE)
    public EntityModel<Carrera> getCarreraByCodigo(@PathVariable String codigo) {
        Carrera carrera = carreraService.findByCodigo(codigo);
        return assembler.toModel(carrera);
    }

    @PostMapping(produces = MediaTypes.HAL_JSON_VALUE)
    public ResponseEntity<EntityModel<Carrera>> createCarrera(@RequestBody Carrera carrera) {
        Carrera newCarrera = carreraService.save(carrera);
        return ResponseEntity
                .created(linkTo(methodOn(CarreraControllerV2.class).getCarreraByCodigo(newCarrera.getCodigo())).toUri())
                .body(assembler.toModel(newCarrera));
    }

    @PutMapping(value = "/{codigo}", produces = MediaTypes.HAL_JSON_VALUE)
    public ResponseEntity<EntityModel<Carrera>> updateCarrera(@PathVariable String codigo, @RequestBody Carrera carrera) {
        carrera.setCodigo(codigo);
        Carrera updatedCarrera = carreraService.save(carrera);
        return ResponseEntity
                .ok(assembler.toModel(updatedCarrera));
    }

    @DeleteMapping(value = "/{codigo}", produces = MediaTypes.HAL_JSON_VALUE)
    public ResponseEntity<?> deleteCarrera(@PathVariable String codigo) {
        carreraService.deleteByCodigo(codigo);
        return ResponseEntity.noContent().build();
    }
}

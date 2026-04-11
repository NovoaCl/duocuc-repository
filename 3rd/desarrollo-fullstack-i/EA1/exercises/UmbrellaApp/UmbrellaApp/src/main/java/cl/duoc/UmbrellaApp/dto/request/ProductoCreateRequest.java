package cl.duoc.UmbrellaApp.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor   
public class ProductoCreateRequest {
    
    @Positive(message = "El id debe ser mayor a 0")
    private Integer idProducto;

    @NotBlank(message = "El nombre no puede estar en blanco")
    @NotNull(message = "El nombre no puede ser nulo")
    private String nombre;

    @NotBlank(message = "La categoria no puede estar en blanco")
    @NotNull(message = "La categoria no puede ser nulo")
    private String categoria;

    @Positive(message = "El precio no puede ser negativo.")
    private Double precio;

    @Positive(message = "El stock no puede ser negativo.")
    private Integer stock;

    @NotBlank(message = "La marca no puede estar en blanco")
    @NotNull(message = "La marca no puede ser nulo")
    private String marcaProveedor;
}


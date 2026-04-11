package cl.duoc.UmbrellaApp.dto.responce;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductoResponse {
    
    private Integer idProducto;
    private String nombre;
    private String categoria;
    private Double precio;
    private Integer stock;
    private String marcaProveedor;
}

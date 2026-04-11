package cl.duoc.UmbrellaApp.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Producto {
    
    private Integer idProducto;
    private String nombre;
    private String categoria;
    private Double precio;
    private Integer stock;
    private String marcaProveedor;
}

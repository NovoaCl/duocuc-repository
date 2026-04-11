package cl.duoc.UmbrellaApp.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import cl.duoc.UmbrellaApp.model.Producto;

@Repository
public class ProductoRepository {
    
    public final List<Producto> listaProductos = new ArrayList<>();

    public Producto guardarProducto(Producto producto) {
        listaProductos.add(producto);
        return producto;
    }

    
    public List<Producto> obtenerTodosProductos() {
        return new ArrayList<>(listaProductos);
    }

    
    public Optional<Producto> obtenerUnProducto(Integer idProducto) {
        for (Producto producto : listaProductos) {
            if (idProducto.equals(producto.getIdProducto())) {
                return Optional.of(producto);
            }
        }
        return Optional.empty();
    }

    public Producto actualizarProducto(Producto actualizar) {
        for (Producto producto : listaProductos) {
            if (actualizar.getIdProducto().equals(producto.getIdProducto())) {
                producto.setNombre(actualizar.getNombre());
                producto.setCategoria(actualizar.getCategoria());
                producto.setPrecio(actualizar.getPrecio());
                producto.setStock(actualizar.getStock());
                producto.setMarcaProveedor(actualizar.getMarcaProveedor());

                return producto;
            }
        }
        return null;
    }

    public boolean eliminarProducto(Integer idProducto) {
        for (Producto producto : listaProductos) {
            if (idProducto.equals(producto.getIdProducto())) {
                listaProductos.remove(producto);
                return true;
            }
        }
        return false;
    }
}

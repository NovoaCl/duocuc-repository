package cl.duoc.UmbrellaApp.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cl.duoc.UmbrellaApp.dto.request.ProductoCreateRequest;
import cl.duoc.UmbrellaApp.dto.request.ProductoUpdateRequest;
import cl.duoc.UmbrellaApp.dto.responce.ProductoResponse;
import cl.duoc.UmbrellaApp.model.Producto;
import cl.duoc.UmbrellaApp.repository.ProductoRepository;

@Service
public class ProductoService {

    @Autowired
    private ProductoRepository productoRepository;

    public ProductoResponse guardarProducto(ProductoCreateRequest request) {
        Producto producto = new Producto();

        producto.setIdProducto(request.getIdProducto());
        producto.setNombre(request.getNombre());
        producto.setCategoria(request.getCategoria());
        producto.setPrecio(request.getPrecio());
        producto.setStock(request.getStock());
        producto.setMarcaProveedor(request.getMarcaProveedor());

        Optional<Producto> buscarProducto = productoRepository.obtenerUnProducto(producto.getIdProducto());

        if (buscarProducto.isPresent()) {
            return null;
        }

        Producto productoGuardado = productoRepository.guardarProducto(producto);
        return new ProductoResponse(
                producto.getIdProducto(),
                productoGuardado.getNombre(),
                productoGuardado.getCategoria(),
                productoGuardado.getPrecio(),
                productoGuardado.getStock(),
                productoGuardado.getMarcaProveedor());
    }

    public List<ProductoResponse> obtenerTodosProductos() {
        List<Producto> productos = productoRepository.obtenerTodosProductos();
        List<ProductoResponse> respuesta = new ArrayList<>();

        for (Producto producto : productos) {
            ProductoResponse response = new ProductoResponse(
                    producto.getIdProducto(),
                    producto.getNombre(),
                    producto.getCategoria(),
                    producto.getPrecio(),
                    producto.getStock(),
                    producto.getMarcaProveedor());
            respuesta.add(response);
        }

        return respuesta;
    }

    public ProductoResponse obtenerUnProducto(Integer idProducto) {
        Producto producto = productoRepository.obtenerUnProducto(idProducto).orElse(null);

        if (producto == null) {
            return null;
        }

        return new ProductoResponse(
                producto.getIdProducto(),
                producto.getNombre(),
                producto.getCategoria(),
                producto.getPrecio(),
                producto.getStock(),
                producto.getMarcaProveedor());
    }

    public ProductoResponse actualizarProducto(Integer idProducto, ProductoUpdateRequest request) {
        Producto producto = new Producto();

        producto.setNombre(request.getNombre());
        producto.setCategoria(request.getCategoria());
        producto.setPrecio(request.getPrecio());
        producto.setStock(request.getStock());
        producto.setMarcaProveedor(request.getMarcaProveedor());

        Producto productoActualizado = productoRepository.actualizarProducto(producto);

        if (productoActualizado == null) {
            return null;
        }

        return new ProductoResponse(
                producto.getIdProducto(),
                productoActualizado.getNombre(),
                productoActualizado.getCategoria(),
                productoActualizado.getPrecio(),
                productoActualizado.getStock(),
                productoActualizado.getMarcaProveedor());
    }

    public boolean eliminarProducto(Integer idProducto) {
        return productoRepository.eliminarProducto(idProducto);
    }
}

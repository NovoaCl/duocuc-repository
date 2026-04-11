package cl.duoc.UmbrellaApp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cl.duoc.UmbrellaApp.dto.request.ProductoCreateRequest;
import cl.duoc.UmbrellaApp.dto.request.ProductoUpdateRequest;
import cl.duoc.UmbrellaApp.dto.responce.ProductoResponse;
import cl.duoc.UmbrellaApp.service.ProductoService;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1/productos")
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    @GetMapping("/producto/{id}")
    public ResponseEntity<ProductoResponse> obtenerUnPrducto(@PathVariable Integer id) {
        ProductoResponse producto = productoService.obtenerUnProducto(id);
        if (producto == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(producto);
    }

    @GetMapping("/listarProductos")
    public ResponseEntity<List<ProductoResponse>> listarTodosProductos() {
        List<ProductoResponse> productos = productoService.obtenerTodosProductos();
        return ResponseEntity.ok(productos);
    }

    @PostMapping("/guardarProducto")
    public ResponseEntity<ProductoResponse> guardarProducto(@Valid @RequestBody ProductoCreateRequest request) {
        ProductoResponse productoGuardado = productoService.guardarProducto(request);
        if (productoGuardado == null) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        } else {
            return ResponseEntity.status(HttpStatus.CREATED).body(productoGuardado);
        }
    }

    @PutMapping("/actualizarProducto/{id}")
    public ResponseEntity<ProductoResponse> actualizarFiesta(@PathVariable Integer id,
            @Valid @RequestBody ProductoUpdateRequest request) {

        ProductoResponse productoActualizado = productoService.actualizarProducto(id, request);

        if (productoActualizado == null) {
            return ResponseEntity.notFound().build(); 
        }

        return ResponseEntity.ok(productoActualizado); 
    }

    
    @DeleteMapping("/eliminarProducto/{id}")
    public ResponseEntity<Void> eliminarProducto(@PathVariable Integer id) {
        boolean eliminado = productoService.eliminarProducto(id);

        if (!eliminado) {
            return ResponseEntity.notFound().build(); 
        }

        return ResponseEntity.noContent().build(); 
    }
}

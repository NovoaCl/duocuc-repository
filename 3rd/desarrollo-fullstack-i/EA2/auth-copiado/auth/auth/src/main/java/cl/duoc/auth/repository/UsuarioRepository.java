package cl.duoc.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import cl.duoc.auth.model.UsuarioModel;

public interface UsuarioRepository extends JpaRepository<UsuarioModel, Long>{
    
    UsuarioModel findByUserName(String username);
    
}

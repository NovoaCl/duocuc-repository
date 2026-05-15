package cl.duoc.auth.service;

import org.springframework.stereotype.Service;

import cl.duoc.auth.dto.request.DtoAuthRequest;
import cl.duoc.auth.dto.response.DtoAuthResponse;
import cl.duoc.auth.model.UsuarioModel;
import cl.duoc.auth.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UsuarioRepository usuarioRepository;
    private final JwtService jwtService;

    public DtoAuthResponse login(DtoAuthRequest request) {
    
        UsuarioModel usuario = usuarioRepository.findByUserName(request.getUsername())
            .orElseThrow(() -> new RunTimeException("Usuario no encontrado"));
        
        if (!usuario.getActive()) {
            throw new RuntimeException( "Usuario inactivo.");
        }

        if(!usuario.getPassword().equals(request.getPassword())) {
            throw new RuntimeException( "Contraseña incorrecta.");
        }

        String token = jwtService.generateToken(usuario.getUsername(), usuario.getRole());
        return new DtoAuthResponse(token);

    }
}

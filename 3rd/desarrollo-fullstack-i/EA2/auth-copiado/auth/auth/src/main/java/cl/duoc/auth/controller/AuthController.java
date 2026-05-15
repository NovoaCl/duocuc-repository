package cl.duoc.auth.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cl.duoc.auth.dto.request.DtoAuthRequest;
import cl.duoc.auth.dto.response.DtoAuthResponse;
import cl.duoc.auth.repository.UsuarioRepository;
import cl.duoc.auth.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
 
    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<DtoAuthResponse> login(@Valid @RequestBody DtoAuthRequest request) {
        
        DtoAuthResponse response = authService.login(request);

        return ResponseEntity.ok(response);
    }
}

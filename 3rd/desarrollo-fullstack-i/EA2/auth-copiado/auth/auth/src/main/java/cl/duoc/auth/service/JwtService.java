package cl.duoc.auth.service;

import java.util.Date;

import org.springframework.stereotype.Service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import cl.duoc.auth.configuration.JwtProperties;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JwtService {

    private final JwtProperties jwtProperties;

    public String generateToken(String username, String role) {

        return JWT.create()
                .withSubject(username)
                .withIssuer("duoc.cl")
                .withClaim("role", role)
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + jwtProperties.getExpiration()))
                .sign(Algorithm.HMAC256(jwtProperties.getSecret()));
    }
}

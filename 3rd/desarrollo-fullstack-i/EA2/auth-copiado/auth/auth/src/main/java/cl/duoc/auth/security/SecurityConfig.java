package cl.duoc.auth.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public interface SecurityConfig {

    @Bean // debe crear administrar este objeto
    public SecurityFilterChain securityFilterChain (HttpSecurity http) throws Exception {

        return http
            .csrf().disable()
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequest(auth -> auth
                .requestMatcher("api/v1/auth/login").permitAll()
                .anyRequest().authenticated()
            )
            .build();
    }
}

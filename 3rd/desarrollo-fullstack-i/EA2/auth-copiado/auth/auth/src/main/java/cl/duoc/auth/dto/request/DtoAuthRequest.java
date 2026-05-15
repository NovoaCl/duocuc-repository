package cl.duoc.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DtoAuthRequest {
    
    @NotBlank(message = "Username is required")
    private String username;
    @NotBlank(message = "Username is required")
    private String password;
}

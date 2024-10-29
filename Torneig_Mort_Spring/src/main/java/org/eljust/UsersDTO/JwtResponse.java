package org.eljust.UsersDTO;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class JwtResponse {

	private String token;
	private String type;
	private Long id;
	private String username;
	private List<String> roles;
	
	
	public JwtResponse(String token, Long id, String username, List<String> roles) {
        this.token = token;
        this.type = "Bearer"; // valor predeterminado
        this.id = id;
        this.username = username;
        this.roles = roles;
    }
}

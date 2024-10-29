package org.eljust.UsersDTO;

import java.util.Set;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CreateUserDTO {

	@NotBlank
	@Size(min = 3, max = 20)
	private String username;

	@NotBlank
	@Size(min = 6, max = 40)
	private String password;
	
	
	@NotBlank
	@Size(min = 6, max = 40)
	private String password2;
	

	private Set<String> role;

}

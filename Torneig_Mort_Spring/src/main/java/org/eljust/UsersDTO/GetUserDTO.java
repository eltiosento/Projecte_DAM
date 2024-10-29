package org.eljust.UsersDTO;

import java.util.Set;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GetUserDTO {
	
	private String username;
	private Set<String> roles;
	

}

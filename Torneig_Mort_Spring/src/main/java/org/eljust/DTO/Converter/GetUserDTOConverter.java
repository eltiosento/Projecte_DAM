package org.eljust.DTO.Converter;

import java.util.Set;
import java.util.stream.Collectors;

import org.eljust.ModelUsers.User;
import org.eljust.UsersDTO.GetUserDTO;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;


@Component
@RequiredArgsConstructor
public class GetUserDTOConverter {
	
	private final ModelMapper modelMapper;

	
	public GetUserDTO convertToDTO(User user) {
		
		
		GetUserDTO userDTO = modelMapper.map(user, GetUserDTO.class);
       
		Set<String> roles = user.getRoles().stream()
                                .map(role -> role.getName().name())
                                .collect(Collectors.toSet());
        userDTO.setRoles(roles);
        return userDTO;
		
	}
	
}

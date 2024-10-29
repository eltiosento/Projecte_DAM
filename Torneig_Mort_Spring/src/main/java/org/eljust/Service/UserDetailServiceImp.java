package org.eljust.Service;

import java.util.HashSet;
import java.util.Set;

import org.eljust.DTO.Converter.GetUserDTOConverter;
import org.eljust.Error.NewUserWithDifferentPasswordsException;
import org.eljust.ModelUsers.Role;
import org.eljust.ModelUsers.User;
import org.eljust.ModelUsers.UserRole;
import org.eljust.Repository.RoleRepository;
import org.eljust.Repository.UserRepository;
import org.eljust.UsersDTO.CreateUserDTO;
import org.eljust.UsersDTO.GetUserDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import jakarta.transaction.Transactional;

/**
 * Aquest servici uneix rol i usuari i es una classe on implementam la
 * interficie de UserDetailsService
 */
@Service
public class UserDetailServiceImp implements UserDetailsService {

	@Autowired
	UserRepository userRepository;

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	GetUserDTOConverter getUserDTOConverter;

	// Carreguem un usuari pasat un nom
	@Override
	@Transactional
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		User user = userRepository.findByUsername(username)
				.orElseThrow(() -> new UsernameNotFoundException("Usuari no trobat amb el username: " + username));

		return User.build(user);

	}

	// Creem un nou usuari
	@Transactional
	public GetUserDTO crearUsuari(CreateUserDTO newUser) {

		if (!newUser.getPassword().contentEquals(newUser.getPassword2())) {
			throw new NewUserWithDifferentPasswordsException();
		}

		User user = new User();

		user.setUsername(newUser.getUsername());
		user.setPassword(passwordEncoder.encode(newUser.getPassword()));

		Set<String> strRoles = newUser.getRole();
		Set<Role> roles = new HashSet<>();

		if (strRoles == null) {
			Role userRole = roleRepository.findByName(UserRole.USER)
					.orElseThrow(() -> new RuntimeException("Error: Rol no trobat."));
			roles.add(userRole);
		} else {
			strRoles.forEach(role -> {
				switch (role) {
				case "admin":
				case "ADMIN":
					Role adminRole = roleRepository.findByName(UserRole.ADMIN)
							.orElseThrow(() -> new RuntimeException("Error: Rol no trobat."));
					roles.add(adminRole);
					break;
				default:
					Role userRole = roleRepository.findByName(UserRole.USER)
							.orElseThrow(() -> new RuntimeException("Error: Rol no trobat."));
					roles.add(userRole);
				}
			});
		}

		user.setRoles(roles);
		try {
			userRepository.save(user);
		} catch (DataIntegrityViolationException ex) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El nom d'usuari ja existeix.");
		}

		return getUserDTOConverter.convertToDTO(user);

	}

}

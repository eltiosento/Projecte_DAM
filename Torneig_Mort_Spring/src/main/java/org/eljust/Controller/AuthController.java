package org.eljust.Controller;

import java.util.List;
import java.util.stream.Collectors;


import org.eljust.ModelUsers.User;
import org.eljust.Security.JwtUtils;
import org.eljust.Service.UserDetailServiceImp;
import org.eljust.UsersDTO.CreateUserDTO;
import org.eljust.UsersDTO.GetUserDTO;
import org.eljust.UsersDTO.JwtResponse;
import org.eljust.UsersDTO.LoginRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Controlador d'usuaris API", description = "Aquest controlador el farem servir per a controlar la autentificació i registre dels usuaris que faran us de la API")
public class AuthController {

	@Autowired
	private UserDetailServiceImp userDetailServiceImp;

	@Autowired
	AuthenticationManager authenticationManager;

	@Autowired
	JwtUtils jwtUtils;

	@Operation(summary = "Petició per donar de alta un nou Usuari.", description = "Aquest controlador el farem servir per donar de alta un nou usuari. Sols el pot fer servir un usuari ja creat que tinga permisos d'administrador. La contrassenya l'hem de posar per duplicat, ja que controla amb aquest procés que la contrassenya siga la correcta. Si no posem cap rol, per defecte serà un USER.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "201", description = "Usuari creat amb èxit", content = @Content(schema = @Schema(implementation = CreateUserDTO.class))),
			@ApiResponse(responseCode = "500", description = "Error intern.", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/register")
	public ResponseEntity<?> crearUsuari(@Valid @RequestBody CreateUserDTO createUserDTO) {

		try {
			GetUserDTO nouUsuari = userDetailServiceImp.crearUsuari(createUserDTO);
			return ResponseEntity.status(HttpStatus.CREATED).body(nouUsuari);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Error al crear l'usuari: " + e.getMessage());
		}
	}

	@Operation(summary = "Petició per fer el login.", description = "Aquest controlador el farem servir per a poder accedir amb les credencials d'un usuari ja creat.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Login exitós", content = @Content(schema = @Schema(implementation = LoginRequest.class))),
			@ApiResponse(responseCode = "500", description = "Error intern.", content = @Content) })
	@PostMapping("/login")
	public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

		try {
			Authentication authentication = authenticationManager.authenticate(
					new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

			SecurityContextHolder.getContext().setAuthentication(authentication);

			String jwt = jwtUtils.generateJwtToken(authentication);

			User userDetails = (User) authentication.getPrincipal();

			List<String> roles = userDetails.getAuthorities().stream().map(item -> item.getAuthority())
					.collect(Collectors.toList());

			return ResponseEntity.ok(new JwtResponse(jwt, userDetails.getIdUsuari(), userDetails.getUsername(), roles));
			
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Usuari o contrasenya invalids. " + e.getMessage());
		}
		
	}

}
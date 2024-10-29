package org.eljust.Controller;

import java.util.List;

import org.eljust.DTO.FaseDTO;
import org.eljust.Service.FaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

/**
 * Controlador de Fases
 * 
 * @author Vicent Roselló
 */
@RestController
@RequestMapping("/api-torneig")
@Tag(name = "Fase", description = "Controlador per a consultar les fases.")
public class FaseController {

	@Autowired
	private FaseService faseService;

	@Operation(summary = "Obtenim un llistat de totes les Fases.", description = "Proveïm d'un mecanisme per obtindre un llistat de totes les fases registrades.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat les fases.", content = @Content(array = @ArraySchema(schema = @Schema(implementation = FaseDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi ha cap fase.", content = @Content) })
	@GetMapping("/fases")
	public ResponseEntity<?> showAllFases() {

		List<FaseDTO> lesFasesDTO = faseService.listAllFases();

		return ResponseEntity.ok(lesFasesDTO);

	}

	@Operation(summary = "Actualitzar nom d'una Fase", description = "Actualitzem o modifica el nom d'una Fase existent a la Base de Dades, proporcionant el ID de la Fase que volem actualitzar.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Fase actualitzada amb èxit", content = @Content(schema = @Schema(implementation = FaseDTO.class))),
			@ApiResponse(responseCode = "400", description = "Solicitud incorrecta", content = @Content),
			@ApiResponse(responseCode = "404", description = "Fase no trobada", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PutMapping("/fase/{idFase}")
	public ResponseEntity<?> putFase(
			@Parameter(description = "ID de la fase", required = true) @PathVariable Long idFase,
			@RequestBody FaseDTO faseDTO) {

		FaseDTO faseActualitzada = faseService.updateFase(idFase, faseDTO);

		return ResponseEntity.ok(faseActualitzada);

	}

}

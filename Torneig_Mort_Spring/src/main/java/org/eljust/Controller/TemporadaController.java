package org.eljust.Controller;

import java.util.List;

import org.eljust.DTO.TemporadaDTO;
import org.eljust.Error.TemporadaNotFoundException;
import org.eljust.Service.TemporadaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

/**
 * Controlador de Temporades
 * 
 * @author Vicent Roselló
 */
@RestController
@RequestMapping("/api-torneig")
@Tag(name = "Temporada", description = "Controlador per gestionar i consultar les Temporades (Cursos escolars).")
public class TemporadaController {

	@Value("${spring.application.name}")
	private String nomAplicacio;

	@Autowired
	private TemporadaService temporadaService;

	@Operation(summary = "Salutació.", description = "Benvingut a la api.")
	@GetMapping("/")
	public String index() {

		return "Benvingut a la api: " + nomAplicacio
				+ ". Aquesta api té totes les funcionalitats per a gestionar el torneig esportiu del 'Mort.'";
	}

	@Operation(summary = "Obtenim el llistat de les temporades.", description = "Proveïm d'un mecanisme per obtindre un llistat de totes les temporades registrades.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat les temporades", content = @Content(array = @ArraySchema(schema = @Schema(implementation = TemporadaDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No existeix cap temporada", content = @Content) })
	@GetMapping("/temporades")
	public ResponseEntity<?> getAllTemporades() {

		List<TemporadaDTO> lesTemporadesDTO = temporadaService.listAllTemporades();
		return ResponseEntity.ok(lesTemporadesDTO);

	}

	@Operation(summary = "Donar d'alta una Temporada", description = "Proveïm d'un mecanisme per a poder crear i registrar una Temporada nova a la Base de Dades. Tan sols hem de proporcionar el nom.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "201", description = "Temporada creada amb èxit", content = @Content(schema = @Schema(implementation = TemporadaDTO.class))),
			@ApiResponse(responseCode = "400", description = "Solicitud incorrecta", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/temporada")
	public ResponseEntity<?> addTemporada(@RequestBody TemporadaDTO temporadaDTO) {

		TemporadaDTO novaTemporada = temporadaService.saveTemporada(temporadaDTO);

		return ResponseEntity.status(HttpStatus.CREATED).body(novaTemporada);

		// Podriem simplificar fent:
		// return
		// ResponseEntity.status(HttpStatus.CREATED).body(temporadaService.saveTemporada(temporadaDTO));

	}

	@Operation(summary = "Actualitzar una Temporada", description = "Actualitza o modifica una Temporada existent a la Base de Dades, proporcionant el ID de la Temporada que volem actualitzar.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Temporada actualitzada amb èxit", content = @Content(schema = @Schema(implementation = TemporadaDTO.class))),
			@ApiResponse(responseCode = "400", description = "Solicitud incorrecta", content = @Content),
			@ApiResponse(responseCode = "404", description = "Temporada no trobada", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PutMapping("/temporada/{idTemporada}")
	public ResponseEntity<?> putTemporada(
			@Parameter(description = "ID de la temporada", required = true) @PathVariable Long idTemporada,
			@RequestBody TemporadaDTO temporadaDTO) {

		TemporadaDTO temporadaActualitzada = temporadaService.updateTemporada(idTemporada, temporadaDTO);

		return ResponseEntity.ok(temporadaActualitzada);

	}

	@Operation(summary = "Eliminar una Temporada", description = "Proporcionant el ID d'una Temporada existent a la Base de Dades, l'elimina d'aquesta, juntament amb TOTES LES ENTITAS QUE DEPENEN D'ELLA (Equips, Partits i Grups).")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Temporada eliminada satisfactòriament", content = @Content),
			@ApiResponse(responseCode = "404", description = "Temporada no trobada", content = @Content) })
	@Secured("ADMIN")
	@DeleteMapping("/temporada/{idTemporada}")
	public ResponseEntity<?> deleteTemporadaById(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {

		boolean temporadaBorrada = temporadaService.deleteTemporada(idTemporada);

		if (temporadaBorrada == true) {
			return new ResponseEntity<>("Temporada amb id: " + idTemporada + " eliminada satisfactòriament",
					HttpStatus.OK);
		} else {
			throw new TemporadaNotFoundException(idTemporada);
		}

	}

}

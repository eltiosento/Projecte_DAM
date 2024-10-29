package org.eljust.Controller;

import java.util.List;

import org.eljust.DTO.JugadorDTO;
import org.eljust.DTO.JugadorSimpleDTO;
import org.eljust.Error.JugadorNotFoundException;
import org.eljust.Service.JugadorService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

/**
 * Controlador de Jugadors
 * 
 * @author Vicent Roselló
 */
@RestController
@RequestMapping("/api-torneig")
@Tag(name = "Jugador", description = "Controlador per a gestionar i consultar els jugadors del campionat.")
public class JugadorController {

	@Autowired
	private JugadorService jugadorService;

	@Operation(summary = "Obtenim un llistat de tots els Jugadors.", description = "Proveïm d'un mecanisme per obtindre un llistat de tots els Jugadors registrats.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els Jugadors", content = @Content(array = @ArraySchema(schema = @Schema(implementation = JugadorSimpleDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han Jugadors", content = @Content) })
	@GetMapping("/jugadors")
	public ResponseEntity<?> showAllJugadors() {

		List<JugadorSimpleDTO> elsJugadorsSimplesDTO = jugadorService.listAllJugadors();

		return ResponseEntity.ok(elsJugadorsSimplesDTO);

	}

	@Operation(summary = "Obtenim un llistat dels Jugadors menors de 14 anys.", description = "Proveïm d'un mecanisme per obtindre un llistat dels Jugadors que estiguen cursant al centre amb edats compreses entre 8 i 13 anys.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els Jugadors", content = @Content(array = @ArraySchema(schema = @Schema(implementation = JugadorSimpleDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han Jugadors", content = @Content) })
	@GetMapping("/jugadors/delCentre")
	public ResponseEntity<?> showJugadorsFiltratsPerEdat() {

		List<JugadorSimpleDTO> elsJugadorsSimplesDTO = jugadorService.listJugadorsFiltratsPerEdat();

		return ResponseEntity.ok(elsJugadorsSimplesDTO);

	}

	@Operation(summary = "Obtenim informació d'un Jugador.", description = "Proveïm d'un mecanisme per obtindre la informació d'un jugador donat el seu ID. Ens mostrarà el jugador i un llistat d'equips amb els que ha jugat.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat el Jugador", content = @Content(array = @ArraySchema(schema = @Schema(implementation = JugadorDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No ha trobat el Jugador", content = @Content) })
	@GetMapping("/jugador/{idJugador}")
	public ResponseEntity<?> showJugadorByID(
			@Parameter(description = "ID del Jugador", required = true) @PathVariable Long idJugador) {

		JugadorDTO jugadorDTO = jugadorService.getJugadorById(idJugador);

		return ResponseEntity.ok(jugadorDTO);
	}

	@Operation(summary = "Busca els Jugadors pel seu nom.", description = "Busquem els jugadors pel seu nom o que el text que porporcionem coincidisca amb un fragment del nom del jugador.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat el/s jugador/s.", content = @Content(array = @ArraySchema(schema = @Schema(implementation = JugadorSimpleDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han jugadors coincidents.", content = @Content) })
	@GetMapping("/jugador/nom")
	public ResponseEntity<?> buscarJugadorPelNom(
			@Parameter(description = "Nom o fragment de nom de l'equip a buscar", required = true) @RequestParam("nom") String nom) {

		List<JugadorSimpleDTO> elsJugadors = jugadorService.listJugadorPelNom(nom);

		return ResponseEntity.ok(elsJugadors);

	}

	@Operation(summary = "Donar d'alta un jugador.", description = "Proveïm d'un mecanisme per a poder crear un jugador nou a la BD.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "201", description = "Jugador creat amb èxit", content = @Content(schema = @Schema(implementation = JugadorSimpleDTO.class))),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/jugador")
	public ResponseEntity<?> addJugador(@RequestBody JugadorSimpleDTO jugadorSimpleDTO) {

		JugadorSimpleDTO newJugadorSimpleDTO = jugadorService.saveJugador(jugadorSimpleDTO);

		return ResponseEntity.status(HttpStatus.CREATED).body(newJugadorSimpleDTO);

	}

	@Operation(summary = "Borrar un jugador.", description = "Proveïm d'un mecanisme per a poder borrar un jugador proporcinant el Id.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Jugador borrat amb èxit", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@DeleteMapping("/jugador/{idJugador}")
	public ResponseEntity<?> deleteJugadorById(
			@Parameter(description = "ID del Jugador", required = true) @PathVariable Long idJugador) {

		boolean jugadorBorrat = jugadorService.deleteJugador(idJugador);

		if (jugadorBorrat == true)
			return new ResponseEntity<>("Jugador amb id: " + idJugador + " eliminat satisfactòriament", HttpStatus.OK);

		throw new JugadorNotFoundException(idJugador);

	}

	@Operation(summary = "Actualitzar un jugador.", description = "Proveïm d'un mecanisme amb el que introduim el ID d'un jugador i podem modificar dit jugador.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Jugador actualitzat amb èxit", content = @Content(schema = @Schema(implementation = JugadorSimpleDTO.class))),
			@ApiResponse(responseCode = "404", description = "Jugador no trobar", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PutMapping("jugador/{idJugador}")
	public ResponseEntity<?> putJugador(
			@Parameter(description = "ID del Jugador", required = true) @PathVariable Long idJugador,
			@RequestBody JugadorSimpleDTO jugadorSimpleDTO) {

		JugadorSimpleDTO jugadorActualitzat = jugadorService.updateJugador(idJugador, jugadorSimpleDTO);

		return ResponseEntity.ok(jugadorActualitzat);
	}

}

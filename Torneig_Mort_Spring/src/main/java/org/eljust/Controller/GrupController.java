package org.eljust.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;

import org.eljust.DTO.GrupDTO;
import org.eljust.DTO.GrupEquipDTO;
import org.eljust.Service.GrupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;


/**
 * Controlador de Grups
 * 
 * @author Vicent Roselló
 */
@RestController
@RequestMapping("/api-torneig")
@Tag(name = "Grup", description = "Controlador per a gestionar i consultar els grups del campionat.")
public class GrupController {

	@Autowired
	private GrupService grupService;

	@Operation(summary = "Obtenim informació d'un Grup.", description = "Proveïm d'un mecanisme per obtindre la informació d'un grup donat el seu ID. Ens mostrarà els equips del grup junt als partits de la fase de grups.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat el Grup", content = @Content(schema = @Schema(implementation = GrupDTO.class))),
			@ApiResponse(responseCode = "404", description = "No ha trobat el Grup", content = @Content) })
	@GetMapping("/grup/{idGrup}")
	public ResponseEntity<?> showGrupById(
			@Parameter(description = "ID del grup", required = true) @PathVariable Long idGrup) {

		GrupDTO grupDTO = grupService.getGrupById(idGrup);

		return ResponseEntity.ok(grupDTO);
	}

	@Operation(summary = "Llistem els Grups que pertanyen a una Temporada.", description = "Proveïm d'un mecanisme per obtindre tots els grups relatius a un ID d'una Temporada en concret. Ens mostrarà els Grups junt als seus equips.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els Grups", content = @Content(array = @ArraySchema(schema = @Schema(implementation = GrupEquipDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No ha trobat els Grups", content = @Content) })
	@GetMapping("/grups/temporada/{idTemporada}")
	public ResponseEntity<?> showGrupsAndEquipsByIdTemporada(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {

		List<GrupEquipDTO> elsGrupsEquipsDTO = grupService.listGrupsEquipsDTOByIdTemporada(idTemporada);

		return ResponseEntity.ok(elsGrupsEquipsDTO);

	}

	@Operation(summary = "Realitzar el sorteig de la fase de Grups.", description = "Proveïm d'un mecanisme per a crear la fase de grups. Asignarem de manera aleatòria als grups de la Temporada vigent (hem de proporcionar el ID de la Temporada), els seus equips una vegada creats.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Sorteig realitzat amb èxit", content = @Content()),
			@ApiResponse(responseCode = "400", description = "Sorteig no realitzat", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/sorteigFaseGrups/{idTemporada}")
	public ResponseEntity<String> sorteigGrups(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {
		grupService.sorteigFaseGrups(idTemporada);
		return ResponseEntity.ok("Sorteig de grups completat!!");
	}

	@Operation(summary = "Borrar sorteig de la fase de Grups.", description = "Proveïm d'un mecanisme per a poder borrar l'assignació d'equips als grups quan hem fet el sorteig de la fase de grups. Borrem els equips dels grups a la Temporada vigent (hem de proporcionar el ID de la Temporada), per a poder realitzar novament el sorteig en cas de que no ens haja agradat com s'han repartit els equips.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Sorteig borrat amb èxit", content = @Content()),
			@ApiResponse(responseCode = "404", description = "Sorteig no trobat", content = @Content) })
	@DeleteMapping("/borrar-Sorteig-FaseGrups/temporada/{idTemporada}")
	@Secured("ADMIN")
	public ResponseEntity<?> deleteSorteigByIdTemporada(@PathVariable Long idTemporada) {

		boolean sorteigBorrat = grupService.buidarEquipsGrups(idTemporada);

		if (sorteigBorrat == true) {
			return new ResponseEntity<>(
					"Sorteig de la fase de Grups de la temporada " + idTemporada + " eliminat satisfactòriament.",
					HttpStatus.OK);
		} else {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"No hi ha fase de Grups feta per a la temporada " + idTemporada);
		}

	}

}

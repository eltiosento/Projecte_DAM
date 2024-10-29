package org.eljust.Controller;

import java.util.List;

import org.eljust.DTO.GrupPartitDTO;
import org.eljust.DTO.PartitDTO;
import org.eljust.DTO.PartitModificatDTO;
import org.eljust.Service.PartitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
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

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * Controlador de Partits
 * 
 * @author Vicent Roselló
 */
@RestController
@RequestMapping("/api-torneig")
@Tag(name = "Partit", description = "Controlador per a gestionar i consultar els partits.")
public class PartitController {

	@Autowired
	private PartitService partitService;

	@Operation(summary = "Llistem tots els partits d'una Temporada.", description = "Proveïm d'un mecanisme per a mostrar tots els partits relatius a una temporada donada mitjançant el seu ID.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els Partits", content = @Content(array = @ArraySchema(schema = @Schema(implementation = PartitDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No ha trobat els Partits", content = @Content) })
	@GetMapping("/partits/temporada/{idTemporada}")
	public ResponseEntity<?> showAllPartitsByIdTemporada(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {

		List<PartitDTO> elsPartitsDTO = partitService.listAllPartits(idTemporada);

		return ResponseEntity.ok(elsPartitsDTO);
	}

	@Operation(summary = "Llistem tots els partits d'una Temporada i Fase en concret.", description = "Proveïm d'un mecanisme per a mostrar tots els partits relatius a una temporada i una fase determinada del campionat mitjançant els ID's Temporada i Fase. Si pasem el 0 com idFase, ens mostrarà el llistat complet de tots els partits siguen de la fase que siguen.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els Partits", content = @Content(array = @ArraySchema(schema = @Schema(implementation = PartitDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No ha trobat els Partits", content = @Content) })
	@GetMapping("/partits/temporada/{idTemporada}/fase/{idFase}")
	public ResponseEntity<?> showAllPartitsByIdTemporadaAndIdFase(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada,
			@Parameter(description = "ID de la Fase, amb el 0 ens mostra els partits de totes les fases", required = true) @PathVariable Long idFase) {

		List<PartitDTO> elsPartitsDTO = partitService.listPartitsTemporadaFase(idTemporada, idFase);

		return ResponseEntity.ok(elsPartitsDTO);
	}

	@Operation(summary = "Llistem tots els partits classificats per Grup corresponent a la Fase de Grups.", description = "Proveïm d'un mecanisme per a mostrar tots els partits relatius a una temporada i que pertanyen a la Fase de Grups. Per a millor manipulació els classsifiquem per grups. Proporcionarem el ID de la Temporada.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els Partits", content = @Content(array = @ArraySchema(schema = @Schema(implementation = GrupPartitDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No ha trobat els Partits", content = @Content) })
	@GetMapping("/partits/temporada/{idTemporada}/grups")
	public ResponseEntity<?> showAllPartitsGrupsFaseGrupByIdTemporada(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {

		List<GrupPartitDTO> elsPartitsGrupDTO = partitService.listPartitsFaseGrups(idTemporada);

		return ResponseEntity.ok(elsPartitsGrupDTO);
	}

	@Operation(summary = "Realitzar els enfrontaments per a la fase de Grups.", description = "Proveïm d'un mecanisme per a crear els partits de la fase de grups. Hem de proporcionar el ID de la Temporada.")
	@ApiResponses(value = { @ApiResponse(responseCode = "200", description = "Partit creats.", content = @Content()),
			@ApiResponse(responseCode = "400", description = "Partits no realitzats", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/sorteigPartitsGrups/{idTemporada}")
	public ResponseEntity<String> sorteigPartitsGrups(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {
		partitService.crearPartitsFaseGrups(idTemporada);
		return ResponseEntity.ok("Sorteig de partits completat!!");
	}

	@Operation(summary = "Realitzar els enfrontaments per a la fase d'Octaus.", description = "Proveïm d'un mecanisme per a crear els partits de la fase d'Octaus. Hem de proporcionar el ID de la Temporada.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Partits realitzats", content = @Content()),
			@ApiResponse(responseCode = "400", description = "Partits no realitzats", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/sorteigOctaus/{idTemporada}")
	public ResponseEntity<String> sorteigPartitsOctaus(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {
		partitService.crearPartitsOctaus(idTemporada);
		return ResponseEntity.ok("Sorteig de partits completat!!");
	}

	@Operation(summary = "Realitzar els enfrontaments per a la fase de Quarts DIRECTAMENT!!.", description = "Proveïm d'un mecanisme per a crear els partits de la fase dE QUARTS i pasem per alt la fase d'octaus. Hem de proporcionar el ID de la Temporada.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Partits realitzats", content = @Content()),
			@ApiResponse(responseCode = "400", description = "Partits no realitzats", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/sorteigQuarts/{idTemporada}")
	public ResponseEntity<String> sorteigPartitsDirectesQuarts(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {
		partitService.crearPartitsDirectesQuarts(idTemporada);
		return ResponseEntity.ok("Sorteig de partits completat!!");
	}

	@Operation(summary = "Realitzar els enfrontaments per a les següents fases: quarts, semifinal i final.", description = "Proveïm d'un mecanisme per a crear els partits de les fases restants. Hem de proporcionar el ID de la Temporada i el ID de la Fase.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Partits realitzats", content = @Content()),
			@ApiResponse(responseCode = "400", description = "Partits no realitzats", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PostMapping("/sorteigEliminacions/{idTemporada}/fase/{idFase}")
	public ResponseEntity<String> sorteigPartitsEliminatoris(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada,
			@Parameter(description = "ID de la Fase", required = true) @PathVariable Long idFase) {
		partitService.crearPartitsEliminatoris(idTemporada, idFase);
		return ResponseEntity.ok("Sorteig de partits completat!!");
	}

	@Operation(summary = "Actualitzar un partit.", description = "Proveïm d'un mecanisme amb el que introduim el ID d'un partit i podem introduir el resultat i la data del enfrontament.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Partit actualitzat amb èxit", content = @Content(schema = @Schema(implementation = PartitModificatDTO.class))),
			@ApiResponse(responseCode = "404", description = "Partit no trobar", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PutMapping("partit/{idPartit}")
	public ResponseEntity<?> putPartit(
			@Parameter(description = "ID de Partit", required = true) @PathVariable Long idPartit,
			@RequestBody PartitModificatDTO partitModificatDTO) {

		PartitModificatDTO partitActualitzat = partitService.updatePartit(idPartit, partitModificatDTO);

		return ResponseEntity.ok(partitActualitzat);
	}

	@Operation(summary = "Eliminar Partits", description = "Mecanisme per apoder borrar tot un llistat de partits referents a uan temporada i fase en concret. Proporcionant el ID d'una Temporada i el ID d'una Fase, cerquem tots els partits coincidents i els eliminem de la BD.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Partits eliminats satisfactòriament", content = @Content),
			@ApiResponse(responseCode = "404", description = "Equip no trobat", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@DeleteMapping("/partits/temporada/{idTemporada}/fase/{idFase}")
	public ResponseEntity<?> deleteTemporadaById(
			@Parameter(description = "ID de Temporada", required = true) @PathVariable Long idTemporada,
			@Parameter(description = "ID Fases", required = true) @PathVariable Long idFase) {

		boolean partitsBorrats = partitService.deletePartitsFase(idTemporada, idFase);

		if (partitsBorrats == true) {
			return new ResponseEntity<>("Partits amb id: " + idTemporada + " corresponents a la fase " + idFase
					+ " eliminats satisfactòriament.", HttpStatus.OK);
		} else {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"No hi han partits de la temporada " + idTemporada + " per a la fase " + idFase);
		}

	}

}

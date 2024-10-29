package org.eljust.Controller;

import java.util.List;

import org.eljust.DTO.EquipDTO;
import org.eljust.DTO.EquipJugadorDTO;
import org.eljust.DTO.EquipNouDTO;
import org.eljust.DTO.EquipSimpleDTO;
import org.eljust.Error.EquipNotFoundException;
import org.eljust.Service.EquipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

/**
 * Controlador d'Equips
 * 
 * @author Vicent Roselló
 */
@RestController
@RequestMapping("/api-torneig")
@Tag(name = "Equip", description = "Controlador per a gestionar i consultar els equips.")
public class EquipController {

	@Autowired
	private EquipService equipService;

	@Operation(summary = "Obtenim un llistat de tots els Equips.", description = "Proveïm d'un mecanisme per obtindre un llistat de tots els equips registrats.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els equips.", content = @Content(array = @ArraySchema(schema = @Schema(implementation = EquipSimpleDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han equips registrats.", content = @Content) })
	@GetMapping("/equips")
	public ResponseEntity<?> showAllEquips() {

		List<EquipSimpleDTO> elsEquipsDTO = equipService.listAllEquips();

		return ResponseEntity.ok(elsEquipsDTO);

	}

	@Operation(summary = "Obtenim la informació d'un equip.", description = "Al introduir el ID d'un equip ens mostra la informació d'aquest amb una llista dels seus jugadors i tots els partits que ha realitzat.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat l'equip.", content = @Content(schema = @Schema(implementation = EquipDTO.class))),
			@ApiResponse(responseCode = "404", description = "No ha trobat l'equip.", content = @Content) })
	@GetMapping("/equip/{idEquip}")
	public ResponseEntity<?> showEquipById(
			@Parameter(description = "ID de l'Equip", required = true) @PathVariable Long idEquip) {

		EquipDTO equipDTO = equipService.getEquipById(idEquip);

		return ResponseEntity.ok(equipDTO);

	}

	@Operation(summary = "Obtenim un llistat d'Equips d'una Temporada en concret.", description = "Al introduir el ID d'una Temporada ens mostrarà un llistat d'equips referents a la temporada proporcionada.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els equips.", content = @Content(array = @ArraySchema(schema = @Schema(implementation = EquipSimpleDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han equips registrats a aqueta temporada.", content = @Content) })
	@GetMapping("/equips/temporada/{idTemporada}")
	public ResponseEntity<?> showEquipsByIdTemporada(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {

		List<EquipSimpleDTO> elsEquipsSimplesDTO = equipService.listEquipsByIdTemporada(idTemporada);

		return ResponseEntity.ok(elsEquipsSimplesDTO);

	}

	@Operation(summary = "Llistat d'Equips amb els jugadors d'una Temporada en concret.", description = "Al introduir el ID d'una Temporada ens mostrarà un llistat d'equips i els noms dels seus jugadors, referents a la temporada proporcionada.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat els equips.", content = @Content(array = @ArraySchema(schema = @Schema(implementation = EquipJugadorDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han equips registrats a aqueta temporada.", content = @Content) })
	@GetMapping("/equips/temporada/{idTemporada}/jugadors")
	public ResponseEntity<Object> showEquipsAmbJugadorsByIdTemporada(
			@Parameter(description = "ID de la Temporada", required = true) @PathVariable Long idTemporada) {

		List<EquipJugadorDTO> elsEquipsJugadorsDTO = equipService.listEquipsJugadorsByIdTemporada(idTemporada);

		return ResponseEntity.ok(elsEquipsJugadorsDTO);

	}

	@Operation(summary = "Busca els Equips pel seu nom.", description = "Busquem els equips pel seu nom o que el text que porporcionem coincidisca amb un fragment del nom de l'equip.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Ha trobat l'equip/s.", content = @Content(array = @ArraySchema(schema = @Schema(implementation = EquipSimpleDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No hi han equips coinsidents.", content = @Content) })
	@GetMapping("/equips/nom")
	public ResponseEntity<?> buscarEquipsPelNom(
			@Parameter(description = "Nom o fragment de nom de l'equip a buscar", required = true) @RequestParam("nom") String nom) {

		List<EquipSimpleDTO> elsEquipsDTO = equipService.listEquipsPelNom(nom);

		return ResponseEntity.ok(elsEquipsDTO);

	}

	@Operation(summary = "D'onar d'alta un nou Equip", description = "Mètode per a crear un nou equip el qual hem de proporsinar les dades necessaries. No hem de proporcinar els partits.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "201", description = "Equip creat satisfactoriament", content = @Content(array = @ArraySchema(schema = @Schema(implementation = EquipNouDTO.class)))),
			@ApiResponse(responseCode = "404", description = "Temporada no trobada, per tant no s'ha creat l'equip.", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@PostMapping("/equip/temporada/{idTemporada}")
	@Secured("ADMIN")
	public ResponseEntity<?> addEquip(
			@Parameter(description = "ID de la temporada associada al nou equip", required = true) @PathVariable Long idTemporada,
			@RequestBody EquipNouDTO equipNouDTO) {

		EquipDTO nouEquip = equipService.saveEquipNou(equipNouDTO, idTemporada);

		return ResponseEntity.status(HttpStatus.CREATED).body(nouEquip);

	}

	@Operation(summary = "Actualitzar un Equip", description = "Actualitza o modifica un Equip existent a la Base de Dades, proporcionant el ID del Equip que volem actualitzar.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Equip actualitzat satisfactoriament", content = @Content(array = @ArraySchema(schema = @Schema(implementation = EquipDTO.class)))),
			@ApiResponse(responseCode = "404", description = "Equip no trobat.", content = @Content),
			@ApiResponse(responseCode = "500", description = "Error intern", content = @Content) })
	@Secured("ADMIN")
	@PutMapping("equip/{idEquip}")
	public ResponseEntity<?> putEquip(
			@Parameter(description = "ID del Equip que volem actualitzar", required = true) @PathVariable Long idEquip,
			@RequestBody EquipNouDTO equipNouDTO) {

		EquipDTO equipActualitzat = equipService.updateEquip(idEquip, equipNouDTO);

		return ResponseEntity.ok(equipActualitzat);
	}

	@Operation(summary = "Eliminar un Equip", description = "Proporcionant el ID d'un Equip existent a la Base de Dades, l'elimina d'aquesta.")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Equip eliminat satisfactòriament", content = @Content),
			@ApiResponse(responseCode = "404", description = "Equip no trobat", content = @Content) })
	@Secured("ADMIN")
	@DeleteMapping("/equip/{idEquip}")
	public ResponseEntity<?> deleteEquipById(
			@Parameter(description = "ID del Equip que volem borrar", required = true) @PathVariable Long idEquip) {

		boolean equipBorrat = equipService.deleteEquip(idEquip);

		if (equipBorrat == true)
			return new ResponseEntity<>("Equip amb id: " + idEquip + " eliminat satisfactòriament", HttpStatus.OK);

		throw new EquipNotFoundException(idEquip);

	}

}

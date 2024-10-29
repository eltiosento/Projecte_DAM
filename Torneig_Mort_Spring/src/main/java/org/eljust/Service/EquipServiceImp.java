package org.eljust.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.eljust.Configuracion.ComparadorPartitPerData;
import org.eljust.DTO.EquipDTO;
import org.eljust.DTO.EquipJugadorDTO;
import org.eljust.DTO.EquipNouDTO;
import org.eljust.DTO.EquipSimpleDTO;
import org.eljust.DTO.PartitDTO;
import org.eljust.DTO.Converter.EquipDTOconverter;
import org.eljust.DTO.Converter.EquipJugadorDTOConverter;
import org.eljust.DTO.Converter.EquipSimpleDTOConverter;
import org.eljust.DTO.Converter.PartitDTOConverter;
import org.eljust.Error.EquipNotFoundException;
import org.eljust.Error.TemporadaNotFoundException;
import org.eljust.Model.Equip;
import org.eljust.Model.Jugador;
import org.eljust.Model.Partit;
import org.eljust.Model.Temporada;
import org.eljust.Repository.EquipRepository;
import org.eljust.Repository.JugadorRepository;
import org.eljust.Repository.PartitRepository;
import org.eljust.Repository.TemporadaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EquipServiceImp implements EquipService {

	@Autowired
	private TemporadaRepository temporadaRepository;

	@Autowired
	private EquipRepository equipRepository;

	@Autowired
	private JugadorRepository jugadorRepository;

	@Autowired
	private PartitRepository partitRepository;

	@Autowired
	private EquipJugadorDTOConverter equipJugadorDTOConverter;

	@Autowired
	private EquipDTOconverter equipDTOConverter;

	@Autowired
	private EquipSimpleDTOConverter equipSimpDTOConverter;

	@Autowired
	private PartitDTOConverter partitDTOConverter;

	@Override
	public EquipDTO getEquipById(Long id) {

		Equip equip = equipRepository.findById(id).orElseThrow(() -> new EquipNotFoundException(id));

		EquipDTO equipDTO = equipDTOConverter.convertToDTO(equip);

		List<Partit> elsPartits = partitRepository.findPartitsPerEquipId(id);

		Collections.sort(elsPartits, new ComparadorPartitPerData());

		List<PartitDTO> elsPartitsDTO = elsPartits.stream().map(partitDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		equipDTO.setElsPartits(elsPartitsDTO);
		equipDTO.setPartitsJugats(partitRepository.contarPartitsJugatsPerEquipFaseGrups(id));
		equipDTO.setPartitsGuanyats(partitRepository.contarPartitsGuanyatsPerEquipFaseGrups(id));
		equipDTO.setPartitsPerduts(partitRepository.contarPartitsPerdutsPerEquipFaseGrups(id));
		equipDTO.setPartitsEmpatats(
				equipDTO.getPartitsJugats() - equipDTO.getPartitsGuanyats() - equipDTO.getPartitsPerduts());
		return equipDTO;

	}

	@Override
	public List<EquipSimpleDTO> listAllEquips() {

		List<Equip> elsEquips = equipRepository.findAll();

		if (elsEquips.isEmpty())
			throw new EquipNotFoundException();

		List<EquipSimpleDTO> elsEquipsSimplesDTO = elsEquips.stream().map(equipSimpDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsEquipsSimplesDTO;
	}

	@Override
	public List<EquipSimpleDTO> listEquipsByIdTemporada(Long id) {
		// Busquem la temporada, si no l'hem trobada llancem l'excepció. Es fer un
		// try-catch simplificat.
		Temporada temporada = temporadaRepository.findById(id).orElseThrow(() -> new TemporadaNotFoundException(id));

		List<Equip> elsEquips = temporada.getElsEquips();

		if (elsEquips.isEmpty())
			throw new EquipNotFoundException("No s'ha trobat cap equip a aquesta Temporada.");

		List<EquipSimpleDTO> elsEquipsDTO = elsEquips.stream().map(equipSimpDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsEquipsDTO;

	}

	@Override
	public List<EquipJugadorDTO> listEquipsJugadorsByIdTemporada(Long id) {
		// Busquem la temporada, si no l'hem trobada llancem l'excepció. Es fer un
		// try-catch simplificat.
		Temporada temporada = temporadaRepository.findById(id).orElseThrow(() -> new TemporadaNotFoundException(id));

		List<Equip> elsEquips = temporada.getElsEquips();

		if (elsEquips.isEmpty())
			throw new EquipNotFoundException("No s'ha trobat cap equip a aquesta Temporada.");

		List<EquipJugadorDTO> elsEquipsDTO = elsEquips.stream().map(equipJugadorDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsEquipsDTO;
	}

	@Override
	public List<EquipSimpleDTO> listEquipsPelNom(String nom) {

		List<Equip> elsEquips = equipRepository.findByNomContainsIgnoreCase(nom);

		if (elsEquips.isEmpty())
			throw new EquipNotFoundException("No hi ha cap equip coincident amb la paraula: " + nom);

		List<EquipSimpleDTO> elsEquipsSimplesDTO = elsEquips.stream().map(equipSimpDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsEquipsSimplesDTO;

	}

	@Override
	public EquipDTO saveEquipNou(EquipNouDTO equipNouDTO, Long idTemporada) {

		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		Equip equip = EquipNouDTO.DTO2Model(equipNouDTO);
		equip.setLaTemporada(temporada);

		List<Long> idsJugadors = equipNouDTO.getIdJugadors();
		List<Jugador> elsJugadors = new ArrayList<>();

		for (Long id : idsJugadors) {
			Jugador jugador = jugadorRepository.findById(id).orElse(null);
			if (jugador != null) {
				elsJugadors.add(jugador);
				// Actualitzem la llista d'equipos del jugador amb l'equip en qüestió.
				jugador.getElsEquips().add(equip);
			}

		}
		equip.setElsJugadors(elsJugadors);

		Equip equipSaved = equipRepository.save(equip);
		// System.out.println(equipSaved.getElsJugadors());
		return equipDTOConverter.convertToDTO(equipSaved);

	}

	@Override
	public EquipDTO updateEquip(Long idEquip, EquipNouDTO equipNouDTO) {

		Equip equip = equipRepository.findById(idEquip).orElseThrow(() -> new EquipNotFoundException(idEquip));

		List<Jugador> elsJugadors = equip.getElsJugadors();
		List<Long> idsJugadors = equipNouDTO.getIdJugadors();

		// AFFEGIM LES MODIFICACIONS
		equip.setNom(equipNouDTO.getNom());
		equip.setCurs(equipNouDTO.getCurs());
		equip.setImatge(equipNouDTO.getImatge());
		equip.setEsGuanyador(equipNouDTO.isEsGuanyador());

		if (!idsJugadors.isEmpty()) {

			// BORREM DE CADA JUGADOR EL EQUIP
			for (Jugador jugador : elsJugadors) {

				jugador.getElsEquips().remove(equip);
			}
			// BORREM DE CADA EQUIP ELS SEUS JUGADORS
			elsJugadors.clear();

			// CONFECCIONEM LA NOVA LLISTA DE JUGADORS QUE REBEM
			for (Long id : idsJugadors) {
				Jugador jugador = jugadorRepository.findById(id).orElse(null);
				if (jugador != null) {

					// AFEGIM ELS NOUS JUGADORS AL EQUIP
					elsJugadors.add(jugador);

					// AFEGIM A CADA JUGADOR EL EQUIP
					jugador.getElsEquips().add(equip);
				}

			}
			// AFEGIM LA NOVA LLISTA DE JUGADORS AL EQUIP
			equip.setElsJugadors(elsJugadors);
		}
		// GUARDEM EL NOU EQUIP
		equipRepository.save(equip);

		// Retornem un EquipDTO per estalviar fer un conversor a EquipNouDTO
		return equipDTOConverter.convertToDTO(equip);

	}

	@Override
	public boolean deleteEquip(Long id) {

		if (equipRepository.existsById(id)) {
			equipRepository.deleteByIdCustom(id);
			return true;
		} else {
			return false;
		}

	}

}

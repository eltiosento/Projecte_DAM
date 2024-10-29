package org.eljust.Service;

import java.util.List;
import java.util.stream.Collectors;

import org.eljust.DTO.JugadorDTO;
import org.eljust.DTO.JugadorSimpleDTO;
import org.eljust.DTO.Converter.JugadorDTOConverter;
import org.eljust.DTO.Converter.JugadorSimpleDTOConverter;
import org.eljust.Error.JugadorNotFoundException;
import org.eljust.Model.Jugador;
import org.eljust.Repository.JugadorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class JugadorServiceImp implements JugadorService {

	@Autowired
	private JugadorRepository jugadorRepository;

	@Autowired
	private JugadorSimpleDTOConverter jugadorSimpleDTOConverter;

	@Autowired
	private JugadorDTOConverter jugadorDTOConverter;

	@Override
	public List<JugadorSimpleDTO> listAllJugadors() {

		List<Jugador> elsJugadors = jugadorRepository.findAll();

		if (elsJugadors.isEmpty())
			throw new JugadorNotFoundException();

		List<JugadorSimpleDTO> elsJugadorsSimplesDTO = elsJugadors.stream().map(jugadorSimpleDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsJugadorsSimplesDTO;
	}

	
	@Override
	public List<JugadorSimpleDTO> listJugadorsFiltratsPerEdat() {
		List<Jugador> elsJugadors = jugadorRepository.filtrarJugadorsPerEdat();

		if (elsJugadors.isEmpty())
			throw new JugadorNotFoundException();

		List<JugadorSimpleDTO> elsJugadorsSimplesDTO = elsJugadors.stream().map(jugadorSimpleDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsJugadorsSimplesDTO;
	}
	
	
	@Override
	public JugadorDTO getJugadorById(Long idJugador) {

		Jugador jugador = jugadorRepository.findById(idJugador)
				.orElseThrow(() -> new JugadorNotFoundException(idJugador));

		JugadorDTO jugadorDTO = jugadorDTOConverter.convertToDTO(jugador);

		return jugadorDTO;
	}

	@Override
	public List<JugadorSimpleDTO> listJugadorPelNom(String nom) {

		List<Jugador> elsJugadors = jugadorRepository.findByNomContainsIgnoreCase(nom);

		if (elsJugadors.isEmpty())
			throw new JugadorNotFoundException("No hi ha cap jugador coincident amb la paraula: " + nom);

		List<JugadorSimpleDTO> elsJugadorsSimplesDTO = elsJugadors.stream().map(jugadorSimpleDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsJugadorsSimplesDTO;
	}

	@Override
	public JugadorSimpleDTO saveJugador(JugadorSimpleDTO elJugador) {

		Jugador jugador = jugadorSimpleDTOConverter.convertToModel(elJugador);

		jugadorRepository.save(jugador);

		JugadorSimpleDTO jugadorSimpleDTO = jugadorSimpleDTOConverter.convertToDTO(jugador);

		return jugadorSimpleDTO;
	}

	@Override
	public JugadorSimpleDTO updateJugador(Long idJugador, JugadorSimpleDTO jugadorSimpleDTO) {

		Jugador jugador = jugadorRepository.findById(idJugador)
				.orElseThrow(() -> new JugadorNotFoundException(idJugador));

		jugador.setNom(jugadorSimpleDTO.getNom());
		jugador.setEdat(jugadorSimpleDTO.getEdat());
		jugador.setSancionat(jugadorSimpleDTO.isSancionat());
		jugadorRepository.save(jugador);

		return jugadorSimpleDTOConverter.convertToDTO(jugador);
	}

	@Override
	public boolean deleteJugador(Long id) {

		if (jugadorRepository.existsById(id)) {
			jugadorRepository.deleteByIdCustom(id);
			return true;
		} else {
			return false;
		}

	}

	

}

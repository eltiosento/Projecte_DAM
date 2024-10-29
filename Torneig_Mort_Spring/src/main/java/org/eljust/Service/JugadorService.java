package org.eljust.Service;

import java.util.List;

import org.eljust.DTO.JugadorDTO;
import org.eljust.DTO.JugadorSimpleDTO;

public interface JugadorService {

	List<JugadorSimpleDTO> listAllJugadors();
	
	List<JugadorSimpleDTO> listJugadorsFiltratsPerEdat();

	JugadorDTO getJugadorById(Long idJugador);

	JugadorSimpleDTO saveJugador(JugadorSimpleDTO elJugador);

	boolean deleteJugador(Long id);

	List<JugadorSimpleDTO> listJugadorPelNom(String nom);

	JugadorSimpleDTO updateJugador(Long idJugador, JugadorSimpleDTO jugadorSimpleDTO);
}

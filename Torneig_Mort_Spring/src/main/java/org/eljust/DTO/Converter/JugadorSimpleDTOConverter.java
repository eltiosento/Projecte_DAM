package org.eljust.DTO.Converter;

import org.eljust.DTO.JugadorSimpleDTO;
import org.eljust.Model.Jugador;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JugadorSimpleDTOConverter {

	private final ModelMapper modelMapper;

	public JugadorSimpleDTO convertToDTO(Jugador jugador) {
		return modelMapper.map(jugador, JugadorSimpleDTO.class);

	}

	public Jugador convertToModel(JugadorSimpleDTO jugadorImpleDTO) {
		return modelMapper.map(jugadorImpleDTO, Jugador.class);

	}
}

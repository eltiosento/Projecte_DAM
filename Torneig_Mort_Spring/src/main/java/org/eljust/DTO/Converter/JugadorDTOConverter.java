package org.eljust.DTO.Converter;

import java.util.List;
import java.util.stream.Collectors;

import org.eljust.DTO.EquipSimpleDTO;
import org.eljust.DTO.JugadorDTO;
import org.eljust.Model.Jugador;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JugadorDTOConverter {

	private final ModelMapper modelMapper;

	public JugadorDTO convertToDTO(Jugador jugador) {

		JugadorDTO jugadorDTO = modelMapper.map(jugador, JugadorDTO.class);

		List<EquipSimpleDTO> elsEquipSimplesDTO = jugador.getElsEquips().stream()
				.map(equip -> modelMapper.map(equip, EquipSimpleDTO.class)).collect(Collectors.toList());

		jugadorDTO.setElsEquips(elsEquipSimplesDTO);

		return jugadorDTO;

	}

}

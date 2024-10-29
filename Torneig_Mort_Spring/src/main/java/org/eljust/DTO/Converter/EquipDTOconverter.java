package org.eljust.DTO.Converter;

import java.util.List;
import java.util.stream.Collectors;

import org.eljust.DTO.EquipDTO;
import org.eljust.DTO.JugadorSimpleDTO;
import org.eljust.Model.Equip;

import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class EquipDTOconverter {
	private final ModelMapper modelMapper;

	public EquipDTO convertToDTO(Equip equip) {

		EquipDTO equipDTO = modelMapper.map(equip, EquipDTO.class);

		List<JugadorSimpleDTO> elsJugadorsDTO = equip.getElsJugadors().stream()
				.map(jugador -> modelMapper.map(jugador, JugadorSimpleDTO.class)).collect(Collectors.toList());

		equipDTO.setElsJugadors(elsJugadorsDTO);
		return equipDTO;
	}

}

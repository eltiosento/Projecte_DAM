package org.eljust.DTO.Converter;

import java.util.List;
import java.util.stream.Collectors;

import org.eljust.DTO.EquipJugadorDTO;
import org.eljust.Model.Equip;
import org.eljust.Model.Jugador;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class EquipJugadorDTOConverter {

	private final ModelMapper modelMapper;

	public EquipJugadorDTO convertToDTO (Equip equip) {
		
		EquipJugadorDTO equipJugadorDTO = modelMapper.map(equip,EquipJugadorDTO.class);
		
		List<String> elsNomsJugadors = equip.getElsJugadors().stream().map(Jugador::getNom).collect(Collectors.toList());
		
		equipJugadorDTO.setElsJugadors(elsNomsJugadors);
		
		return equipJugadorDTO;
	}
}

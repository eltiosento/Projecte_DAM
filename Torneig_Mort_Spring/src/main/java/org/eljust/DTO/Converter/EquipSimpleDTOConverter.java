package org.eljust.DTO.Converter;

import org.eljust.DTO.EquipSimpleDTO;
import org.eljust.Model.Equip;

import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class EquipSimpleDTOConverter {

	private final ModelMapper modelMapper;

	public EquipSimpleDTO convertToDTO(Equip equip) {
		return modelMapper.map(equip, EquipSimpleDTO.class);
	}

}

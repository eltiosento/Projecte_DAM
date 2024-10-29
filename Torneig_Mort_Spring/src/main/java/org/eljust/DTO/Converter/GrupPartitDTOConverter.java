package org.eljust.DTO.Converter;

import org.eljust.DTO.GrupPartitDTO;
import org.eljust.Model.Grup;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class GrupPartitDTOConverter {

	private final ModelMapper modelMapper;

	public GrupPartitDTO convertToDTO(Grup grup) {

		return modelMapper.map(grup, GrupPartitDTO.class);

	}

}

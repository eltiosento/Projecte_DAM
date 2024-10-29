package org.eljust.DTO.Converter;

import org.eljust.DTO.FaseDTO;
import org.eljust.Model.Fase;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class FaseDTOConverter {
	private final ModelMapper modelMapper;

	public FaseDTO convertToDTO(Fase fase) {
		return modelMapper.map(fase, FaseDTO.class);

	}

}

package org.eljust.DTO.Converter;

import org.eljust.DTO.PartitModificatDTO;
import org.eljust.Model.Partit;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class PartitModificatDTOCOnverter {
	private final ModelMapper modelMapper;

	public PartitModificatDTO convertToDTO(Partit partit) {
		return modelMapper.map(partit, PartitModificatDTO.class);
	}
}

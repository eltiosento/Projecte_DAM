package org.eljust.DTO.Converter;

import org.eljust.DTO.TemporadaDTO;
import org.eljust.Model.Temporada;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class TemporadaDTOConverter {

	private final ModelMapper modelMapper;

	public TemporadaDTO convertToDTO(Temporada temporada) {
		return modelMapper.map(temporada, TemporadaDTO.class);
	}

	public Temporada convertToModel(TemporadaDTO temporadaDTO) {
		return modelMapper.map(temporadaDTO, Temporada.class);
	}
}

package org.eljust.Service;

import java.util.List;

import org.eljust.DTO.TemporadaDTO;

public interface TemporadaService {

	List<TemporadaDTO> listAllTemporades();

	TemporadaDTO getTemporadaById(Long id);

	TemporadaDTO saveTemporada(TemporadaDTO temporadaDTO);

	TemporadaDTO updateTemporada(Long id, TemporadaDTO temporadaDTO);

	boolean deleteTemporada(Long id);
}

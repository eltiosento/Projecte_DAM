package org.eljust.Service;

import java.util.List;

import org.eljust.DTO.GrupPartitDTO;
import org.eljust.DTO.PartitDTO;
import org.eljust.DTO.PartitModificatDTO;

public interface PartitService {

	void crearPartitsFaseGrups(Long idTemporada);

	List<PartitDTO> listAllPartits(Long idTemporada);

	List<PartitDTO> listPartitsTemporadaFase(Long idTemporada, Long idFase);

	PartitModificatDTO updatePartit(Long id, PartitModificatDTO partitModificatDTO);
	
	List<GrupPartitDTO> listPartitsFaseGrups(Long idTemporada);

	void crearPartitsOctaus(Long idTemporada);
	
	void crearPartitsDirectesQuarts(Long idTemporada);

	void crearPartitsEliminatoris(Long idTemporada, Long idFase);

	boolean deletePartitsFase(Long idTemporada, Long idFase);
}

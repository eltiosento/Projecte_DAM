package org.eljust.Service;

import java.util.List;

import org.eljust.DTO.GrupDTO;
import org.eljust.DTO.GrupEquipDTO;

public interface GrupService {

	void sorteigFaseGrups(Long idTemporada);

	List<GrupEquipDTO> listGrupsEquipsDTOByIdTemporada(Long id);

	GrupDTO getGrupById(Long id);
	
	boolean buidarEquipsGrups (Long idTemporada);
}

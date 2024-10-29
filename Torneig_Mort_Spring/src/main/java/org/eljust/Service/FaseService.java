package org.eljust.Service;

import java.util.List;

import org.eljust.DTO.FaseDTO;

public interface FaseService {

	List<FaseDTO> listAllFases();

	FaseDTO updateFase(Long id, FaseDTO faseDTO);

}

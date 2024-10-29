package org.eljust.Service;

import java.util.List;
import java.util.stream.Collectors;

import org.eljust.DTO.FaseDTO;
import org.eljust.DTO.Converter.FaseDTOConverter;
import org.eljust.Error.FaseNotFoundException;
import org.eljust.Model.Fase;
import org.eljust.Repository.FaseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FaseServiceImp implements FaseService {

	@Autowired
	private FaseRepository faseRepository;

	@Autowired
	private FaseDTOConverter faseDTOConverter;

	@Override
	public List<FaseDTO> listAllFases() {

		List<Fase> lesFases = faseRepository.findAll();

		if (lesFases.isEmpty())
			throw new FaseNotFoundException();

		List<FaseDTO> lesFasesDTO = lesFases.stream().map(faseDTOConverter::convertToDTO).collect(Collectors.toList());

		return lesFasesDTO;
	}

	@Override
	public FaseDTO updateFase(Long id, FaseDTO faseDTO) {

		Fase fase = faseRepository.findById(id).orElseThrow(() -> new FaseNotFoundException());

		fase.setNom(faseDTO.getNom());
		faseRepository.save(fase);

		return faseDTOConverter.convertToDTO(fase);
	}

}

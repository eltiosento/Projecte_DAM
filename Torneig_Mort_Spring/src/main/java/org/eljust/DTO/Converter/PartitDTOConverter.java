package org.eljust.DTO.Converter;

import org.eljust.DTO.EquipPartitDTO;
import org.eljust.DTO.PartitDTO;
import org.eljust.Model.Partit;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class PartitDTOConverter {
	private final ModelMapper modelMapper;

	public PartitDTO convertToDTO(Partit partit) {

		PartitDTO partitDTO = modelMapper.map(partit, PartitDTO.class);

		EquipPartitDTO equipLocal = modelMapper.map(partit.getEquipLocal(), EquipPartitDTO.class);
		EquipPartitDTO equipVisitant = modelMapper.map(partit.getEquipVisitant(), EquipPartitDTO.class);

		partitDTO.setEquipLocal(equipLocal);
		partitDTO.setEquipVisitant(equipVisitant);

		return partitDTO;

	}
}

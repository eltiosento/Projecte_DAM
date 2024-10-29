package org.eljust.DTO.Converter;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.eljust.Configuracion.ComparadorEquipPerPuntuacio;
import org.eljust.DTO.EquipGrupDTO;
import org.eljust.DTO.GrupEquipDTO;
import org.eljust.Model.Equip;
import org.eljust.Model.Grup;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class GrupEquipDTOConverter {

	private final ModelMapper modelMapper;

	public GrupEquipDTO convertToDTO(Grup grup) {

		GrupEquipDTO grupEquipDTO = modelMapper.map(grup, GrupEquipDTO.class);

		// Ordenem els equips per puntuació.
		List<Equip> elsEquips = grup.getElsEquips();
		Collections.sort(elsEquips, new ComparadorEquipPerPuntuacio());

		// Transformem la llista d'equips EquipGrupDTO.
		List<EquipGrupDTO> elsEquipsGrupsDTO = elsEquips.stream()
				.map(equip -> modelMapper.map(equip, EquipGrupDTO.class)).collect(Collectors.toList());
		
		grupEquipDTO.setElsEquipsGrups(elsEquipsGrupsDTO);

		return grupEquipDTO;
	}

}

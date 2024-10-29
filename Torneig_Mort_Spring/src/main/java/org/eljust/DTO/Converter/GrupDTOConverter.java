package org.eljust.DTO.Converter;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.eljust.Configuracion.ComparadorEquipPerPuntuacio;
import org.eljust.DTO.EquipGrupDTO;
import org.eljust.DTO.GrupDTO;
import org.eljust.Model.Equip;
import org.eljust.Model.Grup;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class GrupDTOConverter {

	private final ModelMapper modelMapper;

	public Grup convertToModel(GrupDTO grupSimpleDTO) {

		return modelMapper.map(grupSimpleDTO, Grup.class);
	}

	public GrupDTO convertToDTO(Grup grup) {

		GrupDTO grupDTO = modelMapper.map(grup, GrupDTO.class);

		// Ordenem els equips per puntuació.
		List<Equip> elsEquips = grup.getElsEquips();
		Collections.sort(elsEquips, new ComparadorEquipPerPuntuacio());

		List<EquipGrupDTO> elsEquipsGrupsDTO = elsEquips.stream()
				.map(equipo -> modelMapper.map(equipo, EquipGrupDTO.class)).collect(Collectors.toList());
		grupDTO.setElsEquipsGrups(elsEquipsGrupsDTO);
		return grupDTO;

	}

}

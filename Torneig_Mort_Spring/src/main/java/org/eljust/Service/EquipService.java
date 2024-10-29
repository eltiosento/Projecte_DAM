package org.eljust.Service;

import java.util.List;

import org.eljust.DTO.EquipDTO;
import org.eljust.DTO.EquipJugadorDTO;
import org.eljust.DTO.EquipNouDTO;
import org.eljust.DTO.EquipSimpleDTO;

public interface EquipService {

	EquipDTO getEquipById(Long id);

	List<EquipSimpleDTO> listAllEquips();

	List<EquipSimpleDTO> listEquipsByIdTemporada(Long id);

	List<EquipJugadorDTO> listEquipsJugadorsByIdTemporada(Long id);

	List<EquipSimpleDTO> listEquipsPelNom(String nom);

	EquipDTO saveEquipNou(EquipNouDTO equipNouDTO, Long idTemporada);

	EquipDTO updateEquip(Long idEquip, EquipNouDTO equipNouDTO);

	boolean deleteEquip(Long id);

}

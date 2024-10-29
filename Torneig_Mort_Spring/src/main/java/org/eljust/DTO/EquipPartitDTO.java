package org.eljust.DTO;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquet DTO Equip, el fem servir per a poder gestionar els equips d'un partit,
 * ja que asi tenim equip local i equip visitant. El gastem a PartitDTO.
 */
@Setter
@Getter
public class EquipPartitDTO {
	private Long idEquip;
	private String nom;
	private String imatge;
	private boolean esGuanyador;
	private String nomGrup;

}

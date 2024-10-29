package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import org.eljust.Model.Equip;

import lombok.Data;

import lombok.NoArgsConstructor;

/**
 * DTO per a crear un nou Equip, el farem servir a la petició POST per a donar
 * d'alta un nou Equip
 */
@Data
@NoArgsConstructor
public class EquipNouDTO {

	private String nom;
	private String curs;
	private String imatge;
	private boolean esGuanyador;
	private List<Long> idJugadors = new ArrayList<>();

	public static Equip DTO2Model(EquipNouDTO equipNouDTO) {

		Equip equip = new Equip();

		equip.setNom(equipNouDTO.getNom());
		equip.setCurs(equipNouDTO.getCurs());
		equip.setImatge(equipNouDTO.getImatge());
		equip.setEsGuanyador(equipNouDTO.isEsGuanyador());

		return equip;

	}

}

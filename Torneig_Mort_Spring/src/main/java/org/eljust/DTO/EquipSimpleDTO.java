package org.eljust.DTO;

import lombok.Getter;
import lombok.Setter;

/**
 * Equip DTO que ens serveix per a mostrar informació més simple d'un o més
 * equips. L'utilitzarem per llistar tots els equips de la BD i els Equips
 * donada una Temporada. També per a quan volem buscar pel nom.
 */
@Getter
@Setter
public class EquipSimpleDTO {

	private Long idEquip;
	private String nom;
	private String curs;
	private String nomTemporada;
	private Long idTemporada;
	private String imatge;
	private boolean esGuanyador;
}

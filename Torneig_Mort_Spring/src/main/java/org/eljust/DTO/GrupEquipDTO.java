package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquest DTO de Grup ens es útil per a mostrar tots els grups junt als equips
 * simplificats d'un grup (EquipGrupDTO, no conté als jugadors, entre altres).
 * El trobem al controlador de Grup i el gastarem per a llistar tots els grups
 * amb els equips que conté.
 */
@Setter
@Getter
public class GrupEquipDTO {
	private Long idGrup;
	private String nom;
	@JsonProperty("Equips")
	private List<EquipGrupDTO> elsEquipsGrups = new ArrayList<>();

}

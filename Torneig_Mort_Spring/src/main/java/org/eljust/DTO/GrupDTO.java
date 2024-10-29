package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquest GrupDTO es una classe la qual ens dona tota la informació rellevant de
 * la entitat Grup. La ferem servir al controlador de Grup concretament per a
 * obtindre la informació d'un grup.
 */
@Getter
@Setter
public class GrupDTO {
	private Long idGrup;
	private String nom;
	@JsonProperty("Equips")
	private List<EquipGrupDTO> elsEquipsGrups = new ArrayList<>();
	private List<PartitDTO> elsPartits = new ArrayList<>();

}

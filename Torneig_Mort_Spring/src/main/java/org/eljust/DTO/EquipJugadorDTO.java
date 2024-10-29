package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

/**
 * Fem servir aquest Equip DTO per a llistar els Equips i el nom dels seus
 * jugadors. Al controlador d'equip.
 */
@Getter
@Setter
public class EquipJugadorDTO {

	private Long idEquip;
	private String nomEquip;
	private String curs;
	private String imatge;
	private boolean esGuanyador;
	@JsonProperty("Jugadors")
	private List<String> elsJugadors = new ArrayList<>();

}

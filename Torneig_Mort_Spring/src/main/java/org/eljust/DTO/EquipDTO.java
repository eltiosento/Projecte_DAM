package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Equip DTO amb tota la informació rellevant. S'utilitza per a quan volem saber
 * la informació d'un equip en concret.
 */
@Getter
@Setter
public class EquipDTO {
	private Long idEquip;
	private String nom;
	private String curs;
	private String imatge;
	private boolean esGuanyador;
	private int punts;
	private int puntsContra;
	private String nomTemporada;
	private Long idTemporada;
	private Long idGrup;
	private String nomGrup;
	private int partitsJugats;
	private int partitsGuanyats;
	private int partitsPerduts;
	private int partitsEmpatats;
	private List<JugadorSimpleDTO> elsJugadors = new ArrayList<>();
	private List<PartitDTO> elsPartits = new ArrayList<>();

}

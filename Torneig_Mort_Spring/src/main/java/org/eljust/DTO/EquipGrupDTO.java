package org.eljust.DTO;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquest DTO d'Equip l'hem creat per a poder mostrar els equips d'un grup i no
 * caure amb la recursivitat infinita de grup i equips, amés tampoc mostrarà els
 * jugadors dels equpis. Simplifiquem la busqueda. El farem servir al GrupDTO i
 * GrupEquipDTO
 */
@Setter
@Getter
public class EquipGrupDTO {
	private Long idEquip;
	private String nom;
	private String curs;
	private String imatge;
	private boolean esGuanyador;
	private int punts;
	private int puntsContra;
	private int partitsJugats;
	private int partitsGuanyats;
	private int partitsPerduts;
	private int partitsEmpatats;

}

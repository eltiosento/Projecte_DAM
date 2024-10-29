package org.eljust.DTO;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * DTO de Partit per a poder gestionar la informació dels partits sense
 * recursivitats amb la fase. El fem servir al controlador de Partits i a
 * GrupDTO per a poder mostrar els partits d'un grup.
 */
@Setter
@Getter
public class PartitDTO {
	private Long idPartit;
	private Date dataPartit;
	private boolean partitJugat;
	private int resultatLocal;
	private int resultatVisitant;
	private String nomFase;
	private EquipPartitDTO equipLocal;
	private EquipPartitDTO equipVisitant;
}

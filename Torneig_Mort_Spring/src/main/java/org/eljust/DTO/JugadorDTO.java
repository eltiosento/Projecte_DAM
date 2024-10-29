package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquest DTO de jugador el farem servir per a mostrar tota la informació
 * relllevant d'un jugador,
 */
@Getter
@Setter
public class JugadorDTO {

	private Long idJugador;
	private String nomJugador;
	private int edat;
	private boolean sancionat;
	private List<EquipSimpleDTO> elsEquips = new ArrayList<>();

}

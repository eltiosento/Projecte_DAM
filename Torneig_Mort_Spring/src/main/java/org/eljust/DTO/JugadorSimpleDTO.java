package org.eljust.DTO;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquest JugadorDTO el fem servir per a llistar tots els jugadors, crear un
 * jugador nou o bé actualitzar un jugador.
 */
@Getter
@Setter
public class JugadorSimpleDTO {

	private Long idJugador;
	private String nom;
	private int edat;
	private boolean sancionat;

}

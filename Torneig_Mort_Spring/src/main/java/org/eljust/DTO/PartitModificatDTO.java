package org.eljust.DTO;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * DTO de Partit el qual utilitzarem per a poder modificar un partit, be siga
 * amb el resultat o la data.
 */
@Getter
@Setter
public class PartitModificatDTO {

	private Long idPartit;
	private Date dataPartit;
	private int resultatLocal;
	private int resultatVisitant;
	private boolean partitJugat;

}

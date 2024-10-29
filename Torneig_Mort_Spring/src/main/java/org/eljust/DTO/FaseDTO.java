package org.eljust.DTO;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de Fase, ens servirà per a poder llistar les fases del campionat
 */
@Data
@NoArgsConstructor
public class FaseDTO {

	private Long idFase;
	private String nom;

}

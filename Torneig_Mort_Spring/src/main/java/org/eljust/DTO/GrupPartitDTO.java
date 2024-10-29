package org.eljust.DTO;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Aquest DTO deGrup el farem servir per a llistar tots els partits que es
 * juguen a la fase de grups i aixi poder separar-los per grup.
 */
@Setter
@Getter
public class GrupPartitDTO {
	private Long idGrup;
	private String nomGrup;
	private List<PartitDTO> elsPartits = new ArrayList<>();

}

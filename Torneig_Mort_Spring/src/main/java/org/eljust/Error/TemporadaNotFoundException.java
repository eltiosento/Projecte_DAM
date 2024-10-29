package org.eljust.Error;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class TemporadaNotFoundException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public TemporadaNotFoundException(Long id) {
		super("No s'ha trobat la temporada amb ID: " + id);
	}

	public TemporadaNotFoundException() {
		super("No hi ha cap temporada registrada a la Base de Dades.");
	}
}

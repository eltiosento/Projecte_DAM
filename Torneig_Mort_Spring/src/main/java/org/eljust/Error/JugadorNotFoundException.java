package org.eljust.Error;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class JugadorNotFoundException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public JugadorNotFoundException(Long id) {
		super("No s'ha trobat el jugador amb ID: " + id);
	}

	public JugadorNotFoundException() {
		super("No s'ha trobat ningún jugador");
	}

	public JugadorNotFoundException(String missatge) {
		super(missatge);
	}
}

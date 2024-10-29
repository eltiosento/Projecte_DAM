package org.eljust.Error;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class PartitNotFoundException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public PartitNotFoundException(Long id) {
		super("No s'ha trobat el partit amb ID: " + id);
	}

	public PartitNotFoundException() {
		super("No s'ha trobat cap partit a aquesta temporada.");
	}

	public PartitNotFoundException(String missatge) {
		super(missatge);
	}
}

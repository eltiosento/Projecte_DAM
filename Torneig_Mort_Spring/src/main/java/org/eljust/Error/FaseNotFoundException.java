package org.eljust.Error;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class FaseNotFoundException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public FaseNotFoundException(Long id) {
		super("No existèix la fase amb ID: " + id);
	}

	public FaseNotFoundException() {
		super("No existèix cap fase.");
	}

}

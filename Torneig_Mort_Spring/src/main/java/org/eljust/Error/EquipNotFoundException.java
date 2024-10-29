package org.eljust.Error;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class EquipNotFoundException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public EquipNotFoundException(Long id) {
		super("No s'ha trobat l'equip amb ID: " + id);
	}

	public EquipNotFoundException() {
		super("No s'ha trobat cap equip.");
	}

	public EquipNotFoundException(String missatge) {
		super(missatge);
	}
}

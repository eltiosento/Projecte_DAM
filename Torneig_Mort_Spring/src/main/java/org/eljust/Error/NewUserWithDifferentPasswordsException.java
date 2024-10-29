package org.eljust.Error;

public class NewUserWithDifferentPasswordsException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4475420555096321289L;
	
	public NewUserWithDifferentPasswordsException() {
		super("Les contrassenyes no coinsideixen");
	}

}

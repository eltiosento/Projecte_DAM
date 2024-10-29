package org.eljust.Error;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@RestControllerAdvice
public class GlobalControllerAdvice extends ResponseEntityExceptionHandler {

	@ExceptionHandler(TemporadaNotFoundException.class)
	public ResponseEntity<ApiError> handleTemporadaNoTrobada(TemporadaNotFoundException ex) {

		ApiError apiError = new ApiError(HttpStatus.NOT_FOUND, ex.getMessage());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(apiError);

	}

	@ExceptionHandler(EquipNotFoundException.class)
	public ResponseEntity<ApiError> handleEquipNoTrobat(EquipNotFoundException ex) {

		ApiError apiError = new ApiError(HttpStatus.NOT_FOUND, ex.getMessage());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(apiError);

	}

	@ExceptionHandler(JugadorNotFoundException.class)
	public ResponseEntity<ApiError> handleJugadorNoTrobat(JugadorNotFoundException ex) {

		ApiError apiError = new ApiError(HttpStatus.NOT_FOUND, ex.getMessage());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(apiError);

	}

	@ExceptionHandler(GrupNotFoundException.class)
	public ResponseEntity<ApiError> handleGrupNoTrobat(GrupNotFoundException ex) {

		ApiError apiError = new ApiError(HttpStatus.NOT_FOUND, ex.getMessage());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(apiError);

	}

	@ExceptionHandler(PartitNotFoundException.class)
	public ResponseEntity<ApiError> handlePartitNoTrobat(PartitNotFoundException ex) {

		ApiError apiError = new ApiError(HttpStatus.NOT_FOUND, ex.getMessage());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(apiError);

	}

	@ExceptionHandler(FaseNotFoundException.class)
	public ResponseEntity<ApiError> handleFaseNoTrobada(FaseNotFoundException ex) {
		ApiError apiError = new ApiError(HttpStatus.NOT_FOUND, ex.getMessage());
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(apiError);
	}
	
	@ExceptionHandler(NewUserWithDifferentPasswordsException.class)
	public ResponseEntity<ApiError> handleNewUserErrors(Exception ex) {
		ApiError apiError = new ApiError(HttpStatus.BAD_REQUEST, ex.getMessage());
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(apiError);
	}
	

	@Override
	protected ResponseEntity<Object> handleExceptionInternal(Exception ex, Object body, HttpHeaders headers,
			HttpStatusCode statusCode, WebRequest request) {

		ApiError apiError = new ApiError(statusCode, ex.getMessage());
		return ResponseEntity.status(statusCode).headers(headers).body(apiError);
	}

}

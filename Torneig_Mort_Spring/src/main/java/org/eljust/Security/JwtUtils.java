package org.eljust.Security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import org.eljust.ModelUsers.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;

import javax.crypto.SecretKey;

import io.jsonwebtoken.security.SignatureException;
import lombok.extern.java.Log;

@Log
@Component
public class JwtUtils {

	@Value("${jwt.secret:Nml5Jyt1biewx6q2d/I9oNMeEFng30nz3h/AFwhjGGiwEboWU4pbYfWbxMvZ2VMRbHPKeCvIb3GSr5bNxfcgJA==}")
	private String jwtSecret;

	@Value("${jwt.expirationMs:86400000}")
	private int jwtDuracionTokenEnSegundos;

	public String generateJwtToken(Authentication authentication) {
		User userPrincipal = (User) authentication.getPrincipal();

		List<String> roles = userPrincipal.getRoleNames();

		Date now = new Date();

		SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));

		return Jwts.builder().subject(userPrincipal.getUsername()).issuedAt(now)
				.expiration(new Date(now.getTime() + jwtDuracionTokenEnSegundos)).signWith(key, Jwts.SIG.HS512)
				.claim("roles", roles).compact();

	}

	public String getUserNameFromJwtToken(String token) {
		SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
		try {

			Claims claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload();
					

			return claims.getSubject();

		} catch (JwtException | IllegalArgumentException e) {
			System.err.println("Error parsing JWT token: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}

	public boolean validateToken(String authToken) {

		try {
			SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
	        Jwts.parser()
	            .verifyWith(key).build()
	            .parseSignedClaims(authToken);
			return true;
		} catch (SignatureException ex) {
			log.info("Error en la firma del token JWT: " + ex.getMessage());
		} catch (MalformedJwtException ex) {
			log.info("Token malformat: " + ex.getMessage());
		} catch (ExpiredJwtException ex) {
			log.info("El token ha caducat: " + ex.getMessage());
		} catch (UnsupportedJwtException ex) {
			log.info("Token JWT no soportat: " + ex.getMessage());
		} catch (IllegalArgumentException ex) {
			log.info("JWT claims buit");
		}
		return false;

	}

}

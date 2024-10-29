package org.eljust.Security;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.java.Log;

@Log
@Component
public class AuthTokenFilter extends OncePerRequestFilter {

	@Autowired
	private JwtUtils jwtUtils;

	@Autowired
	private UserDetailsService userDetailsService;

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		try {
			log.info("AuthTokenFilter: Comencem filter request ");
			String jwt = parseJwt(request);
			log.info("AuthTokenFilter: Extraguem el token " + jwt);
			if (jwt != null && jwtUtils.validateToken(jwt)) {
				log.info("AuthTokenFilter: JWT es valid");
				
				String username = jwtUtils.getUserNameFromJwtToken(jwt);
				log.info("AuthTokenFilter: Username extret de JWT: " + username);
				
				UserDetails userDetails = userDetailsService.loadUserByUsername(username);
				log.info("AuthTokenFilter: Carreguem de UserDetails: " + userDetails.getUsername());
				
				UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
						userDetails, null, userDetails.getAuthorities());
				authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

				SecurityContextHolder.getContext().setAuthentication(authentication);
				log.info("AuthTokenFilter: Authentication correcta");
			}

		} catch (Exception e) {
			log.info("No s'ha pogut establir la autentificació d'usuari en el context de seguritat");
		}
		filterChain.doFilter(request, response);
	}

	private String parseJwt(HttpServletRequest request) {

		String headerAuth = request.getHeader("Authorization");

		if (headerAuth != null && headerAuth.startsWith("Bearer ")) {
			return headerAuth.substring(7);
		}

		return null;
	}

}

/*
package org.eljust.Configuracion;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


AQUESTA CLASSE LA CONFIGUREM EN SecurityConfiguration I COM QUE TENIM SEGURETAT HABILITEM TOTES LES PRCEDENCIES PERMITIM TOT



@Configuration
public class WebConfig implements WebMvcConfigurer {
	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**")				
				.allowedOrigins("http://localhost:8080", "http://192.168.0.17:8080","http://172.25.141.18:8080","http://172.25.141.239:8080","http://172.25.141.254:8080","http://10.2.1.254:8080","http://10.2.0.29:8080") // Agrega aquí otros orígenes según sea necesario																			// sea necesario
				.allowedMethods("GET", "POST", "PUT", "DELETE")
				.allowedHeaders("*")
				.allowCredentials(true);
	}

}

// Aquesta classe ens permet manejar el CORS per a les peticions desde clients externs, 
// tant per a fer html, flutter, i altres frameworks per a consumir la api
// podem restringir a la ruta del controlador que volgam les peticions ex:
// registry.addMapping("/api-torneig/temporades")
//.allowedOrigins("http://localhost:8080", "http://192.168.0.17:8080") // Agrega aquí otros orígenes según	sea necesario.																			
//.allowedMethods("GET", "POST", "PUT", "DELETE")
//.allowedHeaders("*")
//.allowCredentials(true);
// Permitiriem sols a les peticions per a temporades
*/
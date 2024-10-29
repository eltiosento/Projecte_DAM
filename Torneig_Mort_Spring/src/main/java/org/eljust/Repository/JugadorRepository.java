package org.eljust.Repository;

import java.util.List;

import org.eljust.Model.Jugador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
@Transactional
public interface JugadorRepository extends JpaRepository<Jugador, Long> {

	@Modifying
	@Query("DELETE FROM Jugador j WHERE j.idJugador = :id")
	void deleteByIdCustom(Long id);
	
	
	@Query("SELECT j FROM Jugador j WHERE j.edat < 14")
	List<Jugador> filtrarJugadorsPerEdat();

	List<Jugador> findByNomContainsIgnoreCase(String nom);

}

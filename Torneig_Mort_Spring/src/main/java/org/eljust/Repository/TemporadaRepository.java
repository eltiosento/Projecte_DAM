package org.eljust.Repository;

import org.eljust.Model.Temporada;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
@Transactional
public interface TemporadaRepository extends JpaRepository<Temporada, Long> {

	@Modifying
	@Query("DELETE FROM Temporada t WHERE t.idTemporada = :id")
	void deleteByIdCustom(Long id);

}

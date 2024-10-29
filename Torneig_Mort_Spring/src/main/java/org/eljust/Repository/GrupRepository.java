package org.eljust.Repository;

import java.util.List;

import org.eljust.Model.Grup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
@Transactional
public interface GrupRepository extends JpaRepository<Grup, Long> {

	@Query("SELECT DISTINCT e.elGrup FROM Temporada t JOIN t.elsEquips e WHERE t.idTemporada = :id")
	List<Grup> findGrupsByIdTemporada(@Param("id") Long id);

	@Query("SELECT g FROM Grup g WHERE g.elsEquips IS EMPTY")
	List<Grup> findGrupsSenseEquips();

}

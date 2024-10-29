package org.eljust.Repository;

import java.util.List;

import org.eljust.Model.Partit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
@Transactional
public interface PartitRepository extends JpaRepository<Partit, Long> {

	@Query("SELECT p FROM Partit p WHERE p.equipLocal.idEquip = :equipId OR p.equipVisitant.idEquip = :equipId")
	List<Partit> findPartitsPerEquipId(@Param("equipId") Long equipId);

	@Query("SELECT p FROM Partit p WHERE (p.equipLocal.elGrup.idGrup = :grupId OR p.equipVisitant.elGrup.idGrup = :grupId) AND p.laFase.idFase = :idFase")
	List<Partit> findPartitsPerGrupId(@Param("grupId") Long grupId, @Param("idFase") Long idFase);

	@Query("SELECT p FROM Partit p WHERE p.equipLocal.laTemporada.idTemporada = :temporadaId OR p.equipVisitant.laTemporada.idTemporada = :temporadaId")
	List<Partit> findPartitsPerTemporadaId(@Param("temporadaId") Long temporadaId);

	@Query("SELECT p FROM Partit p WHERE (p.equipLocal.laTemporada.idTemporada = :temporadaId OR p.equipVisitant.laTemporada.idTemporada = :temporadaId) AND p.laFase.idFase = :idFase")
	List<Partit> findPartitsPerTemporadaIdFaseId(@Param("temporadaId") Long temporadaId, @Param("idFase") Long idFase);

	@Query("SELECT COUNT(p) FROM Partit p WHERE (p.equipLocal.idEquip = :equipId OR p.equipVisitant.idEquip = :equipId) AND p.partitJugat = true AND p.laFase.idFase = 1")
	int contarPartitsJugatsPerEquipFaseGrups(@Param("equipId") Long equipId);
	
	@Query("SELECT COUNT(p) FROM Partit p WHERE (p.equipLocal.idEquip = :equipId AND p.partitJugat = true AND p.laFase.idFase = 1 AND p.resultatLocal > p.resultatVisitant) OR ( p.equipVisitant.idEquip = :equipId AND p.partitJugat = true AND p.laFase.idFase = 1 AND p.resultatVisitant > p.resultatLocal)")
	int contarPartitsGuanyatsPerEquipFaseGrups(@Param("equipId") Long equipId);

	@Query("SELECT COUNT(p) FROM Partit p WHERE (p.equipLocal.idEquip = :equipId AND p.partitJugat = true AND p.laFase.idFase = 1 AND p.resultatLocal < p.resultatVisitant) OR ( p.equipVisitant.idEquip = :equipId AND p.partitJugat = true AND p.laFase.idFase = 1 AND p.resultatVisitant < p.resultatLocal)")
	int contarPartitsPerdutsPerEquipFaseGrups(@Param("equipId") Long equipId);
	
	
	@Modifying
	@Query("DELETE FROM Partit p WHERE p.idPartit = :id")
	void deleteByIdCustom(Long id);
}

package org.eljust.Repository;

import java.util.List;

import org.eljust.Model.Equip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
@Transactional
public interface EquipRepository extends JpaRepository<Equip, Long> {

	@Modifying
	@Query("DELETE FROM Equip e WHERE e.idEquip = :id")
	void deleteByIdCustom(Long id);

	@Query("SELECT e FROM Equip e WHERE e.laTemporada.idTemporada = :temporadaId")
	List<Equip> findByTemporadaId(Long temporadaId);

	List<Equip> findByNomContainsIgnoreCase(String nom);
}

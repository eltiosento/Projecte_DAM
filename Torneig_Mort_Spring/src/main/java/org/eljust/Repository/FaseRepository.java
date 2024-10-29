package org.eljust.Repository;

import org.eljust.Model.Fase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;

@Repository
@Transactional
public interface FaseRepository extends JpaRepository<Fase, Long> {

}

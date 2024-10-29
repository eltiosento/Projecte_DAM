package org.eljust.Repository;

import java.util.Optional;

import org.eljust.ModelUsers.Role;
import org.eljust.ModelUsers.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

	Optional<Role> findByName(UserRole name);

}

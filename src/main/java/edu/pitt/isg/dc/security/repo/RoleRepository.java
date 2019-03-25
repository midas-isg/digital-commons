package edu.pitt.isg.dc.security.repo;

import edu.pitt.isg.dc.security.jpa.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long>{
}
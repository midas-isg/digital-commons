package edu.pitt.isg.dc.security.repo;

import edu.pitt.isg.dc.security.jpa.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NewUserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
}
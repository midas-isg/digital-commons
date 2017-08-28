package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<Users, Long> {
    @Transactional(readOnly=true)
    public List<Users> findAll();

    @Transactional(readOnly=true)
    public Users findOne(Long id);

    @Query(nativeQuery = true, value="SELECT id FROM users u WHERE u.user_id = ?1 AND u.email = ?2 AND u.name = ?3")
    Long getIdFromUser(String userId, String email, String name);

}

package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    @Transactional(readOnly=true)
    public List<Category> findAll();

    @Transactional(readOnly=true)
    public Category findOne(Long id);

    @Query(nativeQuery = true, value="select path from vw_findsetsview;")
    List<String> findSets();

}

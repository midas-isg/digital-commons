package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    @Query(nativeQuery = true, value =
            "SELECT DISTINCT s.path \n" +
                    "FROM vw_findsetsview as s \n" +
                    "JOIN entry as e \n " +
                    "ON e.category_id = s.setid \n" +
                    "WHERE e.content->'entry'->'identifier'->>'identifier' = ?1 and e.is_public = true;")
    List<String> getCategoryPathForIdentifier(@Param("identifier") String identifier);


}

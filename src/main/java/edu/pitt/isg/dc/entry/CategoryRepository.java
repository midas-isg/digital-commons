package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    @Transactional(readOnly=true)
    public List<Category> findAll();

    @Transactional(readOnly=true)
    public Category findOne(Long id);

    @Query(nativeQuery = true, value="select path \n" +
            "from vw_findsetsview as fs \n" +
            "where fs.path not LIKE '%Websites with data%' ;")
    List<String> findSets();

    @Query(nativeQuery = true, value =
            "SELECT DISTINCT s.path \n" +
                    "FROM vw_findsetsview as s \n" +
                    "JOIN entry as e \n " +
                    "ON e.category_id = s.setid \n" +
                    "WHERE e.content->'entry'->'identifier'->>'identifier' = ?1 and e.is_public = true;")
    List<String> getCategoryPathForIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value="select top_category \n" +
            "from vw_findsetsview as fs \n" +
            "where fs.setid = :identifier ;")
    String getTopCategory(@Param("identifier") Long identifier);

    @Query(nativeQuery = true, value="select setid, tree_path \n" +
            "from vw_findsetsview as fs ;")
    List<Object[]> getTreePaths();

    @Query(nativeQuery = true, value="select setid, tree_path \n" +
            "from vw_findsetsview as fs " +
            "where fs.top_category_id = :identifier ;")
    List<Object[]> getTreePathsSubset(@Param("identifier") Long identifier);

}

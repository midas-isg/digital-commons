package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface CategoryOrderRepository extends JpaRepository<CategoryOrder, Long> {
    @Transactional(readOnly=true)
    public List<CategoryOrder> findAll();

    @Transactional(readOnly=true)
    public CategoryOrder findOne(Long id);

    @Query(nativeQuery = true, value="select category_id from category_order where subcategory_id = ?1")
    public Integer findCategoryIdForSubcategory(Integer subcategory);
}

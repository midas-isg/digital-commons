package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface CategoryOrderRepository extends JpaRepository<CategoryOrder, Long> {
    @Transactional(readOnly=true)
    public List<CategoryOrder> findAll();
}

package edu.pitt.isg.dc.entry;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.persistence.NamedNativeQuery;
import java.util.Collection;
import java.util.List;

@Repository
public interface NcbiRepository extends JpaRepository<Ncbi, Long> {
    List<Ncbi> findAllByPathContaining(String parentId);
}
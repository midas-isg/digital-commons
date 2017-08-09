package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NcbiRepository extends JpaRepository<Ncbi, Long> {
    List<Ncbi> findAllByPathContaining(@Param("q") String parentIdWithDelimitors);
}
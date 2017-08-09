package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
// @RestResource(exported = false)
public interface NcbiRepository extends JpaRepository<Ncbi, Long> {
    @RestResource(path = "paths", rel = "paths")
    List<Ncbi> findAllByPathContaining(@Param("q") String parentIdWithDelimitors);
}
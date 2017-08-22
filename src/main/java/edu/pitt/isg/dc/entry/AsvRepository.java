package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AsvRepository extends JpaRepository<Asv, Long> {
    List<Asv> findByIriIn(List<String> iris);
    List<Asv> findByAncestorsContaining(String iri);
}

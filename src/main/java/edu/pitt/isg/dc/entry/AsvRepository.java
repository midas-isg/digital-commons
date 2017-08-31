package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Set;

public interface AsvRepository extends JpaRepository<Asv, Long> {
    Set<Asv> findByIriIn(Set<String> iris);
    List<Asv> findByAncestorsContaining(String iri);
}

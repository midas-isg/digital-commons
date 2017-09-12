package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {
    List<Location> findByIdIn(String parentIdWithDelimitors);
}
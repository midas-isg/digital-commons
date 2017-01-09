package edu.pitt.isg.dc.digital;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DigitalRepository extends CrudRepository<Digital, Long> {
}
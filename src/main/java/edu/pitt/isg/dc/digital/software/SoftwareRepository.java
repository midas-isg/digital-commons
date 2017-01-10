package edu.pitt.isg.dc.digital.software;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Service;

public interface SoftwareRepository extends CrudRepository<Software, Long> {
}

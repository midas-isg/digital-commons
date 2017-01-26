package edu.pitt.isg.dc.digital.software;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Service;

import java.util.List;

public interface SoftwareRepository extends CrudRepository<Software, Long> {
    public List<Software> findAllByOrderByName();
}

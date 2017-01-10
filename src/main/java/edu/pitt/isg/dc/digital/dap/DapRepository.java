package edu.pitt.isg.dc.digital.dap;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface DapRepository extends CrudRepository<DataAugmentedPublication, Long> {
    List<DataAugmentedPublication> findAllByDoi(String doi);
}

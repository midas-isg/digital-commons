package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.interfaces.WorkflowsInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class WorkflowsImpl implements WorkflowsInterface {
    @Autowired
    private EntryRepository repo;

    public List<Object[]> getSpewLocationsAndAccessUrls() {
        return repo.spewLocationsAndAccessUrls();
    }
}

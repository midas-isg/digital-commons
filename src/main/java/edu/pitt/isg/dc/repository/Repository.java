package edu.pitt.isg.dc.repository;

import edu.pitt.isg.dc.repository.json.DirectoryResolver;
import edu.pitt.isg.dc.repository.json.FileResolver;

import java.util.List;

/**
 * Created by jdl50 on 5/26/17.
 */
public class Repository {
    public List<RepositoryEntry> repository;

    public Repository() {
        DirectoryResolver mdcDataRepository = new DirectoryResolver();
        FileResolver fileResolver = new FileResolver(mdcDataRepository.getDirectoryToClassMap());
        repository = fileResolver.parse();
    }

}

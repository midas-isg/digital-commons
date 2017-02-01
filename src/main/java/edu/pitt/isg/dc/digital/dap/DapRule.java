package edu.pitt.isg.dc.digital.dap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class DapRule {
    @Autowired
    private DapRepository dapRepository;
    private Iterable<DapFolder> cachedDataAugmentedPublications;

    public Iterable<DapFolder> tree() {
        if(cachedDataAugmentedPublications != null) {
            return cachedDataAugmentedPublications;
        }
        Map<Long, DapFolder> root = new HashMap<>();
        Iterable<DataAugmentedPublication> daps = dapRepository.findAll();
        for (DataAugmentedPublication dap : daps){
            if (dap.getTypeText().equals("Paper")){
                final DapFolder folder = newFolder(dap);
                if(root.get(dap.getId()) == null) {
                    root.put(dap.getId(), folder);
                } else {
                    root.get(dap.getId()).setName(folder.getName());
                    root.get(dap.getId()).setPaper(folder.getPaper());
                }
            } else {
                final DataAugmentedPublication paper = dap.getPaper();
                if(root.get(paper.getId()) != null) {
                    final DapFolder folder = root.get(paper.getId());
                    folder.setData(dap);
                } else {
                    final DapFolder folder = newFolder(dap);
                    folder.setData(dap);
                    root.put(paper.getId(), folder);
                }
            }
        }
        cachedDataAugmentedPublications = root.values();
        return root.values();
    }

    private DapFolder newFolder(DataAugmentedPublication paper) {
        final DapFolder folder = new DapFolder();
        folder.setName(paper.getName());
        folder.setPaper(paper);
        return folder;
    }

}

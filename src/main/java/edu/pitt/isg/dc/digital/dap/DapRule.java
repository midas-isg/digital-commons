package edu.pitt.isg.dc.digital.dap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class DapRule {
    @Autowired
    private DapRepository dapRepository;

    public Iterable<DapFolder> tree() {
        Map<Long, DapFolder> root = new HashMap<>();
        Iterable<DataAugmentedPublication> daps = dapRepository.findAll();
        for (DataAugmentedPublication dap : daps){
            if (dap.getTypeText().equals("Paper")){
                final DapFolder folder = newFolder(dap);
                root.put(dap.getId(), folder);
            } else {
                final DataAugmentedPublication paper = dap.getPaper();
                final DapFolder folder = root.get(paper.getId());
                folder.setData(dap);
            }
        }

        return root.values();
    }

    private DapFolder newFolder(DataAugmentedPublication paper) {
        final DapFolder folder = new DapFolder();
        folder.setName(paper.getName());
        folder.setPaper(paper);
        return folder;
    }

}

package edu.pitt.isg.dc.digital.dap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DapController {
    @Autowired
    private DapRule rule;

    @RequestMapping("api/dap-tree")
    public Iterable<DapFolder> treeDigitalObjects(){
        return rule.tree();
    }
}

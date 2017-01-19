package edu.pitt.isg.dc.digital;

import edu.pitt.isg.dc.digital.dap.DapFolder;
import edu.pitt.isg.dc.digital.dap.DapRule;
import edu.pitt.isg.dc.digital.software.SoftwareFolder;
import edu.pitt.isg.dc.digital.software.SoftwareRule;
import edu.pitt.isg.dc.digital.spew.SpewDao;
import edu.pitt.isg.dc.digital.spew.SpewRule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DigitalController {
    @Autowired
    private DapRule dapRule;
    @Autowired
    private SoftwareRule softwareRule;
    @Autowired
    private SpewRule spewRule;

    @RequestMapping("api/dap-tree")
    public Iterable<DapFolder> treeDataAugmentedPublication(){
        return dapRule.tree();
    }

    @RequestMapping("api/software-tree")
    public Iterable<SoftwareFolder> treeSoftware(){
        return softwareRule.tree();
    }

    @RequestMapping("api/spew-tree")
    public Object listCountries(){
        return spewRule.tree();
    }
}

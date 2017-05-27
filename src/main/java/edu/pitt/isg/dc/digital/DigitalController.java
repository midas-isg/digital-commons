package edu.pitt.isg.dc.digital;

import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.digital.spew.SpewRule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@ApiIgnore
@RestController
public class DigitalController {
    @Autowired
    private SpewRule spewRule;

    @RequestMapping("api/spew-tree")
    public Object listCountries(){
        return spewRule.tree();
    }

    @RequestMapping("api/spew-region-tree")
    public Object listCountriesGroupedByRegions(){
        return spewRule.treeRegions();
    }
}

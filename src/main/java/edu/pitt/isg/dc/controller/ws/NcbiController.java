package edu.pitt.isg.dc.controller.ws;

import edu.pitt.isg.dc.entry.Ncbi;
import edu.pitt.isg.dc.entry.NcbiRule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static edu.pitt.isg.dc.controller.ws.MediaType.Application.JSON;
import static edu.pitt.isg.dc.controller.ws.MediaType.Text.XML;
import static org.springframework.web.bind.annotation.RequestMethod.GET;


@RestController
public class NcbiController {
    @Autowired
    private NcbiRule rule;

    @RequestMapping(value = "/ncbis/{id}",
            method = GET,
            produces = {JSON, XML})
    public Ncbi read(@PathVariable Long id) {
        return rule.read(id);
    }

    @RequestMapping(value = "/ncbis/search/used-as-host",
            method = GET,
            produces = {JSON, XML})
    public List<Ncbi> listHostsUsedInEntries() {
        return rule.findHostsInEntries();
    }

    @RequestMapping(value = "/ncbis/search/used-as-pathogen",
            method = GET,
            produces = {JSON, XML})
    public List<Ncbi> listPathogensUsedInEntries() {
        return rule.findPathogensInEntries();
    }
}

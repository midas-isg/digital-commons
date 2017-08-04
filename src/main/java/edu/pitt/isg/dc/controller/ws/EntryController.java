package edu.pitt.isg.dc.controller.ws;

import edu.pitt.isg.dc.entry.EntryRule;
import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;

import static edu.pitt.isg.dc.controller.ws.MediaType.Application.JSON;
import static edu.pitt.isg.dc.controller.ws.MediaType.Text.XML;
import static edu.pitt.isg.dc.vm.EntryOntologyQuery.of;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

@RestController
public class EntryController {
    @Autowired
    private EntryRule rule;

    @Transactional
    @RequestMapping(value = "/entries/by-ontology",
            method = GET,
            produces = {JSON, XML})
    public Object findViaOntology(
            @RequestParam(required = false) Long controlMeasure,
            @RequestParam(required = false) Long hostIncluded,
            @RequestParam(required = false) Long locationCoverage,
            @RequestParam(required = false) Long pathogenCoverage) {

        final EntryOntologyQuery q = of(
                hostIncluded, pathogenCoverage, locationCoverage, controlMeasure
        );
        return rule.findViaOntology(q);
    }
}

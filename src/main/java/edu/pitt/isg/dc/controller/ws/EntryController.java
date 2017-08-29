package edu.pitt.isg.dc.controller.ws;

import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.EntryRule;
import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;

import static edu.pitt.isg.dc.controller.MediaType.Application.JSON;
import static edu.pitt.isg.dc.controller.MediaType.Text.XML;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

@RestController
@RequiredArgsConstructor
public class EntryController{
    private final EntryRule rule;

    @Transactional
    @RequestMapping(value = "/entries/search/by-ontology",
            method = GET,
            produces = {JSON, XML})
    public Object findViaOntology(EntryOntologyQuery q/*, Pageable pageRequest*/) {
        return rule.findViaOntology(q, null);
    }

    @RequestMapping(value = "/entries/{id}/{rev}",
            method = GET,
            produces = {JSON, XML})
    public Object read(@PathVariable long id, @PathVariable long rev) {
        return rule.read(new EntryId(id, rev));
    }

    @RequestMapping(value = "/entries/software-matched",
            method = GET,
            produces = {JSON, XML})
    public Object listSoftwareMatched() {
        return rule.listSoftwareMatched();
    }
}

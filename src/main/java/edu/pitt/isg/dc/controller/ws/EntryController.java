package edu.pitt.isg.dc.controller.ws;

import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryRule;
import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;

import static edu.pitt.isg.dc.controller.ws.MediaType.Application.JSON;
import static edu.pitt.isg.dc.controller.ws.MediaType.Text.XML;
import static edu.pitt.isg.dc.vm.EntryOntologyQuery.of;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

@RestController
@RequiredArgsConstructor
public class EntryController{
    private final EntryRule rule;
    private final PagedResourcesAssembler<Entry> pagedAssembler;

    @Transactional
    @RequestMapping(value = "/entries/search/by-ontology",
            method = GET,
            produces = {JSON, XML})
    public Object findViaOntology(
            @RequestParam(required = false) Long controlMeasure,
            @RequestParam(required = false) Long hostIncluded,
            @RequestParam(required = false) Long locationCoverage,
            @RequestParam(required = false) Long pathogenCoverage,
            Pageable pageRequest
    ) {
        final EntryOntologyQuery q = of(
                hostIncluded, pathogenCoverage, locationCoverage, controlMeasure
        );
        final Page<Entry> page = rule.findViaOntology(q, pageRequest);
        return pagedAssembler.toResource(page);
    }
}

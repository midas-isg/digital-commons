package edu.pitt.isg.dc.controller.ws;

import com.google.gson.JsonObject;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.EntryRule;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.vm.EntryComplexQuery;
import edu.pitt.isg.dc.vm.EntrySimpleQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;

import static edu.pitt.isg.dc.controller.MediaType.Application.JSON;
import static edu.pitt.isg.dc.controller.MediaType.Text.XML;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

@RestController
@RequiredArgsConstructor
public class EntryController{
    private final EntryRule rule;

    @Transactional
    @RequestMapping(value = "/entries/search/by-ontology",
            method = GET,
            produces = {JSON, XML})
    public Object findViaOntology(EntrySimpleQuery q/*, Pageable pageRequest*/) {
        return rule.findViaOntology(q, null);
    }

    @Transactional
    @RequestMapping(value = "/entries/search/via-ontology",
            method = POST,
            produces = {JSON, XML})
    public Object search(@RequestBody EntryComplexQuery q/*, Pageable pageRequest*/) {
        return rule.search(q, null);
    }

    @RequestMapping(value = "/entries/{id}/{rev}",
            method = GET,
            produces = {JSON, XML})
    public Object read(@PathVariable long id, @PathVariable long rev) {
        return rule.read(new EntryId(id, rev));
    }

    @RequestMapping(value = "/entryInfo/{id}/{rev}",
            method = POST,
            produces = {JSON, XML})
    public String getEntryInfo(@PathVariable long id, @PathVariable long rev) {
        Entry entry = rule.read(new EntryId(id, rev));
        EntryView entryView = new EntryView(entry);

        String jsonString = entryView.getUnescapedEntryJsonString();
        String type = entryView.getEntryTypeBaseName();
        String xmlString = entryView.getXmlString();

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("json", jsonString);
        jsonObject.addProperty("type", type);
        jsonObject.addProperty("xml", xmlString);

        return jsonObject.toString();
    }

    @RequestMapping(value = "/entries/software-matched",
            method = GET,
            produces = {JSON, XML})
    public Object listSoftwareMatched() {
        return rule.listSoftwareMatched();
    }
}

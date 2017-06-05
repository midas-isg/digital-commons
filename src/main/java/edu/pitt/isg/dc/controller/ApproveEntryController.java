package edu.pitt.isg.dc.controller;

import edu.pitt.isg.dc.entry.PopulateDatastore;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.H2Datastore;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jdl50 on 6/5/17.
 */
@Controller
public class ApproveEntryController {

    MdcEntryDatastoreInterface h2Datastore = new H2Datastore();

    @RequestMapping(value = "/review", method = RequestMethod.GET)
    public String review(Model model)  {
        List<EntryObject> entries = new ArrayList<>();
        for(String id : h2Datastore.getEntryIds()) {
            EntryObject entryObject = h2Datastore.getEntry(id);
            entries.add(entryObject);
        }
        model.addAttribute("entries", entries);
        return "reviewEntries";
    }

    @RequestMapping(value = "/populate", method = RequestMethod.GET)
    public ResponseEntity<String> populate(Model model)  {
        try {
        PopulateDatastore populateDatastore = new PopulateDatastore(h2Datastore);

            populateDatastore.populate();
            return ResponseEntity.ok(h2Datastore.getEntryIds().size() + " entries added.");
        } catch (MdcEntryDatastoreException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }

    }

    @RequestMapping(value = "/items", method = RequestMethod.GET)
    public ResponseEntity<String> addItems(Model model)  {
        try {
            return ResponseEntity.ok(h2Datastore.getEntryIds().size() + " total entries.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }

    }

}

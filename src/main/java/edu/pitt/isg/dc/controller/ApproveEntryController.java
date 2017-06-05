package edu.pitt.isg.dc.controller;

import edu.pitt.isg.dc.entry.impl.H2Datastore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by jdl50 on 6/5/17.
 */
@Controller
public class ApproveEntryController {

    H2Datastore h2Datastore = new H2Datastore();

    @ResponseBody
    @RequestMapping(value = "/db", method = RequestMethod.GET)
    public String addEntry(Model model) throws Exception {
               return String.valueOf(h2Datastore.getEntryIds().size());
    }

}

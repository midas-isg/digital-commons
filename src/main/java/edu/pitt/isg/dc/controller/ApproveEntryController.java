package edu.pitt.isg.dc.controller;

import com.google.gson.*;
import edu.pitt.isg.dc.entry.PopulateDatastore;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.EntryApproval;
import edu.pitt.isg.dc.entry.impl.H2Datastore;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jdl50 on 6/5/17.
 */
@Controller
public class ApproveEntryController {

    MdcEntryDatastoreInterface h2Datastore = new H2Datastore();
    EntryApprovalInterface entryApprovalInterface = new EntryApproval();

    @RequestMapping(value = "/review", method = RequestMethod.GET)
    public String review(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            List<EntryObject> entries = entryApprovalInterface.getPendingEntries();
            List<EntryObject> datasetEntries = new ArrayList<>();
            List<EntryObject> dataStandardEntries = new ArrayList<>();
            List<EntryObject> softwareEntries = new ArrayList<>();

            for(EntryObject entryObject : entries) {
                if(entryObject.getEntryType().contains("Dataset")) {
                    datasetEntries.add(entryObject);
                } else if(entryObject.getEntryType().contains("DataStandard")) {
                    dataStandardEntries.add(entryObject);
                } else {
                    softwareEntries.add(entryObject);
                }
            }

            model.addAttribute("entries", entries);
            model.addAttribute("datasetEntries", datasetEntries);
            model.addAttribute("dataStandardEntries", dataStandardEntries);
            model.addAttribute("softwareEntries", softwareEntries);
            return "reviewEntries";
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/approve", method = RequestMethod.POST)
    @ResponseBody
    public String approve(@RequestParam(value = "auth", required = false) String auth, @RequestParam(value = "id", required = true) String id, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            String status = "success";
            try {
                entryApprovalInterface.acceptEntry(id, EntryHelper.getServerAuthentication());
            } catch(MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/reject", method = RequestMethod.POST)
    @ResponseBody
    public String reject(@RequestParam(value = "auth", required = false) String auth, @RequestParam(value = "id", required = true) String id, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            String status = "success";
            try {
                entryApprovalInterface.rejectEntry(id, EntryHelper.getServerAuthentication(), "");
            } catch(MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/populate", method = RequestMethod.GET)
    public ResponseEntity<String> populate(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException  {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            try {
                PopulateDatastore populateDatastore = new PopulateDatastore(h2Datastore);

                populateDatastore.populate();
                return ResponseEntity.ok(h2Datastore.getEntryIds().size() + " entries added.");
            } catch (MdcEntryDatastoreException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }

    }

    @RequestMapping(value = "/items", method = RequestMethod.GET)
    public ResponseEntity<String> addItems(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException  {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            try {
                return ResponseEntity.ok(h2Datastore.getEntryIds().size() + " total entries.");
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/exportDatastore", method = RequestMethod.GET)
    public ResponseEntity<String> exportDatastore(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException  {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            try {
                h2Datastore.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
                EntryHelper.copyDatastore();
                return ResponseEntity.ok("Data exported successfully.");
            } catch (MdcEntryDatastoreException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/item/{itemId}", method = RequestMethod.GET)

    public ResponseEntity<String> getItem(@RequestParam(value = "auth", required = false) String auth, Model model, @PathVariable(value="itemId") int itemId) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            try {

                Gson gson = new GsonBuilder().setPrettyPrinting().create();


                return ResponseEntity.ok(gson.toJson(h2Datastore.getEntry(String.valueOf(itemId))));
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/pending", method = RequestMethod.GET)
    public ResponseEntity<String> getPending(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.ENTRIES_ADMIN_AUTHENTICATION)) {
            try {
                List<String> l = h2Datastore.getPendingEntryIds();
                String ids = "";
                for (String id : l) {
                    ids += id + "<br/>";
                }
                return ResponseEntity.ok("The following ids are pending:" + ids);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @ExceptionHandler (MdcEntryDatastoreException.class)
    public ResponseEntity<String> handleException(MdcEntryDatastoreException e) {
        if(e.getMessage().equals("Unauthorized Access Attempt"))
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        else
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
    }

}

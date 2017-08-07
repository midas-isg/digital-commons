package edu.pitt.isg.dc.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.CategoryOrderRepository;
import edu.pitt.isg.dc.entry.PopulateDatastore;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * Created by jdl50 on 6/5/17.
 */
@Controller
public class ApproveEntryController {

    @Autowired
    private MdcEntryDatastoreInterface datastore;

    @Autowired
    private EntryApprovalInterface entryApprovalInterface;

    @Autowired
    private CategoryOrderRepository categoryOrderRepository;

    @RequestMapping(value = "/review", method = RequestMethod.GET)
    public String review(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            List<EntryView> entries = entryApprovalInterface.getPendingEntries();
            List<EntryView> datasetEntries = new ArrayList<>();
            List<EntryView> dataStandardEntries = new ArrayList<>();
            List<EntryView> softwareEntries = new ArrayList<>();

            for(EntryView entryObject : entries) {
                if(entryObject.getEntryType().contains("Dataset")) {
                    datasetEntries.add(entryObject);
                } else if(entryObject.getEntryType().contains("DataStandard")) {
                    dataStandardEntries.add(entryObject);
                } else {
                    softwareEntries.add(entryObject);
                }
            }

            CategoryHelper categoryHelper = new CategoryHelper(categoryOrderRepository, entryApprovalInterface);
            Map<Long, String> categoryPaths = categoryHelper.getTreePaths();

            model.addAttribute("entries", entries);
            model.addAttribute("categoryPaths", categoryPaths);
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
    public String approve(@RequestParam(value = "auth", required = false) String auth, @RequestParam(value = "entryId", required = true) long entryId, @RequestParam(value = "categoryId", required = true) long categoryId, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.getAdminAuthentication())) {
            String status = "success";
            try {
                entryApprovalInterface.acceptEntry(entryId, categoryId, EntryHelper.getServerAuthentication());
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
    public String reject(@RequestParam(value = "auth", required = false) String auth, @RequestParam(value = "id", required = true) long id, Model model) throws MdcEntryDatastoreException {
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
                PopulateDatastore populateDatastore = new PopulateDatastore(datastore);

                populateDatastore.populate();
                return ResponseEntity.ok(datastore.getEntryIds().size() + " entries added.");
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
                return ResponseEntity.ok(datastore.getEntryIds().size() + " total entries.");
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
                datastore.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
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
    public ResponseEntity<String> getItem(Model model, @PathVariable(value="itemId") int itemId) throws MdcEntryDatastoreException {
            try {
                Gson gson = new GsonBuilder().setPrettyPrinting().create();
                return ResponseEntity.ok(gson.toJson(datastore.getEntry(itemId)));
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
    }

    @RequestMapping(value = "/pending", method = RequestMethod.GET)
    public ResponseEntity<String> getPending(@RequestParam(value = "auth", required = false) String auth, Model model) throws MdcEntryDatastoreException {
        if(auth != null && auth.equals(EntryHelper.ENTRIES_ADMIN_AUTHENTICATION)) {
            try {
                List<EntryView> entries = datastore.getPendingEntries();
                String ids = "";
                for (EntryView view : entries) {
                    ids += view.getId() + "<br/>";
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

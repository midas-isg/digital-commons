package edu.pitt.isg.dc.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import edu.pitt.isg.dc.component.DCEmailService;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.security.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static edu.pitt.isg.dc.controller.HomeController.*;
import static edu.pitt.isg.dc.controller.Interceptor.ifISGAdmin;
import static edu.pitt.isg.dc.controller.Interceptor.ifMDCEditor;

/**
 * Created by jdl50 on 6/5/17.
 */
@Controller
public class ApproveEntryController {
    @Autowired
    private ApiUtil apiUtil;

    @Autowired
    private MdcEntryDatastoreInterface datastore;

    @Autowired
    private EntryApprovalInterface entryApprovalInterface;

    @Autowired
    private CategoryHelper categoryHelper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UsersSubmissionInterface usersSubmissionInterface;

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/add/review", method = RequestMethod.GET)
    public String review(HttpSession session, Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session) || ifMDCEditor(session)) {
            List<EntryView> entries = new ArrayList<>();

            if (ifISGAdmin(session)) {
                entries = entryApprovalInterface.getUnapprovedEntries();
            }
            if (ifMDCEditor(session)) {
                Users user = userService.findUserForSubmissionByUserId(session.getAttribute("username").toString());
//                Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());
                entries = entryApprovalInterface.getUserCreatedUnapprovedEntries(user.getId());
            }
            List<EntryView> datasetEntries = new ArrayList<>();
            List<EntryView> dataStandardEntries = new ArrayList<>();
            List<EntryView> softwareEntries = new ArrayList<>();

            for (EntryView entryObject : entries) {
                if (entryObject.getEntryType().contains("Dataset")) {
                    datasetEntries.add(entryObject);
                } else if (entryObject.getEntryType().contains("DataStandard")) {
                    dataStandardEntries.add(entryObject);
                } else {
                    softwareEntries.add(entryObject);
                }
            }

            Map<Long, String> categoryPaths = categoryHelper.getTreePaths("AllEntries");

            model.addAttribute("entries", entries);
            model.addAttribute("categoryPaths", categoryPaths);
            model.addAttribute("datasetEntries", datasetEntries);
            model.addAttribute("dataStandardEntries", dataStandardEntries);
            model.addAttribute("softwareEntries", softwareEntries);
            model.addAttribute("approvedEntries", entryApprovalInterface.getApprovedEntries());
            return "reviewEntries";
        } else {
            return "accessDenied";
        }
    }

    @RequestMapping(value = "/add/approve", method = RequestMethod.POST)
    @ResponseBody
    public String approve(HttpSession session,
                          @RequestParam(value = "entryId", required = true) long id,
                          @RequestParam(value = "revisionId", required = true) long revisionId,
                          @RequestParam(value = "categoryId", required = true) long categoryId,
                          Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
            String status = "success";
            try {
                EntryId entryId = new EntryId(id, revisionId);
                entryApprovalInterface.acceptEntry(entryId, categoryId, EntryHelper.getServerAuthentication());
            } catch (MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/add/make-public", method = RequestMethod.POST)
    @ResponseBody
    public String makePublic(HttpSession session,
                             @RequestParam(value = "entryId", required = true) long id,
                             @RequestParam(value = "revisionId", required = true) long revisionId,
                             @RequestParam(value = "categoryId", required = true) long categoryId,
                             Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
            String status = "success";
            try {
                EntryId entryId = new EntryId(id, revisionId);
                entryApprovalInterface.makePublicEntry(entryId, categoryId, EntryHelper.getServerAuthentication());
            } catch (MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/add/reject", method = RequestMethod.POST)
    @ResponseBody
    public String reject(HttpSession session,
                         @RequestParam(value = "entryId", required = true) long id,
                         @RequestParam(value = "revisionId", required = true) long revisionId,
                         @RequestParam(value = "comments[]", required = false) String[] comments,
                         Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
            String status = "success";
            try {
                EntryId entryId = new EntryId(id, revisionId);
                Users user = userService.findUserForSubmissionByUserId(session.getAttribute("username").toString());
//                Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());
                entryApprovalInterface.rejectEntry(entryId, EntryHelper.getServerAuthentication(), comments, user);
            } catch (MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/add/comment", method = RequestMethod.POST)
    @ResponseBody
    public String comment(HttpSession session,
                          @RequestParam(value = "entryId", required = true) long id,
                          @RequestParam(value = "revisionId", required = true) long revisionId,
                          @RequestParam(value = "comments[]", required = false) String[] comments,
                          Model model, HttpServletRequest request) throws Exception {
        if (ifISGAdmin(session)) {
            String status = "success";
            try {
                EntryId entryId = new EntryId(id, revisionId);
                Users user = userService.findUserForSubmissionByUserId(session.getAttribute("username").toString());
//                Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());
                entryApprovalInterface.commentEntry(entryId, EntryHelper.getServerAuthentication(), comments, user);


                //E-mail to someone it concerns
                String directUrl = request.getRequestURL().toString().replace("comment", "review/comments") + "?entryId=" + entryId.getEntryId() + "&revisionId=" + entryId.getRevisionId();
                DCEmailService emailService = new DCEmailService();
                StringBuilder allComments = new StringBuilder();
                allComments.append("The following comments were added to an entry you created:");
                allComments.append("\n");
                for (String comment : comments) {
                    allComments.append(comment);
                    allComments.append('\n');
                }
                allComments.append("Please visit: " + directUrl + " to view these comments");
                Date date = new Date();

                emailService.mailToUser("[Digital Commons New Comment(s)] " + date, allComments.toString(), user.getEmail());
            } catch (MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/add/comment/delete", method = RequestMethod.POST)
    @ResponseBody
    public String deleteComment(HttpSession session, @RequestParam(value = "commentId", required = true) long commentId) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
            String status = "success";
            try {
                datastore.deleteComment(commentId);
            } catch (MdcEntryDatastoreException e) {
                status = "fail";
            }
            return status;
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }


    @RequestMapping(value = "/add/review/comments", method = RequestMethod.GET)
    public String deleteComment(HttpSession session, Model model,
                                @RequestParam(value = "entryId", required = true) Long entryId,
                                @RequestParam(value = "revisionId", required = true) Long revisionId) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session) || ifMDCEditor(session)) {
            EntryView entryView = datastore.getEntry(new EntryId(entryId, revisionId));
            List<Comments> commentsList = datastore.findComments(new EntryId(entryId, revisionId));
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("comments", commentsList);
            model.addAttribute("entryTitle", entryView.getTitle());
            model.addAttribute("entry", entryView);
            return "reviewComments";
        } else {
            return "accessDenied";
        }
    }

    @RequestMapping(value = "/add/populate", method = RequestMethod.GET)
    public ResponseEntity<String> populate(HttpSession session,
                                           Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
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

    @RequestMapping(value = "/add/items", method = RequestMethod.GET)
    public ResponseEntity<String> addItems(HttpSession session,
                                           Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
            try {
                return ResponseEntity.ok(datastore.getEntryIds().size() + " total entries.");
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
            }
        } else {
            throw new MdcEntryDatastoreException("Unauthorized Access Attempt");
        }
    }

    @RequestMapping(value = "/add/exportDatastore", method = RequestMethod.GET)
    public ResponseEntity<String> exportDatastore(HttpSession session,
                                                  Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
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

    @RequestMapping(value = "/add/item/{itemId}", method = RequestMethod.GET)
    public ResponseEntity<String> getItem(@PathVariable(value = "itemId") long itemId,
                                          @RequestParam(value = "revisionId", required = false) long revisionId,
                                          Model model) throws MdcEntryDatastoreException {
        try {
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            return ResponseEntity.ok(gson.toJson(datastore.getEntry(new EntryId(itemId, revisionId))));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    @RequestMapping(value = "/add/pending", method = RequestMethod.GET)
    public ResponseEntity<String> getPending(HttpSession session,
                                             Model model) throws MdcEntryDatastoreException {
        if (ifISGAdmin(session)) {
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

    @ExceptionHandler(MdcEntryDatastoreException.class)
    public ResponseEntity<String> handleException(MdcEntryDatastoreException e) {
        if (e.getMessage().equals("Unauthorized Access Attempt"))
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        else
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
    }

}

package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

import static edu.pitt.isg.dc.entry.Keys.STATUS;
import static edu.pitt.isg.dc.entry.Values.APPROVED;
import static edu.pitt.isg.dc.entry.Values.REJECTED;

/**
 * Created by amd176 on 6/5/17.
 */
@Component
public class EntryApproval implements EntryApprovalInterface {
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }

    @Autowired
    private MdcEntryDatastoreInterface mdcEntryDatastoreInterface;// = new Datastore();

    @Autowired
    private CategoryRepository categoryRepository;// = new Datastore();

    @Override
    public void acceptEntry(EntryId entryId, long categoryId, String authenticationToken) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryView entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            entryObject.setProperty(STATUS, APPROVED);

            Category category = categoryRepository.findOne(categoryId);
            entryObject.setCategory(category);

            mdcEntryDatastoreInterface.editEntry(entryId, entryObject);
            //TODO: Do we need? mdcEntryDatastoreInterface.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
        }
    }

    @Override
    public void makePublicEntry(EntryId entryId, long categoryId, String authenticationToken) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryView entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            entryObject.setIsPublic(true);

            Category category = categoryRepository.findOne(categoryId);
            entryObject.setCategory(category);

            mdcEntryDatastoreInterface.editEntry(entryId, entryObject);
            //TODO: Do we need? mdcEntryDatastoreInterface.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
        }
    }

    @Override
    public void rejectEntry(EntryId entryId, String authenticationToken, String[] commentsArr, Users users) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryView entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            entryObject.setProperty(STATUS, REJECTED);

            if(commentsArr != null) {
                for(String comment : commentsArr) {
                    Comments comments = parseComments(entryId, comment, users);
                    mdcEntryDatastoreInterface.updateComments(comments);
                }
            }

            mdcEntryDatastoreInterface.editEntry(entryId, entryObject);
        }
    }

    @Override
    public void commentEntry(EntryId entryId, String authenticationToken, String[] commentsArr, Users users) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryView entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            Set<String> commentSet =  new HashSet<String>(Arrays.asList(commentsArr));
            if(entryObject != null) {
                for(String comment : commentSet) {
                    Comments comments = parseComments(entryId, comment, users);
                    //ensure the comment doesnt already exist
                    if(mdcEntryDatastoreInterface.getCommentId(entryId.getEntryId(), entryId.getRevisionId(), comment) == null) {
                        mdcEntryDatastoreInterface.updateComments(comments);
                    }
                }
            }
        }
    }

    private Comments parseComments(EntryId entryId, String comment, Users user_id) {
        Comments comments = new Comments();
        comments.setEntryId(entryId);
        comments.setContent(comment);
        comments.setUsers(user_id);
        return comments;
    }

    @Override
    public List<EntryView> getPendingEntries() throws MdcEntryDatastoreException {
        return mdcEntryDatastoreInterface.getPendingEntries();
    }

    @Override
    public List<EntryView> getApprovedEntries() throws MdcEntryDatastoreException {
        List<EntryView> entries = mdcEntryDatastoreInterface.getLatestApprovedNotPublicEntries();
        for(EntryView entryView : entries) {
            entryView.setComments( mdcEntryDatastoreInterface.findComments(entryView.getId()));
        }
        return entries;
    }

    @Override
    public List<EntryView> getPublicEntries() throws MdcEntryDatastoreException {
        List<EntryId> entryIds = mdcEntryDatastoreInterface.getEntryIds();
        List<EntryView> entries = new ArrayList<>();
        for(EntryId entryId : entryIds) {
            EntryView entryView = mdcEntryDatastoreInterface.getEntry(entryId);
            boolean isPublic = entryView.getIsPublic();
            if(isPublic) {
                entries.add(entryView);
            }
        }
        return entries;
    }

    @Override
    public List<EntryView> getUnapprovedEntries() throws MdcEntryDatastoreException {
        List<EntryView> entries = mdcEntryDatastoreInterface.getLatestUnapprovedEntries();
        for (EntryView entryView : entries) {
            entryView.setComments( mdcEntryDatastoreInterface.findComments(entryView.getId()));
        }
        return entries;
    }

    @Override
    public List<EntryView> getUserCreatedUnapprovedEntries(Long userId) throws MdcEntryDatastoreException {
        List<EntryView> entries = mdcEntryDatastoreInterface.getUserLatestUnapprovedEntries(userId);
        for (EntryView entryView : entries) {
            entryView.setComments( mdcEntryDatastoreInterface.findComments(entryView.getId()));
        }
        return entries;
    }
}

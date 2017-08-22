package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.CategoryRepository;
import edu.pitt.isg.dc.entry.Comments;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

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
    public void rejectEntry(EntryId entryId, String authenticationToken, String[] commentsArr) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryView entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            entryObject.setProperty(STATUS, REJECTED);

            if(commentsArr != null) {
                Comments comments = parseComments(entryId, commentsArr);
                mdcEntryDatastoreInterface.updateComments(comments);
            }

            mdcEntryDatastoreInterface.editEntry(entryId, entryObject);
        }
    }

    @Override
    public void commentEntry(EntryId entryId, String authenticationToken, String[] commentsArr) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryView entryObject = mdcEntryDatastoreInterface.getEntry(entryId);

            if(entryObject != null) {
                Comments comments = parseComments(entryId, commentsArr);
                mdcEntryDatastoreInterface.updateComments(comments);
            }
        }
    }

    private Comments parseComments(EntryId entryId, String[] commentsArr) {
        List<String> commentsContent = null;
        if(commentsArr != null) {
            commentsContent = Arrays.asList(commentsArr);
        }
        Comments comments = new Comments();
        comments.setId(entryId);
        comments.setContent(commentsContent);
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
            Comments comments = mdcEntryDatastoreInterface.getComments(entryView.getId());
            if(comments != null && comments.getContent() != null) {
                entryView.setComments(new ArrayList<>(comments.getContent()));
            }
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
        for(EntryView entryView : entries) {
            Comments comments = mdcEntryDatastoreInterface.getComments(entryView.getId());
            if(comments != null && comments.getContent() != null) {
                entryView.setComments(new ArrayList<>(comments.getContent()));
            }
        }
        return entries;
    }
}

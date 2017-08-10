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

import java.util.*;

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
            entryObject.setProperty("status", "approved");

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
            entryObject.setProperty("status", "rejected");

            if(commentsArr != null && commentsArr.length > 0) {
                Set<String> commentsContent = new HashSet(Arrays.asList(commentsArr));
                Comments comments = new Comments();
                comments.setId(entryId);
                comments.setContent(commentsContent);
                mdcEntryDatastoreInterface.updateComments(comments);
            }

            mdcEntryDatastoreInterface.editEntry(entryId, entryObject);
        }
    }

    @Override
    public List<EntryView> getPendingEntries() throws MdcEntryDatastoreException {
        return mdcEntryDatastoreInterface.getPendingEntries();
    }

    @Override
    public List<EntryView> getApprovedEntries() throws MdcEntryDatastoreException {
        List<EntryId> entryIds = mdcEntryDatastoreInterface.getEntryIds();
        List<EntryView> entries = new ArrayList<>();
        for(EntryId entryId : entryIds) {
            EntryView entryView = mdcEntryDatastoreInterface.getEntry(entryId);
            String status = entryView.getProperty("status");
            if(status.equals("approved")) {
                entries.add(entryView);
            }
        }
        return entries;
    }
}

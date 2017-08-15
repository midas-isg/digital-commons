package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Properties;

/**
 * Created by amd176 on 6/5/17.
 */
@Component
public class EntrySubmission implements EntrySubmissionInterface {
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }

    @Autowired
    private MdcEntryDatastoreInterface mdcEntryDatastoreInterface;

    @Override
    public String submitEntry(EntryView entryObject, Long entryId, Long revisionId, Long categoryValue, String authenticationToken) throws MdcEntryDatastoreException {
        String returnValue = null;
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            Category category = new Category();
            category.setId(categoryValue);

            entryObject.setProperty("status", "pending");

            if(category != null) {
                entryObject.setCategory(category);
            }

            if(entryId != null && revisionId != null) {
                returnValue = mdcEntryDatastoreInterface.addEntryRevision(entryId, revisionId, entryObject);
            } else {
                returnValue = mdcEntryDatastoreInterface.addEntry(entryObject);
            }
        }
        return returnValue;
    }
}

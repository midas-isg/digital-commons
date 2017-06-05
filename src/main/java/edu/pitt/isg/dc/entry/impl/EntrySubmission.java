package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;

import java.util.Properties;

/**
 * Created by amd176 on 6/5/17.
 */
public class EntrySubmission implements EntrySubmissionInterface {
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }

    private MdcEntryDatastoreInterface mdcEntryDatastoreInterface = new H2Datastore();

    @Override
    public String submitEntry(EntryObject entryObject, String emailAddress, String authenticationToken) throws MdcEntryDatastoreException {
        String returnValue = null;
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            entryObject.setProperty("status", "pending");
            entryObject.setProperty("email", "emailAddress");
            returnValue = mdcEntryDatastoreInterface.addEntry(entryObject);
        }
        return returnValue;
    }
}

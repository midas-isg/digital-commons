package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.vm.EntryView;
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
    public String submitEntry(EntryView entryObject, String emailAddress, String authenticationToken) throws MdcEntryDatastoreException {
        String returnValue = null;
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            entryObject.setProperty("status", "pending");
            entryObject.setProperty("email", emailAddress);
            returnValue = mdcEntryDatastoreInterface.addEntry(entryObject);
        }
        return returnValue;
    }
}

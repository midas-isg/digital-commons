package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * Created by amd176 on 6/5/17.
 */
public class EntryApproval implements EntryApprovalInterface {
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }

    private MdcEntryDatastoreInterface mdcEntryDatastoreInterface = new H2Datastore();

    @Override
    public void acceptEntry(String entryId, String authenticationToken) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryObject entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            entryObject.setProperty("status", "approved");
            try {
                mdcEntryDatastoreInterface.editEntry(entryId, entryObject);
                mdcEntryDatastoreInterface.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
            } catch (MdcEntryDatastoreException e) {
                throw new MdcEntryDatastoreException(e);
            }
        }
    }

    @Override
    public void rejectEntry(String entryId, String authenticationToken, String reason) throws MdcEntryDatastoreException {
        if(authenticationToken.equals(ENTRIES_AUTHENTICATION)) {
            EntryObject entryObject = mdcEntryDatastoreInterface.getEntry(entryId);
            entryObject.setProperty("status", "approved");
            try {
                mdcEntryDatastoreInterface.deleteEntry(entryId);
            } catch (MdcEntryDatastoreException e) {
                throw new MdcEntryDatastoreException(e);
            }
        }
    }

    @Override
    public List<EntryObject> getPendingEntries() throws MdcEntryDatastoreException {
        List<String> pendingEntryIds = mdcEntryDatastoreInterface.getPendingEntryIds();

        List<EntryObject> pendingEntries = new ArrayList<>();
        for(String id : pendingEntryIds) {
            EntryObject entryObject = mdcEntryDatastoreInterface.getEntry(id);
            pendingEntries.add(entryObject);
        }
        return pendingEntries;
    }
}

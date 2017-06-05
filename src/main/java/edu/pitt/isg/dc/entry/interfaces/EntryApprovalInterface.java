package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

import java.util.List;

public interface EntryApprovalInterface {
    void acceptEntry(String entryId,
                     String authenticationToken) throws MdcEntryDatastoreException;

    void rejectEntry(String entryId,
                     String authenticationToken,
                     String reason) throws MdcEntryDatastoreException;

    List<EntryObject> getPendingEntries() throws MdcEntryDatastoreException;
}
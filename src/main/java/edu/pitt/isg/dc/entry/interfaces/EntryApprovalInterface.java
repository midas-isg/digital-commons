package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.vm.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

import java.util.List;

public interface EntryApprovalInterface {
    void acceptEntry(long entryId,
                     String authenticationToken) throws MdcEntryDatastoreException;

    void rejectEntry(long entryId,
                     String authenticationToken,
                     String reason) throws MdcEntryDatastoreException;

    List<EntryView> getPendingEntries() throws MdcEntryDatastoreException;
}
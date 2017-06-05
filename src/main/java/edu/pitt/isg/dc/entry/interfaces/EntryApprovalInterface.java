package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;

import java.util.List;

public interface EntryApprovalInterface {
    void acceptEntry(String entryId,
                     String authenticationToken);

    void rejectEntry(String entryId,
                     String authenticationToken,
                     String reason);

    List<EntryObject> getPendingEntries();
}
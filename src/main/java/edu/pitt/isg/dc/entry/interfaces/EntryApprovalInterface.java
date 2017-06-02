package edu.pitt.isg.dc.entry.interfaces;

public interface EntryApprovalInterface {
    void acceptEntry(String entryId,
                     String authenticationToken);

    void rejectEntry(String entryId,
                     String authenticationToken,
                     String reason);
}
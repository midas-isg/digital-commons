package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

import java.util.List;

public interface EntryApprovalInterface {
    void acceptEntry(EntryId entryId,
                     long categoryId,
                     String authenticationToken) throws MdcEntryDatastoreException;

    void makePublicEntry(EntryId entryId,
                         long categoryId,
                         String authenticationToken) throws MdcEntryDatastoreException;

    void rejectEntry(EntryId entryId,
                     String authenticationToken,
                     String[] commentsArr, Users users) throws MdcEntryDatastoreException;

    void commentEntry(EntryId entryId,
                      String authenticationToken,
                      String[] commentsArr,
                      Users users) throws MdcEntryDatastoreException;

    List<EntryView> getPendingEntries() throws MdcEntryDatastoreException;

    List<EntryView> getApprovedEntries() throws MdcEntryDatastoreException;

    List<EntryView> getUnapprovedEntries() throws MdcEntryDatastoreException;

    List<EntryView> getUserCreatedUnapprovedEntries(Long userId) throws MdcEntryDatastoreException;

    List<EntryView> getPublicEntries() throws MdcEntryDatastoreException;
}
package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.Comments;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;

import java.util.List;

public interface MdcEntryDatastoreInterface {
    String addEntry(EntryView entryObject) throws MdcEntryDatastoreException;

    String addEntryRevision(Long id, Long revisionId, EntryView entryObject) throws MdcEntryDatastoreException;

    EntryView getEntry(EntryId id) throws MdcEntryDatastoreException;

    List<EntryView> getPendingEntries() throws MdcEntryDatastoreException;

    List<EntryId> getEntryIds() throws MdcEntryDatastoreException;

    String editEntry(EntryId id,
                     EntryView entryObject) throws MdcEntryDatastoreException;

    String deleteEntry(EntryId id) throws MdcEntryDatastoreException;

    List<EntryView> getLatestUnapprovedEntries() throws MdcEntryDatastoreException;

    List<EntryView> getUserLatestUnapprovedEntries(Long userId) throws MdcEntryDatastoreException;

    List<EntryView> getLatestApprovedNotPublicEntries() throws MdcEntryDatastoreException;

    List<EntryView> getPublicEntries() throws MdcEntryDatastoreException;

    void exportDatastore(MdcDatastoreFormat mdcDatastoreFormat) throws MdcEntryDatastoreException;

    Comments getComments(Long id) throws MdcEntryDatastoreException;

    String deleteComment(Long commentId) throws MdcEntryDatastoreException;

    List<Comments> findComments(EntryId entryId) throws MdcEntryDatastoreException;

    Long getCommentId(Long entryId, Long revisionId, String content) throws MdcEntryDatastoreException;

    String updateComments(Comments comments) throws MdcEntryDatastoreException;

    Users addUser(String userId, String email, String name) throws MdcEntryDatastoreException;
}
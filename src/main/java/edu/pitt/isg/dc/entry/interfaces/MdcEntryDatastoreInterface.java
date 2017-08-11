package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.Comments;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.vm.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;

import java.util.List;

public interface MdcEntryDatastoreInterface {
    String addEntry(EntryView entryObject) throws MdcEntryDatastoreException;

    EntryView getEntry(long id) throws MdcEntryDatastoreException;

    List<EntryView> getPendingEntries() throws MdcEntryDatastoreException;

    List<Long> getEntryIds() throws MdcEntryDatastoreException;

    String editEntry(long id,
                     EntryView entryObject) throws MdcEntryDatastoreException;

    String deleteEntry(long id) throws MdcEntryDatastoreException;


    void exportDatastore(MdcDatastoreFormat mdcDatastoreFormat) throws MdcEntryDatastoreException;

    Comments getComments(EntryId id);

    String updateComments(Comments comments) throws MdcEntryDatastoreException;
}
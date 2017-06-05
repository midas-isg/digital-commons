package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;

import java.util.List;

public interface MdcEntryDatastoreInterface {
    String addEntry(EntryObject entryObject) throws MdcEntryDatastoreException;

    EntryObject getEntry(String id);

    List<String> getEntryIds();

    String editEntry(String id,
                     EntryObject entryObject) throws MdcEntryDatastoreException;

    String deleteEntry(String id) throws MdcEntryDatastoreException;


    void exportDatastore(MdcDatastoreFormat mdcDatastoreFormat) throws MdcEntryDatastoreException;
}
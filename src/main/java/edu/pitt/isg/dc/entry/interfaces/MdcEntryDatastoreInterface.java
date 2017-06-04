package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;

import java.util.List;

public interface MdcEntryDatastoreInterface {
    String addEntry(EntryObject entryObject) throws Exception;

    Object getEntry(String id);

    List<String> getEntryIds();

    String editEntry(String id,
                     EntryObject entryObject) throws Exception;

    String deleteEntry(String id) throws Exception;

    boolean setEntryProperty(String id,
                             String key,
                             String value);

    String getEntryProperty(String id,
                            String key);
}
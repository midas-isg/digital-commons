package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;

import java.util.List;

public interface MdcEntryDatastoreInterface {
    String addEntry(EntryObject entryObject);

    Object getEntry(String id);

    List<String> getEntryIds();

    String editEntry(String id,
                     EntryObject entryObject) throws Exception;

    boolean deleteEntry(String id);

    boolean setEntryProperty(String id,
                             String key,
                             String value);

    String getEntryProperty(String id,
                            String key);
}
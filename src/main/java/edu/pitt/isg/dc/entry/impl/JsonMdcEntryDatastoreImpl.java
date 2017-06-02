package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;

import java.util.List;

public class JsonMdcEntryDatastoreImpl implements MdcEntryDatastoreInterface {
    @Override
    public String addEntry(EntryObject entryObject, String emailAddress) {
        return null;
    }

    @Override
    public Object getEntry(String id) {
        return null;
    }

    @Override
    public List<Integer> getEntryIds() {
        return null;
    }

    @Override
    public String editEntry(String id, EntryObject entryObject) {
        return null;
    }

    @Override
    public boolean deleteEntry(String id) {
        return false;
    }

    @Override
    public boolean setEntryProperty(String id, String key, String value) {
        return false;
    }

    @Override
    public String getEntryProperty(String id, String key) {
        return null;
    }
}

package edu.pitt.isg.dc.entry.impl;

/**
 * Created by jdl50 on 6/5/17.
 */

import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryHelper;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.vm.EntryView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;

import static edu.pitt.isg.dc.entry.Values.PENDING;

@Component
public class Datastore implements MdcEntryDatastoreInterface {
    @Autowired
    private EntryRepository repo;

    @Override
    @Transactional
    public String addEntry(EntryView entryObject) throws MdcEntryDatastoreException {
        try {
            final Entry entry = EntryView.toEntry(null, entryObject);
            repo.save(entry);
            return entry.getId().toString();
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e);
        }
    }

    @Override
    @Transactional
    public String editEntry(long id, EntryView entryObject) throws MdcEntryDatastoreException {
        try {
            final Entry entry = EntryView.toEntry(id, entryObject);
            repo.save(entry);
            return entry.getId().toString();
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e);
        }
    }

    @Override
    @Transactional
    public EntryView getEntry(long id) {
        final Entry one = repo.findOne(id);
        return new EntryView(one);
    }

    @Override
    @Transactional
    public List<EntryView> getPendingEntries() throws MdcEntryDatastoreException {
        List<EntryView> list = new ArrayList<>();
        for (Entry entry: repo.findAllByStatus(PENDING, null)) {
            list.add(new EntryView(entry));
        }
        return list;
    }

    @Override
    public List<Long> getEntryIds() {
        List<Long> list = new ArrayList<>();
        for (Entry entry: repo.findAll()) {
            list.add(entry.getId());
        }
        return list;
    }



    @Override
    @Transactional
    public String deleteEntry(long id) throws MdcEntryDatastoreException {
        try {
            repo.delete(id);
            return String.valueOf(id);
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e.getMessage());
        }
    }

    @Override
    public synchronized void exportDatastore(MdcDatastoreFormat mdcDatastoreFormat) throws MdcEntryDatastoreException {
        switch (mdcDatastoreFormat) {
            case MDC_DATA_DIRECTORY_FORMAT:
                EntryHelper.exportDatastore(this);
                break;
            default:
                throw new MdcEntryDatastoreException("Unsupported mdcDatastoreFormat" + mdcDatastoreFormat);
        }
    }
}
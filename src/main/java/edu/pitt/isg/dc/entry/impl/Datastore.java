package edu.pitt.isg.dc.entry.impl;

/**
 * Created by jdl50 on 6/5/17.
 */

import edu.pitt.isg.dc.entry.Comments;
import edu.pitt.isg.dc.entry.CommentsRepository;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.EntryIdManager;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;

@Component
public class Datastore implements MdcEntryDatastoreInterface {
    @Autowired
    private EntryRepository repo;

    @Autowired
    private CommentsRepository commentsRepo;

    @Autowired
    private EntryIdManager entryIdManager;

    @Override
    @Transactional
    public String addEntry(EntryView entryObject) throws MdcEntryDatastoreException {
        try {
            final Entry entry = EntryView.toEntry(entryIdManager.getNewEntryId(), entryObject);
            repo.save(entry);
            return entry.getId().toString();
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e);
        }
    }

    @Override
    @Transactional
    public String addEntryRevision(Long id, Long revisionId, EntryView entryObject) throws MdcEntryDatastoreException {
        try {
            EntryId entryId = new EntryId(id, revisionId);
            EntryView previousEntry = this.getEntry(entryId);
            String status = previousEntry.getProperty("status");

            Entry entry = EntryView.toEntry(entryIdManager.getLatestRevisionEntryId(id), entryObject);

            if(status.equals("rejected") || status.equals("revised") || status.equals("pending")) {
                entry.setStatus("revised");
            } else {
                entry.setStatus("pending");
            }

            repo.save(entry);
            return entry.getId().toString();
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e);
        }
    }

    @Override
    @Transactional
    public String editEntry(EntryId id, EntryView entryObject) throws MdcEntryDatastoreException {
        try {
            final Entry entry = EntryView.toEntry(id, entryObject);

            // find out if there are other public entries with the same entry id
            if(entry.getIsPublic()) {
                for(Entry publicEntry : repo.findDistinctPublicEntries(id.getEntryId(), id.getRevisionId())) {
                    publicEntry.setIsPublic(false);
                    repo.save(publicEntry);
                }
            }

            repo.save(entry);
            return entry.getId().toString();
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e);
        }
    }

    @Override
    @Transactional
    public EntryView getEntry(EntryId id) {
        final Entry one = repo.findOne(id);
        return new EntryView(one);
    }

    @Override
    @Transactional
    public List<EntryView> getPendingEntries() throws MdcEntryDatastoreException {
        List<EntryView> list = new ArrayList<>();
        for (Entry entry: repo.findAllByStatus("pending")) {
            list.add(new EntryView(entry));
        }
        return list;
    }

    @Override
    @Transactional
    public List<EntryView> getLatestUnapprovedEntries() throws MdcEntryDatastoreException {
        List<EntryView> list = new ArrayList<>();
        for (Entry entry: repo.findLatestUnapprovedEntries()) {
            list.add(new EntryView(entry));
        }
        return list;
    }

    @Override
    @Transactional
    public List<EntryView> getLatestApprovedNotPublicEntries() throws MdcEntryDatastoreException {
        List<EntryView> list = new ArrayList<>();
        for (Entry entry: repo.findLatestApprovedNotPublicEntries()) {
            list.add(new EntryView(entry));
        }
        return list;
    }

    @Override
    public List<EntryId> getEntryIds() {
        List<EntryId> list = new ArrayList<>();
        for (Entry entry: repo.findAll()) {
            list.add(entry.getId());
        }
        return list;
    }



    @Override
    @Transactional
    public String deleteEntry(EntryId id) throws MdcEntryDatastoreException {
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

    @Override
    @Transactional
    public Comments getComments(EntryId id) {
        return commentsRepo.findOne(id);
    }

    @Override
    @Transactional
    public String updateComments(Comments comments) throws MdcEntryDatastoreException {
        try {
            commentsRepo.save(comments);
            return comments.getId().toString();
        } catch (Exception e) {
            throw new MdcEntryDatastoreException(e);
        }
    }
}
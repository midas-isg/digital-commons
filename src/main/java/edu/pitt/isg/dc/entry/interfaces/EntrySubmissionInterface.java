package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

public interface EntrySubmissionInterface {
    String submitEntry(EntryView entryObject,
                       String emailAddress,
                       String authenticationToken) throws MdcEntryDatastoreException;
}
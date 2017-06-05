package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

public interface EntrySubmissionInterface {
    String submitEntry(EntryObject entryObject,
                       String emailAddress,
                       String authenticationToken) throws MdcEntryDatastoreException;
}
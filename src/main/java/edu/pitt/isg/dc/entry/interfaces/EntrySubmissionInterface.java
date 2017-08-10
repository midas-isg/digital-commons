package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.vm.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

public interface EntrySubmissionInterface {
    String submitEntry(EntryView entryObject,
                       String emailAddress,
                       String authenticationToken) throws MdcEntryDatastoreException;
}
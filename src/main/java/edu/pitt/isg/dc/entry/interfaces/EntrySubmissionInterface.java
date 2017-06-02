package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.classes.EntryObject;

public interface EntrySubmissionInterface {
    String submitEntry(EntryObject entryObject,
                       String emailAddress);
}
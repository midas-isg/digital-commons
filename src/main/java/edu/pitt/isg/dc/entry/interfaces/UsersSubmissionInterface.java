package edu.pitt.isg.dc.entry.interfaces;

import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;

public interface UsersSubmissionInterface {
    Users submitUser(String usersId, String email, String name) throws MdcEntryDatastoreException;
}

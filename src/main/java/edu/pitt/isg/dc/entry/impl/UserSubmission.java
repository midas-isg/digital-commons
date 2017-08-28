package edu.pitt.isg.dc.entry.impl;

import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UserSubmission implements UsersSubmissionInterface {

    @Autowired
    private MdcEntryDatastoreInterface mdcEntryDatastoreInterface;


    @Override
    public Users submitUser(String userId, String email, String name) throws MdcEntryDatastoreException {
        Users returnValue = null;
        if(userId != null && !userId.equals("")) {
            returnValue = mdcEntryDatastoreInterface.addUser(userId, email, name);
        }
        return returnValue;
    }
}

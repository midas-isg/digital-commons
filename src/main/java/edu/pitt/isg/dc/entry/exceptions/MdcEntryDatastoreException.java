package edu.pitt.isg.dc.entry.exceptions;

public class MdcEntryDatastoreException extends Exception {
    public MdcEntryDatastoreException() {}

    public MdcEntryDatastoreException(String msg) {
        super(msg);
    }

    public MdcEntryDatastoreException(Throwable cause) {
        super(cause);
    }

    public MdcEntryDatastoreException(String msg, Throwable cause) {
        super(msg, cause);
    }
}

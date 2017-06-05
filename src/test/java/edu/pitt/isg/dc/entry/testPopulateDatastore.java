package edu.pitt.isg.dc.entry;


import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.springframework.test.util.ReflectionTestUtils;
import edu.pitt.isg.JsonConverter;
import edu.pitt.isg.dc.config.H2Configuration;
import edu.pitt.isg.dc.entry.impl.H2Datastore;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.apache.commons.io.FileUtils;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import org.junit.Test;
import org.springframework.test.util.ReflectionTestUtils;

/**
 * Created by jdl50 on 5/23/17.
 */

public class testPopulateDatastore {

    static H2Datastore h2Datastore;

    @BeforeClass
    public static void setup() {
        H2Configuration h2Configuration = new H2Configuration();
        ReflectionTestUtils.setField(h2Configuration, "DB_DRIVER", "org.h2.Driver");
        ReflectionTestUtils.setField(h2Configuration, "DB_CONNECTION", "jdbc:h2:./mdcDB");
        h2Datastore = new H2Datastore(true);
        ReflectionTestUtils.setField(h2Datastore, "h2Configuration", h2Configuration);

    }


    @Test
    public void testPopulateDatastore() throws MdcEntryDatastoreException {

        PopulateDatastore populateDatastore = new PopulateDatastore(h2Datastore);
    }

    @AfterClass
    public static void testDump() throws MdcEntryDatastoreException {
        h2Datastore.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
    }

}

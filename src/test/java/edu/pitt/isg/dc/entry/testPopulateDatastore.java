package edu.pitt.isg.dc.entry;


import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

/**
 * Created by jdl50 on 5/23/17.
 */

public class testPopulateDatastore {

    //static Datastore h2Datastore;

    @BeforeClass
    public static void setup() {
        /*H2Configuration h2Configuration = null;
        try {
            h2Configuration = new H2Configuration();

        ReflectionTestUtils.setField(h2Configuration, "DB_DRIVER", "org.h2.Driver");
        ReflectionTestUtils.setField(h2Configuration, "DB_CONNECTION", "jdbc:h2:./mdcDB");
        h2Datastore = new Datastore();
        ReflectionTestUtils.setField(h2Datastore, "h2Configuration", h2Configuration);
        } catch (IOException e) {
            e.printStackTrace();
        }*/
    }


    @Ignore("Not use H2 any more. Test will be fixed later.") @Test
    public void testPopulateDatastore() throws MdcEntryDatastoreException {
        //PopulateDatastore populateDatastore = new PopulateDatastore(h2Datastore);
    }

    @AfterClass
    public static void testDump() throws MdcEntryDatastoreException {
        //h2Datastore.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
    }

}

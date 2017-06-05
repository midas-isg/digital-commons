package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.H2Datastore;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Properties;

public class PopulateDatastore {
    private static String ENTRIES_FILEPATH = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_FILEPATH = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_FILEPATH);
    }

    private final MdcEntryDatastoreInterface mdcEntryDatastoreInterface;

    public PopulateDatastore(MdcEntryDatastoreInterface mdcEntryDatastoreInterface) throws MdcEntryDatastoreException {
            this.mdcEntryDatastoreInterface = mdcEntryDatastoreInterface;
        }

    public void populate() throws MdcEntryDatastoreException {
        MdcEntryDatastoreInterface datastore = new H2Datastore();

        String[] extensions = new String[] { "json" };
        List<File> files = (List<File>) FileUtils.listFiles(Paths.get(ENTRIES_FILEPATH).toFile(), extensions, true);

        JsonParser parser = new JsonParser();
        for(File file : files) {
            String jsonEntryString = null;
            try {
                jsonEntryString = FileUtils.readFileToString(file, "UTF-8");
            } catch (IOException e) {
                throw new MdcEntryDatastoreException(e);
            }
            JsonObject jsonEntryObject = parser.parse(jsonEntryString).getAsJsonObject();

            EntryObject entryObject = new EntryObject();
            entryObject.setId(file.getPath());
            entryObject.setEntry(jsonEntryObject);
            mdcEntryDatastoreInterface.addEntry(entryObject);

        }
    }
}

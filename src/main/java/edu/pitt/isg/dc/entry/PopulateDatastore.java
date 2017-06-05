package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.impl.H2Datastore;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

public class PopulateDatastore {
    private final String entriesFilepath = "../mdc-data";
    private final MdcEntryDatastoreInterface mdcEntryDatastoreInterface;

    public PopulateDatastore(MdcEntryDatastoreInterface mdcEntryDatastoreInterface) throws Exception {
        this.mdcEntryDatastoreInterface = mdcEntryDatastoreInterface;
        this.populate();
    }

    public void populate() throws Exception {
        String[] extensions = new String[] { "json" };

        JsonParser parser = new JsonParser();
        List<File> files = (List<File>) FileUtils.listFiles(Paths.get(entriesFilepath).toFile(), extensions, true);
        for(File file : files) {
            String jsonEntryString = FileUtils.readFileToString(file, "UTF-8");
            JsonObject jsonEntryObject = parser.parse(jsonEntryString).getAsJsonObject();

            EntryObject entryObject = new EntryObject();
            entryObject.setEntry(jsonEntryObject);
            mdcEntryDatastoreInterface.addEntry(entryObject);
        }
    }




}

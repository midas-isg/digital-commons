package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import static edu.pitt.isg.dc.entry.Keys.STATUS;
import static edu.pitt.isg.dc.entry.Keys.SUBTYPE;
import static edu.pitt.isg.dc.entry.Keys.TYPE;
import static edu.pitt.isg.dc.entry.Values.APPROVED;
import static edu.pitt.isg.dc.entry.Values.PENDING;

public class PopulateDatastore {
    private static String ENTRIES_FILEPATH = EntryHelper.getEntriesFilepath();

    private final MdcEntryDatastoreInterface mdcEntryDatastoreInterface;

    public PopulateDatastore(MdcEntryDatastoreInterface mdcEntryDatastoreInterface) throws MdcEntryDatastoreException {
            this.mdcEntryDatastoreInterface = mdcEntryDatastoreInterface;
        }

    public void populate() throws MdcEntryDatastoreException {
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

            EntryView entryObject = new EntryView();
            entryObject.setEntry(jsonEntryObject);

            if(file.getPath().contains(PENDING))
                entryObject.setProperty(STATUS, PENDING);
            else {
                entryObject.setProperty(STATUS, APPROVED);
                entryObject.setIsPublic(true);
            }

            String type = EntryHelper.getTypeFromPath(file.getPath());
            entryObject.setProperty(TYPE, type);

            String subtype = EntryHelper.getSubtypeFromPath(file.getPath());
            if (subtype != null)
                entryObject.setProperty(SUBTYPE, subtype);

            mdcEntryDatastoreInterface.addEntry(entryObject);
        }
    }
}

package edu.pitt.isg.dc.entry.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Properties;

/**
 * Created by amd176 on 6/6/17.
 */
public class EntryHelper {
    private static String ENTRIES_FILEPATH = "";
    private static String TEMP_FILEPATH = "";
    public static String ENTRIES_ADMIN_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_FILEPATH = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_FILEPATH);
        TEMP_FILEPATH = configurationProperties.getProperty(DigitalCommonsProperties.TEMP_FILEPATH);
        ENTRIES_ADMIN_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_ADMIN_AUTHENTICATION);
    }

    private static final Object dumpLock = new Object();
    private static final Object copyLock = new Object();

    public static String getTypeFromPath(String path) {
        if (path != null && path.length() > 0) {
            String[] splitPath = path.split("/");

            String type = "";
            String previousPart = "";
            for (String pathPart : splitPath) {
                // grab data type folder after version folder
                if (previousPart.matches(".*\\d+_\\d+$")) {
                    String typePath = "";
                    if (previousPart.equals("2_2")) {
                        typePath = "edu.pitt.isg.mdc.dats2_2.";
                    } else if (previousPart.equals("v1_0")) {
                        typePath = "edu.pitt.isg.mdc.v1_0.";
                    }
                    type = typePath + pathPart;
                    break;
                }
                previousPart = pathPart;
            }
            return type;
        } else {
            return null;
        }
    }

    public static String getPathFromType(String type, String subtype, boolean isPending) {
        String path = ENTRIES_FILEPATH;

        if(type.contains("edu.pitt.isg.mdc.dats2_2")) {
            path += "/json/DATS/2_2/";
        } else if(type.contains("edu.pitt.isg.mdc.v1_0")) {
            path += "/json/mdc/isg/pitt/edu/v1_0/";
        }

        String[] splitType = type.split("\\.");
        String typePart = splitType[splitType.length - 1];
        path += typePart;

        if(subtype != null)
            path += "/" + subtype;


        if(isPending)
            path += "/pending";


        return path;
    }

    public static String getSubtypeFromPath(String path) {
        String subtype = null;

        String[] typesWithSubtypes = new String[] {"Dataset"};
        String typeWithSubtype = null;
        for(String type : typesWithSubtypes) {
            if(path.contains(type)) {
                typeWithSubtype = type;
                break;
            }
        }


        if(typeWithSubtype != null) {
            subtype = path.substring(path.indexOf(typeWithSubtype) + typeWithSubtype.length() + 1, path.lastIndexOf('/'));
        }

        return subtype;
    }

    public static String convertEnglishSubtype(String subtype) {
        return "";
    }

    public static String getEntriesFilepath() {
        return ENTRIES_FILEPATH;
    }

    public static String getTempFilepath() {
        return TEMP_FILEPATH;
    }

    public static String getAdminAuthentication() {
        return ENTRIES_ADMIN_AUTHENTICATION;
    }

    public static void exportDatastore(MdcEntryDatastoreInterface mdcEntryDatastoreInterface) throws MdcEntryDatastoreException {
        synchronized (dumpLock) {
            File jsonFileDirectory = Paths.get(EntryHelper.getEntriesFilepath(), "json").toFile();
            try {
                FileUtils.deleteDirectory(jsonFileDirectory);
            } catch (IOException e) {
                throw new MdcEntryDatastoreException(e);
            }

            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            List<String> ids = mdcEntryDatastoreInterface.getEntryIds();
            for (String id : ids) {
                EntryObject entryObject = mdcEntryDatastoreInterface.getEntry(id);
                JsonElement jsonElement = gson.toJsonTree(entryObject.getEntry());
                String json = gson.toJson(jsonElement);

                String type = entryObject.getProperty("type");
                String subtype = entryObject.getProperty("subtype");
                boolean isPending = entryObject.getProperty("status").equals("pending");

                String path = EntryHelper.getPathFromType(type, subtype, isPending);
                File file = Paths.get(path, String.format("%05d", Integer.parseInt(id)) + ".json").toFile();
                try {
                    FileUtils.writeStringToFile(file, json, "UTF-8");
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void copyDatastore() {
        synchronized (dumpLock) {
            synchronized (copyLock) {
                File fileSrc = Paths.get(EntryHelper.getEntriesFilepath()).toFile();
                File fileDest = Paths.get(EntryHelper.getTempFilepath(), "mdc-data-copy").toFile();
                try {
                    FileUtils.copyDirectory(fileSrc, fileDest);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void pushDatastoreToGitHub() {
        synchronized (copyLock) {

        }
    }
}

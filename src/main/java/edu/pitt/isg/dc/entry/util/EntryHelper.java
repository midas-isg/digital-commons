package edu.pitt.isg.dc.entry.util;

import edu.pitt.isg.dc.utils.DigitalCommonsProperties;

import java.util.Properties;

/**
 * Created by amd176 on 6/6/17.
 */
public class EntryHelper {
    private static String ENTRIES_FILEPATH = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_FILEPATH = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_FILEPATH);
    }

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
}

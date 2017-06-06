package edu.pitt.isg.dc.entry.classes;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

import java.util.Map;
import java.util.HashMap;

public class EntryObject {
    private String id;
    private Object entry;
    private Map<String, String> properties = new HashMap<>();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Object getEntry() {
        return entry;
    }

    public void setEntry(Object entry) {
        this.entry = entry;
    }

    public Map<String, String> getProperties() {
        return properties;
    }

    public void setProperties(Map<String, String> properties) {
        this.properties = properties;
    }

    public String getProperty(String key) {
        return properties.get(key);
    }

    public void setProperty(String key, String value) {
        this.properties.put(key, value);
    }

    public String getEntryType() {
        String path = this.getId();
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
        } else if (this.getProperty("type") != null && this.getProperty("type").length() > 0) {
            return this.getProperty("type");
        } else {
            return "N/A";
        }
    }

    public Object getEntryAsTypeClass() {
        GsonBuilder gsonBuilder = new GsonBuilder().serializeNulls();
        Gson gson = gsonBuilder.create();

        JsonObject jsonObjectEntry = (JsonObject) entry;
        String jsonString = jsonObjectEntry.toString();

        Object returnObject = null;
        try {
            Class typeClass = Class.forName(this.getEntryType());
            returnObject = gson.fromJson(jsonString, typeClass);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return returnObject;
    }
}

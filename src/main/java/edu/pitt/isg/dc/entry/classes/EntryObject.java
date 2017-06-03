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

    public Object getEntryAsTypeClass() {
        GsonBuilder gsonBuilder = new GsonBuilder().serializeNulls();
        Gson gson = gsonBuilder.create();

        JsonObject jsonObjectEntry = (JsonObject) entry;
        String jsonString = jsonObjectEntry.toString();

        Object returnObject = null;
        try {
            Class typeClass = Class.forName(properties.get("type"));
            returnObject = gson.fromJson(jsonString, typeClass);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return returnObject;
    }
}

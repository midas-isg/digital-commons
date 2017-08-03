package edu.pitt.isg.dc.entry.classes;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import edu.pitt.isg.dc.entry.Category;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;

import java.util.*;

class EntryObject {
    transient private Long id;
    private Object entry;
    private Category category;
    private Map<String, String> properties = new HashMap<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Object getEntry() {
        return entry;
    }

    public void setEntry(Object entry) {
        this.entry = entry;
    }

    public Category getCategory() {
        return this.category;
    }

    public void setCategory(Category category) {
        this.category = category;
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

    public String getEntryJsonString() {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(this.getEntry());
        return StringEscapeUtils.escapeJavaScript(json);
    }

    public String getTitle() {
        String title = "";
        String name = "";
        String version = "";
        LinkedHashMap entryData = (LinkedHashMap) this.getEntry();
        if(entryData.containsKey("title")) {
            name = String.valueOf(entryData.get("title"));
        } else if(entryData.containsKey("name")) {
            name = String.valueOf(entryData.get("name"));
        }

        if(entryData.containsKey("version")) {
            Object versionObj = entryData.get("version");
            if(versionObj instanceof String) {
                version = (String) versionObj;
            } else {
                List<String> versionList = (ArrayList<String>) entryData.get("version");
                String[] versions = new String[versionList.size()];
                versionList.toArray(versions);
                version = StringUtils.join(versions, ", ");
            }

            if(version.length() > 0) {
                if(!version.toUpperCase().matches("^[A-Z].*$")) {
                    version = " - v" + version;
                } else {
                    version = " - " + version;
                }
            }
        }

        title = name + version;
        return title;
    }

    public String getUnescapedEntryJsonString() {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        return gson.toJson(this.getEntry());
    }

    public String getEntryType() {
        if (this.getProperty("type") != null && this.getProperty("type").length() > 0) {
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

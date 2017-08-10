package edu.pitt.isg.dc.vm;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import edu.pitt.isg.dc.entry.Entry;

import java.util.HashMap;
import java.util.Map;

import static edu.pitt.isg.dc.entry.Keys.ENTRY;
import static edu.pitt.isg.dc.entry.Keys.N_A;
import static edu.pitt.isg.dc.entry.Keys.PROPERTIES;
import static edu.pitt.isg.dc.entry.Keys.STATUS;
import static edu.pitt.isg.dc.entry.Keys.TYPE;

public class EntryView {
    private static Gson gson = new GsonBuilder().setPrettyPrinting().create();

    transient private String content;
    transient private Long id;
    private Object entry;
    private Map<String, String> properties = new HashMap<>();

    public EntryView() {
    }

    public EntryView(Entry entry) {
        content =  gson.toJson(entry.getContent());
        setId(entry.getId());
        setEntry(entry.getContent().get(ENTRY));
        copyPropertiesFrom(entry.getContent().get(PROPERTIES));
    }

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
        if (this.getProperty(TYPE) != null && this.getProperty(TYPE).length() > 0) {
            return this.getProperty(TYPE);
        } else {
            return N_A;
        }
    }


    private void copyPropertiesFrom(Object obj) {
        if (obj instanceof Map){
            @SuppressWarnings("unchecked")
            Map<String, String> properties = (Map<String, String>)obj;
            for (Map.Entry<String, String> pair : properties.entrySet()){
                setProperty(pair.getKey(), pair.getValue());
            }
        }
    }
    public static Entry toEntry(Long id, EntryView entryObject){
        final Entry entry = new Entry();
        final String json = gson.toJson(entryObject);
        final HashMap hashMap = gson.fromJson(json, HashMap.class);
        entry.setId(id);
        entry.setContent(hashMap);
        entry.setStatus(entryObject.getProperty(STATUS));
        return entry;
    }
}

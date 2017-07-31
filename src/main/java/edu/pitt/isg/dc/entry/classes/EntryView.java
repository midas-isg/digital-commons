package edu.pitt.isg.dc.entry.classes;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import edu.pitt.isg.dc.entry.Entry;
import org.apache.commons.lang.StringEscapeUtils;

import java.util.HashMap;
import java.util.Map;

public class EntryView extends EntryObject {
    transient private String content;
    private static Gson gson = new GsonBuilder().setPrettyPrinting().create();

    public static Entry toEntry(Long id, EntryView entryObject){
        final Entry entry = new Entry();
        final String json = gson.toJson(entryObject);
        final HashMap hashMap = gson.fromJson(json, HashMap.class);
        entry.setId(id);
        entry.setContent(hashMap);
        entry.setStatus(entryObject.getProperty("status"));
        return entry;
    }

    public EntryView() {
    }

    public EntryView(Entry entry) {
        content =  gson.toJson(entry.getContent());
        setId(entry.getId());
        setEntry(entry.getContent().get("entry"));
        setCategory(entry.getCategory());
        copyPropertiesFrom(entry.getContent().get("properties"));
    }

    private void copyPropertiesFrom(Object obj) {
        if (obj instanceof Map){
            Map<String, String> properties = (Map<String, String>)obj;
            for (Map.Entry<String, String> pair : properties.entrySet()){
                setProperty(pair.getKey(), pair.getValue());
            }
        }
    }

    public String getEntryJsonString() {
        return StringEscapeUtils.escapeJavaScript(content);
    }
}

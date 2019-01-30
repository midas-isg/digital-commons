package edu.pitt.isg.dc.entry.classes;

import com.google.gson.*;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import org.apache.commons.lang.StringEscapeUtils;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import static edu.pitt.isg.dc.entry.Values.APPROVED;

public class EntryView extends EntryObject {
    transient private String content;
//    private static Gson gson = new GsonBuilder().setPrettyPrinting().create();

    private static Gson gson = new GsonBuilder().
            registerTypeAdapter(Double.class, new JsonSerializer<Double>() {

                @Override
                public JsonElement serialize(Double src, Type typeOfSrc, JsonSerializationContext context) {
                    if (src == src.longValue())
                        return new JsonPrimitive(src.longValue());
                    return new JsonPrimitive(src);
                }
            }).create();

    public static Entry toEntry(EntryId id, EntryView entryObject) {
        final Entry entry = new Entry();
        final String json = gson.toJson(entryObject);
        final HashMap hashMap = gson.fromJson(json, HashMap.class);
        cleanUpMap(hashMap);
        entry.setId(id);
        entry.setContent(hashMap);
        entry.setStatus(entryObject.getProperty("status"));
        entry.setIsPublic(entryObject.getIsPublic());
        entry.setCategory(entryObject.getCategory());
        entry.setIsPublic(entryObject.getIsPublic());
        entry.setDisplayName(entryObject.getDisplayName());
        entry.setTags(entryObject.getTags());
        entry.setUsers(entryObject.getUsersId());
        entry.setDateAdded(entryObject.getDateAdded());
        return entry;
    }

    private static void cleanUpMap(Map map) {
        Iterator it = map.keySet().iterator();
        while (it.hasNext()){
            Object key = it.next();
            Object value = map.get(key);
            if (value instanceof Map) {
                cleanUpMap((Map) value);
            } else if (value instanceof Double && (String.valueOf(value)).endsWith(".0")) {
                map.put(key, ((Double) value).intValue());
            } else if ((((String) key).equalsIgnoreCase("inputs") || ((String) key).equalsIgnoreCase("outputs"))  && value instanceof List) {
                List list = (List) value;
                for (int i = 0; i < list.size(); i++){
                    cleanUpMap((Map) list.get(i));
                }
            }
        }
    }

    public EntryView() {
    }

    public EntryView(Entry entry) {
        content = gson.toJson(entry.getContent());
        setId(entry.getId());
        setEntry(entry.getContent().get("entry"));
        setCategory(entry.getCategory());
        setIsPublic(entry.getIsPublic());
        setDisplayName(entry.getDisplayName());
        setTags(entry.getTags());
        copyPropertiesFrom(entry.getContent().get("properties"));
        setProperty("status", entry.getStatus());
        setUsersId(entry.getUsers());
        setDateAdded(entry.getDateAdded());
    }

    private void copyPropertiesFrom(Object obj) {
        if (obj instanceof Map) {
            Map<String, String> properties = (Map<String, String>) obj;
            for (Map.Entry<String, String> pair : properties.entrySet()) {
                setProperty(pair.getKey(), pair.getValue());
            }
        }
    }

    public String getEntryJsonString() {
        return StringEscapeUtils.escapeJavaScript(content);
    }
}

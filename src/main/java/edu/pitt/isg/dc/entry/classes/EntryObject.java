package edu.pitt.isg.dc.entry.classes;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.Comments;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import edu.pitt.isg.dc.utils.DigitalCommonsHelper;
import edu.pitt.isg.mdc.v1_0.Software;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import scala.util.parsing.combinator.testing.Str;

import java.util.*;

class EntryObject {
    transient private EntryId id;
    private Object entry;
    private Category category;
    private String displayName;
    private boolean isPublic;
    private List<String> comments;
    private Set<String> tags;
    private Map<String, String> properties = new HashMap<>();

    public EntryId getId() {
        return id;
    }

    public void setId(EntryId id) {
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

    public boolean getIsPublic() {
        return this.isPublic;
    }

    public void setIsPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public List<String> getComments() {
        return comments;
    }

    public void setComments(List<String> comments) {
        this.comments = comments;
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

    public Set<String> getTags() {
        return tags;
    }

    public void setTags(Set<String> tags) {
        this.tags = tags;
    }

    public String getEntryJsonString() {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(this.getEntry());
        return StringEscapeUtils.escapeJavaScript(json);
    }

    public String getTitle() {
        LinkedHashMap entryData = (LinkedHashMap) this.getEntry();
        String title = this.getDisplayName();

        if(title == null) {
            String name = "";
            String version = "";
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
                    if(!version.toUpperCase().matches("^[A-Z].*$") && !version.toUpperCase().matches("^\\d{4}.*$")) {
                        version = " - v" + version;
                    } else {
                        version = " - " + version;
                    }
                }
            }

            title = name + version;
        }

        title = addBadges(title, entryData);

        return title;
    }

    private boolean hasBadge(LinkedHashMap entryData, String key) {
        boolean hasBadge = false;
        if(entryData.containsKey(key)) {
            hasBadge = (boolean) entryData.get(key);
        }
        return hasBadge;
    }

    private String addBadges(String title, LinkedHashMap entryData) {
        Set<String> tags = this.getTags();
        if(tags != null && tags.size() > 0) {
            title = EntryHelper.addBadges(title, tags);
        } else {
            String key = "availableOnOlympus";
            if(hasBadge(entryData, key)) {
                title += EntryHelper.getBadge(key);
            }

            key = "availableOnUIDS";
            if(hasBadge(entryData, key)) {
                title += EntryHelper.getBadge(key);
            }

            key = "signInRequired";
            if(hasBadge(entryData, key)) {
                title += EntryHelper.getBadge(key);
            }
        }

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

        String jsonString = gson.toJson(this.getEntry());

        Object returnObject = null;
        try {
            Class typeClass = Class.forName(this.getEntryType());
            returnObject = gson.fromJson(jsonString, typeClass);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return returnObject;
    }

    public String getXmlString() {
        if(this.getEntryType().contains("edu.pitt.isg.mdc.v1_0")) {
            return DigitalCommonsHelper.jsonToXml((Software) getEntryAsTypeClass());
        } else {
            return null;
        }
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
}

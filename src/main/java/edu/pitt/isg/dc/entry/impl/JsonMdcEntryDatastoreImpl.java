package edu.pitt.isg.dc.entry.impl;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class JsonMdcEntryDatastoreImpl implements MdcEntryDatastoreInterface {
    private final String datastoreUrl = "https://api.github.com/repos/midas-isg/mdc-data/git/trees/master?recursive=1";
    private List<EntryObject> entries = new ArrayList<>();

    private static String DATASTORE_TOKEN = "";
    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        DATASTORE_TOKEN = configurationProperties.getProperty(DigitalCommonsProperties.DATASTORE_TOKEN);
    }

    @Override
    public String addEntry(EntryObject entryObject) {
        return null;
    }

    @Override
    public Object getEntry(String id) {
        return null;
    }

    @Override
    public List<Integer> getEntryIds() {
        return null;
    }

    @Override
    public String editEntry(String id, EntryObject entryObject) {
        return null;
    }

    @Override
    public boolean deleteEntry(String id) {
        return false;
    }

    @Override
    public boolean setEntryProperty(String id, String key, String value) {
        return false;
    }

    @Override
    public String getEntryProperty(String id, String key) {
        return null;
    }

    public void populate() throws IOException {
        JsonObject datastore = this.readJsonFileFromUrl(datastoreUrl);
        JsonArray datastoreTree = datastore.get("tree").getAsJsonArray();
        for(JsonElement datastoreElement : datastoreTree) {
            JsonObject datastoreObject = datastoreElement.getAsJsonObject();

            String path = datastoreObject.get("path").getAsString();
            if(path.endsWith(".json")) {
                EntryObject entryObject = new EntryObject();

                String[] splitPath = path.split("/");

                String type = "";
                String previousPart = "";
                for(String pathPart : splitPath) {
                    // grab data type folder after version folder
                    if(previousPart.matches(".*\\d+_\\d+$")) {
                        type = pathPart;
                    }
                    previousPart = pathPart;
                }

                String id = datastoreObject.get("sha").getAsString();

                String url = datastoreObject.get("url").getAsString();
                JsonObject entry = readJsonFileFromUrl(url);

                entryObject.setId(id);
                entryObject.setEntry(entry);
                if(type.length() > 0) {
                    entryObject.setProperty("type", type);
                }

                entries.add(entryObject);
            }
        }
    }

    public JsonObject readJsonFileFromUrl(String url) throws IOException {
        HttpClient httpClient = HttpClients.createDefault();

        HttpGet httpGet = new HttpGet(url);
        httpGet.setHeader("Accept", "application/vnd.github.3.raw");
        httpGet.setHeader("Authorization", "token " + DATASTORE_TOKEN);

        HttpResponse response = httpClient.execute(httpGet);
        HttpEntity entity = response.getEntity();

        JsonObject jsonObject = new JsonObject();
        if (entity != null) {
            InputStream inputStream = entity.getContent();
            try {
                String content = IOUtils.toString(inputStream, "UTF-8");

                JsonParser jsonParser = new JsonParser();
                jsonObject = jsonParser.parse(content).getAsJsonObject();
            } finally {
                inputStream.close();
            }
        }

        return jsonObject;
    }
}

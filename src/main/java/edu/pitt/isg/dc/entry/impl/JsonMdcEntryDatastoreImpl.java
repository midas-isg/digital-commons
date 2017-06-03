package edu.pitt.isg.dc.entry.impl;

import com.google.gson.*;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.mdc.dats2_2.*;
import edu.pitt.isg.mdc.v1_0.*;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;

public class JsonMdcEntryDatastoreImpl implements MdcEntryDatastoreInterface {
    private final String datastoreUrl = "https://api.github.com/repos/midas-isg/mdc-data/";
    private Map<String, EntryObject> entries = new HashMap<>();

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
        return entries.get(id);
    }

    @Override
    public List<String> getEntryIds() {
        return Arrays.asList((String[]) entries.keySet().toArray());
    }

    @Override
    public String editEntry(String id, EntryObject entryObject) throws Exception {
        HttpClient httpClient = HttpClients.createDefault();

        HttpPut httpPut = new HttpPut(datastoreUrl + "contents/" + entryObject.getProperty("path"));
        httpPut.setHeader("Authorization", "token " + DATASTORE_TOKEN);
        httpPut.setHeader("Content-Type", "application/json");

        JsonObject jsonObjectEntry = (JsonObject) entryObject.getEntry();
        String base64Entry = Base64.getEncoder().encodeToString(jsonObjectEntry.toString().getBytes());

        JsonObject jsonRequestObject = new JsonObject();
        jsonRequestObject.addProperty("message", "api commit");

        JsonObject jsonCommitter = new JsonObject();
        jsonCommitter.addProperty("name", "API Commit Author");
        jsonCommitter.addProperty("email", "author@email.com");

        jsonRequestObject.add("committer", jsonCommitter);
        jsonRequestObject.addProperty("content", base64Entry);
        jsonRequestObject.addProperty("sha", entryObject.getId());

        String jsonRequestString = jsonRequestObject.toString();
        StringEntity jsonEntity = new StringEntity(jsonRequestString);
        httpPut.setEntity(jsonEntity);

        HttpResponse response = httpClient.execute(httpPut);
        int status = response.getStatusLine().getStatusCode();
        if(status != 200) {
            return "Error: " + status;
        } else {
            entries.put(id, entryObject);
            return id;
        }
    }

    @Override
    public boolean deleteEntry(String id) {
        return false;
    }

    @Override
    public boolean setEntryProperty(String id, String key, String value) {
        entries.get(id).setProperty(key, value);
        return false;
    }

    @Override
    public String getEntryProperty(String id, String key) {
        return entries.get(id).getProperty(key);
    }

    public void populate() throws Exception {
        JsonObject datastore = this.readJsonFileFromUrl(datastoreUrl + "git/trees/master?recursive=1");
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
                        String typePath = "";
                        if(previousPart.equals("2_2")) {
                            typePath = "edu.pitt.isg.mdc.dats2_2.";
                        } else if(previousPart.equals("v1_0")) {
                            typePath = "edu.pitt.isg.mdc.v1_0.";
                        }
                        type = typePath + pathPart;
                        break;
                    }
                    previousPart = pathPart;
                }

                String id = datastoreObject.get("sha").getAsString();
                String url = datastoreObject.get("url").getAsString();
                JsonObject entry = readJsonFileFromUrl(url);

                entryObject.setId(id);
                entryObject.setEntry(entry);
                entryObject.setProperty("type", type);
                entryObject.setProperty("path", path);

                entries.put(id, entryObject);
            }
        }
    }

    private JsonObject readJsonFileFromUrl(String url) throws IOException {
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

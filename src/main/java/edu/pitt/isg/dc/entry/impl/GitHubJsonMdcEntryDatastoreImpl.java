package edu.pitt.isg.dc.entry.impl;

import com.google.gson.*;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.mdc.dats2_2.*;
import edu.pitt.isg.mdc.v1_0.*;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.security.MessageDigest;
import java.util.*;

public class GitHubJsonMdcEntryDatastoreImpl implements MdcEntryDatastoreInterface {
    private final String datastoreUrl = "https://api.github.com/repos/midas-isg/mdc-data/";
    private Map<String, EntryObject> entries = new HashMap<>();

    private static String DATASTORE_TOKEN = "";
    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        DATASTORE_TOKEN = configurationProperties.getProperty(DigitalCommonsProperties.DATASTORE_TOKEN);
    }

    @Override
    public String addEntry(EntryObject entryObject) throws Exception {
        String type = entryObject.getProperty("type");
        String typeDirectory = type.substring(type.lastIndexOf('.') + 1, type.length());

        if(entryObject.getProperty("type") != null) {
            if(entryObject.getEntryAsTypeClass() != null) {
                String status = entryObject.getProperty("status");
                if (status.equals("approved") || status.equals("pending")) {
                    JsonObject datastore = this.readJsonFileFromUrl(datastoreUrl + "git/trees/master?recursive=1");
                    JsonArray datastoreTree = datastore.get("tree").getAsJsonArray();

                    String path = "";
                    for (JsonElement datastoreElement : datastoreTree) {
                        JsonObject datastoreObject = datastoreElement.getAsJsonObject();
                        String elementPath = datastoreObject.get("path").getAsString();
                        if (elementPath.contains(typeDirectory)) {
                            path = elementPath.substring(0, elementPath.indexOf(typeDirectory) + typeDirectory.length());

                            MessageDigest md5 = MessageDigest.getInstance("MD5");
                            md5.update(entryObject.getEntry().toString().getBytes());
                            byte[] bytes = md5.digest();
                            String stringHash = new String(Hex.encodeHex(bytes));

                            path += "/" + stringHash + ".json";
                            entryObject.setProperty("path", path);
                            break;
                        }
                    }

                    HttpClient httpClient = HttpClients.createDefault();

                    HttpPut httpPut = new HttpPut(datastoreUrl + "contents/" + entryObject.getProperty("path"));
                    httpPut.setHeader("Authorization", "token " + DATASTORE_TOKEN);
                    httpPut.setHeader("Content-Type", "application/json");

                    JsonObject jsonObjectEntry = (JsonObject) entryObject.getEntry();
                    String base64Entry = base64EncodeJsonObject(jsonObjectEntry);

                    JsonObject jsonRequestObject = basicJsonRequestObject("api add","API Commit Author","author@email.com");
                    jsonRequestObject.addProperty("content", base64Entry);

                    String jsonRequestString = jsonRequestObject.toString();
                    StringEntity jsonEntity = new StringEntity(jsonRequestString);
                    httpPut.setEntity(jsonEntity);

                    HttpResponse response = httpClient.execute(httpPut);
                    int responseStatus = response.getStatusLine().getStatusCode();
                    if(responseStatus != 201) {
                        return "Error: " + status;
                    } else {
                        HttpEntity entity = response.getEntity();

                        JsonObject jsonObject;
                        if (entity != null) {
                            InputStream inputStream = entity.getContent();
                            try {
                                String content = IOUtils.toString(inputStream, "UTF-8");
                                JsonParser jsonParser = new JsonParser();
                                jsonObject = jsonParser.parse(content).getAsJsonObject();

                                String id = jsonObject.get("content").getAsJsonObject().get("sha").getAsString();
                                entryObject.setId(id);
                            } finally {
                                inputStream.close();
                            }
                        }
                        return entryObject.getId();
                    }
                } else {
                    return "Error: Invalid status specified";
                }
            } else {
                return "Error: Invalid type specified";
            }
        } else {
            return "Error: No type specified";
        }
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
        String base64Entry = base64EncodeJsonObject(jsonObjectEntry);

        JsonObject jsonRequestObject = basicJsonRequestObject("api update","API Commit Author","author@email.com");
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
    public String deleteEntry(String id) throws Exception {
        EntryObject entryObject = entries.get(id);

        HttpClient httpClient = HttpClients.createDefault();

        MyHttpDelete httpDelete = new MyHttpDelete(datastoreUrl + "contents/" + entryObject.getProperty("path"));
        httpDelete.setHeader("Authorization", "token " + DATASTORE_TOKEN);
        httpDelete.setHeader("Content-Type", "application/json");

        JsonObject jsonRequestObject = basicJsonRequestObject("api delete","API Commit Author","author@email.com");
        jsonRequestObject.addProperty("sha", entryObject.getId());

        String jsonRequestString = jsonRequestObject.toString();
        StringEntity jsonEntity = new StringEntity(jsonRequestString);
        httpDelete.setEntity(jsonEntity);

        HttpResponse response = httpClient.execute(httpDelete);
        int status = response.getStatusLine().getStatusCode();
        if(status != 200) {
            return "Error: " + status;
        } else {
            entries.remove(id);
            return id;
        }
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
            if(path.endsWith("test.json")) {
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
                entryObject.setProperty("status", "approved");

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

        JsonObject jsonObject = null;
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

    private JsonObject basicJsonRequestObject(String commit, String name, String email) {
        JsonObject jsonRequestObject = new JsonObject();
        jsonRequestObject.addProperty("message", commit);

        JsonObject jsonCommitter = new JsonObject();
        jsonCommitter.addProperty("name", name);
        jsonCommitter.addProperty("email", email);

        jsonRequestObject.add("committer", jsonCommitter);

        return jsonRequestObject;
    }

    private String base64EncodeJsonObject(JsonObject jsonObject) {
        return Base64.getEncoder().encodeToString(jsonObject.toString().getBytes());
    }

    private class MyHttpDelete extends HttpPost {
        public MyHttpDelete(String uri) {
            this.setURI(URI.create(uri));
        }

        @Override
        public String getMethod() {
            return "DELETE";
        }
    }
}

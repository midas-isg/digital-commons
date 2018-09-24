package edu.pitt.isg.dc.fm;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.net.URI;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class JsonKit {
    private JsonKit(){}

    public static Map<String, Object> toStringObjectMap(String json) {
        final Gson gson = new Gson();
        Type type = new TypeToken<HashMap<String, Object>>(){}.getType();
        return gson.fromJson(json, type);
    }

    public static List<Object> toObjectList(String json) {
        final Gson gson = new Gson();
        Type type = new TypeToken<List<Object>>(){}.getType();
        return gson.fromJson(json, type);
    }

    public static String dumpJsonFile(String path) {
        try {
            final Class<?> aClass = path.getClass();
            final URL url = aClass.getResource(path);
            final URI uri = url.toURI();
            return Files.readAllLines(Paths.get(uri), Charset.defaultCharset()).stream().collect(Collectors.joining());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String toJson(Object object){
        return new Gson().toJson(object);
    }
}

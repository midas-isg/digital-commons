package edu.pitt.isg.dc.repository.json;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import edu.pitt.isg.Converter;
import edu.pitt.isg.JsonConverter;
import edu.pitt.isg.dc.repository.RepositoryEntry;
import edu.pitt.isg.mdc.v1_0.Software;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.WordUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * Created by jdl50 on 5/26/17.
 */
public class FileResolver {
    Map<File, Class> directoriesToClassesMap;

    public FileResolver(Map<File, Class> directoriesToClassesMap) {
        this.directoriesToClassesMap = directoriesToClassesMap;
    }

    public List<RepositoryEntry> parse() {
        List<RepositoryEntry> repo = new ArrayList<>();
        Iterator<File> it = directoriesToClassesMap.keySet().iterator();
        while (it.hasNext()) {
            File directory = it.next();
            String memberOf = directory.getName();
            for (File f : directory.listFiles((dir, name) -> name.endsWith(".json"))) {
                Class clazz = directoriesToClassesMap.get(directory);
                JsonConverter converter = new JsonConverter();
                Converter softwareConverter = new Converter();
                try {
                    RepositoryEntry repositoryEntry = new RepositoryEntry<>(clazz, FileUtils.readFileToString(f), directory.getName());
                } catch (IOException e) {
                    e.printStackTrace();
                }
                if (clazz.isAssignableFrom(edu.pitt.isg.mdc.v1_0.Software.class)) {
                    try {
                        JsonParser parser = new JsonParser();
                        JsonArray arr = (JsonArray) parser.parse(FileUtils.readFileToString(f));
                        Iterator<JsonElement> softwareIterator = arr.iterator();
                        while (softwareIterator.hasNext()) {
                            JsonElement element = softwareIterator.next();
                            Object s = converter.convert(element.toString(), new Software());
                            Class subClass = null;
                            String subtype = element.getAsJsonObject().get("subtype").toString();
                            subtype = subtype.replaceAll("-", " ");
                            String className = "edu.pitt.isg.mdc.v1_0." + WordUtils.capitalize(subtype).replaceAll("[ \"]", "");
                            RepositoryEntry repositoryEntry;
                            try {
                                subClass = Class.forName(className);
                                Object o = converter.convert(element.toString(), subClass.newInstance());
                                repositoryEntry = new RepositoryEntry(o, element.toString(), memberOf);
                                repo.add(repositoryEntry);
                            } catch (Exception e) {
                                try {
                                    className = className.replaceAll("s$", "");
                                    subClass = Class.forName(className);
                                    Object o = converter.convert(element.toString(), subClass.newInstance());
                                    repositoryEntry = new RepositoryEntry(o, element.toString(), memberOf);
                                    repo.add(repositoryEntry);
                                } catch (Exception e1) {
                                    e1.printStackTrace();
                                }
                            }
                            ;

                            //System.out.println(WordUtils.capitalize(element.getAsJsonObject().get("subtype").toString()).replaceAll("[ \"]", "")+".class");
                            //RepositoryEntry repositoryEntry = new RepositoryEntry(s, directory.getName());
                            //System.out.println(s);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else {
                    Object o = null;
                    try {
                        String sourceData = FileUtils.readFileToString(f);
                        o = converter.convert(sourceData, clazz.newInstance());
                        RepositoryEntry repositoryEntry = new RepositoryEntry(o, sourceData, memberOf);
                        repo.add(repositoryEntry);
                    } catch (Exception e) {
                        System.err.println("File " + f.getName() + "(" + clazz.getName() + ") = " + e.getMessage());
                    }
                }
            }
        }
        return repo;
    }
}

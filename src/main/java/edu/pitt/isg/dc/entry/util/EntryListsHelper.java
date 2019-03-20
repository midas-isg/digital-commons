package edu.pitt.isg.dc.entry.util;

import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.google.common.reflect.TypeToken;
import com.google.gson.*;
import edu.pitt.isg.dc.entry.EntryLists;
import edu.pitt.isg.dc.entry.EntryListsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class EntryListsHelper {
    @Autowired
    private EntryListsService entryListsService;
    public static final java.lang.reflect.Type mapType = new TypeToken<TreeMap<String, Object>>() {
    }.getType();

    public HashMap<String, Object> convertListIdToContent(HashMap<String, Object> entryMap) {
        //when ready to use uncomment call from getContentFromEntryLists in EntryService
        //License
        entryMap = checkEachLicenseIdForIdentifier(entryMap);

        return entryMap;
    }

    private HashMap<String, Object> checkEachLicenseIdForIdentifier(HashMap<String, Object> entryMap) {
/*
                  jsonb_array_elements(content->'entry'->'licenses') as license
                  jsonb_array_elements(content->'entry'->'storedIn'->'licenses') as license
                  jsonb_array_elements(jsonb_array_elements(content->'entry'->'distributions')->'licenses') as license
                  jsonb_array_elements(jsonb_array_elements(content->'entry'->'distributions')->'storedIn'->'licenses') as license
                  jsonb_array_elements(jsonb_array_elements(jsonb_array_elements(content->'entry'->'distributions')->'conformsTo')->'licenses') as license
 */
        String key = "licenses";
        String identifier = "licenseId";
        List<String> keyList = Arrays.asList("identifier", "name", "version", "creators");

        if(entryMap.containsKey(key)) {
            entryMap.put(key, convertIdentifierToListsContent((ArrayList<HashMap<String, Object>>) entryMap.get(key), identifier, keyList));
        }

        if(entryMap.containsKey("storedIn")) {
            entryMap.put("storedIn", convertArrayListIdsToContent((HashMap<String, Object>) entryMap.get("storedIn"), key, identifier, keyList));
        }

        if(entryMap.containsKey("distributions")) {
            List<HashMap<String, Object>> distributionsList = (ArrayList<HashMap<String, Object>>) entryMap.get("distributions");
            for(HashMap<String, Object> distributionMap : distributionsList) {
                if(distributionMap.containsKey(key)) {
                    distributionMap.put(key, convertIdentifierToListsContent((ArrayList<HashMap<String, Object>>) distributionMap.get(key), identifier, keyList));
                }
                if(distributionMap.containsKey("storedIn")) {
                    distributionMap.put("storedIn", convertArrayListIdsToContent((HashMap<String, Object>) distributionMap.get("storedIn"), key, identifier, keyList));
                }
                if(distributionMap.containsKey("conformsTo")) {
                    List<HashMap<String, Object>> conformsToList = (ArrayList<HashMap<String, Object>>) distributionMap.get("conformsTo");
                    for(HashMap<String, Object> conformsToMap : conformsToList) {
                        if(conformsToMap.containsKey(key)){
                            conformsToMap.put(key, convertIdentifierToListsContent((ArrayList<HashMap<String, Object>>) conformsToMap.get(key), identifier, keyList));
                        }
                    }
                    distributionMap.put("conformsTo", conformsToList);
                }
            }

            entryMap.put("distributions", distributionsList);
        }

        return entryMap;
    }

    private HashMap<String, Object> convertArrayListIdsToContent(HashMap<String, Object> entryMap, String key, String identifier, List<String> keyList) {
        if(entryMap.containsKey(key)) {
            entryMap.put(key, convertIdentifierToListsContent((ArrayList<HashMap<String, Object>>) entryMap.get(key), identifier, keyList));
        }
        return entryMap;
    }

    private List<HashMap<String, Object>> convertIdentifierToListsContent(ArrayList<HashMap<String, Object>> entryMapList, String identifier, List<String> keyList) {
        for(HashMap<String, Object> entryMap : entryMapList){
            if(entryMap.containsKey(identifier)) {
                Long listsId;
                if(entryMap.get(identifier) instanceof Double) {
                    listsId = ((Double) entryMap.get(identifier)).longValue();
                } else listsId = Long.valueOf(entryMap.get(identifier).toString());
                HashMap<String, Object> listsContent = new HashMap<String, Object>();
                    listsContent = getListsContent(listsId);

                for (String key : keyList) {
                    if(listsContent.containsKey(key)) {
                        entryMap.put(key, listsContent.get(key));
                    }
                }
                entryMap.remove(identifier);
            }
        }

        return entryMapList;
    }

    private HashMap getListsContent(Long identifier) {
        EntryLists entryLists = entryListsService.findOne(identifier);
        return entryLists.getContent();
    }



    public JsonObject convertContentToListId(JsonObject jsonObject) {
        //when ready to use uncomment call from submitDigitalObject in DatasetWebflowValidator
        //License
        jsonObject = checkEachLicenseIdForContent(jsonObject);

        return jsonObject;
    }

    private JsonObject checkEachLicenseIdForContent(JsonObject jsonObject) {
/*
                  jsonb_array_elements(content->'entry'->'licenses') as license
                  jsonb_array_elements(content->'entry'->'storedIn'->'licenses') as license
                  jsonb_array_elements(jsonb_array_elements(content->'entry'->'distributions')->'licenses') as license
                  jsonb_array_elements(jsonb_array_elements(content->'entry'->'distributions')->'storedIn'->'licenses') as license
                  jsonb_array_elements(jsonb_array_elements(jsonb_array_elements(content->'entry'->'distributions')->'conformsTo')->'licenses') as license
 */
        String key = "licenses";
        String type = "license";
        String identifier = "licenseId";
        List<String> keyList = Arrays.asList("identifier", "name", "version", "creators");

        if(jsonObject.has(key)) {
            jsonObject.add(key, convertListsContentToIdentifier(jsonObject.getAsJsonArray(key), type, identifier, keyList));
        }

        if(jsonObject.has("storedIn")) {
            jsonObject.add("storedIn", convertArrayListContentToIds(jsonObject.getAsJsonObject("storedIn"), key, type, identifier, keyList));
        }

        if(jsonObject.has("distributions")) {
            JsonArray distributionsArray = jsonObject.getAsJsonArray("distributions");
            for(JsonElement distributionElement : distributionsArray) {
                JsonObject distribution = distributionElement.getAsJsonObject();
                if(distribution.has(key)) {
                    distribution.add(key, convertListsContentToIdentifier(distribution.getAsJsonArray(key), type, identifier, keyList));
                }
                if(distribution.has("storedIn")) {
                    distribution.add("storedIn", convertArrayListContentToIds(distribution.getAsJsonObject("storedIn"), key, type, identifier, keyList));
                }
                if(distribution.has("conformsTo")) {
                    JsonArray conformsToArray = distribution.getAsJsonArray("conformsTo");
                    for(JsonElement conformsToElement : conformsToArray) {
                        JsonObject conformsTo = conformsToElement.getAsJsonObject();
                        if(conformsTo.has(key)){
                            conformsTo.add(key, convertListsContentToIdentifier(conformsTo.getAsJsonArray(key), type, identifier, keyList));
                        }
                    }
                    distribution.add("conformsTo", conformsToArray);
                }
            }

            jsonObject.add("distributions", distributionsArray);
        }

        return jsonObject;
    }


    private JsonObject convertArrayListContentToIds(JsonObject entry, String key, String type, String identifier, List<String> keyList) {
        if(entry.has(key)) {
            entry.add(key, convertListsContentToIdentifier(entry.getAsJsonArray(key), type, identifier, keyList));
        }
        return entry;
    }

    private JsonArray convertListsContentToIdentifier(JsonArray entryContentArray, String type, String identifierKey, List<String> keyList){
//        int index = 0;
        for(JsonElement entryElement : entryContentArray){
            JsonObject entryContent = entryElement.getAsJsonObject();

            JsonObject identifierJson = getIdentifierBasedOnContent(type, identifierKey, entryContent);
            if(identifierJson.has(identifierKey)){
                entryContent.add(identifierKey, identifierJson.get(identifierKey));
                for (String key : keyList) {
                    if(entryContent.has(key)) {
                        entryContent.remove(key);
                    }
                }
/*
                Gson gson = new Gson();
                entryElement = gson.fromJson(entryContent.toString(), JsonElement.class);
                entryContentArray.set(index, entryElement);
*/
            }
//            index = index + 1;
        }

        return entryContentArray;
    }

    private JsonObject getIdentifierBasedOnContent(String type, String identifierKey, JsonObject content){
        JsonObject identifier = new JsonObject();
        Long identifierId = findIdentifierForMatchingContent(type, content);
        if(identifierId != null){
            Gson gson = new GsonBuilder().create();
            JsonElement identifierElement = gson.toJsonTree(identifierId.toString());
            identifier.add(identifierKey, identifierElement);
        } else identifier = content;

        return identifier;
    }

    private Long findIdentifierForMatchingContent(String type, JsonObject content){
        Long identifier = null;
        Boolean foundMatch = false;
        List<EntryLists> entryListsList = entryListsService.findEntryLists(type);
        for (EntryLists entryLists : entryListsList){
            Gson gson = new Gson();
            JsonObject entryJson = gson.toJsonTree(entryLists.getContent()).getAsJsonObject();
            if(jsonObjectComparision(entryJson, content)){
                identifier = entryLists.getId();
                foundMatch = true;
                break;
            }
        }

        if(!foundMatch){
            // do stuff
        }

        return identifier;
    }


    public Boolean jsonObjectComparision(JsonObject jsonObjectFromLeft, JsonObject jsonObjectFromRight) {
        Gson gson = new GsonBuilder().serializeNulls().enableComplexMapKeySerialization().create();
        Map<String, Object> databaseMapLeft = gson.fromJson(jsonObjectFromLeft, mapType);
        Map<String, Object> databaseMapRight = gson.fromJson(jsonObjectFromRight, mapType);

        MapDifference<String, Object> d = Maps.difference(databaseMapLeft, databaseMapRight);

        if (jsonObjectFromLeft.equals(jsonObjectFromRight) && d.areEqual()) {
            return true;
        } else {
/*
            if (!d.toString().equalsIgnoreCase("equal")) {
                if (d.entriesOnlyOnLeft().size() > 0) {
                    System.out.print("JsonObject " + jsonObjectFromRight.get("title") + " Left contains");
                    Iterator<String> it = d.entriesOnlyOnLeft().keySet().iterator();
                    while (it.hasNext()) {

                        String field = it.next();
                        System.out.print(" " + field + ",");

                    }
                    System.out.print(" but Right does not.\n");
                }

                if (d.entriesOnlyOnRight().size() > 0) {
                    System.out.print("JsonObject " + jsonObjectFromRight.get("title") + " Right contains");
                    Iterator<String> it = d.entriesOnlyOnRight().keySet().iterator();
                    while (it.hasNext()) {
                        String field = it.next();
                        System.out.print(" " + field + ",");

                    }
                    System.out.print(" but Left does not.\n");
                }

                if (d.entriesDiffering().size() > 0) {
                    Iterator<String> it = d.entriesDiffering().keySet().iterator();
                    while (it.hasNext()) {
                        String value = it.next();

                        String left;
                        if (jsonObjectFromLeft.get(value).isJsonArray()) {
                            left = sortJsonObject(jsonObjectFromLeft.get(value).getAsJsonArray().get(0).getAsJsonObject());
                        } else {
                            left = sortJsonObject(jsonObjectFromLeft.get(value).getAsJsonObject());
                        }

                        String right;
                        if (jsonObjectFromRight.get(value).isJsonArray()) {
                            right = sortJsonObject(jsonObjectFromRight.get(value).getAsJsonArray().get(0).getAsJsonObject());
                        } else {
                            right = sortJsonObject(jsonObjectFromRight.get(value).getAsJsonObject());
                        }

                        if (!left.equals(right)) {
                            int idxOfDifference = TestConvertDatsToJava.indexOfDifference(left, right);


                            try {
                                System.out.println("In " + value + " section from Left: ...\n" + left.substring(0, idxOfDifference) + Converter.ANSI_CYAN + left.substring(idxOfDifference, left.length()) + Converter.ANSI_RESET);
                                System.out.println("In " + value + " section from Right: ...\n" + right.substring(0, idxOfDifference) + Converter.ANSI_CYAN + right.substring(idxOfDifference, right.length()) + Converter.ANSI_RESET);
                            } catch (StringIndexOutOfBoundsException e) {
                                System.out.println("idxOfDifference:" + idxOfDifference);
                                // System.out.println("end:" + end);

                                throw e;
                            }
                        } else {
                            System.out.println(d);
                        }

                    }
                }
            }
*/
            return false;
        }

    }

/*
    private String sortJsonObject(JsonObject jsonObject) {
        List<String> jsonElements = new ArrayList<>();

        Set<Map.Entry<String, JsonElement>> entries = jsonObject.entrySet();
        for (Map.Entry<String, JsonElement> entry : entries)
            jsonElements.add(entry.getKey());

        Collections.sort(jsonElements);

        JsonArray jsonArray = new JsonArray();
        for (String elementName : jsonElements) {
            JsonObject newJsonObject = new JsonObject();
            JsonElement jsonElement = jsonObject.get(elementName);
            if (jsonElement.isJsonObject())
                newJsonObject.add(elementName, new JsonPrimitive(sortJsonObject(jsonObject.get(elementName).getAsJsonObject())));
            else if (jsonElement.isJsonArray()) {
                newJsonObject.add(elementName, sortJsonArray(jsonElement));
            } else
                newJsonObject.add(elementName, jsonElement);
            jsonArray.add(newJsonObject);
        }

        return jsonArray.toString();
    }

    private JsonArray sortJsonArray(JsonElement jsonElement) {
        JsonArray sortedArray = new JsonArray();

        JsonArray jsonElementAsArray = jsonElement.getAsJsonArray();
        for (JsonElement arrayMember : jsonElementAsArray)
            if (arrayMember.isJsonObject()) {
                sortedArray.add(new JsonPrimitive(sortJsonObject(arrayMember.getAsJsonObject())));
            } else if (arrayMember.isJsonArray()) {
                sortedArray.add(sortJsonArray(arrayMember));
            } else {
                sortedArray.add(arrayMember.toString());
            }
        return sortedArray;
    }
*/


}

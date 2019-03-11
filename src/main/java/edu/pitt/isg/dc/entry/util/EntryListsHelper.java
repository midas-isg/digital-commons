package edu.pitt.isg.dc.entry.util;

import edu.pitt.isg.dc.entry.EntryLists;
import edu.pitt.isg.dc.entry.EntryListsRepository;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

@Component
public class EntryListsHelper {
    @Autowired
    private EntryListsRepository entryListsRepository;
    @Autowired
    private ApiUtil apiUtil;

    public HashMap<String, Object> convertListIdToContent(HashMap<String, Object> entryMap) {
        //License
        entryMap = checkEachLicenseId(entryMap);

        return entryMap;
    }

    private HashMap<String, Object> checkEachLicenseId(HashMap<String, Object> entryMap) {
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
                Integer listsId = Integer.valueOf(entryMap.get(identifier).toString());
                HashMap<String, Object> listsContent = new HashMap<String, Object>();
//                    listsContent = getListsContent(listsId);
//                    listsContent.put("identifier", "Attribution-NonCommercial-ShareAlike 4.0 International");
                listsContent.put("name", "Attribution-NonCommercial-ShareAlike 4.0 International");
                listsContent.put("version", "4.00");
//                    listsContent.put("creators", "Attribution-NonCommercial-ShareAlike 4.0 International");

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

    private HashMap getListsContent(Integer identifier) {
        EntryLists entryLists = entryListsRepository.findOne(identifier);
        return entryLists.getContent();
    }

}

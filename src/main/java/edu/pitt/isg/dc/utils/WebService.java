package edu.pitt.isg.dc.utils;

import com.google.gson.*;
//import com.wordnik.swagger.annotations.ApiParam;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import org.openarchives.oai._2.ListSetsType;
import org.openarchives.oai._2.OAIPMHtype;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;
import edu.pitt.isg.Converter;

import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.JAXB;
import javax.xml.bind.JAXBElement;
import java.util.List;
import java.util.Optional;

@Component
public class WebService {

    @Autowired
    private ApiUtil apiUtil;
/*
    public String getIdentifiersWebService(ModelMap model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<String> identifiers = apiUtil.getIdentifiers();
        return gson.toJson(identifiers);
    }
*/
    public ResponseEntity getMetadataWebService(ModelMap model, String identifier, HttpServletRequest request) {
        String header = request.getHeader("Accept");
        String metadata = apiUtil.getMetadata(identifier, header);
        if(metadata != null) return ResponseEntity.status(HttpStatus.OK).body(metadata);
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier " + identifier + " with response content type " + header + ".");
    }

    public Object getDataWebService(String identifier, Optional<Integer> distribution) {
        Integer distributionId = null;

        if(distribution.isPresent()) distributionId = distribution.get();

        if(distributionId == null) distributionId = 0;

        String accessUrl = apiUtil.getAccessUrl(identifier, distributionId.toString());
        if(accessUrl != null) {
            return "redirect:" + accessUrl;
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No data found for identifier " + identifier + " and distribution index " + distributionId);
        }
    }

    public Object getMetadataTypeWebService(String identifier) {
        String type = apiUtil.getMetadataType(identifier);

        if(type != null) {
            String simpleName = type.substring(type.lastIndexOf('.') + 1, type.length());
            String schema = null;

            if(simpleName.equals("Dataset")) {
                schema = "https://raw.githubusercontent.com/biocaddie/WG3-MetadataSpecifications/v2.2/json-schemas/dataset_schema.json";
            } else if(simpleName.equals("DataStandard")) {
                schema = "https://raw.githubusercontent.com/biocaddie/WG3-MetadataSpecifications/v2.2/json-schemas/data_standard_schema.json";
            } else {
                schema = "https://raw.githubusercontent.com/midas-isg/mdc-xsd-and-types/master/src/main/resources/software.xsd";
            }

            JsonObject responseObj = new JsonObject();
            responseObj.addProperty("datatype", simpleName);
            responseObj.addProperty("schema", schema);

            String responseJson = responseObj.toString();
            return ResponseEntity.status(HttpStatus.OK).body(responseJson);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier: " + identifier);
    }

    public String getPublicEntryContentsWebService(ModelMap model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<Entry> entries = apiUtil.getPublicEntryContents();

        JsonParser parser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        for(int i = 0; i < entries.size(); i++) {
            EntryView entryView = new EntryView(entries.get(i));
            String json = entryView.getUnescapedEntryJsonString();
            JsonElement element = parser.parse(json).getAsJsonObject();

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("type", entryView.getEntryType());
            jsonObject.add("content", element);

            jsonArray.add(jsonObject);
        }

        return gson.toJson(jsonArray);
    }

    public ResponseEntity<String> getCategoryWebService(String identifier) {
        List<Category> categories = apiUtil.getCategoryLineage(identifier);
        if (categories == null || categories.size() == 0) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("{ \"Error\":\"Identifier '" + identifier + "' not found.\"}");
        }

        JsonArray categoryNameArray = new JsonArray();
        Gson gson = new GsonBuilder().setPrettyPrinting().create();

        for (int i = categories.size() - 1; i >=0; i--)
            categoryNameArray.add(categories.get(i).getCategory());

        return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(categoryNameArray));
    }

    public ResponseEntity getIdentifiersWebService(ModelMap model) {
        OAIPMHtype identifiers = new OAIPMHtype();
        identifiers = apiUtil.getIdentifiersList();

        if(identifiers != null && !identifiers.getListIdentifiers().getHeader().isEmpty()) {
            //return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(sets));
            return ResponseEntity.status(HttpStatus.OK).body(identifiers);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no records available.");
        }

    }

    public ResponseEntity getIdentifyInfo(){
        OAIPMHtype oaipmHtype = new OAIPMHtype();
        return ResponseEntity.status(HttpStatus.OK).body(oaipmHtype);
    }

    public ResponseEntity getRecordForIdentifierWebService(ModelMap model, String identifier) {
        OAIPMHtype record = new OAIPMHtype();
        HttpHeaders headers = new HttpHeaders();
        Converter converter = new Converter();
        headers.add(HttpHeaders.CONTENT_TYPE, "application/xml; charset=UTF-8");

        if(!identifier.isEmpty()) {
            List<String> identifiersList = apiUtil.getIdentifiers();
            if(identifiersList.contains(identifier)) {
                record = apiUtil.getRecord(identifier);
                String body = null;
                try {
                    body = converter.convertToXml(record);
                    body = body.replaceAll("(?s)&lt;.*?&gt;", "");
                    //JAXBElement jaxbElement = null;
                    //jaxbElement.setValue(record);
                    //return ResponseEntity.status(HttpStatus.OK).headers(headers).body(record);

                } catch(Exception e) {
                    System.out.println("Error: " + e);
                }

                return ResponseEntity.status(HttpStatus.OK).headers(headers).body(body);
                //return ResponseEntity.status(HttpStatus.OK).body(record);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The value of the  " + identifier + " argument is unknown or illegal in this repository.");
            }
        }
        else
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The value of the  " + identifier + " argument is unknown or illegal in this repository.");

    }

    public ResponseEntity getRecordsWebService(ModelMap model) {
        OAIPMHtype records = new OAIPMHtype();
        records = apiUtil.getRecords();

        if(records != null && !records.getListRecords().getRecord().isEmpty()) {
            //return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(sets));
            return ResponseEntity.status(HttpStatus.OK).body(records);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no records available.");
        }

    }

    public ResponseEntity getMetadataFormatsWebService(ModelMap model, Optional<String> identifier) {
        String identifierId = null;
        //List<String> types = null;
        OAIPMHtype types = new OAIPMHtype();
        types = null;

        //Gson gson = new GsonBuilder().setPrettyPrinting().create();

        if(identifier.isPresent()) {
            identifierId = identifier.get();

            List<String> identifiersList = apiUtil.getIdentifiers();
            if(identifiersList.contains(identifierId)) {
                types = apiUtil.getMetadataFormatsForIdentifier(identifierId);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The value of the  " + identifierId + " argument is unknown or illegal in this repository.");
            }
        }
        if(identifierId == null) {
            identifierId = "";
            types = apiUtil.getMetadataFormatsAll();
        }
        //return gson.toJson(types);

        if(types != null && !types.getListMetadataFormats().getMetadataFormat().isEmpty()) {
            //return "redirect:" + accessUrl;
            //return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(types));
            return ResponseEntity.status(HttpStatus.OK).body(types);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no metadata formats available for the specified item.");
        }

    }


    public ResponseEntity getSetsWebService(ModelMap model) {
        //ListSetsType sets = null;
        OAIPMHtype sets = null;
        //Gson gson = new GsonBuilder().setPrettyPrinting().create();
        sets = apiUtil.getSets();

        if(sets != null && !sets.getListSets().getSet().isEmpty()) {
            //return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(sets));
            return ResponseEntity.status(HttpStatus.OK).body(sets);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no sets available.");
        }

    }

}

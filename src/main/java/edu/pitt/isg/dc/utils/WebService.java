package edu.pitt.isg.dc.utils;

import com.google.gson.*;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import org.openarchives.oai._2.OAIPMHtype;
import org.openarchives.oai._2.ObjectFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;
import org.springframework.xml.transform.StringResult;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import static edu.pitt.isg.dc.repository.utils.ApiUtil.convertUtcDateTimeStringToDate;

//import com.wordnik.swagger.annotations.ApiParam;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;

@Component
public class WebService {

    Jaxb2Marshaller marshaller;
    @Autowired
    private ApiUtil apiUtil;
/*
    public String getIdentifiersWebService(ModelMap model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<String> identifiers = apiUtil.getIdentifiers();
        return gson.toJson(identifiers);
    }
*/

    public WebService() {
        marshaller = new Jaxb2Marshaller();
        marshaller.setClassesToBeBound(new Class[]{
                //all the classes the context needs to know about
                org.openarchives.oai._2.ObjectFactory.class,
                org.openarchives.oai._2_0.oai_dc.ObjectFactory.class,
                org.purl.dc.elements._1.ObjectFactory.class,
        }); //"alternatively" setContextPath(<jaxb.context>),


        marshaller.setMarshallerProperties(new HashMap<String, Object>() {{
            put(javax.xml.bind.Marshaller.JAXB_FORMATTED_OUTPUT, true);
        }});
    }



    //public void setupApiUtilForTesting(ApiUtil apiUtil) {
    //    this.apiUtil = apiUtil;
    //}

    public ResponseEntity getMetadataWebService(ModelMap model, String identifier, HttpServletRequest request) {
        String header = request.getHeader("Accept");
        String metadata = apiUtil.getMetadata(identifier, header);
        if (metadata != null) return ResponseEntity.status(HttpStatus.OK).body(metadata);
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier " + identifier + " with response content type " + header + ".");
    }

    public Object getDataWebService(String identifier, Optional<Integer> distribution) {
        Integer distributionId = null;

        if (distribution.isPresent()) distributionId = distribution.get();

        if (distributionId == null) distributionId = 0;

        String accessUrl = apiUtil.getAccessUrl(identifier, distributionId.toString());
        if (accessUrl != null) {
            return "redirect:" + accessUrl;
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No data found for identifier " + identifier + " and distribution index " + distributionId);
        }
    }

    public Object getMetadataTypeWebService(String identifier) {
        String type = apiUtil.getMetadataType(identifier);

        if (type != null) {
            String simpleName = type.substring(type.lastIndexOf('.') + 1, type.length());
            String schema = null;

            if (simpleName.equals("Dataset")) {
                schema = "https://raw.githubusercontent.com/biocaddie/WG3-MetadataSpecifications/v2.2/json-schemas/dataset_schema.json";
            } else if (simpleName.equals("DataStandard")) {
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
        for (int i = 0; i < entries.size(); i++) {
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

        for (int i = categories.size() - 1; i >= 0; i--)
            categoryNameArray.add(categories.get(i).getCategory());

        return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(categoryNameArray));
    }

    public ResponseEntity getIdentifiersWebService(ModelMap model, String from, String until, String metadataPrefix, String set, String resumptionToken) {
        if (!metadataPrefix.toLowerCase().equals("oai_dc")) {
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.");
        }

        // Convert UTC datetime string to date
        Date fromDate = null;
        Date untilDate = null;
        if (from != null && !from.isEmpty()) {
            try {
                fromDate = convertUtcDateTimeStringToDate(from);
            } catch (ParseException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("badArgument - The request includes illegal arguments or is missing required arguments.");
            }
        }
        if (until != null && !until.isEmpty()) {
            try {
                untilDate = convertUtcDateTimeStringToDate(until);
            } catch (ParseException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("badArgument - The request includes illegal arguments or is missing required arguments.");
            }
        }


        OAIPMHtype identifiers = new OAIPMHtype();
        String notFound = "There are no records available.";
        identifiers = apiUtil.getIdentifiersList(fromDate, untilDate, metadataPrefix, set, resumptionToken);
        if(identifiers.getListIdentifiers().getHeader().size() == 0){
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.");
        }
        return ResponseEntity.status(HttpStatus.OK).body(getXMLResultString(identifiers));
        //return convertRecordsToXML(identifiers, notFound);
/*
        if(identifiers != null && !identifiers.getListIdentifiers().getHeader().isEmpty()) {
            //return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(sets));
            return ResponseEntity.status(HttpStatus.OK).body(identifiers);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no records available.");
        }
*/
    }

    private String getXMLResultString(OAIPMHtype oaipmHtype){
        StringResult stringResult = new StringResult();
        marshaller.marshal( new ObjectFactory().createOAIPMH(oaipmHtype),stringResult );
        return stringResult.toString();
    }

    public ResponseEntity getIdentifyInfo() {
        OAIPMHtype oaipmHtype = new OAIPMHtype();
        String notFound = "There are no information available.";
        oaipmHtype = apiUtil.getIdentifyInfo();
        return ResponseEntity.status(HttpStatus.OK).body(getXMLResultString(oaipmHtype));

    }

    public ResponseEntity getRecordForIdentifierWebService(ModelMap model, String identifier, String metadataPrefix) {
        OAIPMHtype record = new OAIPMHtype();
        if (!metadataPrefix.toLowerCase().equals("oai_dc")) {
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.");
        }
        String notFound = "idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.";
        //HttpHeaders headers = new HttpHeaders();
        //Converter converter = new Converter();
        //headers.add(HttpHeaders.CONTENT_TYPE, "application/xml; charset=UTF-8");

        if (!identifier.isEmpty()) {
            List<String> identifiersList = apiUtil.getIdentifiers();
            if (identifiersList.contains(identifier)) {
                record = apiUtil.getRecord(identifier);
                return ResponseEntity.status(HttpStatus.OK).body(getXMLResultString(record));
                //return convertRecordsToXML(record, notFound);
                /*
                String body = null;
                try {
                    body = converter.convertToXml(record);
                    body = body.replaceAll("(?s)&lt;.*?&gt;", "");
                    //JAXBElement jaxbElement = null;
                    //jaxbElement.setValue(record);
                    //return ResponseEntity.status(HttpStatus.OK).headers(headers).body(record);

                } catch(Exception e) {
                    System.out.println("Error: " + e);
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
                }

                return ResponseEntity.status(HttpStatus.OK).headers(headers).body(body);
                //return ResponseEntity.status(HttpStatus.OK).body(record);
                */
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.");
            }

        } else
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The value of the  " + identifier + " argument is unknown or illegal in this repository.");

    }

    public ResponseEntity getRecordsWebService(ModelMap model, String from, String until, String metadataPrefix, String set, String resumptionToken) {
        if (!metadataPrefix.toLowerCase().equals("oai_dc")) {
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.");
        }

        // Convert UTC datetime string to date
        Date fromDate = null;
        Date untilDate = null;
        if (from != null && !from.isEmpty()) {
            try {
                fromDate = convertUtcDateTimeStringToDate(from);
            } catch (ParseException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("badArgument - The request includes illegal arguments or is missing required arguments.");
            }
        }
        if (until != null && !until.isEmpty()) {
            try {
                untilDate = convertUtcDateTimeStringToDate(until);
            } catch (ParseException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("badArgument - The request includes illegal arguments or is missing required arguments.");
            }
        }


        OAIPMHtype records = new OAIPMHtype();
        records = apiUtil.getRecords(fromDate, untilDate, metadataPrefix, set, resumptionToken);
        if(records.getListRecords().getRecord().size() == 0){
            return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body("noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.");
        }
        String notFound = "noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.";

        return ResponseEntity.status(HttpStatus.OK).body(getXMLResultString(records));
        //return convertRecordsToXML(records, notFound);
/*
        Converter converter = new Converter();
        if(records != null && !records.getListRecords().getRecord().isEmpty()) {
            String body = null;
            try {
                body = converter.convertToXml(records);
                body = body.replaceAll("(?s)&lt;.*?&gt;", "");

            } catch(Exception e) {
                System.out.println("Error: " + e);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
            }

            return ResponseEntity.status(HttpStatus.OK).body(body);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no records available.");
        }
*/
    }

    public ResponseEntity getMetadataFormatsWebService(ModelMap model, Optional<String> identifier) {
        //String identifierId = null;
        //List<String> types = null;
        OAIPMHtype types = new OAIPMHtype();
        OAIPMHtype record = new OAIPMHtype();
        String notFound = "noMetadataFormats - There are no metadata formats available for the specified item.";
        String identifierId = "";

        if(identifier.isPresent() && !identifier.toString().isEmpty()) {
            identifierId = identifier.get();
            List<String> identifiersList = apiUtil.getIdentifiers();
            if(!identifiersList.contains(identifierId)) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.");
            }
        }
        types = null;

        types = apiUtil.getMetadataFormatsAll();
        return ResponseEntity.status(HttpStatus.OK).body(getXMLResultString(types));
        //return convertRecordsToXML(types, notFound);
/*
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
*/
    }


    public ResponseEntity getSetsWebService(ModelMap model) {
        //ListSetsType sets = null;
        OAIPMHtype sets = null;
        String notFound = "noSetHierarchy - The repository does not support sets.";
        sets = apiUtil.getSets();

        return ResponseEntity.status(HttpStatus.OK).body(getXMLResultString(sets));
        //return convertRecordsToXML(sets, notFound);
/*
        if(sets != null && !sets.getListSets().getSet().isEmpty()) {
            //return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(sets));
            return ResponseEntity.status(HttpStatus.OK).body(sets);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("There are no sets available.");
        }
*/
    }

    private ResponseEntity convertRecordsToXML(OAIPMHtype records, String notFound) {
        Converter converter = new Converter();
        if (records != null) {
            String body = null;
            try {
                body = converter.convertToXml(records);
                body = body.replaceAll("(?s)&lt;.*?&gt;", "");
                //return ResponseEntity.status(HttpStatus.OK).body(records);
                return ResponseEntity.status(HttpStatus.OK).body(body);

            } catch (Exception e) {
                System.out.println("Error: " + e);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(notFound);
        }

    }
}

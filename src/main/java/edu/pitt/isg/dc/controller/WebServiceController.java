package edu.pitt.isg.dc.controller;

import com.google.gson.*;
import com.wordnik.swagger.annotations.*;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import scala.Int;

import javax.servlet.http.HttpServletRequest;
import javax.swing.text.html.Option;
import javax.ws.rs.GET;
import java.util.*;

/**
 * Created by jdl50 on 5/27/17.
 * http://localhost:8080/digital-commons/api/entry?doi=10.5281/zenodo.580101
 *
 */

@RequestMapping("/api/v1")
@Controller
@Api(value = "Identifier controller", description = "List digital objects and retrieve their data/metadata")
public class WebServiceController {
    @Autowired
    private ApiUtil apiUtil;

    @GET
    @ApiOperation(value = "Retrieves every global identifier in the MIDAS Digital Commons.", notes = "This method retrieves every global identifier in the MIDAS Digital Commons. ", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "A JSON array containing the identifiers.")
    })
    @RequestMapping(value = "/identifiers", method = RequestMethod.GET, headers = "Accept=application/json")
    public @ResponseBody
    String getIdentifiers(ModelMap model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<String> identifiers = apiUtil.getIdentifiers();
        return gson.toJson(identifiers);
    }

    @GET
    @ApiOperation(value = "Retrieves the metadata for an entry in the MIDAS Digital Commons given an identifier.", notes = "Retrieves the metadata for an entry in the MIDAS Digital Commons given an identifier.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "The metadata in JSON or XML format.")
    })
    @RequestMapping(value = "/identifiers/metadata", method = RequestMethod.GET, headers = {"Accept=application/json", "Accept=application/xml"})
    public @ResponseBody
    ResponseEntity getMetadata(ModelMap model, @RequestParam("identifier") String identifier, HttpServletRequest request) {
        String header = request.getHeader("Accept");
        String metadata = apiUtil.getMetadata(identifier, header);
        if(metadata != null) return ResponseEntity.status(HttpStatus.OK).body(metadata);
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier " + identifier + " with response content type " + header + ".");
    }
    /*    Gson gson = new GsonBuilder().setPrettyPrinting().create();
        for (RepositoryEntry entry : repository.repository) {
            String entryIdentifier = ExtractIdentifiersFromRepositoryEntry.getIdentifiers(entry);
            if (entryIdentifier != null) {
                if (entryIdentifier.equalsIgnoreCase(identifier)) {
                    JsonParser jp = new JsonParser();
                    JsonElement je = jp.parse(entry.getSourceData());
                    String response = gson.toJson(je);
                    if(request.getHeader("Accept").equalsIgnoreCase("application/xml")) {
                        if (entry.getInstance() instanceof Software) {
                            Software s = (Software) entry.getInstance();
                            Converter converter = new Converter();
                            try {
                                response = converter.convertToXml(s);
                            } catch (SerializationException | JsonProcessingException e) {
                                e.printStackTrace();
                                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Invalid configuration.");
                            }
                        } else {
                            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Invalid configuration.");
                        }
                    }
                    return ResponseEntity.status(HttpStatus.OK).body(response);

                }
            }
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier: " + identifier);
    }*/

    @GET
    @ApiOperation(value = "Retrieves the data for an entry in the MIDAS Digital Commons given an identifier and distribution index.", notes = "Retrieves the data for an entry in the MIDAS Digital Commons given an identifier and distribution index.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "You will be redirected to the data if the identifier is found.")
    })
    @RequestMapping(value = "/identifiers/data", method = RequestMethod.GET, headers = "Accept=text/html")
    public Object getData(@RequestParam("identifier") String identifier, @ApiParam(value = "The index in the list of distributions for the dataset. The index starts at 0.") @RequestParam("distributionIndex") Optional<Integer> distribution) {
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

    @GET
    @ApiOperation(value = "Retrieves the metadata type for an entry in the MIDAS Digital Commons given an identifier.", notes = "Retrieves the metadata type for an entry in the MIDAS Digital Commons given a identifier.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "A string containing the data type.")
    })
    @RequestMapping(value = "/identifiers/metadata-type", method = RequestMethod.GET, headers = "Accept=application/json")
    public Object getMetadataType(@RequestParam("identifier") String identifier) {
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

    @GET
    @ApiOperation(value = "Retrieves the contents of every public entry in the MIDAS Digital Commons.", notes = "This method retrieves the contents of every public entry in the MIDAS Digital Commons.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "A JSON array containing the contents of every public entry.")
    })
    @RequestMapping(value = "/contents", method = RequestMethod.GET, headers = "Accept=application/json")
    public @ResponseBody
    String getPublicEntryContents(ModelMap model) {
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

}

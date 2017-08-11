package edu.pitt.isg.dc.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.google.gson.*;
import com.wordnik.swagger.annotations.*;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.repository.Repository;
import edu.pitt.isg.dc.repository.RepositoryEntry;
import edu.pitt.isg.dc.repository.utils.ExtractIdentifiersFromRepositoryEntry;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.Distribution;
import edu.pitt.isg.mdc.v1_0.Software;
import edu.pitt.isg.objectserializer.exceptions.SerializationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
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
    private static Repository repository;

    static {
        repository = new Repository();
    }
    
    @GET
    @ApiOperation(value = "Retrieves every global identifier in the MIDAS Digital Commons.", notes = "This method retrieves every global identifier in the MIDAS Digital Commons. ", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "A JSON array containing the identifiers.")
    })
    @RequestMapping(value = "/identifiers", method = RequestMethod.GET, headers = "Accept=application/json")
    public @ResponseBody
    String getIdentifiers(ModelMap model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        Set<String> identifierSet = new HashSet<>();

        for (RepositoryEntry entry : repository.repository) {
            String identifier = ExtractIdentifiersFromRepositoryEntry.extractIdentifiers(entry);
            if (identifier != null) {
                identifierSet.add(identifier);
            }
        }

        List<String> sortedIdentifiers = new ArrayList<>(identifierSet);
        Collections.sort(sortedIdentifiers);
        return gson.toJson(sortedIdentifiers);
    }

    @GET
    @ApiOperation(value = "Retrieves the metadata for an entry in the MIDAS Digital Commons given an identifier.", notes = "Retrieves the metadata for an entry in the MIDAS Digital Commons given an identifier.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "The metadata in JSON or XML format.")
    })
    @RequestMapping(value = "/identifiers/metadata", method = RequestMethod.GET, headers = {"Accept=application/json", "Accept=application/xml"})
    public @ResponseBody
    ResponseEntity getMetadata(ModelMap model, @RequestParam("identifier") String identifier, HttpServletRequest request) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        for (RepositoryEntry entry : repository.repository) {
            String entryIdentifier = ExtractIdentifiersFromRepositoryEntry.extractIdentifiers(entry);
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
    }

    @GET
    @ApiOperation(value = "Retrieves the data for an entry in the MIDAS Digital Commons given an identifier and distributionId.", notes = "Retrieves the data for an entry in the MIDAS Digital Commons given an identifier and distributionId.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "You will be redirected to the data if the identifier is found.")
    })
    @RequestMapping(value = "/identifiers/data", method = RequestMethod.GET, headers = "Accept=text/html")
    public Object getData(@RequestParam("identifier") String identifier, @ApiParam(value = "The index in the list of distributions for the dataset.  The index starts at 0.") @RequestParam("distributionId") Integer distribution) {

        for (RepositoryEntry entry : repository.repository) {
            String entryIdentifier = ExtractIdentifiersFromRepositoryEntry.extractIdentifiers(entry);
            if (entryIdentifier != null) {
                if (entryIdentifier.equalsIgnoreCase(identifier)) {
                    if (entry.getInstance() instanceof Dataset) {
                        Dataset d = (Dataset) entry.getInstance();
                        for (int i = 0; i < d.getDistributions().size(); i++) {
                            if (i == distribution) {
                                Distribution dist = d.getDistributions().get(i);
                                return "redirect:" + dist.getAccess().getAccessURL();
                            }
                        }
                        //if we are here, the specified distribtuion was not found
                        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The requested distribution (" + distribution + ") was not found for identifier " + identifier);
                    } else {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("This method is only available for methods of type dataset.");
                    }
                }
            }
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier: " + identifier);
    }

    @GET
    @ApiOperation(value = "Retrieves the metadata type for an entry in the MIDAS Digital Commons given an identifier.", notes = "Retrieves the metadata type for an entry in the MIDAS Digital Commons given a identifier.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "A string containing the data type.")
    })
    @RequestMapping(value = "/identifiers/metadata-type", method = RequestMethod.GET, headers = "Accept=application/json")
    public Object getMetadataType(@RequestParam("identifier") String identifier) {

        for (RepositoryEntry entry : repository.repository) {
            String entryIdentifier = ExtractIdentifiersFromRepositoryEntry.extractIdentifiers(entry);
            if (entryIdentifier != null) {
                if (entryIdentifier.equalsIgnoreCase(identifier)) {
                    String type = "";
                    String schema = "";

                    if (entry.getInstance() instanceof Dataset) {
                        Dataset d = (Dataset) entry.getInstance();
                        type = "DATS v2.2 " + d.getClass().getSimpleName();
                        schema = "https://raw.githubusercontent.com/biocaddie/WG3-MetadataSpecifications/v2.2/json-schemas/dataset_schema.json";
                    } else if(entry.getInstance() instanceof DataStandard) {
                        DataStandard ds = (DataStandard) entry.getInstance();
                        type = "DATS v2.2 " +ds.getClass().getSimpleName();
                        schema = "https://raw.githubusercontent.com/biocaddie/WG3-MetadataSpecifications/v2.2/json-schemas/data_standard_schema.json";
                    } else if(entry.getInstance() instanceof Software) {
                        Software s = (Software) entry.getInstance();
                        type = s.getClass().getSimpleName();
                        schema = "https://raw.githubusercontent.com/midas-isg/mdc-xsd-and-types/master/src/main/resources/software.xsd";
                    }

                    JsonObject responseObj = new JsonObject();
                    responseObj.addProperty("datatype", type);
                    responseObj.addProperty("schema", schema);

                    String responseJson = responseObj.toString();
                    return ResponseEntity.status(HttpStatus.OK).body(responseJson);
                }
            }
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for identifier: " + identifier);
    }

}

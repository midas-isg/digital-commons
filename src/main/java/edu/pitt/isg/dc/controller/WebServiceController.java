package edu.pitt.isg.dc.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.wordnik.swagger.annotations.Api;
import com.wordnik.swagger.annotations.ApiOperation;
import com.wordnik.swagger.annotations.ApiParam;
import com.wordnik.swagger.annotations.ApiResponse;
import com.wordnik.swagger.annotations.ApiResponses;
import edu.pitt.isg.dc.repository.Repository;
import edu.pitt.isg.dc.repository.RepositoryEntry;
import edu.pitt.isg.dc.repository.utils.ExtractDoisFromRepositoryEntry;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.Distribution;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.ws.rs.GET;

/**
 * Created by jdl50 on 5/27/17.
 * http://localhost:8080/digital-commons/api/entry?doi=10.5281/zenodo.580101
 *
 */

@RequestMapping("/api/v1")
@Controller
@Api(value = "DOI controller", description = "List digital objects and retrieve their data/metadata")
public class WebServiceController {
    private static Repository repository;

    static {
        repository = new Repository();
    }
    @GET
    @ApiOperation(value = "Retrieves every DOI in the MIDAS Digital Commons.", notes = "This method retrieves every DOI in the MIDAS Digital Commons. ", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "A JSON array containing the DOIs.")
    })
    @RequestMapping(value = "/dois", method = RequestMethod.GET, headers = "Accept=text/html")
    public @ResponseBody
    String getDois(ModelMap model) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        //
        JsonArray jsonArray = new JsonArray();

        for (RepositoryEntry entry : repository.repository) {
            String doi = ExtractDoisFromRepositoryEntry.execute(entry);
            if (doi != null) {
                jsonArray.add(doi);
            }
        }


        JsonParser jp = new JsonParser();
        JsonElement je = jp.parse(jsonArray.toString());
        return gson.toJson(je);
    }

    @GET
    @ApiOperation(value = "Retrieves the metadata for an entry in the MIDAS Digital Commons given a DOI.", notes = "Retrieves the metadata for an entry in the MIDAS Digital Commons given a DOI.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "The metadata in JSON format.")
    })
    @RequestMapping(value = "/dois/metadata", method = RequestMethod.GET, headers = "Accept=text/html")
    public @ResponseBody
    ResponseEntity getDois(ModelMap model, @RequestParam("doi") String doi) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        for (RepositoryEntry entry : repository.repository) {
            String entryDoi = ExtractDoisFromRepositoryEntry.execute(entry);
            if (entryDoi != null) {
                if (entryDoi.equalsIgnoreCase(doi)) {
                    JsonParser jp = new JsonParser();
                    JsonElement je = jp.parse(entry.getSourceData());
                    return ResponseEntity.status(HttpStatus.OK).body(gson.toJson(je));

                }
            }
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for DOI: " + doi);

    }

    @GET
    @ApiOperation(value = "Retrieves the data for an entry in the MIDAS Digital Commons given a DOI.", notes = "Retrieves the data for an entry in the MIDAS Digital Commons given a DOI.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "You will be redirected to the data if the DOI is found.")
    })
    @RequestMapping(value = "/dois/data", method = RequestMethod.GET, headers = "Accept=text/html")
    public Object getDois(@RequestParam("doi") String doi, @ApiParam(value = "The index in the list of distributions for the dataset.  The index starts at 0.") @RequestParam("distributionId") Integer distribution) {

        for (RepositoryEntry entry : repository.repository) {
            String entryDoi = ExtractDoisFromRepositoryEntry.execute(entry);
            if (entryDoi != null) {
                if (entryDoi.equalsIgnoreCase(doi)) {
                    if (entry.getInstance() instanceof Dataset) {
                        Dataset d = (Dataset) entry.getInstance();
                        for (int i = 0; i < d.getDistributions().size(); i++) {
                            if (i == distribution) {
                                Distribution dist = d.getDistributions().get(i);
                                return "redirect:" + dist.getAccess().getAccessURL();
                            }
                        }
                        //if we are here, the specified distribtuion was not found
                        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The requested distribution (" + distribution + ") was not found for doi " + doi);
                    } else {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("This method is only available for methods of type dataset.");
                    }
                }
            }
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No entry found for DOI: " + doi);
    }

}

package edu.pitt.isg.dc.controller;

//import com.google.gson.*;
import com.wordnik.swagger.annotations.*;
//import edu.pitt.isg.dc.entry.Category;
//import edu.pitt.isg.dc.entry.Entry;
//import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DigitalCommonsHelper;
import edu.pitt.isg.mdc.v1_0.Software;
import org.openarchives.oai._2.OAIPMHtype;
import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import java.util.*;
import edu.pitt.isg.dc.utils.WebService;

/**
 * Created by jbs82 on 4/9/18.
 * http://localhost:8080/digital-commons/api/entry?doi=10.5281/zenodo.580101
 *
 */

@RequestMapping("/api/v1")
@Controller
@Api(value = "Identifier controller", description = "List digital objects and retrieve their data/metadata")
public class WebServiceOAIPMHController {
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private WebService webService;

    @GET
    @ApiOperation(value = "Retrieves the metadata for an entry in the MIDAS Digital Commons given an identifier.", notes = "Retrieves the metadata for an entry in the MIDAS Digital Commons given an identifier.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "The metadata in XML format.")
    })
    @RequestMapping(value = "/GetRecord", method = RequestMethod.GET, headers = {"Accept=application/xml"})
    public @ResponseBody
    ResponseEntity getRecord(ModelMap model, @RequestParam("identifier") String identifier) {
        //return DigitalCommonsHelper.jsonToXml(webService.getRecordForIdentifierWebService(model, identifier));
        return webService.getRecordForIdentifierWebService(model, identifier);
    }

    @GET
    @ApiOperation(value = "Retrieves information about the MIDAS Digital Commons.", notes = "This method retrieves information about MIDAS Digital Commons.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "XML information about the MIDAS Digital Commons")
    })
    @RequestMapping(value = "/Identify", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getIdentify(ModelMap model) {
        return webService.getIdentifyInfo();
    }


    @GET
    @ApiOperation(value = "Retrieves every global identifier in the MIDAS Digital Commons.", notes = "This method retrieves every global identifier in the MIDAS Digital Commons. ", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "XML containing the identifiers.")
    })
    @RequestMapping(value = "/ListIdentifiers", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getIdentifiers(ModelMap model) {
        return webService.getIdentifiersWebService(model);
    }

    @GET
    @ApiOperation(value = "Retrieves the contents of every public entry in the MIDAS Digital Commons.", notes = "This method retrieves the contents of every public entry in the MIDAS Digital Commons.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "XML containing the contents of every public entry.")
    })
    @RequestMapping(value = "/ListRecords", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getRecords(ModelMap model) {
        return webService.getRecordsWebService(model);
    }

    @GET
    @ApiOperation(value = "Retrieves every Metadata Format in the MIDAS Digital Commons.", notes = "This method retrieves every Metadata Format in the MIDAS Digital Commons. ", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "XML containing Metadata Formats.")
    })
    @RequestMapping(value = "/ListMetaDataFormats", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    //ResponseEntity<String> getMetaDataFormats(ModelMap model, @RequestParam("identifier") Optional<String> identifier) {
    ResponseEntity getMetaDataFormats(ModelMap model, @RequestParam("identifier") Optional<String> identifier) {
        return webService.getMetadataFormatsWebService(model, identifier);
    }

    @GET
    @ApiOperation(value = "Retrieves the set structure of the MIDAS Digital Commons.", notes = "This method retrieves the set structure of the MIDAS Digital Commons.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "XML containing the set structure of MIDAS Digital Commons")
    })
    @RequestMapping(value = "/ListSets", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getSetsWebService(ModelMap model) {
        return webService.getSetsWebService(model);
    }

}

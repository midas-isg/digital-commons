package edu.pitt.isg.dc.controller;

import com.wordnik.swagger.annotations.*;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.WebService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.ws.rs.GET;
import java.util.Optional;


/**
 * Created by jbs82 on 4/9/18.
 * http://localhost:8080/digital-commons/api/entry?doi=10.5281/zenodo.580101
 */

@RequestMapping("/api/v2")
@Controller
@Api(value = "OAI-PMH controller", description = "an application-independent interoperability framework based on metadata harvesting")
public class WebServiceOAIPMHController {
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private WebService webService;

    @GET
    @ApiOperation(value = "Retrieves an individual metadata record from the repository.", notes = "Required arguments specify the identifier of the item from which the record is requested and the format of the metadata that should be included in the record.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "An XML document containing an individual metadata record from the repository."),
            @ApiResponse(code = 422, message = "badArgument - The request includes illegal arguments or is missing required arguments.<br><br>" +
                    "cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.<br><br>" +
                    "idDoesNotExist - The request includes illegal arguments or is missing required arguments."),

    })
    @RequestMapping(value = "/GetRecord", method = RequestMethod.GET, headers = {"Accept=application/xml"})
    public @ResponseBody
    ResponseEntity getRecord(ModelMap model, @ApiParam(value = "specifies the unique identifier of the item in the repository from which the record will be disseminated.") @RequestParam("identifier") String identifier, @ApiParam("specifies the metadataPrefix of the format (e.g. \"oai_dc\") that will be included in the metadata part of the returned record.") @RequestParam("metadataPrefix") String metadataPrefix) {
        //return DigitalCommonsHelper.jsonToXml(webService.getRecordForIdentifierWebService(model, identifier));
        return webService.getRecordForIdentifierWebService(model, identifier);
    }

    @GET
    @ApiOperation(value = "Retrieves information about the repository.", notes = "The information that is returned is required as part of the OAI-PMH.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "An XML document containing information about the repository."),
            @ApiResponse(code = 422, message = "badArgument - The request includes illegal arguments or is missing required arguments."),
    })
    @RequestMapping(value = "/Identify", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getIdentify(ModelMap model) {
        return webService.getIdentifyInfo();
    }


    @GET
    @ApiOperation(value = "Retrieves the headers of every item in the repository. ", notes = " Optional arguments permit selective harvesting of headers based on set membership and/or datestamp. <br>" +
            "A header contains the unique identifier of the item and properties necessary for selective harvesting. The header consists of the unique identifier of the item, a datestamp marking creation, modification or deletion time of the record, and the set membership of the item."
            , response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "An XML document that contains the headers of every item in the repository."),
            @ApiResponse(code = 422, message = "badArgument - The request includes illegal arguments or is missing required arguments.<br><br>" +
                    "badResumptionToken - The value of the resumptionToken argument is invalid or expired.<br><br> " +
                    "cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.<br><br>" +
                    "noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.<br><br>" +
                    "noSetHierarchy - The repository does not support sets."),
            @ApiResponse(code = 404, message = "idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.")
    })
    @RequestMapping(value = "/ListIdentifiers", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getIdentifiers(ModelMap model,
                                  @ApiParam(required = false, value = "[optional] an argument with a UTCdatetime value, which specifies a lower bound for datestamp-based selective harvesting") @RequestParam("from") String from,
                                  @ApiParam(required = false, value = "[optional] an argument with a UTCdatetime value, which specifies a upper bound for datestamp-based selective harvesting.") @RequestParam("until") String until,
                                  @ApiParam(required = true, value = "[required] an argument, which specifies that headers should be returned only if the metadata format matching the supplied metadataPrefix is available or, depending on the repository's support for deletions, has been deleted. The metadata formats supported by a repository and for a particular item can be retrieved using the ListMetadataFormats request.") @RequestParam("metadataPrefix") String metadataPrefix,
                                  @ApiParam(required = false, value = "[optional] an argument with a setSpec value, which specifies set criteria for selective harvesting.") @RequestParam("set") String set,
                                  @ApiParam(required = false, value = "[optional] an argument with a value that is the flow control token returned by a previous ListIdentifiers request that issued an incomplete list.") @RequestParam("resumptionToken") String resumptionToken) {
        return webService.getIdentifiersWebService(model);
    }

    @GET
    @ApiOperation(value = "Returns multiple records from the repository.", notes = "Optional arguments permit selective harvesting of records based on set membership and/or datestamp. Depending on the repository's support for deletions, a returned header may have a status attribute of \"deleted\" if a record matching the arguments specified in the request has been deleted. No metadata will be present for records with deleted status.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "An XML document containing records from the repository."),
            @ApiResponse(code = 422, message = "badArgument - The request includes illegal arguments or is missing required arguments.<br><br>" +
            "badResumptionToken - The value of the resumptionToken argument is invalid or expired.<br><br> " +
            "cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.<br><br>" +
            "noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.<br><br>" +
            "noSetHierarchy - The repository does not support sets."),
            @ApiResponse(code = 404, message = "idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.")
    })
    @RequestMapping(value = "/ListRecords", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getRecords(ModelMap model,
                              @ApiParam(required = false, value = "[optional] an argument with a UTCdatetime value, which specifies a lower bound for datestamp-based selective harvesting") @RequestParam("from") String from,
                              @ApiParam(required = false, value = "[optional] an  argument with a UTCdatetime value, which specifies a upper bound for datestamp-based selective harvesting.") @RequestParam("until") String until,
                              @ApiParam(required = true, value = "[required] an argument, which specifies that headers should be returned only if the metadata format matching the supplied metadataPrefix is available or, depending on the repository's support for deletions, has been deleted. The metadata formats supported by a repository and for a particular item can be retrieved using the ListMetadataFormats request.") @RequestParam("metadataPrefix") String metadataPrefix,
                              @ApiParam(required = false, value = "[optional] an argument with a setSpec value, which specifies set criteria for selective harvesting.") @RequestParam("set") String set,
                              @ApiParam(required = false, value = "[optional] an argument with a value that is the flow control token returned by a previous ListIdentifiers request that issued an incomplete list.") @RequestParam("resumptionToken") String resumptionToken) {
        return webService.getRecordsWebService(model, metadataPrefix);
    }


    @GET
    @ApiOperation(value = "Retrieves the metadata formats available from the repository.", notes = "An optional argument restricts the request to the formats available for a specific item.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "An XML document containing a list of metadata formats."),
            @ApiResponse(code = 422, message = "badArgument - The request includes illegal arguments or is missing required arguments.<br><br>" +
                    "noMetadataFormats - There are no metadata formats available for the specified item."),
            @ApiResponse(code = 404, message = "idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.")
    })
    @RequestMapping(value = "/ListMetaDataFormats", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
        //ResponseEntity<String> getMetaDataFormats(ModelMap model, @RequestParam("identifier") Optional<String> identifier) {
    ResponseEntity getMetaDataFormats(ModelMap model, @ApiParam(required = false, value = "[optional] argument that specifies the unique identifier of the item for which available metadata formats are being requested. If this argument is omitted, then the response includes all metadata formats supported by this repository. Note that the fact that a metadata format is supported by a repository does not mean that it can be disseminated from all items in the repository.") @RequestParam("identifier") Optional<String> identifier) {
        return webService.getMetadataFormatsWebService(model, identifier);
    }

    @GET
    @ApiOperation(value = "Retrieves the set structure of the MIDAS Digital Commons.", notes = "This method retrieves the set structure of the MIDAS Digital Commons.", response = String.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "XML containing the set structure of MIDAS Digital Commons"),
            @ApiResponse(code = 422, message = "badArgument - The request includes illegal arguments or is missing required arguments.<br><br>" +
                    "badResumptionToken - The value of the resumptionToken argument is invalid or expired.<br><br> " +
                    "noSetHierarchy - The repository does not support sets."),
    })
    @RequestMapping(value = "/ListSets", method = RequestMethod.GET, headers = "Accept=application/xml")
    public @ResponseBody
    ResponseEntity getSetsWebService(ModelMap model,
                                     @ApiParam(required = false, value = "[optional] an argument with a value that is the flow control token returned by a previous ListSets request that issued an incomplete list.") @RequestParam("resumptionToken") String resumptionToken) {
        return webService.getSetsWebService(model);
    }

}

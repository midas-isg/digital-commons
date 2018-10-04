package edu.pitt.isg.dc.controller;


import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.component.DCEmailService;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.dc.validator.*;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.v1_0.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.webflow.execution.RequestContext;
import org.springframework.webflow.execution.RequestContextHolder;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Date;
import java.util.Properties;

import static edu.pitt.isg.dc.controller.Auth0Controller.ISG_ADMIN_TOKEN;
import static edu.pitt.isg.dc.controller.Auth0Controller.MDC_EDITOR_TOKEN;
import static edu.pitt.isg.dc.controller.HomeController.*;

/**
 * Created by TPS23 on 5/10/2017.
 */

@ApiIgnore
@Controller
public class DataEntryController {

    private static final String[] XSD_FILES = {
            "software.xsd",
            "dats.xsd"
    };
    private static final String XSD_FORMS_PATH;
    private static final String OUTPUT_DIRECTORY;
    private static final String DC_ENTRY_REQUESTS_LOG;
    private static boolean GENERATE_XSD_FORMS = true;
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }

    static {
        String outputDirectory = "";
        String xsdFormsPath = "";
        String dcEntryRequestsLog = "";
        Properties dataEntryConfig = new Properties();

        try {
            dataEntryConfig.load(DCEmailService.class.getClassLoader()
                    .getResourceAsStream("config.properties"));
            outputDirectory = dataEntryConfig.getProperty("outputDirectory");
            xsdFormsPath = dataEntryConfig.getProperty("xsdFormsPath");
            dcEntryRequestsLog = dataEntryConfig.getProperty("dcEntryRequestsLog");
        } catch (Exception exception) {
            System.err.print(exception);
        }

        OUTPUT_DIRECTORY = outputDirectory;
        XSD_FORMS_PATH = xsdFormsPath;
        DC_ENTRY_REQUESTS_LOG = dcEntryRequestsLog;
    }
    @Autowired
    EntrySubmissionInterface entrySubmissionInterface;
    @Autowired
    UsersSubmissionInterface usersSubmissionInterface;
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private EntryRepository repo;
    private Converter converter = new Converter();
    @Autowired
    private ServletContext context;
    @Autowired
    private CategoryHelper categoryHelper;
    @Autowired
    private DataGovInterface dataGovInterface;


    @RequestMapping(value = "/add-entry", method = RequestMethod.POST)
    public @ResponseBody
    String addNewEntry(@RequestParam(value = "datasetType", required = false) String datasetType,
                       @RequestParam(value = "customValue", required = false) String customValue, HttpServletRequest request, HttpSession session) throws Exception {
        Date date = new Date();
        Converter xml2JSONConverter = new Converter();

        Long category = null, entryId = null, revisionId = null;
        try {
            category = Long.valueOf(java.net.URLDecoder.decode(request.getParameter("categoryValue"), "UTF-8"));
            entryId = Long.valueOf(java.net.URLDecoder.decode(request.getParameter("entryId"), "UTF-8"));
            revisionId = Long.valueOf(java.net.URLDecoder.decode(request.getParameter("revisionId"), "UTF-8"));
        } catch (NumberFormatException e) {
            // pass
        }

        String xmlString = java.net.URLDecoder.decode(request.getParameter("xmlString"), "UTF-8");
        xmlString = xmlString.substring(0, xmlString.lastIndexOf('>') + 1);

        String jsonString = null;

//        System.out.println(xmlString);
        try {
            jsonString = xml2JSONConverter.xmlToJson(xmlString, false);
        } catch (Exception exception) {
            exception.printStackTrace();
        }

        if (jsonString.length() > 0) {
            JsonParser parser = new JsonParser();
            JsonObject entry = parser.parse(jsonString).getAsJsonObject();

            EntryView entryObject = new EntryView();
            entryObject.setProperty("type", entry.get("class").getAsString());

            entry.remove("class");
            entryObject.setEntry(entry);

            Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

            entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, category, user, ENTRIES_AUTHENTICATION);

            //E-mail to someone it concerns
            DCEmailService emailService = new DCEmailService();
            emailService.mailToAdmin("[Digital Commons New Entry Request] " + date, jsonString);
        }

        return jsonString;
    }


    @RequestMapping(value = "/add-data-gov-record-by-id", method = RequestMethod.GET)
    public String addNewEntryFromDataGov(HttpSession session, Model model) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        //model.addAttribute("category", category);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }

        return "addDataGovRecordById";
    }

    @RequestMapping(value = "/add-datagov-entry", method = RequestMethod.POST)
    public String addNewEntry(HttpServletRequest request, HttpSession session, Model model) throws Exception {
        Long category = null;
        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        try {
            category = Long.valueOf(java.net.URLDecoder.decode(request.getParameter("category"), "UTF-8"));
        } catch (NumberFormatException e) {
            // pass
        }

        String catalogURL = java.net.URLDecoder.decode(request.getParameter("catalogURL"), "UTF-8");
        String dataGovIdentifier = java.net.URLDecoder.decode(request.getParameter("identifier_from_data_gov"), "UTF-8");
        String title = java.net.URLDecoder.decode(request.getParameter("title"), "UTF-8");

        String result = dataGovInterface.submitDataGovEntry(user, catalogURL, category, dataGovIdentifier, title);

        //E-mail to someone it concerns
        //Date date = new Date();
        //DCEmailService emailService = new DCEmailService();
        //emailService.mailToAdmin("[Digital Commons New Entry Request] " + date, result);

        model.addAttribute("returnMessasge", result);

        return "reviewDataGovEntry";
    }


}

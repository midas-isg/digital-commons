package edu.pitt.isg.dc.controller;


import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.component.DCEmailService;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.security.service.UserService;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import static edu.pitt.isg.dc.controller.Interceptor.ifISGAdmin;
import static edu.pitt.isg.dc.controller.Interceptor.ifMDCEditor;

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
    private EntryService repo;
    private Converter converter = new Converter();
    @Autowired
    private ServletContext context;
    @Autowired
    private CategoryHelper categoryHelper;
    @Autowired
    private DataGovInterface dataGovInterface;
    @Autowired
    private UserService userService;

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

            Users user = userService.findUserForSubmissionByUserId(session.getAttribute("username").toString());
//            Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

            entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, category, user, ENTRIES_AUTHENTICATION);

            //E-mail to someone it concerns
            DCEmailService emailService = new DCEmailService();
            emailService.mailToAdmin("[Digital Commons New Entry Request] " + date, jsonString);
        }

        return jsonString;
    }


    @RequestMapping(value = "/add-data-gov-record-by-id", method = RequestMethod.GET)
    public String addNewEntryFromDataGov(HttpSession session, Model model) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths("AllEntries"));
        //model.addAttribute("category", category);

        if (!ifISGAdmin(session) && !ifMDCEditor(session)) {
            return "accessDenied";
        }

        return "addDataGovRecordById";
    }

    @RequestMapping(value = "/add-datagov-entry", method = RequestMethod.POST)
    public String addNewEntry(HttpServletRequest request, HttpSession session, Model model) throws Exception {
        Long category = null;
        Users user = userService.findByUserId(session.getAttribute("username").toString());
//        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

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

    @RequestMapping(value="/get-autocomplete-list", method = RequestMethod.GET)
    @ResponseBody
    public List getAutoCompleteList(@RequestParam("type") String type, @RequestParam("subType") String subType, HttpServletRequest request, HttpServletResponse response) {
        if (type.equalsIgnoreCase("license")) {
            if (subType.equalsIgnoreCase("dataFormats")) {
                return repo.findDataFormatsLicenses();
            } else if (subType.equalsIgnoreCase("dataRepository")) {
                return repo.findDataRepositoryLicenses();
            }
        }
        return null;
//       return apiUtil.getLicenseList(subType);
    }

}

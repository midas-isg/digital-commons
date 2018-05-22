package edu.pitt.isg.dc.controller;

import com.github.davidmoten.xsdforms.Generator;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.component.DCEmailService;
import edu.pitt.isg.dc.entry.DataGovInterface;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
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

    private static boolean GENERATE_XSD_FORMS = true;
    private static final String[] XSD_FILES = {
            "software.xsd",
            "dats.xsd"
    };

    @Autowired
    private ApiUtil apiUtil;

    private Converter converter = new Converter();

    private static final String XSD_FORMS_PATH;
    private static final String OUTPUT_DIRECTORY;
    private static final String DC_ENTRY_REQUESTS_LOG;

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
    private ServletContext context;

    @Autowired
    private CategoryHelper categoryHelper;

    @Autowired
    private DataGovInterface dataGovInterface;

    @Component
    public class StartupHousekeeper implements ApplicationListener<ContextRefreshedEvent> {
        @Override
        public void onApplicationEvent(final ContextRefreshedEvent event) {
            try {
                readXSDFiles(context);
            } catch (Exception e) {

            }
        }
    }

    @RequestMapping(value = "/test-add-entry", method = RequestMethod.GET)
    public String testAddNewEntry(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        Dataset dataset = new Dataset();
        if(entryId != null) {
            Entry entry = apiUtil.getEntryById(entryId);
            EntryView entryView = new EntryView(entry);

            dataset =converter.convertToJavaDataset(entryView.getUnescapedEntryJsonString());
        }
        model.addAttribute("dataset", dataset);

        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "newDigitalObjectForm";
    }

    @RequestMapping(value = "/testAddDataset", method = RequestMethod.POST)
    public String submit(@Valid @ModelAttribute("dataset") Dataset dataset,
                         BindingResult result, ModelMap model) {
        if (result.hasErrors()) {
            return "error";
        }
//        model.addAttribute("name", employee.getName());
//        model.addAttribute("contactNumber", employee.getContactNumber());
//        model.addAttribute("id", employee.getId());
        return "dataset";
    }

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
            jsonString = xml2JSONConverter.xmlToJson(xmlString);
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

    private static void generateForm(String xsdFile, String rootElementName, ApplicationContext appContext, ServletContext context) throws IOException {
        InputStream schema;
        String idPrefix = "";
        String htmlString;
        scala.Option<String> rootElement;

        if (rootElementName != null) {
            rootElement = scala.Option.apply(rootElementName);

            schema = appContext.getResource(xsdFile).getInputStream();
            htmlString = Generator.generateHtmlAsString(schema, idPrefix, rootElement);
            schema.close();
            writeFormToPath(context.getRealPath("/WEB-INF/views/"), rootElementName, htmlString);
        }
    }

    private static void writeFormToPath(String realPath, String className, String htmlString) {
        Path path = FileSystems.getDefault().getPath(realPath, className + ".jsp");
        Charset charset = Charset.forName("US-ASCII");
        try (BufferedWriter writer = Files.newBufferedWriter(path, charset)) {
            writer.write(htmlString, 0, htmlString.length());
        } catch (IOException x) {
            System.err.format("IOException: %s%n", x);
        }
    }

    public static String readXSDFiles(ServletContext context) throws Exception {
        ApplicationContext appContext = new ClassPathXmlApplicationContext(new String[]{});
        InputStream schema;
        DocumentBuilderFactory dbFactory;
        DocumentBuilder dBuilder;
        Document document;
        String rootElementName;
        String typeList = "";

        for (int i = 0; i < XSD_FILES.length; i++) {
            typeList += (XSD_FILES[i] + ":");
            schema = appContext.getResource(XSD_FILES[i]).getInputStream();
            dbFactory = DocumentBuilderFactory.newInstance();
            dBuilder = dbFactory.newDocumentBuilder();
            document = dBuilder.parse(schema);
            schema.close();

            NodeList nodes = document.getElementsByTagName("schema").item(0).getChildNodes();
            int nodesLength = nodes.getLength();

            for (int j = 0; j < nodesLength; j++) {
                if (nodes.item(j).getNodeName().equals("element")) {
                    rootElementName = nodes.item(j).getAttributes().getNamedItem("name").getNodeValue();
                    typeList += (rootElementName + ";");

                    if (GENERATE_XSD_FORMS) {
                        generateForm(XSD_FILES[i], rootElementName, appContext, context);
                    }
                }
            }
            typeList += "-";
        }

        GENERATE_XSD_FORMS = false;

        return typeList;
    }

    @RequestMapping(value = "/addDataGovRecordById", method = RequestMethod.GET)
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

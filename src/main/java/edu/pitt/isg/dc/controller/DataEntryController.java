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
import edu.pitt.isg.mdc.dats2_2.Annotation;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.v1_0.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
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
    @Autowired
    private EntryRepository repo;
    @Autowired
    DatasetValidator datasetValidator;
    @Autowired
    DataFormatConverterValidator dataFormatConverterValidator;
    @Autowired
    DataServiceValidator dataServiceValidator;
    @Autowired
    DataVisualizerValidator dataVisualizerValidator;
    @Autowired
    DiseaseForecasterValidator diseaseForecasterValidator;
    @Autowired
    DiseaseTransmissionModelValidator diseaseTransmissionModelValidator;
    @Autowired
    DiseaseTransmissionTreeEstimatorValidator diseaseTransmissionTreeEstimatorValidator;
    @Autowired
    MetagenomicAnalysisValidator metagenomicAnalysisValidator;
    @Autowired
    ModelingPlatformValidator modelingPlatformValidator;
    @Autowired
    PathogenEvolutionModelValidator pathogenEvolutionModelValidator;
    @Autowired
    PhylogeneticTreeConstructorValidator phylogeneticTreeConstructorValidator;
    @Autowired
    PopulationDynamicsModelValidator populationDynamicsModelValidator;
    @Autowired
    SyntheticEcosystemConstructorValidator syntheticEcosystemConstructorValidator;
    @Autowired
    DataStandardValidator dataStandardValidator;

    @InitBinder("dataset")
    protected void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(datasetValidator);
    }

    @InitBinder("dataFormatConverters")
    protected void initBinderDataFormatConverters(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(dataFormatConverterValidator);
    }

    @InitBinder("dataService")
    protected void initBinderDataService(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(dataServiceValidator);
    }

    @InitBinder("dataVisualizer")
    protected void initBinderDataVisualizer(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(dataVisualizerValidator);
    }

    @InitBinder("diseaseForecaster")
    protected void initBinderDiseaseForecaster(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(diseaseForecasterValidator);
    }

    @InitBinder("diseaseTransmissionModel")
    protected void initBinderDiseaseTransmissionModel(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(diseaseTransmissionModelValidator);
    }

    @InitBinder("diseaseTransmissionTreeEstimator")
    protected void initBinderDiseaseTransmissionTreeEstimator(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(diseaseTransmissionTreeEstimatorValidator);
    }

    @InitBinder("metagenomicAnalysis")
    protected void initBinderMetagenomicAnalysis(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(metagenomicAnalysisValidator);
    }

    @InitBinder("modelingPlatform")
    protected void initBinderModelingPlatform(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(modelingPlatformValidator);
    }

    @InitBinder("pathogenEvolutionModel")
    protected void initBinderPathogenEvolutionModel(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(pathogenEvolutionModelValidator);
    }

    @InitBinder("phylogeneticTreeConstructor")
    protected void initBinderPhylogeneticTreeConstructor(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(phylogeneticTreeConstructorValidator);
    }

    @InitBinder("populationDynamicsModel")
    protected void initBinderPopulationDynamicsModel(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(populationDynamicsModelValidator);
    }

    @InitBinder("syntheticEcosystemConstructor")
    protected void initBinderSyntheticEcosystemConstructor(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(syntheticEcosystemConstructorValidator);
    }

    @InitBinder("dataStandard")
    protected void initBinderDataStandard(WebDataBinder binder) {
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
        binder.registerCustomEditor(String.class, new CustomDatasetEditor());
        binder.setValidator(dataStandardValidator);
    }


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

    @RequestMapping(value = "/addDataset", method = RequestMethod.GET)
    public String addNewDataset(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        Dataset dataset = new Dataset();
        model.addAttribute("categoryID", 0);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
            model.addAttribute("categoryID", entry.getCategory().getId());
        } else dataset = DatasetFactory.createDatasetForWebFlow(dataset);
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

        return "datasetForm";
    }

    @RequestMapping(value = "/addDataset/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("dataset") @Validated Dataset dataset,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {

        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            return "datasetForm";
        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(Dataset.class, dataset);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", dataset.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);
        return "entryConfirmation";
    }


   /* @RequestMapping(value = "/addDatasetWithOrganization", method = RequestMethod.GET)
    public String addNewDatasetWithOrganization(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DatasetWithOrganization datasetWithOrganization = new DatasetWithOrganization();
        model.addAttribute("categoryID", 0);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            datasetWithOrganization = converter.convertToJavaDatasetWithOrganization(entryView.getUnescapedEntryJsonString());
            model.addAttribute("categoryID", entry.getCategory().getId());
        }
        model.addAttribute("datasetWithOrganization", datasetWithOrganization);

        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "datasetWithOrganizationForm";
    }*/

  /*  @RequestMapping(value = "/addDatasetWithOrganization/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("datasetWithOrganization") @Validated Dataset datasetWithOrganization,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            return "datasetWithOrganizationForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(Dataset.class, datasetWithOrganization);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", datasetWithOrganization.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }*/



    @RequestMapping(value = "/addDataFormatConverters", method = RequestMethod.GET)
    public String addNewDataFormatConverters(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DataFormatConverters dataFormatConverters = new DataFormatConverters();
        model.addAttribute("categoryID", 6);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            dataFormatConverters = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DataFormatConverters.class);
            model.addAttribute("software", dataFormatConverters);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("dataFormatConverters", dataFormatConverters);

        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "dataFormatConvertersForm";
    }

    @RequestMapping(value = "/addDataFormatConverters/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("dataFormatConverters") @Validated DataFormatConverters dataFormatConverters,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", dataFormatConverters);
            return "dataFormatConvertersForm";

        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DataFormatConverters.class, dataFormatConverters);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", dataFormatConverters.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addDataService", method = RequestMethod.GET)
    public String addNewDataService(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DataService dataService = new DataService();
        model.addAttribute("categoryID", 7);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            dataService = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DataService.class);
            model.addAttribute("software", dataService);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("dataService", dataService);
        model.addAttribute("accessPointTypes", DataServiceAccessPointType.values());
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "dataServiceForm";
    }

    @RequestMapping(value = "/addDataService/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("dataService") @Validated DataService dataService,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {

        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("accessPointTypes", DataServiceAccessPointType.values());
            model.addAttribute("software", dataService);
            return "dataServiceForm";
        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DataService.class, dataService);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", dataService.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addDataVisualizers", method = RequestMethod.GET)
    public String addNewDataVisualizer(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DataVisualizers dataVisualizer = new DataVisualizers();
        model.addAttribute("categoryID", 8);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            dataVisualizer = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DataVisualizers.class);
            model.addAttribute("software", dataVisualizer);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("dataVisualizer", dataVisualizer);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }

        return "dataVisualizerForm";
    }

    @RequestMapping(value = "/addDataVisualizers/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("dataVisualizer") @Validated DataVisualizers dataVisualizer,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", dataVisualizer);
            return "dataVisualizerForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DataVisualizers.class, dataVisualizer);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", dataVisualizer.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addDiseaseForecasters", method = RequestMethod.GET)
    public String addNewDiseaseForecaster(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DiseaseForecasters diseaseForecaster = new DiseaseForecasters();
        model.addAttribute("categoryID", 9);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            diseaseForecaster = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DiseaseForecasters.class);
            model.addAttribute("software", diseaseForecaster);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("diseaseForecaster", diseaseForecaster);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "diseaseForecasterForm";
    }

    @RequestMapping(value = "/addDiseaseForecasters/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("diseaseForecaster") @Validated DiseaseForecasters diseaseForecaster,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", diseaseForecaster);
            return "diseaseForecasterForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DiseaseForecasters.class, diseaseForecaster);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", diseaseForecaster.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addDiseaseTransmissionModel", method = RequestMethod.GET)
    public String addNewDiseaseTransmissionModel(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DiseaseTransmissionModel diseaseTransmissionModel = new DiseaseTransmissionModel();
        model.addAttribute("categoryID", 10);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            diseaseTransmissionModel = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DiseaseTransmissionModel.class);
            model.addAttribute("software", diseaseTransmissionModel);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("diseaseTransmissionModel", diseaseTransmissionModel);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "diseaseTransmissionModelForm";
    }

    @RequestMapping(value = "/addDiseaseTransmissionModel/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("diseaseTransmissionModel") @Validated DiseaseTransmissionModel diseaseTransmissionModel,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", diseaseTransmissionModel);
            return "diseaseTransmissionModelForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DiseaseTransmissionModel.class, diseaseTransmissionModel);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", diseaseTransmissionModel.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addDiseaseTransmissionTreeEstimators", method = RequestMethod.GET)
    public String addNewDiseaseTransmissionTreeEstimators(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DiseaseTransmissionTreeEstimators diseaseTransmissionTreeEstimator = new DiseaseTransmissionTreeEstimators();
        model.addAttribute("categoryID", 12);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            diseaseTransmissionTreeEstimator = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DiseaseTransmissionTreeEstimators.class);
            model.addAttribute("software", diseaseTransmissionTreeEstimator);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("diseaseTransmissionTreeEstimator", diseaseTransmissionTreeEstimator);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "diseaseTransmissionTreeEstimatorForm";
    }

    @RequestMapping(value = "/addDiseaseTransmissionTreeEstimators/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("diseaseTransmissionTreeEstimator") @Validated DiseaseTransmissionTreeEstimators diseaseTransmissionTreeEstimator,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", diseaseTransmissionTreeEstimator);
            return "diseaseTransmissionTreeEstimatorForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DiseaseTransmissionTreeEstimators.class, diseaseTransmissionTreeEstimator);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", diseaseTransmissionTreeEstimator.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addMetagenomicAnalysis", method = RequestMethod.GET)
    public String addNewMetagenomicAnalysis(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        MetagenomicAnalysis metagenomicAnalysis = new MetagenomicAnalysis();
        model.addAttribute("categoryID", 448);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            metagenomicAnalysis = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), MetagenomicAnalysis.class);
            model.addAttribute("software", metagenomicAnalysis);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("metagenomicAnalysis", metagenomicAnalysis);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "metagenomicAnalysisForm";
    }

    @RequestMapping(value = "/addMetagenomicAnalysis/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("metagenomicAnalysis") @Validated MetagenomicAnalysis metagenomicAnalysis,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", metagenomicAnalysis);
            return "metagenomicAnalysisForm";
        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(MetagenomicAnalysis.class, metagenomicAnalysis);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", metagenomicAnalysis.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addModelingPlatforms", method = RequestMethod.GET)
    public String addNewModelingPlatform(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        ModelingPlatforms modelingPlatform = new ModelingPlatforms();
        model.addAttribute("categoryID", 13);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            modelingPlatform = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), ModelingPlatforms.class);
            model.addAttribute("software", modelingPlatform);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("modelingPlatform", modelingPlatform);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "modelingPlatformForm";
    }

    @RequestMapping(value = "/addModelingPlatforms/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("modelingPlatform") @Validated ModelingPlatforms modelingPlatform,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", modelingPlatform);
            return "modelingPlatformForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(ModelingPlatforms.class, modelingPlatform);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", modelingPlatform.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addPathogenEvolutionModels", method = RequestMethod.GET)
    public String addNewPathogenEvolutionModel(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        PathogenEvolutionModels pathogenEvolutionModel = new PathogenEvolutionModels();
        model.addAttribute("categoryID", 14);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            pathogenEvolutionModel = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), PathogenEvolutionModels.class);
            model.addAttribute("software", pathogenEvolutionModel);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("pathogenEvolutionModel", pathogenEvolutionModel);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "pathogenEvolutionModelForm";
    }

    @RequestMapping(value = "/addPathogenEvolutionModels/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("pathogenEvolutionModel") @Validated PathogenEvolutionModels pathogenEvolutionModel,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", pathogenEvolutionModel);
            return "pathogenEvolutionModelForm";
        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(PathogenEvolutionModels.class, pathogenEvolutionModel);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", pathogenEvolutionModel.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addPhylogeneticTreeConstructors", method = RequestMethod.GET)
    public String addNewPhylogenticTreeConstructor(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        PhylogeneticTreeConstructors phylogeneticTreeConstructor = new PhylogeneticTreeConstructors();
        model.addAttribute("categoryID", 15);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            phylogeneticTreeConstructor = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), PhylogeneticTreeConstructors.class);
            model.addAttribute("software", phylogeneticTreeConstructor);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("phylogeneticTreeConstructor", phylogeneticTreeConstructor);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }

        return "phylogeneticTreeConstructorForm";
    }

    @RequestMapping(value = "/addPhylogeneticTreeConstructors/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId,  @Valid @ModelAttribute("phylogeneticTreeConstructor") @Validated PhylogeneticTreeConstructors phylogeneticTreeConstructor,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", phylogeneticTreeConstructor);
            return "phylogeneticTreeConstructorForm";
        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(PhylogeneticTreeConstructors.class, phylogeneticTreeConstructor);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", phylogeneticTreeConstructor.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addPopulationDynamicsModel", method = RequestMethod.GET)
    public String addNewPopulationDynamicsModel(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        PopulationDynamicsModel populationDynamicsModel = new PopulationDynamicsModel();
        model.addAttribute("categoryID", 11);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            populationDynamicsModel = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), PopulationDynamicsModel.class);
            model.addAttribute("software", populationDynamicsModel);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("populationDynamicsModel", populationDynamicsModel);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "populationDynamicsModelForm";
    }

    @RequestMapping(value = "/addPopulationDynamicsModel/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("populationDynamicsModel") @Validated PopulationDynamicsModel populationDynamicsModel,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", populationDynamicsModel);
            return "populationDynamicsModelForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(PopulationDynamicsModel.class, populationDynamicsModel);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", populationDynamicsModel.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addSyntheticEcosystemConstructors", method = RequestMethod.GET)
    public String addNewSyntheticEcosystemConstructor(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        SyntheticEcosystemConstructors syntheticEcosystemConstructor = new SyntheticEcosystemConstructors();
        model.addAttribute("categoryID", 16);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            syntheticEcosystemConstructor = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), SyntheticEcosystemConstructors.class);
            model.addAttribute("software", syntheticEcosystemConstructor);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("syntheticEcosystemConstructor", syntheticEcosystemConstructor);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }


        return "syntheticEcosystemConstructorForm";
    }

    @RequestMapping(value = "/addSyntheticEcosystemConstructors/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("syntheticEcosystemConstructor") @Validated SyntheticEcosystemConstructors syntheticEcosystemConstructor,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", syntheticEcosystemConstructor);
            return "syntheticEcosystemConstructorForm";
        }
        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(SyntheticEcosystemConstructors.class, syntheticEcosystemConstructor);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", syntheticEcosystemConstructor.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
    }

    @RequestMapping(value = "/addDataStandard", method = RequestMethod.GET)
    public String addNewDataStandard(HttpSession session, Model model, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @RequestParam(value = "categoryId", required = false) Long categoryId) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        DataStandard dataStandard = new DataStandard();
        model.addAttribute("categoryID", 4);
        model.addAttribute("entryId", entryId);
        model.addAttribute("revisionId", revisionId);

        if (entryId != null) {
            Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
            EntryId id = entry.getId();
            model.addAttribute("revisionId", id.getRevisionId());
            EntryView entryView = new EntryView(entry);

            dataStandard = new Gson().fromJson(entryView.getUnescapedEntryJsonString(), DataStandard.class);
            model.addAttribute("categoryID", entry.getCategory().getId());
        }

        model.addAttribute("dataStandard", dataStandard);
        if (ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if (ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if (ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if (!model.containsAttribute("adminType")) {
            return "accessDenied";
        }

        return "dataStandardForm";
    }

    @RequestMapping(value = "/addDataStandard/{categoryID}", method = RequestMethod.POST)
    public String submit(HttpSession session, @PathVariable(value = "categoryID") Long categoryID, @RequestParam(value = "entryId", required = false) Long entryId, @RequestParam(value = "revisionId", required = false) Long revisionId, @Valid @ModelAttribute("dataStandard") @Validated DataStandard dataStandard,
                         BindingResult result, ModelMap model) throws MdcEntryDatastoreException {
        if (categoryID == 0) {
            result.addError(new ObjectError("categoryIDError", ""));
            model.addAttribute("categoryIDError", true);
        }
        if (result.hasErrors()) {
            model.addAttribute("entryId", entryId);
            model.addAttribute("revisionId", revisionId);
            model.addAttribute("categoryID", categoryID);
            model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
            model.addAttribute("software", dataStandard);
            return "dataStandardForm";
        }

        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(DataStandard.class, dataStandard);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", dataStandard.getClass().toString());

        Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());

        entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);

        return "entryConfirmation";
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

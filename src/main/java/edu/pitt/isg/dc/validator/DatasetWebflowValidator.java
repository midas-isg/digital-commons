package edu.pitt.isg.dc.validator;

import com.google.gson.JsonObject;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.Geometry;
import edu.pitt.isg.mdc.v1_0.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.Message;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;
import org.springframework.webflow.execution.RequestContext;
import org.springframework.webflow.execution.RequestContextHolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.*;

import static edu.pitt.isg.dc.controller.HomeController.ifISGAdmin;
import static edu.pitt.isg.dc.controller.HomeController.ifMDCEditor;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isEmpty;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.validatorErrors;

@Component
public class DatasetWebflowValidator {

    @Autowired
    EntrySubmissionInterface entrySubmissionInterface;
    @Autowired
    UsersSubmissionInterface usersSubmissionInterface;
    @Autowired
    private ApiUtil apiUtil;
    private WebFlowReflectionValidator webFlowReflectionValidator = new WebFlowReflectionValidator();
    @Autowired
    private CategoryHelper categoryHelper;
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }

    private Converter converter = new Converter();

    public String controlFlow(RequestContext context, MessageContext messageContext) {
        Long categoryID = context.getFlowScope().getLong("categoryID");

        if (categoryID == null || categoryID == 0) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "category").defaultText("Please select a category").build());
            return "";
        }
        context.getFlowScope().put("categoryName", createLineage(getCategoryNameFromID(categoryID)));

        String category = getCategoryNameFromID(categoryID);
        if (category.toLowerCase().contains("software")) {
            return "software";
        }
        return "dataset";
    }

    public String isLoggedIn(RequestContext context) {
        HttpSession session = ((HttpServletRequest) context.getExternalContext().getNativeRequest()).getSession();
        if (ifMDCEditor(session) || ifISGAdmin(session)) {
            return "true";
        }
        return "true";
    }

    public String goToIndex(String indexValue) {
        RequestContext requestContext = RequestContextHolder.getRequestContext();
        requestContext.getFlowScope().put("indexValue", null);
        return indexValue;
    }

    public Map<Long, String> getCategories(String digitalObjectType) {
        try {
            Map<Long, String> categoryMap = categoryHelper.getTreePaths();
            categoryMap.entrySet().removeIf(entry -> entry.getValue().equals("Software"));
            categoryMap.entrySet().removeIf(entry -> entry.getValue().equals("Data"));

            if (digitalObjectType.equals("dataset")) {
                categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Software"));
            }

/*
            if(categoryID != null){
                String categoryName = categoryMap.get(categoryID);

                if((categoryName.startsWith("Data") && !categoryName.startsWith("Data Formats")) || categoryName.startsWith("Websites with data")) {
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Software"));
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Data Formats"));
                }
                if(categoryName.startsWith("Software")) {
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Data"));
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Websites with data"));
                }
                if(categoryName.startsWith("Data Formats")) {
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Data ->"));
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Websites with data"));
                    categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Software"));
                }
            }
*/

            return categoryMap;
        } catch (Exception e) {
            return null;
        }
    }

/*
    public Dataset editDataset(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
        try {
            dataset = (Dataset) ReflectionFactory.create(Dataset.class, dataset);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dataset;
    }
*/


    public Object createSoftware(Long categoryID) {
        if (categoryID == null) {
            return null;  //TODO: return some kind or error checking
        }
        String softwareType = getSoftwareTypeFromCategoryID(categoryID);
        RequestContext requestContext = RequestContextHolder.getRequestContext();
        requestContext.getFlowScope().put("softwareType", softwareType);

        try {
            switch (softwareType) {
                case "Data-format converters": // Root: Software: (Data-format converters)
                    return (DataFormatConverters) ReflectionFactory.create(DataFormatConverters.class);
                case "Data services": // Root: Software: (Data services)
                    return (DataService) ReflectionFactory.create(DataService.class);
                case "Data Formats": // Root: (Data Formats)
                    return (DataStandard) ReflectionFactory.create(DataStandard.class);
                case "Data visualizers": // Root: Software: (Data visualizers)
                    return (DataVisualizers) ReflectionFactory.create(DataVisualizers.class);
                case "Disease forecasters": // Root: Software: (Disease forecasters)
                    return (DiseaseForecasters) ReflectionFactory.create(DiseaseForecasters.class);
                case "Disease transmission models": // Root: Software: (Disease transmission models)
                    return (DiseaseTransmissionModel) ReflectionFactory.create(DiseaseTransmissionModel.class);
                case "Disease transmission tree estimators": // Root: Software: (Disease transmission tree estimators)
                    return (DiseaseTransmissionTreeEstimators) ReflectionFactory.create(DiseaseTransmissionTreeEstimators.class);
                case "Metagenomic Analysis": // Root: Software: (Metagenomic Analysis)
                    return (MetagenomicAnalysis) ReflectionFactory.create(MetagenomicAnalysis.class);
                case "Modeling platforms": // Root: Software: (Modeling platforms)
                    return (ModelingPlatforms) ReflectionFactory.create(ModelingPlatforms.class);
                case "Pathogen evolution models": // Root: Software: (Pathogen evolution models)
                    return (PathogenEvolutionModels) ReflectionFactory.create(PathogenEvolutionModels.class);
                case "Phylogenetic tree constructors": // Root: Software: (Phylogenetic tree constructors)
                    return (PhylogeneticTreeConstructors) ReflectionFactory.create(PhylogeneticTreeConstructors.class);
                case "Population dynamics models": // Root: Software: (Population dynamics models)
                    return (PopulationDynamicsModel) ReflectionFactory.create(PopulationDynamicsModel.class);
                case "Synthetic ecosystem constructors": // Root: Software: (Synthetic ecosystem constructors)
                    return (SyntheticEcosystemConstructors) ReflectionFactory.create(SyntheticEcosystemConstructors.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;  //TODO: return some kind or error checking
    }

    public String getSoftwareTypeFromCategoryID(Long categoryID) {
        //Given the category ID, grab the string after the first '->'
        String category = getCategoryNameFromID(categoryID);
        return category.split("->")[1].trim();
    }

    public String getCategoryNameFromID(Long categoryID) {
        try {
            Map<Long, String> categoryMap = categoryHelper.getTreePaths();
            return categoryMap.get(categoryID);
        } catch (Exception e) {
            return null;
        }
    }

    public List<String> createLineage(String categoryName) {
        String[] lineageArray = categoryName.split("->");
        return Arrays.asList(lineageArray);
    }

    public Object editDigitalObject(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        RequestContext requestContext = RequestContextHolder.getRequestContext();
        Long categoryID = getCategoryId(entryId);
        requestContext.getFlowScope().put("categoryID", categoryID);
        requestContext.getFlowScope().put("categoryName", createLineage(getCategoryNameFromID(categoryID)));

        //TODO: put in an if for software
        String softwareType = getSoftwareTypeFromCategoryID(categoryID);
        requestContext.getFlowScope().put("softwareType", softwareType);

        String digitalObjectClassName = entryView.getProperties().get("type");
        Class clazz = null;
        Object digitalObject = null;
        try {
            clazz = Class.forName(digitalObjectClassName);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        try {
            digitalObject = clazz.newInstance();
            digitalObject = converter.fromJson(entryView.getUnescapedEntryJsonString(), clazz);
            digitalObject = ReflectionFactory.create(clazz, digitalObject);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return digitalObject;
    }


    public String getSoftwareClassName(Object software, MessageContext messageContext, Long categoryID) {
        return software.getClass().getTypeName().substring(software.getClass().getTypeName().lastIndexOf(".") + 1);
    }

    public Long getCategoryId(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        return entry.getCategory().getId();
    }

/*
    public Long getCategoryId(String category) {
        if (category == null || category.isEmpty()) {
            return 0L;
        }
        try {
            switch (category) {
                case "dataFormatConverters":
                    return 6L; // Root: Software: (Data-format converters)
                case "dataServices":
                    return 7L; // Root: Software: (Data services)
                case "dataStandard":
                    return 4L; // Root: (Data Formats)
                case "dataVisualizers":
                    return 8L; // Root: Software: (Data visualizers)
                case "diseaseForecasters":
                    return 9L; // Root: Software: (Disease forecasters)
                case "diseaseTransmissionModels":
                    return 10L; // Root: Software: (Disease transmission models)
                case "diseaseTransmissionTreeEstimators":
                    return 12L; // Root: Software: (Disease transmission tree estimators)
                case "metagenomicAnalysis":
                    return 448L; // Root: Software: (Metagenomic Analysis)
                case "modelingPlatforms":
                    return 13L; // Root: Software: (Modeling platforms)
                case "pathogenEvolutionModels":
                    return 14L; // Root: Software: (Pathogen evolution models)
                case "phylogeneticTreeConstructors":
                    return 15L; // Root: Software: (Phylogenetic tree constructors)
                case "populationDynamicsModels":
                    return 11L; // Root: Software: (Population dynamics models)
                case "syntheticEcosystemConstructors":
                    return 16L; // Root: Software: (Synthetic ecosystem constructors)
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0L;
    }
*/

    public Long getRevisionId(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryId id = entry.getId();
        return id.getRevisionId();
    }

    public List getGeometryEnums() {
        return Arrays.asList(Geometry.class.getEnumConstants());
    }

    public List getAccessPointEnums() {
        return Arrays.asList(DataServiceAccessPointType.class.getEnumConstants());
    }

    public String validateDatasetForm1(Dataset dataset, MessageContext messageContext, Long categoryID) {
        String isValid;
        String title = dataset.getTitle();

        //validate dates
        isValid = validatePartOfDataset(dataset, messageContext, "edu.pitt.isg.mdc.dats2_2.Date", "getDates", true);

        if (isEmpty(title)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "title").defaultText("Title cannot be empty").build());
            isValid = "false";
        }

        RequestContext requestContext = RequestContextHolder.getRequestContext();
        if (requestContext.getFlowScope().get("indexValue") != null && Boolean.valueOf(isValid)) {
            return "index";
        }
        return isValid;
    }

    public String validateSoftwareForm1(Object software, MessageContext messageContext, Long categoryID) {
        String isValid;
        String title = ((Software) software).getTitle();
        String humanReadableSynopsis = ((Software) software).getHumanReadableSynopsis();

        isValid = "true";

        if (categoryID == null || categoryID == 0) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "category").defaultText("Please select a category").build());
            isValid = "false";
        }
        if (isEmpty(title)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "title").defaultText("Title cannot be empty").build());
            isValid = "false";
        }
        if (isEmpty(humanReadableSynopsis)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "humanReadableSynopsis").defaultText("Human Readable Synopsis cannot be empty").build());
            isValid = "false";
        }

        RequestContext requestContext = RequestContextHolder.getRequestContext();
        if (requestContext.getFlowScope().get("indexValue") != null && Boolean.valueOf(isValid)) {
            return "index";
        }
        return isValid;
    }

    public String validatePartOfDataset(Dataset dataset, MessageContext messageContext, String className, String envokeMethod, boolean rootIsRequired) {
//        TODO: For some reason validating types doesn't work the first time, null pointer exception
        // rootIsRequired: For Lists, if  it is not required this value should True. For Objects if it is not required this should be False.
        List<ValidatorError> errors = new ArrayList<>();
        try {
            String breadcrumb = "";
            Method method = dataset.getClass().getMethod(envokeMethod);
            Object obj = method.invoke(dataset);
            Field field = null;

            for (Field newField : dataset.getClass().getDeclaredFields()) {
                if (newField.getName().toLowerCase().contains(envokeMethod.replace("get", "").toLowerCase())) {
                    field = newField;
                    break;
                }
            }

            if (obj instanceof List) {
                webFlowReflectionValidator.validateList((List) obj, rootIsRequired, breadcrumb, field, errors);
            } else {
                webFlowReflectionValidator.validate(Class.forName(className), obj, rootIsRequired, breadcrumb, field, errors);
            }

            errors = validatorErrors(errors);
            WebFlowReflectionValidator.addValidationErrorToMessageContext(errors, messageContext);
        } catch (Exception e) {
            e.printStackTrace();
            messageContext.addMessage(new MessageBuilder().error().source(
                    "exception").defaultText("Possible error with validating an empty list that is required").build());
            return "false";
        }

        if (errors.size() > 0) {
            return "false";
        }

        RequestContext requestContext = RequestContextHolder.getRequestContext();
        if (requestContext.getFlowScope().get("indexValue") != null) {
            return "index";
        }
        return "true";
    }

/*
    public String createDataset(RequestContext context, MessageContext messageContext) {
        HttpSession session = ((HttpServletRequest) context.getExternalContext().getNativeRequest()).getSession();

        Dataset dataset = (Dataset) context.getFlowScope().get("dataset");
        Long revisionId = (Long) context.getFlowScope().get("revisionID");
        Long entryID = Long.parseLong(context.getFlowScope().get("entryID").toString());
//        Long entryID = (Long) context.getFlowScope().get("entryID");
        Long categoryID = (Long) context.getFlowScope().get("categoryID");

        //Second check for required fields
        String breadcrumb = "";
        List<ValidatorError> errors = new ArrayList<>();
        try {
            webFlowReflectionValidator.validate(Dataset.class, dataset, true, breadcrumb, null, errors);
            webFlowReflectionValidator.addValidationErrorToMessageContext(errors, messageContext);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (errors.size() > 0) {
            //Redirect to page with the error
            for (Message message : messageContext.getAllMessages()) {
                String messageSource = message.getSource().toString();
                context.getFlowScope().put("indexValue", messageSource.split("\\.")[0]);
                return "index";
            }
            return "false";
        }

        try {
            dataset = (Dataset) webFlowReflectionValidator.cleanse(Dataset.class, dataset);
        } catch (FatalReflectionValidatorException e) {
            e.printStackTrace();
        }


        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(Dataset.class, dataset);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", dataset.getClass().toString());

        try {
            Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());
            entrySubmissionInterface.submitEntry(entryObject, entryID, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);
        } catch (Exception e) {
            e.printStackTrace();
            return "false";
        }

        return "true";
    }
*/


    public String submitDigitalObject(RequestContext context, MessageContext messageContext) {
        HttpSession session = ((HttpServletRequest) context.getExternalContext().getNativeRequest()).getSession();

        Class clazz = context.getFlowScope().get("digitalObject").getClass();
        Object digitalObject = null;
        digitalObject = clazz.cast(context.getFlowScope().get("digitalObject"));

        Long categoryID = null;
        Long revisionId = null;
        Long entryIdentifier = null;

        try {
            categoryID = (Long) context.getFlowScope().get("categoryID");
            revisionId = (Long) context.getFlowScope().get("revisionID");
            entryIdentifier = (Long) Long.parseLong(context.getFlowScope().get("entryID").toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

        //Second check for required fields
        String breadcrumb = "";
        List<ValidatorError> errors = new ArrayList<>();
        try {
            webFlowReflectionValidator.validate(clazz, digitalObject, true, breadcrumb, null, errors);
            webFlowReflectionValidator.addValidationErrorToMessageContext(errors, messageContext);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (errors.size() > 0) {
            //Redirect to page with the error
            for (Message message : messageContext.getAllMessages()) {
                String messageSource = message.getSource().toString();
                context.getFlowScope().put("indexValue", messageSource.split("\\.")[0]);
                return "index";
            }
            return "false";
        }

        try {
            digitalObject = webFlowReflectionValidator.cleanse(clazz, digitalObject);
        } catch (FatalReflectionValidatorException e) {
            e.printStackTrace();
        }


        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(clazz, digitalObject);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", clazz.getName());

        try {
            Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());
            entrySubmissionInterface.submitEntry(entryObject, entryIdentifier, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);
        } catch (Exception e) {
            e.printStackTrace();
            return "false";
        }

        return "true";
    }

}
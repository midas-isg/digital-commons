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
import edu.pitt.isg.mdc.dats2_2.License;
import edu.pitt.isg.mdc.v1_0.*;
import org.apache.commons.collections.map.HashedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.Message;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;
import org.springframework.util.AutoPopulatingList;
import org.springframework.webflow.execution.RequestContext;
import org.springframework.webflow.execution.RequestContextHolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import static edu.pitt.isg.dc.controller.HomeController.ifISGAdmin;
import static edu.pitt.isg.dc.controller.HomeController.ifMDCEditor;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isEmpty;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.validatorErrors;

@Component
public class DatasetWebflowValidator {
    Logger logger = LoggerFactory.getLogger(DatasetWebflowValidator.class);

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

    public Map<String, String> getDataFormatsEnums() {
        Map<String, String> dataFormats = new LinkedHashMap<String, String>();
        List<Object[]> dataFormatsObjectList = apiUtil.getDataFormats();

        for (Iterator<Object[]> iterator = dataFormatsObjectList.iterator(); iterator.hasNext();){
            Object[] dataFormatsObject = iterator.next();
            if (!dataFormats.containsKey(dataFormatsObject[0].toString())) {
                dataFormats.put(dataFormatsObject[0].toString(), dataFormatsObject[1].toString());
            }
        }

        dataFormats.put("Syntax Not Available", "Syntax Not Available");

        return dataFormats;
    }

    public List<License> getDataFormatsLicenses() {
        return apiUtil.getDataFormatsLicenses();
    }

    public String isDigitalObjectDatasetOrSoftware(Long entryID) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryID);
        EntryView entryView = new EntryView(entry);
        RequestContext context = RequestContextHolder.getRequestContext();
        context.getFlowScope().put("categoryName", createLineage(getCategoryNameFromID(entry.getCategory().getId())));

        String digitalObjectClassName = entryView.getProperties().get("type");
        if(digitalObjectClassName.contains("mdc.v1_0")) {
            return "software";
        }
        if(digitalObjectClassName.endsWith("DataStandard")) {
            return "dataStandard";
        }
        return "dataset";
    }

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
        if (category.toLowerCase().startsWith("data formats")) {
            return "dataStandard";
        }
        return "dataset";
    }

    public String isLoggedIn(RequestContext context) {
        HttpSession session = ((HttpServletRequest) context.getExternalContext().getNativeRequest()).getSession();
        if (ifMDCEditor(session) || ifISGAdmin(session)) {
            return "true";
        }
        return "false";
    }

    public String goToIndex(String indexValue) {
        RequestContext requestContext = RequestContextHolder.getRequestContext();
        requestContext.getFlowScope().put("indexValue", null);
        return indexValue;
    }

    public Map<Long, String> categoryListForDropdown(String digitalObjectType) {
        try {
            Map<Long, String> categoryMap = categoryHelper.getTreePaths();
            categoryMap.entrySet().removeIf(entry -> entry.getValue().equals("Software"));
            categoryMap.entrySet().removeIf(entry -> entry.getValue().equals("Data"));
            categoryMap.entrySet().removeIf(entry -> entry.getValue().equals("Websites with data"));

            if (digitalObjectType.equals("dataset")) {
                categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Software"));
                categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Data Format"));
            }

            if (digitalObjectType.equals("dataStandard")) {
                categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Data ->"));
                categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Websites with data"));
                categoryMap.entrySet().removeIf(entry -> entry.getValue().startsWith("Software"));
            }

            return categoryMap;
        } catch (Exception e) {
            return null;
        }
    }

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
                case "Metagenomic analysis": // Root: Software: (Metagenomic Analysis)
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
        if (category.contains("->")) {
            return category.split("->")[1].trim();
        } else return category;
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

    public List<String> createLineageFromCategoryID(Long categoryID) {
        return createLineage(getCategoryNameFromID(categoryID));
    }

    public Object copyDigitalObject(Long entryId, String dataType) {
        Object digitalObject = editDigitalObject(entryId);
        RequestContext requestContext = RequestContextHolder.getRequestContext();
        requestContext.getFlowScope().put("entryID", null);

        switch (dataType) {
            case "Dataset":
                if (!isEmpty(((Dataset) digitalObject).getTitle())) {
                    ((Dataset) digitalObject).setTitle("Copy of (" + ((Dataset) digitalObject).getTitle() + ")");
                }
                break;
            case "DataStandard":
                if (!isEmpty(((DataStandard) digitalObject).getName())) {
                    ((DataStandard) digitalObject).setName("Copy of (" + ((DataStandard) digitalObject).getName() + ")");
                }
                break;
            case "Software":
                if (!isEmpty(((Software) digitalObject).getTitle())) {
                    ((Software) digitalObject).setTitle("Copy of (" + ((Software) digitalObject).getTitle() + ")");
                }
                break;
        }
        return digitalObject;
    }

    public Object editDigitalObject(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        RequestContext requestContext = RequestContextHolder.getRequestContext();
        Long categoryID = getCategoryId(entryId);
        logger.debug("Setting variable category ID: " + categoryID + ".");
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

        requestContext.getFlowScope().put("editing", true);

        return digitalObject;
    }


    public String getSoftwareClassName(Object software, MessageContext messageContext, Long categoryID) {
        return software.getClass().getTypeName().substring(software.getClass().getTypeName().lastIndexOf(".") + 1);
    }

    public Long getCategoryId(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        return entry.getCategory().getId();
    }


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

    private String getTitleForEntryId(Long entryId){
        return apiUtil.getTitleByEntryId(entryId);
    }

    private Long getEntryIdForExistingIdentifier(String identifier){
        return apiUtil.getEntryIdFromIdentifier(identifier);
    }

    private Integer numberOfEntriesWithIdentifier(String identifier){
        return apiUtil.getCountOfIdentifier(identifier);
    }

    private String getInvalidIdentiferErrorMessage(Long entryIdForExistingIdentifier) {
        String existingIdentifierTitle = getTitleForEntryId(entryIdForExistingIdentifier);
        String errorMessage;
        if (isEmpty((existingIdentifierTitle))) {
            errorMessage = "Please provide a unique Identifier.  This identifier already being used.";
        } else errorMessage = "Please provide a unique Identifier.  This identifier already being used for " + existingIdentifierTitle + ".";

        return  errorMessage;
    }

    private MessageContext checkForIdentifierUniqueness(MessageContext messageContext, String identifier){
        RequestContext requestContext = RequestContextHolder.getRequestContext();
        Long entryIdForThisIdentifier = null;
        if (!isEmpty(requestContext.getFlowScope().get("entryID"))) {
            entryIdForThisIdentifier = Long.valueOf(requestContext.getFlowScope().get("entryID").toString());
        }

        if (isEmpty(identifier)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "identifier").defaultText("Identifier cannot be empty").build());
        }else {
            Integer numberOfEntries = numberOfEntriesWithIdentifier(identifier);
            String id = null;
            if (numberOfEntries.equals(0)) {
                if (identifier.startsWith("https")) {
                    id = identifier.replace("https","http");
                    numberOfEntries = numberOfEntriesWithIdentifier(id);
                } else if (identifier.startsWith("http")) {
                    id = identifier.replace("http","https");
                    numberOfEntries = numberOfEntriesWithIdentifier(id);
                }
            } else {
                id = identifier;
            }
            if (numberOfEntries > 1) {
                messageContext.addMessage(new MessageBuilder().error().source(
                        "identifier").defaultText("Please provide a unique Identifier.  This identifier already being used.").build());
            } else if (numberOfEntries.equals(1)) {
                Long entryIdForExistingIdentifier = getEntryIdForExistingIdentifier(id);
                if (isEmpty(entryIdForThisIdentifier) || !entryIdForThisIdentifier.equals(entryIdForExistingIdentifier)) {
                    messageContext.addMessage(new MessageBuilder().error().source(
                            "identifier").defaultText(getInvalidIdentiferErrorMessage(entryIdForExistingIdentifier)).build());
                }
            }
        }
        return messageContext;
    }

    private Integer getResponseCodeForURL(URL url){
        try {
            HttpURLConnection http = (HttpURLConnection) url.openConnection();
            return http.getResponseCode();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private Boolean checkURLValidity(URL url){
        Integer statusCode = getResponseCodeForURL(url);

        if(statusCode >= 200 && statusCode <= 299){
            return true;
/*
        } else if (statusCode == 301) {
            return true;
*/
        } else if (statusCode == 302) {
            return true;
        } else return false;
    }

    private void changeIdentifierToHttp (String identifier) {
        if (!isEmpty(identifier) && identifier.startsWith("https")) {
            String httpIdentifier = identifier.replace("https", "http");
            RequestContext context = RequestContextHolder.getRequestContext();
            Object object = context.getFlowScope().get("digitalObject");

            if (object.getClass().getSimpleName().equalsIgnoreCase("Dataset")) {
                ((Dataset) object).getIdentifier().setIdentifier(httpIdentifier);
            } else if (object.getClass().getSimpleName().equalsIgnoreCase("DataStandard")) {
                ((DataStandard) object).getIdentifier().setIdentifier(httpIdentifier);
            } else {
                ((Software) object).getIdentifier().setIdentifier(httpIdentifier);
            }

            context.getFlowScope().put("digitalObject", object);
        }
    }

    private String resolveUri (String uri, String path) {
        String status = null;
        Boolean isIdentifier = false;
        if (!isEmpty(path) && path.equals("identifier.identifier")) {
            isIdentifier = true;
        }

        if (!isEmpty(uri)) {
            try {
                if(uri.startsWith("https")) {
                    if (isIdentifier && checkURLValidity(new URL(uri.replace("https", "http")))) {
                        changeIdentifierToHttp(uri);
                        status = "valid";
                    } else if (checkURLValidity(new URL(uri))) {
                        status = "valid";
                    } else status = "invalid";
                } else if (uri.startsWith("http")) {
                    if (checkURLValidity(new URL(uri))) {
                        status = "valid";
                    } else status = "invalid";
                } else status = "nonURL";
            } catch (Exception e) {
                e.printStackTrace();
                status = "error";
            }
        } else status = "empty";

        return status;
    }

    private MessageContext checkForUrlResolution(MessageContext messageContext, String path, String uri, Boolean allowEmptyAndNonURL){
        if (!isEmpty(uri) && !isEmpty(path)) {
            String errorMessage = "Please provide a valid URL";
            String uriStatus = resolveUri(uri, path);
            if (uriStatus.equals("invalid")) {
                try {
                    Integer errorCode = getResponseCodeForURL(new URL(uri));
                    if (errorCode.equals(301)) {errorMessage = "Please provide and updated URL.  This URL has permanently moved.";}
                    else if (errorCode >=300 && errorCode <= 399) {errorMessage = "Please provide a updated URL.  This URL has been redirected.";}
                    else if (errorCode.equals(404)) {errorMessage = "Please provide a valid URL.  This URL was not found.";}
                    else if (errorCode >=400 && errorCode <= 499) {errorMessage = "Please provide a valid URL.  This URL was not found.";}
                    else if (errorCode >=500) {errorMessage = "Please provide a valid URL.";}

                } catch (Exception e) {
                    e.printStackTrace();
                }
                messageContext.addMessage(new MessageBuilder().error().source(path).defaultText(errorMessage).build());
            }
            if (uriStatus.equals("error")) {
                messageContext.addMessage(new MessageBuilder().error().source(path).defaultText(errorMessage).build());
            }
            if (!allowEmptyAndNonURL) {
                if (uriStatus.equals("empty") || uriStatus.equals("nonURL")) {
                    messageContext.addMessage(new MessageBuilder().error().source(path).defaultText(errorMessage).build());
                }
            }
        }

        return messageContext;
    }


        private MessageContext checkSoftwareInputOutputNumberUniqueness(Object software, MessageContext messageContext){
        List<DataInputs> inputs = ((Software) software).getInputs();
        Map<BigInteger, Integer> inputMap = new HashMap<BigInteger, Integer>();
        for (int i = 0; i < inputs.size(); i++){
            DataInputs dataInput = inputs.get(i);
            if(!isEmpty(dataInput)){
                BigInteger inputNumber = dataInput.getInputNumber();
                if (!isEmpty(inputNumber)) {
                    if (inputMap.containsKey(inputNumber)) {
                        messageContext.addMessage(new MessageBuilder().error().source(
                                "inputs[" + i + "].inputNumber").defaultText("Input Number must be unique").build());
                    } else inputMap.put(inputNumber, i);
                }
            }
        }

        List<DataOutputs> outputs = ((Software) software).getOutputs();
        Map<BigInteger, Integer> outputMap = new HashMap<BigInteger, Integer>();
        for (int i = 0; i < outputs.size(); i++){
            DataOutputs dataOutput = outputs.get(i);
            if (!isEmpty(dataOutput)) {
                BigInteger outputNumber = dataOutput.getOutputNumber();
                if (!isEmpty(outputNumber)) {
                    if (outputMap.containsKey(outputNumber)) {
                        messageContext.addMessage(new MessageBuilder().error().source(
                                "outputs[" + i + "].outputNumber").defaultText("Output Number must be unique").build());
                    } else outputMap.put(outputNumber, i);
                }
            }
        }

        return messageContext;
    }

    public String validateDatasetForm1(Dataset dataset, MessageContext messageContext, Long categoryID) {
        String isValid;
        String title = dataset.getTitle();

        //validate dates
        isValid = validatePartOfDataset(dataset, messageContext, "edu.pitt.isg.mdc.dats2_2.Identifier", "getIdentifier", false);
        if(isValid.equals("true") || isValid.equals("index")) {
            isValid = validatePartOfDataset(dataset, messageContext, "edu.pitt.isg.mdc.dats2_2.Date", "getDates", true);
        } else {
            return "false";
        }

        if (isEmpty(title)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "title").defaultText("Title cannot be empty").build());
            isValid = "false";
        }

        //Check to see if the entered Identifier is unique to the system
        String identifier = dataset.getIdentifier().getIdentifier();
        messageContext = checkForIdentifierUniqueness(messageContext, identifier);
        messageContext = checkForUrlResolution(messageContext, "identifier.identifier", identifier, true);
        if(messageContext.hasErrorMessages()){
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
        //Check to see if the entered Identifier is unique to the system
        String identifier = ((Software) software).getIdentifier().getIdentifier();
        messageContext = checkForIdentifierUniqueness(messageContext, identifier);
        messageContext = checkForUrlResolution(messageContext, "identifier.identifier", identifier, true);
        messageContext = checkSoftwareInputOutputNumberUniqueness(software, messageContext);
        if(messageContext.hasErrorMessages()){
            isValid = "false";
        }
        if (isEmpty(humanReadableSynopsis)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "humanReadableSynopsis").defaultText("Human Readable Synopsis cannot be empty").build());
            isValid = "false";
        }

        Class clazz = software.getClass();
        RequestContext requestContext =  RequestContextHolder.getRequestContext();
        try {
            software = webFlowReflectionValidator.cleanse(clazz, software, false, false);
            requestContext.getFlowScope().put("software", software);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (requestContext.getFlowScope().get("indexValue") != null && Boolean.valueOf(isValid)) {
            return "index";
        }
        return isValid;
    }

    public String validatePartOfDataset(Dataset dataset, MessageContext messageContext, String className, String invokeMethod, boolean rootIsRequired) {
//        TODO: For some reason validating types doesn't work the first time, null pointer exception
        // rootIsRequired: For Lists, if  it is not required this value should True. For Objects if it is not required this should be False.
        List<ValidatorError> errors = new ArrayList<>();
        RequestContext requestContext = RequestContextHolder.getRequestContext();

        try {
            String breadcrumb = "";
            Method method = dataset.getClass().getMethod(invokeMethod);
            Object obj = method.invoke(dataset);
            Field field = null;
            AutoPopulatingList newList = null;

            for (Field newField : dataset.getClass().getDeclaredFields()) {
                if (newField.getName().toLowerCase().contains(invokeMethod.replace("get", "").toLowerCase())) {
                    field = newField;
                    break;
                }
            }

            if (obj instanceof List) {
                webFlowReflectionValidator.validateList((List) obj, rootIsRequired, breadcrumb, field, errors);
                dataset = (Dataset) webFlowReflectionValidator.cleanse(Dataset.class, dataset, false, false);
                requestContext.getFlowScope().put("dataset", dataset);
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

        if (requestContext.getFlowScope().get("indexValue") != null) {
            return "index";
        }
        return "true";
    }


    public String submitDigitalObject(RequestContext context, MessageContext messageContext) {
        HttpSession session = ((HttpServletRequest) context.getExternalContext().getNativeRequest()).getSession();

        Class clazz = context.getFlowScope().get("digitalObject").getClass();
        Object digitalObject = null;
        digitalObject = clazz.cast(context.getFlowScope().get("digitalObject"));

        Long categoryID = null;
        Long revisionId = null;
        Long entryIdentifier = null;

        try {
            categoryID = Long.parseLong((String) context.getFlowScope().get("categoryID"));
        } catch (ClassCastException e) {
            categoryID = (Long) context.getFlowScope().get("categoryID");
        }
        revisionId = (Long) context.getFlowScope().get("revisionID");
        try {
            entryIdentifier = Long.parseLong((String) context.getFlowScope().get("entryID"));
        } catch (NumberFormatException e) {
            entryIdentifier = (Long) context.getFlowScope().get("entryID");
        }

        //Second check for required fields
        String breadcrumb = "";
        List<ValidatorError> errors = new ArrayList<>();
        Boolean isValid = true;
        if (clazz.getSimpleName().endsWith("DataStandard")) {
            //Check to see if the entered Identifier is unique to the system
            String identifier = ((DataStandard) digitalObject).getIdentifier().getIdentifier();
            messageContext = checkForIdentifierUniqueness(messageContext, identifier);
            messageContext = checkForUrlResolution(messageContext, "identifier.identifier", identifier, true);
            if(messageContext.hasErrorMessages()){
                isValid = false;
            }
        }
        try {
            webFlowReflectionValidator.validate(clazz, digitalObject, true, breadcrumb, null, errors);
            webFlowReflectionValidator.addValidationErrorToMessageContext(errors, messageContext);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (errors.size() > 0 || !isValid) {
            //Redirect to page with the error
            for (Message message : messageContext.getAllMessages()) {
                String messageSource = message.getSource().toString();
                context.getFlowScope().put("indexValue", messageSource.split("\\.")[0].split("\\[")[0]);
                return "index";
            }
            return "false";
        }

        if(context.getCurrentEvent().getId().equals("previous") || context.getCurrentEvent().getId().equals("index")) {
            return "index";
        }

        try {
            digitalObject = webFlowReflectionValidator.cleanse(clazz, digitalObject, true, true);
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
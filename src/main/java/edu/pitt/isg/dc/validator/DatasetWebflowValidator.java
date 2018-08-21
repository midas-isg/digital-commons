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
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Geometry;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
import edu.pitt.isg.mdc.v1_0.*;
import edu.pitt.isg.mdc.v1_0.Software;
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
import static edu.pitt.isg.dc.controller.HomeController.ifLoggedIn;
import static edu.pitt.isg.dc.controller.HomeController.ifMDCEditor;
import static edu.pitt.isg.dc.utils.TagUtil.isObjectEmpty;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.*;

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

    public Map<Long, String> getCategories() {
        try {
            return categoryHelper.getTreePaths();
        } catch (Exception e) {
            return null;
        }
    }

    public Dataset editDataset(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
        try {
            dataset = (Dataset) ReflectionFactory.create(Dataset.class, dataset);
        } catch (Exception e) {
            e.printStackTrace();
        }
/*
        DatasetFactory datasetFactory = new DatasetFactory(true);
        dataset = datasetFactory.createDatasetForWebFlow(dataset);
*/
        return dataset;
    }


    public Object createSoftware(String softwareCategory) {
        if (softwareCategory == null || softwareCategory.isEmpty()) {
            return null;  //TODO: return some kind or error checking
        }

        try {
            switch (softwareCategory) {
                case "dataFormatConverters":
                    return (DataFormatConverters) ReflectionFactory.create(DataFormatConverters.class);
                case "dataService":
                    return (DataService) ReflectionFactory.create(DataService.class);
                case "dataStandard":
                    return (DataStandard) ReflectionFactory.create(DataStandard.class);
                case "dataVisualizers":
                    return (DataVisualizers) ReflectionFactory.create(DataVisualizers.class);
                case "diseaseForecasters":
                    return (DiseaseForecasters) ReflectionFactory.create(DiseaseForecasters.class);
                case "diseaseTransmissionModel":
                    return (DiseaseTransmissionModel) ReflectionFactory.create(DiseaseTransmissionModel.class);
                case "diseaseTransmissionTreeEstimators":
                    return (DiseaseTransmissionTreeEstimators) ReflectionFactory.create(DiseaseTransmissionTreeEstimators.class);
                case "metagenomicAnalysis":
                    return (MetagenomicAnalysis) ReflectionFactory.create(MetagenomicAnalysis.class);
                case "modelingPlatforms":
                    return (ModelingPlatforms) ReflectionFactory.create(ModelingPlatforms.class);
                case "pathogenEvolutionModels":
                    return (PathogenEvolutionModels) ReflectionFactory.create(PathogenEvolutionModels.class);
                case "phylogeneticTreeConstructors":
                    return (PhylogeneticTreeConstructors) ReflectionFactory.create(PhylogeneticTreeConstructors.class);
                case "populationDynamicsModel":
                    return (PopulationDynamicsModel) ReflectionFactory.create(PopulationDynamicsModel.class);
                case "syntheticEcosystemConstructors":
                    return (SyntheticEcosystemConstructors) ReflectionFactory.create(SyntheticEcosystemConstructors.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;  //TODO: return some kind or error checking
    }


    public Object editSoftware(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        String softwareClassName = entryView.getProperties().get("type");
        Class clazz = null;
        Object software = null;
        try {
            clazz = Class.forName(softwareClassName);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        try {
            software = clazz.newInstance();
            software = converter.fromJson(entryView.getUnescapedEntryJsonString(), clazz);
            software = ReflectionFactory.create(clazz, software);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return software;
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

    public String validateDatasetForm1(Dataset dataset, MessageContext messageContext, Long categoryID) {
        String isValid;
        String title = dataset.getTitle();

        //validate dates
        isValid = validatePartOfDataset(dataset, messageContext, "edu.pitt.isg.mdc.dats2_2.Date", "getDates", true);

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

            for(Field newField : dataset.getClass().getDeclaredFields()) {
                if(newField.getName().toLowerCase().contains(envokeMethod.replace("get", "").toLowerCase())) {
                    field = newField;
                    break;
                }
            }

            if(obj instanceof List) {
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

        if(errors.size() > 0){
            return "false";
        }

        RequestContext requestContext = RequestContextHolder.getRequestContext();
        if (requestContext.getFlowScope().get("indexValue") != null) {
            return "index";
        }
        return "true";
    }

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

        if(errors.size() > 0) {
            //Redirect to page with the error
            for(Message message : messageContext.getAllMessages()) {
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


    //TODO: See if we can combine the previous method and this one -- or atleast split out the similarities
    public String submitSoftware(RequestContext context, MessageContext messageContext) {
        HttpSession session = ((HttpServletRequest) context.getExternalContext().getNativeRequest()).getSession();

        Class clazz = context.getFlowScope().get("software").getClass();
        Object software = null;
        software = clazz.cast(context.getFlowScope().get("software"));
/*
        try {
            software = clazz.newInstance();
            software = clazz.cast(context.getFlowScope().get("software"));
        } catch (InstantiationException | IllegalAccessException e) {
            e.printStackTrace();
        }
*/
        Long revisionId = (Long) context.getFlowScope().get("revisionID");
        Long entryID = Long.parseLong(context.getFlowScope().get("entryID").toString());
//        Long entryID = (Long) context.getFlowScope().get("entryID");
        Long categoryID = (Long) context.getFlowScope().get("categoryID");

        //Second check for required fields
        String breadcrumb = "";
        List<ValidatorError> errors = new ArrayList<>();
        try {
            webFlowReflectionValidator.validate(clazz, software, true, breadcrumb, null, errors);
            webFlowReflectionValidator.addValidationErrorToMessageContext(errors, messageContext);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if(errors.size() > 0) {
            //Redirect to page with the error
            for(Message message : messageContext.getAllMessages()) {
                String messageSource = message.getSource().toString();
                context.getFlowScope().put("indexValue", messageSource.split("\\.")[0]);
                return "index";
            }
            return "false";
        }

        try {
            software = webFlowReflectionValidator.cleanse(clazz, software);
        } catch (FatalReflectionValidatorException e) {
            e.printStackTrace();
        }


        EntryView entryObject = new EntryView();

        JsonObject json = converter.toJsonObject(clazz, software);
        json.remove("class");
        entryObject.setEntry(json);
        entryObject.setProperty("type", clazz.getClass().toString());

        try {
            Users user = usersSubmissionInterface.submitUser(session.getAttribute("userId").toString(), session.getAttribute("userEmail").toString(), session.getAttribute("userName").toString());
            entrySubmissionInterface.submitEntry(entryObject, entryID, revisionId, categoryID, user, ENTRIES_AUTHENTICATION);
        } catch (Exception e) {
            e.printStackTrace();
            return "false";
        }

        return "true";
    }

}
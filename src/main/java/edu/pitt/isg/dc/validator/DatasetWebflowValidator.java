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
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
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
        if(ifMDCEditor(session) || ifISGAdmin(session)) {
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
        dataset = DatasetFactory.createDatasetForWebFlow(dataset);
        return dataset;
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

}
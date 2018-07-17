package edu.pitt.isg.dc.validator;

import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;
import org.springframework.webflow.execution.RequestContext;

import java.util.ArrayList;
import java.util.Map;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearTypes;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isEmpty;

@Component
public class DatasetWebflowValidator {
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private CategoryHelper categoryHelper;

    private Converter converter = new Converter();

    public Map<Long, String> getCategories() {
        try {
            return categoryHelper.getTreePaths();
        } catch (Exception e) {
            return null;
        }
    }

    public void test(String test) {
        System.out.println(test);
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

    public String validateDatasetForm1(Dataset dataset, MessageContext messageContext, Long categoryID, Long revisionID) {
        String title = dataset.getTitle();
        if (isEmpty(title)) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "title").defaultText("Title cannot be empty").build());
            messageContext.addMessage(new MessageBuilder().error().source(
                    "test").defaultText("Test").build());
            return "false";
        } else {
            return "true";
        }
    }

    public String validateDatasetForm4(Dataset dataset, MessageContext messageContext) {
        // Validate and remove empty types
        boolean valid = clearTypes(dataset.getTypes(), messageContext);
        return  Boolean.toString(valid);
    }

    public String validateDataset(Dataset dataset, MessageContext messageContext) {
        String title = dataset.getTitle();

//        Person person  = new Person();
//        PersonOrganization personOrganization = (PersonOrganization) dataset.getCreators().get(0);
//        person.setFirstName(personOrganization.getFirstName());
//        person.setLastName(personOrganization.getLastName());
//        person.setIdentifier(personOrganization.getIdentifier());
//        dataset.getCreators().add(person);
        if (title != "") {
            return "true";
        } else {
            return "true";
//            messageContext.addMessage(new MessageBuilder().error().source(
//                    "title").defaultText("Title cannot be empty").build());
//            return "false";
        }
    }

    public String createDataset(RequestContext context) {
        Dataset dataset = (Dataset) context.getFlowScope().get("dataset");


        //Remove empty identifier
        if (!isEmpty(dataset.getIdentifier())) {
            if (isEmpty(dataset.getIdentifier().getIdentifier()) && isEmpty(dataset.getIdentifier().getIdentifierSource())) {
                dataset.setIdentifier(null);
            }
        }


        return "success";
    }

}
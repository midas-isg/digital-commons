package edu.pitt.isg.dc.validator;

import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DatasetFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.webflow.execution.RequestContext;

import java.util.ArrayList;
import java.util.List;

@Component
public class TestDatasetValidator
{
    @Autowired
    private ApiUtil apiUtil;

    private Converter converter = new Converter();

    public Dataset editDataset(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryId id = entry.getId();
//        model.addAttribute("revisionId", id.getRevisionId());
        EntryView entryView = new EntryView(entry);

        Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
//        model.addAttribute("categoryID", entry.getCategory().getId());
        return dataset;
    }

    public String validateDataset(Dataset dataset, MessageContext messageContext)
    {
        String title = dataset.getTitle();

//        Person person  = new Person();
//        PersonOrganization personOrganization = (PersonOrganization) dataset.getCreators().get(0);
//        person.setFirstName(personOrganization.getFirstName());
//        person.setLastName(personOrganization.getLastName());
//        person.setIdentifier(personOrganization.getIdentifier());
//        dataset.getCreators().add(person);
        if(title != "")
        {
            return "true";
        }
        else
        {
            return "true";
//            messageContext.addMessage(new MessageBuilder().error().source(
//                    "title").defaultText("Title cannot be empty").build());
//            return "false";
        }
    }

    public String createDataset(RequestContext context) {
        Dataset dataset = (Dataset) context.getFlowScope().get("dataset");
        return "success";
    }

}
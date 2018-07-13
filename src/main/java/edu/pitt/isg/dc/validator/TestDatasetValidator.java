package edu.pitt.isg.dc.validator;

import edu.pitt.isg.dc.entry.classes.PersonOrganization;
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
            messageContext.addMessage(new MessageBuilder().error().source(
                    "title").defaultText("Title cannot be empty").build());
            return "false";
        }
    }

    public String createDataset(RequestContext context) {
        Dataset dataset = (Dataset) context.getFlowScope().get("dataset");
        return "success";
    }

}
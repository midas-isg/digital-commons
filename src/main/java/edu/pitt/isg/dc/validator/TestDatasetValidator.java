package edu.pitt.isg.dc.validator;

import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.utils.DatasetFactory;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.webflow.execution.RequestContext;

import java.util.ArrayList;
import java.util.List;

@Component
public class TestDatasetValidator
{
    public Dataset initFlow() {
        Dataset dataset = DatasetFactory.createDatasetForWebFlow();
        return dataset;
/*
        Dataset dataset = new Dataset();
//        dataset.setTitle("test");
        dataset.setIdentifier(new Identifier());
        for(int i=5; i>0; i--) {
            PersonComprisedEntity personComprisedEntity = new PersonOrganization();
            personComprisedEntity.setIdentifier(new Identifier());

            List<Identifier> alternateIdentifiers = new ArrayList<>();
            for(int j=5; j>0; j--) {
                alternateIdentifiers.add(new Identifier());
            }
            ((PersonOrganization) personComprisedEntity).setAlternateIdentifiers(alternateIdentifiers);


            ((PersonOrganization) personComprisedEntity).getAffiliations().add(new Organization());
            ((PersonOrganization) personComprisedEntity).getRoles().add(new Annotation());
            dataset.getCreators().add(personComprisedEntity);
        }
//        dataset.getCreators().add(new Person());
//        dataset.setProducedBy(new Study());
        return dataset;
*/
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
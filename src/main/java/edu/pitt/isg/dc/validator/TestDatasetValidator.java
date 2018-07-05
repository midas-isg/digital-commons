package edu.pitt.isg.dc.validator;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.webflow.execution.RequestContext;

@Component
public class TestDatasetValidator
{
    public Dataset initFlow() {
        Dataset dataset = new Dataset();
//        dataset.setTitle("test");
        dataset.setIdentifier(new Identifier());
        for(int i=50; i>0; i--) {
            dataset.getCreators().add(new Person());
        }
//        dataset.getCreators().add(new Person());
//        dataset.setProducedBy(new Study());
        return dataset;
    }

    public String validateDataset(Dataset dataset, MessageContext messageContext)
    {
        String title = dataset.getTitle();
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
package edu.pitt.isg.dc.utils;

import edu.pitt.isg.mdc.dats2_2.Annotation;
import edu.pitt.isg.mdc.dats2_2.CategoryValuePair;
import edu.pitt.isg.mdc.dats2_2.Dataset;

public class DatasetFactory {
    public static Dataset createDatasetForWebFlow() {
        //create an instance of every member of Dataset
        //every member of every member must be instantiated
        //every list must contain at least one entry for every type the list can take (e.g. Person/Organization)
        Dataset dataset = new Dataset();

        //section where you create your member
        CategoryValuePair categoryValuePair = new CategoryValuePair();
        categoryValuePair.getValues().add(new Annotation());

        //add member to dataset
        dataset.getExtraProperties().add(categoryValuePair);

        //next dataset member
        //dataset.getCreators().add

    }
}

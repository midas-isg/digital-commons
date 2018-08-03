package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.CategoryValuePair;

public class AutoPopulatedCategoryValuePairWrapper extends CategoryValuePair {
    public AutoPopulatedCategoryValuePairWrapper() {

        super();
        DatasetFactory datasetFactory = new DatasetFactory(true);
        datasetFactory.createCategoryValuePair(this);
    }
}

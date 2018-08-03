package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Publication;

public class AutoPopulatedPublicationWrapper extends Publication {
    public AutoPopulatedPublicationWrapper() {

        super();
        DatasetFactory datasetFactory = new DatasetFactory(true);
        datasetFactory.createPublication(this);
    }
}

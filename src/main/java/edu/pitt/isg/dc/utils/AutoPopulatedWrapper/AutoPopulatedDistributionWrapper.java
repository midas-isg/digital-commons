package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Distribution;

public class AutoPopulatedDistributionWrapper extends Distribution {
    public AutoPopulatedDistributionWrapper() {

        super();
        DatasetFactory datasetFactory = new DatasetFactory(true);
        datasetFactory.createDistribution(this);
    }

}

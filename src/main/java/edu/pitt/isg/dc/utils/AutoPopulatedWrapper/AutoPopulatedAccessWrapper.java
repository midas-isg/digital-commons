package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Access;

public class AutoPopulatedAccessWrapper extends Access {
    public AutoPopulatedAccessWrapper() {

        super();
        DatasetFactory datasetFactory = new DatasetFactory(true);
        datasetFactory.createAccess(this);
    }
}

package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.DataStandard;

public class AutoPopulatedDataStandardWrapper extends DataStandard {
    public AutoPopulatedDataStandardWrapper() {

        super();
        DatasetFactory.createDataStandard(this);
    }
}

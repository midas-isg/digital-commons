package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Grant;

public class AutoPopulatedGrantWrapper extends Grant {
    public AutoPopulatedGrantWrapper () {

        super();
        DatasetFactory.createGrant(this);
    }
}

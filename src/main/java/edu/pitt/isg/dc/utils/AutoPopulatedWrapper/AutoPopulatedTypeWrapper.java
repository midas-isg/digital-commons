package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Type;

public class AutoPopulatedTypeWrapper extends Type {
    public AutoPopulatedTypeWrapper() {

        super();
        DatasetFactory.createType(this);
    }
}

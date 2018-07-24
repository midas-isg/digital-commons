package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Annotation;
import edu.pitt.isg.mdc.dats2_2.Date;

public class AutoPopulatedDateWrapper extends Date {
    public AutoPopulatedDateWrapper() {

        super();
        this.setType(new Annotation());
    }
}

package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.IsAbout;

public class AutoPopulatedIsAboutWrapper extends IsAbout {
    public AutoPopulatedIsAboutWrapper() {

        super();
        DatasetFactory.createIsAbout(this);
    }
}

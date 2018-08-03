package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.IsAbout;

public class AutoPopulatedIsAboutWrapper extends IsAboutItems {
    public AutoPopulatedIsAboutWrapper() {

        super();
        DatasetFactory datasetFactory = new DatasetFactory(true);
        datasetFactory.createIsAboutItems(this);
    }
}

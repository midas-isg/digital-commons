package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Place;

public class AutoPopulatedPlaceWrapper extends Place {
    public AutoPopulatedPlaceWrapper() {

        super();
        DatasetFactory datasetFactory = new DatasetFactory(true);
        datasetFactory.createPlace(this);
//        this.alternateIdentifiers = DatasetFactory.wrapListWithAutoPopulatingList(this.alternateIdentifiers, Identifier.class);
//        this.identifier = new Identifier();
    }
}

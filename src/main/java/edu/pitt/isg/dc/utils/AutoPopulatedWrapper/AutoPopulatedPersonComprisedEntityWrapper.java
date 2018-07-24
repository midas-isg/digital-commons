package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;

public class AutoPopulatedPersonComprisedEntityWrapper extends PersonOrganization {
    public AutoPopulatedPersonComprisedEntityWrapper() {

        super();
        DatasetFactory.createPersonOrganization(this);
    }
}

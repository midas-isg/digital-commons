package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.Organization;

public class AutoPopulatedOrganizationWrapper extends Organization {
    public AutoPopulatedOrganizationWrapper() {

        super();
        DatasetFactory.createOrganization(this);
    }
}

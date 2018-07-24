package edu.pitt.isg.dc.utils.AutoPopulatedWrapper;

import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.mdc.dats2_2.License;

public class AutoPopulatedLicenseWrapper extends License {
    public AutoPopulatedLicenseWrapper() {

        super();
        DatasetFactory.createLicense(this);
    }
}

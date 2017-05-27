package edu.pitt.isg.dc.repository.json;

import edu.pitt.isg.dc.repository.Repository;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.v1_0.Software;

import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by jdl50 on 5/26/17.
 */
public class DirectoryResolver {
    protected static final Map<File, Class> repo;

    private static final String CASE_SERIES_LOCATION = "/resources/case-series-dats-json/";
    private static final Class CASES_SERIES_CLASS = Dataset.class;

    private static final String CHIKUNGUNYA_LOCATION = "/resources/chikungunya-dats-json/";
    private static final Class CHIKUNGUNYA_CLASS = Dataset.class;

    private static final String DATA_FORMATS_LOCATION = "/resources/data-formats-dats-json/";
    private static final Class DATA_FORMATS_CLASS = DataStandard.class;

    private static final String DISEASE_SURVEILLANCE_LOCATION = "/resources/disease-surveillance-dats-json/";
    private static final Class DISEASE_SURVEILLANCE_CLASS = Dataset.class;

    private static final String EBOLA_LOCATION = "/resources/ebola-dats-json/";
    private static final Class EBOLA_CLASS = Dataset.class;

    private static final String INFECTIOUS_DISEASE_LOCATION = "/resources/infectious-disease-dats-json/";
    private static final Class INFECTIOUS_DISEASE_CLASS = Dataset.class;

    private static final String MORTALITY_LOCATION = "/resources/mortality-dats-json/";
    private static final Class MORTALITY_CLASS = Dataset.class;

    private static final String SPEW_LOCATION = "/resources/spew-dats-json/";
    private static final Class SPEW_CLASS = Dataset.class;

    private static final String SYNTHIA_LOCATION = "/resources/synthia-dats-json/";
    private static final Class SYNTHIA_CLASS = Dataset.class;

    private static final String TYCHO_LOCATION = "/resources/tycho-dats-json/";
    private static final Class TYCHO_CLASS = Dataset.class;

    private static final String ZIKA_LOCATION = "/resources/zika-dats-json/";
    private static final Class ZIKA_CLASS = Dataset.class;

    private static final String SOFTWARE_LOCATION = "/json/";
    private static final Class SOFTWARE_CLASS = Software.class;

    static {
        Map<File, Class> initilizationRepo = new HashMap<>();
        Class clazz = DirectoryResolver.class;
        initilizationRepo.put(new File(clazz.getResource(CASE_SERIES_LOCATION).getFile()), CASES_SERIES_CLASS);
        initilizationRepo.put(new File(clazz.getResource(CHIKUNGUNYA_LOCATION).getFile()), CHIKUNGUNYA_CLASS);
        initilizationRepo.put(new File(clazz.getResource(DATA_FORMATS_LOCATION).getFile()), DATA_FORMATS_CLASS);
        initilizationRepo.put(new File(clazz.getResource(DISEASE_SURVEILLANCE_LOCATION).getFile()), DISEASE_SURVEILLANCE_CLASS);
        initilizationRepo.put(new File(clazz.getResource(EBOLA_LOCATION).getFile()), EBOLA_CLASS);
        initilizationRepo.put(new File(clazz.getResource(INFECTIOUS_DISEASE_LOCATION).getFile()), INFECTIOUS_DISEASE_CLASS);
        initilizationRepo.put(new File(clazz.getResource(MORTALITY_LOCATION).getFile()), MORTALITY_CLASS);
        initilizationRepo.put(new File(clazz.getResource(SPEW_LOCATION).getFile()), SPEW_CLASS);
        initilizationRepo.put(new File(clazz.getResource(SYNTHIA_LOCATION).getFile()), SYNTHIA_CLASS);
        initilizationRepo.put(new File(clazz.getResource(TYCHO_LOCATION).getFile()), TYCHO_CLASS);
        initilizationRepo.put(new File(clazz.getResource(ZIKA_LOCATION).getFile()), ZIKA_CLASS);
        initilizationRepo.put(new File(clazz.getResource(SOFTWARE_LOCATION).getFile()), SOFTWARE_CLASS);
        repo = Collections.unmodifiableMap(initilizationRepo);
        new FileResolver(repo).parse();

    }


    public Map<File, Class> getDirectoryToClassMap() {
        return repo;
    }
}

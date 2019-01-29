package edu.pitt.isg.dc;

import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.google.common.reflect.TypeToken;
import com.google.gson.*;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.dc.utils.DatasetFactoryPerfectTest;
import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.dc.validator.*;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
import edu.pitt.isg.mdc.dats2_2.Type;
import edu.pitt.isg.mdc.v1_0.Software;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.validatorErrors;
import static org.junit.Assert.*;


@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class ResolveHttpIdentifiersTest {
    public static final java.lang.reflect.Type mapType = new TypeToken<TreeMap<String, Object>>() {
    }.getType();
    private final Converter converter = new Converter();
    Gson gson = new GsonBuilder().serializeNulls().enableComplexMapKeySerialization().create();
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private EntryRepository repo;
    private WebFlowReflectionValidator webFlowReflectionValidator = new WebFlowReflectionValidator();

    @Test
    public void testEmptyDataset() {
        Dataset dataset = new Dataset();
    }

    private Dataset createTestDataset(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
        DatasetFactory datasetFactory = new DatasetFactory(true);
        dataset = datasetFactory.createDatasetForWebFlow(dataset);


//        Dataset dataset = (Dataset) ReflectionFactory.create(Dataset.class);
        //make your dataset here

        return dataset;
    }

    private Software createTestSoftware(Long entryId) {
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        Software software = (Software) converter.fromJson(entryView.getUnescapedEntryJsonString(), Software.class);
        return software;
    }

    @Test
    public void testResolveHttpIdentifiersForAllDatasets() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypesMaxRevisionID(types);
        System.out.println("Total entries: " + entriesList.size());

        Map<Integer, List<Long>> statusCodeForEntryIds = new HashMap<Integer, List<Long>>();

        for (Entry entry : entriesList) {
//            System.out.println(entry.getId().getEntryId());
            Dataset dataset = createTestDataset(entry.getId().getEntryId());
            if(dataset.getIdentifier().getIdentifier() != null && !dataset.getIdentifier().getIdentifier().isEmpty()){
                String identifier = dataset.getIdentifier().getIdentifier();

                if (!identifier.isEmpty() && identifier.startsWith("https:")) {
                    String httpIdentifier = identifier.replace("https:","http:");
                    try {
                        URL url = new URL(httpIdentifier);
//                        URL url = new URL(identifier);
                        HttpURLConnection http = (HttpURLConnection) url.openConnection();
                        Integer statusCode = http.getResponseCode();

                        if (statusCodeForEntryIds.containsKey(statusCode)) {
                            statusCodeForEntryIds.get(statusCode).add(entry.getId().getEntryId());
                        } else {
                            ArrayList<Long> longList = new ArrayList<Long>();
                            longList.add(entry.getId().getEntryId());
                            statusCodeForEntryIds.put(statusCode, longList);
                        }
                        if (statusCode != 200 && statusCode != 302) {
                            System.out.println(entry.getId().getEntryId() + " --- " + statusCode + " --- " + identifier);
                        }

                    } catch (Exception e) {
                        fail(e.getMessage());
                    }
                }
            }
        }

        assertTrue(true);
    }

    @Test
    public void testResolveHttpIdentifiersForAllSoftware() {
        Set<String> types = new HashSet<>();
//        types.add(Software.class.getTypeName());
        types.add("edu.pitt.isg.mdc.v1_0.DataFormatConverters");
        types.add("edu.pitt.isg.mdc.v1_0.DataService");
        types.add("edu.pitt.isg.mdc.v1_0.DataVisualizers");
        types.add("edu.pitt.isg.mdc.v1_0.DiseaseForecasters");
        types.add("edu.pitt.isg.mdc.v1_0.DiseaseTransmissionModel");
        types.add("edu.pitt.isg.mdc.v1_0.DiseaseTransmissionTreeEstimators");
        types.add("edu.pitt.isg.mdc.v1_0.MetagenomicAnalysis");
        types.add("edu.pitt.isg.mdc.v1_0.ModelingPlatforms");
        types.add("edu.pitt.isg.mdc.v1_0.PathogenEvolutionModels");
        types.add("edu.pitt.isg.mdc.v1_0.PhylogeneticTreeConstructors");
        types.add("edu.pitt.isg.mdc.v1_0.PopulationDynamicsModel");
        types.add("edu.pitt.isg.mdc.v1_0.SyntheticEcosystemConstructors");

        List<Entry> entriesList = repo.filterEntryIdsByTypesMaxRevisionID(types);
        System.out.println("Total entries: " + entriesList.size());

        Map<Integer, List<Long>> statusCodeForEntryIds = new HashMap<Integer, List<Long>>();

        for (Entry entry : entriesList) {
            System.out.println(entry.getId().getEntryId());
            Software software = createTestSoftware(entry.getId().getEntryId());
            if(software.getIdentifier() != null && software.getIdentifier().getIdentifier() != null && !software.getIdentifier().getIdentifier().isEmpty()){
                String identifier = software.getIdentifier().getIdentifier();

                if (!identifier.isEmpty() && identifier.startsWith("https:")) {
                    String httpIdentifier = identifier.replace("https:","http:");
                    try {
                        URL url = new URL(httpIdentifier);
//                        URL url = new URL(identifier);
                        HttpURLConnection http = (HttpURLConnection) url.openConnection();
                        Integer statusCode = http.getResponseCode();

                        if (statusCodeForEntryIds.containsKey(statusCode)) {
                            statusCodeForEntryIds.get(statusCode).add(entry.getId().getEntryId());
                        } else {
                            ArrayList<Long> longList = new ArrayList<Long>();
                            longList.add(entry.getId().getEntryId());
                            statusCodeForEntryIds.put(statusCode, longList);
                        }
                        if (statusCode != 200 && statusCode != 302) {
                            System.out.println(entry.getId().getEntryId() + " --- " + statusCode + " --- " + identifier);
                        }

                    } catch (Exception e) {
                        fail(e.getMessage());
                    }
                }
            }
        }

        assertTrue(true);
    }

    @Test
    public void testResolveHttpIdentifiersForOneDataset() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        Entry entry = repo.getEntryByEntryIdAndMaxRevisionId(134L);

        Map<Integer, List<Long>> statusCodeForEntryIds = new HashMap<Integer, List<Long>>();

        Dataset dataset = createTestDataset(entry.getId().getEntryId());
        String identifier = dataset.getIdentifier().getIdentifier();
        if (identifier.startsWith("https://")) {
            String httpIdentifier = identifier.replace("https://","http://");
            try {
                URL url = new URL(httpIdentifier);
                HttpURLConnection http = (HttpURLConnection) url.openConnection();
                Integer statusCode = http.getResponseCode();

                if (statusCode != 200 && statusCode != 302) {
                    if (statusCodeForEntryIds.containsKey(statusCode)) {
                        statusCodeForEntryIds.get(statusCode).add(entry.getId().getEntryId());
                    } else {
                        ArrayList<Long> longList = new ArrayList<Long>();
                        longList.add(entry.getId().getEntryId());
                        statusCodeForEntryIds.put(statusCode, longList);
                    }
                }

            } catch (Exception e) {
                fail(e.getMessage());
            }
        }

        assertTrue(true) ;
    }


}

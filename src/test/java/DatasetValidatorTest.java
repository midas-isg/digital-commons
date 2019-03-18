import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.google.common.reflect.TypeToken;
import com.google.gson.*;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.TestConvertDatsToJava;
import edu.pitt.isg.dc.WebApplication;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryService;
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
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.*;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.validatorErrors;
import static org.junit.Assert.*;


@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class DatasetValidatorTest {
    public static final java.lang.reflect.Type mapType = new TypeToken<TreeMap<String, Object>>() {
    }.getType();
    private final Converter converter = new Converter();
    Gson gson = new GsonBuilder().serializeNulls().enableComplexMapKeySerialization().create();
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private EntryService repo;
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

    private Dataset createPerfectDataset() {
        return DatasetFactoryPerfectTest.createDatasetForWebFlow(null);
    }

    private List<ValidatorError> test(Dataset dataset) {
        //don't have to do this yet
        String breadcrumb = "";
        List<ValidatorError> errors = new ArrayList<>();
        try {
            ReflectionValidator reflectionValidator = new ReflectionValidator();
            reflectionValidator.validate(Dataset.class, dataset, true, breadcrumb, null, errors);
            //somehow "expect" error messages....
        } catch (Exception e) {
            e.printStackTrace();
            fail();
        }
        return validatorErrors(errors);
    }

    @Test
    public void testPerfectDatasetWithAllPossibleFields() {
        Dataset dataset = createPerfectDataset();

        List<ValidatorError> errors = test(dataset);
        assertTrue(errors.isEmpty());
    }

    @Test
    public void testPerfectDatasetForceErrors() {
        Dataset dataset = createPerfectDataset();

        dataset.setTitle(null);

        ListIterator<? extends Type> iterator = dataset.getTypes().listIterator();
        while (iterator.hasNext()) {
            iterator.next();
            iterator.remove();
        }

        dataset.getStoredIn().setName(null);

        ((PersonOrganization) dataset.getCreators().get(1)).setName(null);

        dataset.getDistributions().get(0).getAccess().setLandingPage(null);

        dataset.getDistributions().get(0).getDates().get(0).getType().setValue(null);
        dataset.getDistributions().get(0).getDates().get(0).getType().setValueIRI(null);

        dataset.getDistributions().get(0).getConformsTo().get(0).getType().setValue(null);
        dataset.getDistributions().get(0).getConformsTo().get(0).getType().setValueIRI(null);

        dataset.getLicenses().get(0).setName(null);

        ((PersonOrganization) dataset.getCreators().get(0)).getAffiliations().get(0).getLocation().getIdentifier().setIdentifierSource(null);

        dataset.getPrimaryPublications().get(0).getAcknowledges().get(0).setName(null);

        DatasetFactory datasetFactory = new DatasetFactory(true);


        dataset.getPrimaryPublications().get(0).getAcknowledges().get(0).setFunders(datasetFactory.createPersonComprisedEntityList(null));

        ((IsAboutItems) dataset.getIsAbout().get(0)).setName(null);

        dataset.getProducedBy().setName(null);

        dataset.getProducedBy().getEndDate().setDate(null);

        List<ValidatorError> errors = test(dataset);
        if (!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->title");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(1).getPath(), "(root)->types");
            assertEquals(errors.get(1).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(2).getPath(), "(root)->creators->0->affiliations->0->location->identifier->identifierSource");
            assertEquals(errors.get(2).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(3).getPath(), "(root)->creators->1->name");
            assertEquals(errors.get(3).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(4).getPath(), "(root)->storedIn->name");
            assertEquals(errors.get(4).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(5).getPath(), "(root)->distributions->0->access->landingPage");
            assertEquals(errors.get(5).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(6).getPath(), "(root)->distributions->0->dates->0->type");
            assertEquals(errors.get(6).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(7).getPath(), "(root)->distributions->0->conformsTo->0->type");
            assertEquals(errors.get(7).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(8).getPath(), "(root)->primaryPublications->0->acknowledges->0->name");
            assertEquals(errors.get(8).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(9).getPath(), "(root)->primaryPublications->0->acknowledges->0->funders");
            assertEquals(errors.get(9).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(10).getPath(), "(root)->producedBy->name");
            assertEquals(errors.get(10).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(11).getPath(), "(root)->producedBy->endDate->date");
            assertEquals(errors.get(11).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(12).getPath(), "(root)->licenses->0->name");
            assertEquals(errors.get(12).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(13).getPath(), "(root)->isAbout->0->name");
            assertEquals(errors.get(13).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced.");
    }



/*
    @Test
    public void testDatasetWithoutTitleOnly() throws Exception {
//        Dataset dataset = createTestDataset(566L);
        Dataset dataset = createPerfectDataset();

        dataset.setTitle(null);

        List<ValidatorError> errors = test(dataset);

        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->title");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Title");
    }

    @Test
    public void testDatasetCreatorOrganizationNameMissing() {
        Dataset dataset = createPerfectDataset();

        ((PersonOrganization) dataset.getCreators().get(1)).setName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->creators->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Creator Organization name.");
    }
*/

    @Test
    public void testDatasetWithoutCreatorsOnly() {
        Dataset dataset = createPerfectDataset();

        ListIterator<? extends PersonComprisedEntity> iterator = dataset.getCreators().listIterator();
        while (iterator.hasNext()) {
            iterator.next();
            iterator.remove();
        }

        List<ValidatorError> errors = test(dataset);
        if (!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->creators");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Creators");
    }

/*
    @Test
    public void testDatasetWithoutTyesOnly() {
        Dataset dataset = createPerfectDataset();

        ListIterator<? extends Type> iterator = dataset.getTypes().listIterator();
        while (iterator.hasNext()) {
            Type type = iterator.next();
            iterator.remove();
        }

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->types");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Types");
    }

    @Test
    public void testDatasetWithoutStoredInName() {
        Dataset dataset = createPerfectDataset();

        dataset.getStoredIn().setName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->storedIn->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing StoredIn (Data Repository) name.");
    }
*/

    @Test
    public void testDatasetWithoutDistributionAccess() {
        Dataset dataset = createPerfectDataset();

        dataset.getDistributions().get(0).setAccess(null);

        List<ValidatorError> errors = test(dataset);
        if (!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->distributions->0->access");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for empty Distribution Access.");
    }
/*

    @Test
    public void testDatasetWithoutDistributionAccessLandingPage() {
        Dataset dataset = createPerfectDataset();

        dataset.getDistributions().get(0).getAccess().setLandingPage(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->distributions->access->landingPage");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for empty Distribution Access LandingPage.");
    }

    @Test
    public void testPerfectDatasetExceptLicenseIsMissingName() {
        Dataset dataset = createPerfectDataset();

        dataset.getLicenses().get(0).setName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->licenses->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for empty License name.");

    }

    @Test
    public void testDatasetWithoutIdentifierSource() {
        Dataset dataset = createPerfectDataset();

        ((PersonOrganization) dataset.getCreators().get(0)).getAffiliations().get(0).getLocation().getIdentifier().setIdentifierSource(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->creators->affiliations->location->identifier->identifierSource");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing IdenfifierSource");
    }

    @Test
    public void testDatasetWithoutDatesAnnotation() {
        Dataset dataset = createPerfectDataset();

        dataset.getDistributions().get(0).getDates().get(0).getType().setValue(null);
        dataset.getDistributions().get(0).getDates().get(0).getType().setValueIRI(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->distributions->dates->type");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Types");
    }


    @Test
    public void testDatasetWithoutPrimaryPublicationsAcknowledgesName() {
        Dataset dataset = createPerfectDataset();

        dataset.getPrimaryPublications().get(0).getAcknowledges().get(0).setName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->primaryPublications->acknowledges->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing name");
    }

    @Test
    public void testDatasetWithoutPrimaryPublicationsAcknowledgesFunders() {
        Dataset dataset = createPerfectDataset();

        dataset.getPrimaryPublications().get(0).getAcknowledges().get(0).setFunders(DatasetFactory.createPersonComprisedEntityList(null));

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->primaryPublications->acknowledges->funders");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Funders");
    }

    @Test
    public void testDatasetWithoutIsAboutBiologicalEntityName() {
        Dataset dataset = createPerfectDataset();

        ((IsAboutItems) dataset.getIsAbout().get(0)).setName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->isAbout->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing IsAbout (Biological Entity) name");
    }

    @Test
    public void testDatasetWithoutStudyName() {
        Dataset dataset = createPerfectDataset();

        dataset.getProducedBy().setName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->producedBy->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing name of Produced By");
    }

    @Test
    public void testDatasetWithoutDate() {
        Dataset dataset = createPerfectDataset();

        dataset.getProducedBy().getEndDate().setDate(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->producedBy->endDate->date");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing End Date for Produced By");
    }

    @Test
    public void testDatasetWithoutDistributionConformsToTypes() {
        Dataset dataset = createPerfectDataset();

        dataset.getDistributions().get(0).getConformsTo().get(0).getType().setValue(null);
        dataset.getDistributions().get(0).getConformsTo().get(0).getType().setValueIRI(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->distributions->conformsTo->type");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Types");
    }
*/

/*
    @Test
    public void testRealDataset() {
        Dataset dataset = createTestDataset(86L);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
//            assertEquals(errors.get(0).getPath(), "(root)->isAbout->name");
//            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
            assertTrue(false);
        } else assertTrue(true);
    }
*/


/*
    @Test
    public void testValidationErrorsByDataset() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypes(types);

        Map<Dataset, List<ValidatorError>> datasetErrorListMap = new HashMap<Dataset, List<ValidatorError>>();

        for (Entry entry : entriesList) {
            Dataset dataset = createTestDataset(entry.getId().getEntryId());
            List<ValidatorError> errors = test(dataset);

            if(!errors.isEmpty()){
                datasetErrorListMap.put(dataset,errors);
            }
        }

        if(datasetErrorListMap.isEmpty()) {
            assertTrue(true);
        } else fail("Errors were found!");
    }
*/

    @Test
    public void testValidationErrorCountByBreadcrumbForAllDatasets() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypesMaxRevisionID(types);

        Map<String, Integer> errorPathCount = new HashMap<String, Integer>();

        for (Entry entry : entriesList) {
//            System.out.println(entry.getId().getEntryId());
            Dataset dataset = createTestDataset(entry.getId().getEntryId());
            List<ValidatorError> errors = test(dataset);

            if (!errors.isEmpty()) {
                for (ValidatorError error : errors) {
                    if (errorPathCount.containsKey(error.getPath())) {
                        errorPathCount.put(error.getPath(), errorPathCount.get(error.getPath()) + 1);
                    } else errorPathCount.put(error.getPath(), 1);
                }
            }
        }

        assertEquals(errorPathCount.size(), 0);
    }

    @Test
    public void testGetEntryIdByErrorBreadcrumbForAllDatasets() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypesMaxRevisionID(types);

        Map<String, List<Long>> errorPathForEntryIds = new HashMap<String, List<Long>>();

        for (Entry entry : entriesList) {
            Dataset dataset = createTestDataset(entry.getId().getEntryId());
            List<ValidatorError> errors = test(dataset);

            if (!errors.isEmpty()) {
                for (ValidatorError error : errors) {
                    if (errorPathForEntryIds.containsKey(error.getPath())) {
                        errorPathForEntryIds.get(error.getPath()).add(entry.getId().getEntryId());
                    } else {
                        ArrayList<Long> longList = new ArrayList<Long>();
                        longList.add(entry.getId().getEntryId());
                        errorPathForEntryIds.put(error.getPath(), longList);
                    }
                }
            }
        }

        assertEquals(errorPathForEntryIds.size(), 0);
    }


    private String sortJsonObject(JsonObject jsonObject) {
        List<String> jsonElements = new ArrayList<>();

        Set<Map.Entry<String, JsonElement>> entries = jsonObject.entrySet();
        for (Map.Entry<String, JsonElement> entry : entries)
            jsonElements.add(entry.getKey());

        Collections.sort(jsonElements);

        JsonArray jsonArray = new JsonArray();
        for (String elementName : jsonElements) {
            JsonObject newJsonObject = new JsonObject();
            JsonElement jsonElement = jsonObject.get(elementName);
            if (jsonElement.isJsonObject())
                newJsonObject.add(elementName, new JsonPrimitive(sortJsonObject(jsonObject.get(elementName).getAsJsonObject())));
            else if (jsonElement.isJsonArray()) {
                newJsonObject.add(elementName, sortJsonArray(jsonElement));
            } else
                newJsonObject.add(elementName, jsonElement);
            jsonArray.add(newJsonObject);
        }

        return jsonArray.toString();
    }

    private JsonArray sortJsonArray(JsonElement jsonElement) {
        JsonArray sortedArray = new JsonArray();

        JsonArray jsonElementAsArray = jsonElement.getAsJsonArray();
        for (JsonElement arrayMember : jsonElementAsArray)
            if (arrayMember.isJsonObject()) {
                sortedArray.add(new JsonPrimitive(sortJsonObject(arrayMember.getAsJsonObject())));
            } else if (arrayMember.isJsonArray()) {
                sortedArray.add(sortJsonArray(arrayMember));
            } else {
                sortedArray.add(arrayMember.toString());
            }
        return sortedArray;
    }


/*
    @Test
    public void testDatasetCreationComparision() {
        Long entryId = 566L;
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);

        Dataset datasetJohn = null;
        Dataset datasetJeff = null;
        try {
            datasetJohn = (Dataset) ReflectionFactory.create(Dataset.class, dataset);
            //Reflection Factory
//            datasetJohn = (Dataset) ReflectionFactory.create(Dataset.class, createTestDataset(entryId));
            //Dataset Factory
            datasetJeff = createTestDataset(entryId);
//            datasetJeff = DatasetFactory.createDatasetForWebFlow(null);
        } catch (Exception e) {
            e.printStackTrace();
            fail();
        }

        assertTrue(datasetComparision(datasetJohn, datasetJeff, entry));
        datasetJeff.getDistributions().get(0).getDates().get(4);
        datasetJohn.getDistributions().get(0).getDates().get(4);

        XStream xstream = new XStream(new DomDriver()); // does not require XPP3 library
        String xmlJohn = xstream.toXML(datasetJohn).
                replaceAll("edu.pitt.isg.dc.utils.ReflectionFactoryElementFactory", "org.springframework.util.AutoPopulatingList\\$ReflectiveElementFactory").
                replaceAll("dats2_2", "dats2__2");


        String xmlJeff = xstream.toXML(datasetJeff).
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedDateWrapper", "edu.pitt.isg.mdc.dats2_2.Date").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedOrganizationWrapper", "edu.pitt.isg.mdc.dats2_2.Organization").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedPersonComprisedEntityWrapper", "edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedLicenseWrapper", "edu.pitt.isg.mdc.dats2_2.License").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedAccessWrapper", "edu.pitt.isg.mdc.dats2_2.Access").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedPlaceWrapper", "edu.pitt.isg.mdc.dats2_2.Place").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedTypeWrapper", "edu.pitt.isg.mdc.dats2_2.Type").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedDistributionWrapper", "edu.pitt.isg.mdc.dats2_2.Distribution").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedGrantWrapper", "edu.pitt.isg.mdc.dats2_2.Grant").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedPublicationWrapper", "edu.pitt.isg.mdc.dats2_2.Publication").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedIsAboutWrapper", "edu.pitt.isg.mdc.dats2_2.IsAbout").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedCategoryValuePairWrapper", "edu.pitt.isg.mdc.dats2_2.CategoryValuePair").
                replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedDataStandardWrapper", "edu.pitt.isg.mdc.dats2_2.DataStandard").
                replaceAll("dats2_2", "dats2__2");



        assertEquals(xmlJeff, xmlJohn);
    }
*/


    @Test
    public void testDatasetCreationComparisionForAllDatasets() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypesMaxRevisionID(types);

        Map<String, List<Long>> errorPathForEntryIds = new HashMap<String, List<Long>>();

        for (Entry entry : entriesList) {
            EntryView entryView = new EntryView(entry);

            Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
            Dataset datasetJohn = null;
            Dataset datasetJeff = null;
            try {
                //Reflection Factory
                datasetJohn = (Dataset) ReflectionFactory.create(Dataset.class, dataset);
                //Dataset Factory
                datasetJeff = createTestDataset(entryView.getId().getEntryId());
            } catch (Exception e) {
                e.printStackTrace();
                fail();
            }

            assertTrue(datasetComparision(datasetJohn, datasetJeff, entry));
//            datasetJeff.getDistributions().get(0).getDates().get(4);
//            datasetJohn.getDistributions().get(0).getDates().get(4);

            XStream xstream = new XStream(new DomDriver()); // does not require XPP3 library
            String xmlJohn = xstream.toXML(datasetJohn).
                    replaceAll("edu.pitt.isg.dc.utils.ReflectionFactoryElementFactory", "org.springframework.util.AutoPopulatingList\\$ReflectiveElementFactory").
                    replaceAll("dats2_2", "dats2__2");


            String xmlJeff = xstream.toXML(datasetJeff).
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedDateWrapper", "edu.pitt.isg.mdc.dats2_2.Date").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedOrganizationWrapper", "edu.pitt.isg.mdc.dats2_2.Organization").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedPersonComprisedEntityWrapper", "edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedLicenseWrapper", "edu.pitt.isg.mdc.dats2_2.License").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedAccessWrapper", "edu.pitt.isg.mdc.dats2_2.Access").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedPlaceWrapper", "edu.pitt.isg.mdc.dats2_2.Place").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedTypeWrapper", "edu.pitt.isg.mdc.dats2_2.Type").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedDistributionWrapper", "edu.pitt.isg.mdc.dats2_2.Distribution").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedGrantWrapper", "edu.pitt.isg.mdc.dats2_2.Grant").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedPublicationWrapper", "edu.pitt.isg.mdc.dats2_2.Publication").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedIsAboutWrapper", "edu.pitt.isg.mdc.dats2_2.IsAbout").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedCategoryValuePairWrapper", "edu.pitt.isg.mdc.dats2_2.CategoryValuePair").
                    replaceAll("edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedDataStandardWrapper", "edu.pitt.isg.mdc.dats2_2.DataStandard").
                    replaceAll("dats2_2", "dats2__2");

            assertEquals(xmlJeff, xmlJohn);        }
    }


    public Boolean datasetComparision(Dataset datasetLeft, Dataset datasetRight, Entry entry) {
        Class clazz = Dataset.class;

        //issues with converter.toJsonObject -- with regards to isAbout and PersonComprisedEntity
        //for example PeronComprisedEntity is only returning identifier and alternateIdentifier;  isAbout isn't returning anything
        JsonObject jsonObjectFromDatabaseLeft = converter.toJsonObject(clazz, datasetLeft);
        JsonObject jsonObjectFromDatabaseRight = converter.toJsonObject(clazz, datasetRight);

        Map<String, Object> databaseMapLeft = gson.fromJson(jsonObjectFromDatabaseLeft, mapType);
        Map<String, Object> databaseMapRight = gson.fromJson(jsonObjectFromDatabaseRight, mapType);

        MapDifference<String, Object> d = Maps.difference(databaseMapLeft, databaseMapRight);

        if (datasetLeft.equals(datasetRight) && d.areEqual()) {
            return true;
        } else {
            if (!d.toString().equalsIgnoreCase("equal")) {
                if (d.entriesOnlyOnLeft().size() > 0) {
                    System.out.print("Entry " + jsonObjectFromDatabaseRight.get("title") + " (" + entry.getId().getEntryId() + "), Left contains");
                    Iterator<String> it = d.entriesOnlyOnLeft().keySet().iterator();
                    while (it.hasNext()) {

                        String field = it.next();
                        System.out.print(" " + field + ",");

                    }
                    System.out.print(" but Right does not.\n");
                }

                if (d.entriesOnlyOnRight().size() > 0) {
                    System.out.print("Entry " + jsonObjectFromDatabaseRight.get("title") + " (" + entry.getId().getEntryId() + "), Right contains");
                    Iterator<String> it = d.entriesOnlyOnRight().keySet().iterator();
                    while (it.hasNext()) {
                        String field = it.next();
                        System.out.print(" " + field + ",");

                    }
                    System.out.print(" but Left does not.\n");
                }

                if (d.entriesDiffering().size() > 0) {
                    Iterator<String> it = d.entriesDiffering().keySet().iterator();
                    while (it.hasNext()) {
                        String value = it.next();

                        String left;
                        if (jsonObjectFromDatabaseLeft.get(value).isJsonArray()) {
                            left = sortJsonObject(jsonObjectFromDatabaseLeft.get(value).getAsJsonArray().get(0).getAsJsonObject());
                        } else {
                            left = sortJsonObject(jsonObjectFromDatabaseLeft.get(value).getAsJsonObject());
                        }

                        String right;
                        if (jsonObjectFromDatabaseRight.get(value).isJsonArray()) {
                            right = sortJsonObject(jsonObjectFromDatabaseRight.get(value).getAsJsonArray().get(0).getAsJsonObject());
                        } else {
                            right = sortJsonObject(jsonObjectFromDatabaseRight.get(value).getAsJsonObject());
                        }

                        if (!left.equals(right)) {
                            int idxOfDifference = TestConvertDatsToJava.indexOfDifference(left, right);


                            try {
                                System.out.println("In " + value + " section from Left: ...\n" + left.substring(0, idxOfDifference) + Converter.ANSI_CYAN + left.substring(idxOfDifference, left.length()) + Converter.ANSI_RESET);
                                System.out.println("In " + value + " section from Right: ...\n" + right.substring(0, idxOfDifference) + Converter.ANSI_CYAN + right.substring(idxOfDifference, right.length()) + Converter.ANSI_RESET);
                            } catch (StringIndexOutOfBoundsException e) {
                                System.out.println("idxOfDifference:" + idxOfDifference);
                                // System.out.println("end:" + end);

                                throw e;
                            }
                        } else {
                            System.out.println(d);
                        }

                    }
                }
            }
            return false;
        }

    }


/*
    @Test
    public void testCleanseSingleDataset(){
        Long entryId = 566L;
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        //create and clean datasetOriginal -- remove Emtpy Strings
        Dataset datasetOriginal = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
        try {
            datasetOriginal = (Dataset) webFlowReflectionValidator.cleanse(Dataset.class, datasetOriginal);
        } catch (FatalReflectionValidatorException e) {
            e.printStackTrace();
        }

        //create and run dataset through Factory
        Dataset dataset = new Dataset();
        try {
            dataset = (Dataset) ReflectionFactory.create(Dataset.class, datasetOriginal);
//            dataset = createTestDataset(entry.getId().getEntryId());
        } catch (Exception e) {
            e.printStackTrace();
            fail();
        }
        //clean dataset
        try {
            dataset = (Dataset) webFlowReflectionValidator.cleanse(Dataset.class, dataset);
        } catch (FatalReflectionValidatorException e) {
            e.printStackTrace();
        }

        //compare original (cleaned) with dataset ran through Factory and cleaned
        assertTrue(datasetComparision(datasetOriginal, dataset, entry));

        XStream xstream = new XStream(new DomDriver()); // does not require XPP3 library
        String xmlCleansed = xstream.toXML(dataset);
        String xmlOriginal = xstream.toXML(datasetOriginal);
        assertEquals(xmlOriginal, xmlCleansed);
    }
*/


    @Test
    public void testCleanseForAllDatasets() {
        Set<String> types = new HashSet<>();
        types.add(Dataset.class.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypesMaxRevisionID(types);

        Map<String, List<Long>> errorPathForEntryIds = new HashMap<String, List<Long>>();

        for (Entry entry : entriesList) {
            EntryView entryView = new EntryView(entry);

            //create and clean datasetOriginal -- remove Emtpy Strings
            Dataset datasetOriginal = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
            try {
                datasetOriginal = (Dataset) webFlowReflectionValidator.cleanse(Dataset.class, datasetOriginal, true, true);
            } catch (FatalReflectionValidatorException e) {
                e.printStackTrace();
            }

            //create and run dataset through Factory
            Dataset dataset = new Dataset();
            try {
                dataset = (Dataset) ReflectionFactory.create(Dataset.class, datasetOriginal);
//                dataset = createTestDataset(entry.getId().getEntryId());
            } catch (Exception e) {
                e.printStackTrace();
                fail();
            }
            //clean dataset
            try {
                dataset = (Dataset) webFlowReflectionValidator.cleanse(Dataset.class, dataset, true, true);
            } catch (FatalReflectionValidatorException e) {
                e.printStackTrace();
            }

            //compare original (cleaned) with dataset ran through Factory and cleaned
            assertTrue(datasetComparision(datasetOriginal, dataset, entry));

            XStream xstream = new XStream(new DomDriver()); // does not require XPP3 library
            String xmlCleansed = xstream.toXML(dataset);
            String xmlOriginal = xstream.toXML(datasetOriginal);
            assertEquals(xmlOriginal, xmlCleansed);
        }
    }

}

import edu.pitt.isg.dc.WebApplication;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.utils.DatasetFactory;
import edu.pitt.isg.dc.utils.DatasetFactoryPerfectTest;
import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.dc.validator.ReflectionValidator;
import edu.pitt.isg.dc.validator.ValidatorError;
import edu.pitt.isg.dc.validator.ValidatorErrorType;
import edu.pitt.isg.mdc.dats2_2.Access;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.Converter;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
import edu.pitt.isg.mdc.dats2_2.Type;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.validatorErrors;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;


@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class DatasetValidatorTest {
    @Autowired
    private ApiUtil apiUtil;

    private Converter converter = new Converter();

    @Test
    public void testEmptyDataset() {
        Dataset dataset = new Dataset();
    }

    private Dataset createTestDataset(Long entryId){
        Entry entry = apiUtil.getEntryByIdIncludeNonPublic(entryId);
        EntryView entryView = new EntryView(entry);

        Dataset dataset = (Dataset) converter.fromJson(entryView.getUnescapedEntryJsonString(), Dataset.class);
        dataset = DatasetFactory.createDatasetForWebFlow(dataset);

//        Dataset dataset = (Dataset) ReflectionFactory.create(Dataset.class);
        //make your dataset here

        return dataset;
    }

    private Dataset createPerfectDataset(){
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
            Type type = iterator.next();
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

        dataset.getPrimaryPublications().get(0).getAcknowledges().get(0).setFunders(DatasetFactory.createPersonComprisedEntityList(null));

        ((IsAboutItems) dataset.getIsAbout().get(0)).setName(null);

        dataset.getProducedBy().setName(null);

        dataset.getProducedBy().getEndDate().setDate(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->title");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(1).getPath(), "(root)->types");
            assertEquals(errors.get(1).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(2).getPath(), "(root)->creators->affiliations->location->identifier->identifierSource");
            assertEquals(errors.get(2).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(3).getPath(), "(root)->creators->name");
            assertEquals(errors.get(3).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(4).getPath(), "(root)->storedIn->name");
            assertEquals(errors.get(4).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(5).getPath(), "(root)->distributions->access->landingPage");
            assertEquals(errors.get(5).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(6).getPath(), "(root)->distributions->dates->type");
            assertEquals(errors.get(6).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(7).getPath(), "(root)->distributions->conformsTo->type");
            assertEquals(errors.get(7).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(8).getPath(), "(root)->primaryPublications->acknowledges->name");
            assertEquals(errors.get(8).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(9).getPath(), "(root)->primaryPublications->acknowledges->funders");
            assertEquals(errors.get(9).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(10).getPath(), "(root)->producedBy->name");
            assertEquals(errors.get(10).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(11).getPath(), "(root)->producedBy->endDate->date");
            assertEquals(errors.get(11).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(12).getPath(), "(root)->licenses->name");
            assertEquals(errors.get(12).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);

            assertEquals(errors.get(13).getPath(), "(root)->isAbout->name");
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
            PersonComprisedEntity personComprisedEntity = iterator.next();
            iterator.remove();
        }

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
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
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->distributions->access");
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

    @Test
    public void testRealDataset() {
        Dataset dataset = createTestDataset(86L);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
          /*  assertEquals(errors.get(0).getPath(), "(root)->isAbout->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);*/
        } else assertTrue(true);
    }


}

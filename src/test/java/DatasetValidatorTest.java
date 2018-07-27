import edu.pitt.isg.dc.WebApplication;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.EntryId;
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

import static org.junit.Assert.assertEquals;
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
            ReflectionValidator.validate(Dataset.class, dataset, true, breadcrumb, null, errors);
            //somehow "expect" error messages....
        } catch (Exception e) {
            e.printStackTrace();
            fail();
        }
        return validatorErrors(errors);
    }

    private List<ValidatorError> validatorErrors(List<ValidatorError> errors){
        ListIterator<? extends ValidatorError> iterator = errors.listIterator();
        while (iterator.hasNext()) {
            ValidatorError validatorError = iterator.next();
            if(validatorError.getPath().contains("coordinates")){
                iterator.remove();
            }
        }
        return errors;
    }

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

/*
    @Test
    public void testDatasetCreatorNameMissing() {
//        Dataset dataset = createTestDataset(566L);
        Dataset dataset = createPerfectDataset();

        ((PersonOrganization) dataset.getCreators().get(0)).setLastName(null);
        ((PersonOrganization) dataset.getCreators().get(0)).setFirstName(null);
        ((PersonOrganization) dataset.getCreators().get(0)).setFullName(null);

        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Creator name.");
    }
*/

    @Test
    public void testDatasetCreatorOrganizationNameMissing() {
        Dataset dataset = createPerfectDataset();

        ListIterator<? extends PersonComprisedEntity> iterator = dataset.getCreators().listIterator();
        while (iterator.hasNext()) {
            PersonComprisedEntity personComprisedEntity = iterator.next();
            iterator.remove();
        }

        dataset.setCreators(DatasetFactory.createPersonComprisedEntityList(null));
        dataset.getCreators().get(0).getIdentifier().setIdentifier("id");
        dataset.getCreators().get(0).getIdentifier().setIdentifierSource("id source");
        ((PersonOrganization) dataset.getCreators().get(0)).setAbbreviation("abbrev");
        ((PersonOrganization) dataset.getCreators().get(0)).getLocation().setName("location name");


        List<ValidatorError> errors = test(dataset);
        if(!errors.isEmpty()) {
            assertEquals(errors.get(0).getPath(), "(root)->creators->name");
            assertEquals(errors.get(0).getErrorType(), ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD);
        } else fail("No error messages produced for missing Creator Organization name.");
    }

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
        } else fail("No error messages produced for missing Types");
    }


    @Test
    public void testPerfectDatasetWithAllPossibleFields() {
///???
    }


}

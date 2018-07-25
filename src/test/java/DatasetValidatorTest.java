import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.dc.validator.ReflectionValidator;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class DatasetValidatorTest {
    @Test
    public void testEmptyDataset() {
        Dataset dataset = new Dataset();
    }

    private List<String> test(Dataset dataset) {
        //don't have to do this yet
        String breadcrumb = "";
        List<String> errors = new ArrayList<>();
        try {
            ReflectionValidator.validate(Dataset.class, dataset, true, breadcrumb, null, errors);
            //somehow "expect" error messages....
        } catch (Exception e) {
            fail();
        }
        return errors;
    }

    @Test
    public void testDatasetWithoutTitleOnly() throws Exception {

        Dataset dataset = (Dataset) ReflectionFactory.create(Dataset.class);
        //make your dataset here


        List<String> errors = test(dataset);
        //add all requires lists, but not the title...
        assertEquals(errors.get(0), "Field title....is not empty.");
    }

    @Test
    public void testDatasetWithoutCreatorsOnly() {

    }

    @Test
    public void testPerfectDatasetExceptLicenseIsMissingName() {

    }


    @Test
    public void testPerfectDatasetWithAllPossibleFields() {
///???
    }


}

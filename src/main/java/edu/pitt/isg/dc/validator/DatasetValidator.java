package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.Organization;
import edu.pitt.isg.mdc.dats2_2.Person;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.*;

@Component
public class DatasetValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return Dataset.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Dataset dataset = (Dataset) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.dataset.title");

        // Validate and remove empty creators
        if (dataset.getCreators().size() == 0) {
            errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
        } else {
            clearPersonComprisedEntity(dataset.getCreators(), errors, "creators");
//            boolean hasError = true;
//            ListIterator<PersonComprisedEntity> iterator = dataset.getCreators().listIterator();
//            while (iterator.hasNext()) {
//                PersonComprisedEntity personComprisedEntity = iterator.next();
//                if (personComprisedEntity instanceof Person) {
//                    Person person = (Person) personComprisedEntity;
//                    if (isEmpty(person.getFirstName()) && isEmpty(person.getLastName()) && isEmpty(person.getEmail())) {
//                        iterator.remove();
//                    } else {
//                        hasError = false;
//                    }
//                } else if (personComprisedEntity instanceof Organization) {
//                    //ADD CODE HERE
//                }
//            }
            if (dataset.getCreators().size() == 0) {
                errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
            }
        }

        //Remove empty identifier
        if (!isEmpty(dataset.getIdentifier())) {
            if (isEmpty(dataset.getIdentifier().getIdentifier()) && isEmpty(dataset.getIdentifier().getIdentifierSource())) {
                dataset.setIdentifier(null);
            }
        }

        // Validate and remove empty types
        clearTypes(dataset.getTypes(), errors);

        // Remove empty extra properties
        clearExtraProperties(dataset.getExtraProperties(), "", errors);

        //Remove empty study
        clearStudy(dataset.getProducedBy(), errors);

        //Remove empty distributions
        clearDistributions(dataset.getDistributions(), errors);

        // Remove empty isAbout and spatial coverage
        clearBiologicalEntities(dataset.getIsAbout(), errors, "isAbout");

        //JDL JDL JDL
        //clearBiologicalEntities(dataset.getSpatialCoverage(), errors, "spatialCoverage");
    }
}
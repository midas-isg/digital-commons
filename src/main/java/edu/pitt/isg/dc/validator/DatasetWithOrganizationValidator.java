package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.List;
import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.*;

@Component
public class DatasetWithOrganizationValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DatasetWithOrganization.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DatasetWithOrganization dataset = (DatasetWithOrganization) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.dataset.title");

        // Validate and remove empty creators
        if (dataset.getCreators().size() == 0) {
            errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
        } else {
            ListIterator<Organization> iterator = dataset.getCreators().listIterator();
            while (iterator.hasNext()) {
                Organization organization = iterator.next();
                if (isEmpty(organization.getName())) {
                    errors.rejectValue("creators["+iterator.previousIndex()+"].name", "NotEmpty.dataset.creator.name");
                }
                if (isEmpty(organization.getName()) && isEmpty(organization.getAbbreviation()) && isEmpty(organization.getLocation().getName()) && isEmpty(organization.getLocation().getDescription()) && isEmpty(organization.getLocation().getPostalAddress())) {
                    iterator.remove();
                }
            }
            if (dataset.getCreators().size() == 0) {
                errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
            }
        }

        //Remove empty identifier
        if(!isEmpty(dataset.getIdentifier())) {
            if (isEmpty(dataset.getIdentifier().getIdentifier()) && isEmpty(dataset.getIdentifier().getIdentifierSource())) {
                dataset.setIdentifier(null);
            }
        }

        // Validate and remove empty types
        clearTypes(dataset.getTypes(), errors);

        // Remove empty extra properties
        clearExtraProperties(dataset.getExtraProperties());

        //Remove empty distributions
        clearDistributions(dataset.getDistributions());

        // Remove empty isAbout and spatial coverage
        clearBiologicalEntities(dataset.getIsAbout());
        clearBiologicalEntities(dataset.getSpatialCoverage());
    }
}
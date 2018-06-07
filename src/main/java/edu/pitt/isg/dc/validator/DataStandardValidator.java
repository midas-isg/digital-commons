package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.Annotation;
import edu.pitt.isg.mdc.dats2_2.CategoryValuePair;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.*;

@Component
public class DataStandardValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DataStandard.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DataStandard dataStandard = (DataStandard) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "NotEmpty.dataset.creator.name");

        if(isEmpty(dataStandard.getType())) {
            errors.rejectValue("type", "NotEmpty.dataset.type");
        } else {
            if (isEmpty(dataStandard.getType().getValue()) && isEmpty(dataStandard.getType().getValueIRI())) {
                errors.rejectValue("type", "NotEmpty.dataset.type");
            }

            if (!isValidIRI(dataStandard.getType().getValueIRI())) {
                errors.rejectValue("type.valueIRI", "NotEmpty.dataset.valueIRI");
            }
        }

        if(isEmpty(dataStandard.getIdentifier()) || isEmpty(dataStandard.getIdentifier().getIdentifier())) {
            errors.rejectValue("identifier", "NotEmpty.dataset.identifier");
        }

        // Remove empty extra properties
        clearExtraProperties(dataStandard.getExtraProperties());
    }

}
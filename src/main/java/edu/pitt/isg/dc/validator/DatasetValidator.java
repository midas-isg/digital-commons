package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

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

        if (dataset.getCreators().get(0).getLastName() == null && dataset.getCreators().get(0).getFirstName() == null && dataset.getCreators().get(0).getEmail() == null) {
            errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
        }

        if(dataset.getTypes().size() == 0) {
            errors.rejectValue("types[0]", "NotEmpty.dataset.type");
        }
    }
}

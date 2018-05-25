package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.Annotation;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.Type;
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

        if (dataset.getTypes().size() == 0) {
            errors.rejectValue("types[0]", "NotEmpty.dataset.type");
        } else {
            boolean hasError = false;
            for (Type type : dataset.getTypes()) {
                if (type.getInformation() == null && type.getPlatform() == null && type.getMethod() == null) {
                    hasError = true;
                } else {
                    Annotation annotation;
                    try {
                        annotation = type.getInformation();
                        if (annotation.getValueIRI() == null && annotation.getValue() == null) {
                            hasError = true;
                        }
                    } catch (NullPointerException e) {
                    }

                    try {
                        annotation = type.getMethod();
                        if (annotation.getValueIRI() == null && annotation.getValue() == null) {
                            hasError = true;
                        }
                    } catch (NullPointerException e) {
                    }

                    try {
                        annotation = type.getPlatform();
                        if (annotation.getValueIRI() == null && annotation.getValue() == null) {
                            hasError = true;
                        }
                    } catch (NullPointerException e) {
                    }
                }
            }
            if (hasError) {
                errors.rejectValue("types[0]", "NotEmpty.dataset.type");
            }
        }
    }
}

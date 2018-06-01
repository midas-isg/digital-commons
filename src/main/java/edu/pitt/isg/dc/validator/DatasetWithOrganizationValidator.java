package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

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
            boolean hasError = true;
            ListIterator<Organization> iterator = dataset.getCreators().listIterator();
            while (iterator.hasNext()) {
                Organization organization = iterator.next();
                if (isEmpty(organization.getName())) {
                    iterator.remove();
                } else {
                    hasError = false;
                }
            }
            if (hasError) {
                errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
            }
        }

        // Validate and remove empty types
        if (dataset.getTypes().size() == 0) {
            errors.rejectValue("types[0]", "NotEmpty.dataset.type");
        } else {
            boolean hasError = true;
            ListIterator<Type> iterator = dataset.getTypes().listIterator();
            while (iterator.hasNext()) {
                Type type = iterator.next();
                Annotation annotation;
                try {
                    annotation = type.getInformation();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setInformation(null);
                    } else {
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getMethod();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setMethod(null);
                    } else {
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getPlatform();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setPlatform(null);
                    } else {
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                if (isEmpty(type.getInformation()) && isEmpty(type.getMethod()) && isEmpty(type.getPlatform())) {
                    iterator.remove();
                }
            }

            if (hasError) {
                errors.rejectValue("types[0]", "NotEmpty.dataset.type");
            }
        }

        // Remove empty isAbout and spatial coverage
        ListIterator<BiologicalEntity> iterator = dataset.getIsAbout().listIterator();
        while (iterator.hasNext()) {
            BiologicalEntity entity = iterator.next();
            if (isEmpty(entity)) {
                iterator.remove();
            } else if (isEmpty(entity.getDescription()) && isEmpty(entity.getName()) && entity.getAlternateIdentifiers().size() == 0 && isEmpty(entity.getIdentifier())) {
                iterator.remove();
            }
        }
        iterator = dataset.getSpatialCoverage().listIterator();
        while (iterator.hasNext()) {
            BiologicalEntity entity = iterator.next();
            if (isEmpty(entity)) {
                iterator.remove();
            } else if (isEmpty(entity.getDescription()) && isEmpty(entity.getName()) && entity.getAlternateIdentifiers().size() == 0 && isEmpty(entity.getIdentifier())) {
                iterator.remove();
            }
        }
    }


    public static boolean isEmpty(Object object) {
        if (object == null) {
            return true;
        }
        return false;
    }


    public static boolean isEmpty(Object[] array) {
        if (array == null || array.length == 0) {
            return true;
        }
        return false;
    }


    public static boolean isEmpty(String string) {
        if (string == null || string.trim().length() == 0) {
            return true;
        }
        return false;
    }
}
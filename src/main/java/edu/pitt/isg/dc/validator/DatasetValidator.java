package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isEmpty;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isValidIRI;

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
            boolean hasError = true;
            ListIterator<Person> iterator = dataset.getCreators().listIterator();
            while (iterator.hasNext()) {
                Person person = iterator.next();
                if (isEmpty(person.getFirstName()) && isEmpty(person.getLastName()) && isEmpty(person.getEmail())) {
                    iterator.remove();
                } else {
                    hasError = false;
                }
            }
            if (hasError) {
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
        if (dataset.getTypes().size() == 0) {
            errors.rejectValue("types[0]", "NotEmpty.dataset.type");
        } else {
            boolean hasError = true;
            ListIterator<Type> iterator = dataset.getTypes().listIterator();
            int counter = 0;
            while (iterator.hasNext()) {
                Type type = iterator.next();
                Annotation annotation;
                try {
                    annotation = type.getInformation();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setInformation(null);
                    } else {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue("types[" + Integer.toString(counter) + "].information.valueIRI", "NotEmpty.dataset.valueIRI");
                            }
                        }
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getMethod();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setMethod(null);
                    } else {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue("types[" + Integer.toString(counter) + "].method.valueIRI", "NotEmpty.dataset.valueIRI");
                            }
                        }
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getPlatform();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setPlatform(null);
                    } else {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue("types[" + Integer.toString(counter) + "].platform.valueIRI", "NotEmpty.dataset.valueIRI");
                            }
                        }
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                if (isEmpty(type.getInformation()) && isEmpty(type.getMethod()) && isEmpty(type.getPlatform())) {
                    iterator.remove();
                    counter--;
                }
                counter++;
            }

            if (hasError) {
                errors.rejectValue("types[0]", "NotEmpty.dataset.type");
            }
        }

        // Remove empty extra properties
        if (dataset.getExtraProperties().size() > 0) {
            ListIterator<CategoryValuePair> iterator = dataset.getExtraProperties().listIterator();
            while (iterator.hasNext()) {
                CategoryValuePair property = iterator.next();
                ListIterator<Annotation> valueIterator = property.getValues().listIterator();
                while (valueIterator.hasNext()) {
                    Annotation value = valueIterator.next();
                    if (isEmpty(value.getValue()) && isEmpty(value.getValueIRI())) {
                        valueIterator.remove();
                    }
                }

                if (isEmpty(property.getCategory()) && isEmpty(property.getCategoryIRI()) && property.getValues().size() == 0) {
                    iterator.remove();
                }
            }
        }

        //Remove empty distributions
        if (dataset.getDistributions().size() > 0) {
            ListIterator<Distribution> iterator = dataset.getDistributions().listIterator();
            while (iterator.hasNext()) {
                Distribution distribution = iterator.next();
                if (!isEmpty(distribution.getIdentifier())) {
                    if (isEmpty(distribution.getIdentifier().getIdentifier()) && isEmpty(distribution.getIdentifier().getIdentifierSource())) {
                        distribution.setIdentifier(null);
                    }
                }

                //Clean up Access
                if (isEmpty(distribution.getAccess().getAccessURL()) && isEmpty(distribution.getAccess().getLandingPage())) {
                    distribution.setAccess(null);
                }

                //Clean up Unit
                if (isEmpty(distribution.getUnit().getValue()) && isEmpty(distribution.getUnit().getValueIRI())) {
                    distribution.setUnit(null);
                }

                //Clean up Dates
                ListIterator<Date> dateListIterator = distribution.getDates().listIterator();
                while (dateListIterator.hasNext()) {
                    Date date = dateListIterator.next();
                    if (isEmpty(date.getDate()) && isEmpty(date.getType().getValue()) && isEmpty(date.getType().getValueIRI())) {
                        dateListIterator.remove();
                    }
                }

                //Clean up ConformsTo
                ListIterator<DataStandard> conformsToIterator = distribution.getConformsTo().listIterator();
                while (conformsToIterator.hasNext()) {
                    DataStandard conformsTo = conformsToIterator.next();

                    ListIterator<License> licenseListIterator = conformsTo.getLicenses().listIterator();
                    while (licenseListIterator.hasNext()) {
                        License license = licenseListIterator.next();
                        if (isEmpty(license.getIdentifier()) && isEmpty(license.getIdentifierSource()) && isEmpty(license.getVersion())) {
                            licenseListIterator.remove();
                        }
                    }

                    if (isEmpty(conformsTo.getIdentifier()) && isEmpty(conformsTo.getName()) && isEmpty(conformsTo.getDescription()) && isEmpty(conformsTo.getVersion()) && conformsTo.getExtraProperties().size() == 0 && isEmpty(conformsTo.getType().getValueIRI()) && isEmpty(conformsTo.getType().getValue()) && conformsTo.getLicenses().size() == 0) {
                        conformsToIterator.remove();
                    }
                }


                //Clean up Stored In
                DataRepository storedIn = distribution.getStoredIn();
                ListIterator<License> licenseListIterator = storedIn.getLicenses().listIterator();
                while (licenseListIterator.hasNext()) {
                    License license = licenseListIterator.next();
                    if (isEmpty(license.getIdentifier()) && isEmpty(license.getIdentifierSource()) && isEmpty(license.getVersion())) {
                        licenseListIterator.remove();
                    }
                }
                ListIterator<Annotation> typesIterator = storedIn.getTypes().listIterator();
                while (typesIterator.hasNext()) {
                    Annotation annotation = typesIterator.next();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        typesIterator.remove();
                    }
                }
                if (isEmpty(storedIn.getName()) && isEmpty(storedIn.getIdentifier()) && isEmpty(storedIn.getVersion()) && storedIn.getLicenses().size() == 0 && storedIn.getTypes().size() == 0) {
                    distribution.setStoredIn(null);
                }


                // Clean up Formats
                ListIterator<String> formatIterator = distribution.getFormats().listIterator();
                while (formatIterator.hasNext()) {
                    String format = formatIterator.next();
                    if (isEmpty(format)) {
                        formatIterator.remove();
                    }
                }

                if (isEmpty(distribution.getIdentifier()) && isEmpty(distribution.getSize()) && distribution.getDates().size() == 0 && distribution.getConformsTo().size() == 0 && isEmpty(distribution.getStoredIn()) && isEmpty(distribution.getUnit()) && distribution.getFormats().size() == 0) {
                    iterator.remove();
                }
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
}
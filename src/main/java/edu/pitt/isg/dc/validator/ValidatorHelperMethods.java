package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.*;
import edu.pitt.isg.mdc.v1_0.Identifier;
import edu.pitt.isg.mdc.v1_0.NestedIdentifier;
import org.springframework.validation.Errors;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.List;
import java.util.ListIterator;

public class ValidatorHelperMethods {
    public static void clearStringList(ListIterator<String> listIterator) {
        while (listIterator.hasNext()) {
            String string = listIterator.next();
            if (isEmpty(string)) {
                listIterator.remove();
            }
        }
    }

    public static void clearNestedIdentifier(ListIterator<NestedIdentifier> nestedIdentifierListIterator) {
        while(nestedIdentifierListIterator.hasNext()) {
            NestedIdentifier nestedIdentifier = nestedIdentifierListIterator.next();
            Identifier identifier = nestedIdentifier.getIdentifier();
            if(identifier == null) {
                nestedIdentifierListIterator.remove();
                continue;
            }
            if(isEmpty(identifier.getIdentifier()) && isEmpty(identifier.getIdentifierDescription()) && isEmpty(identifier.getIdentifierSource())) {
                nestedIdentifierListIterator.remove();
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

    public static boolean isValidIRI(String string) {
        if(isEmpty(string)) {
            return false;
        }
        else if (string.toLowerCase().contains("http:") || string.toLowerCase().contains("https:")) {
            return true;
        }
        return false;
    }

    public static void clearBiologicalEntities(List<BiologicalEntity> biologicalEntities) {
        ListIterator<BiologicalEntity> iterator = biologicalEntities.listIterator();
        while (iterator.hasNext()) {
            BiologicalEntity entity = iterator.next();
            if (isEmpty(entity)) {
                iterator.remove();
            } else if (isEmpty(entity.getDescription()) && isEmpty(entity.getName()) && entity.getAlternateIdentifiers().size() == 0 && isEmpty(entity.getIdentifier())) {
                iterator.remove();
            }
        }
    }

    public static void clearStudy (Study study, Errors errors){
//        boolean hasError = true;
        if(!isEmpty(study)){
            if(isEmpty(study.getLocation().getPostalAddress())){
                study.setLocation(null);
            }

            if(!isEmpty(study.getStartDate().getType().getValueIRI())) {
                Annotation annotation;
                try {
                    annotation = study.getStartDate().getType();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        study.getStartDate().setType(null);
                    } else {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue("producedBy.startDate.type.valueIRI","NotEmpty.dataset.valueIRI");
                            }
                        }
//                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }
            } // end if

            if(!isEmpty(study.getEndDate().getType().getValueIRI())) {
                Annotation annotation;
                try {
                    annotation = study.getEndDate().getType();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        study.getEndDate().setType(null);
                    } else {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue("producedBy.endDate.type.valueIRI","NotEmpty.dataset.valueIRI");
                            }
                        }
//                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }
            } // end if

            if(isEmpty(study.getStartDate().getDate()) && isEmpty(study.getStartDate().getType())){
                study.setStartDate(null);
            }

            if(isEmpty(study.getEndDate().getDate()) && isEmpty(study.getEndDate().getType())){
                study.setEndDate(null);
            }

            if(isEmpty(study.getName())){
                errors.rejectValue("producedBy.name","NotEmpty.dataset.name");
            }

        }
    }

    public static void clearDistributions (List<Distribution> distributions, Errors errors) {
        if (distributions.size() > 0) {
            ListIterator<Distribution> iterator = distributions.listIterator();
            Integer distributionCounter = 0;
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
                } else if(!isEmpty(distribution.getUnit().getValueIRI())) {
                    if (!isValidIRI(distribution.getUnit().getValueIRI())) {
                        errors.rejectValue("distributions["+ distributionCounter + "].unit.valueIRI","NotEmpty.dataset.valueIRI");
                    }
                }


                //Clean up Dates
                ListIterator<Date> dateListIterator = distribution.getDates().listIterator();
                Integer dateCounter = 0;
                while (dateListIterator.hasNext()) {
                    Date date = dateListIterator.next();
                    if (isEmpty(date.getDate()) && isEmpty(date.getType().getValue()) && isEmpty(date.getType().getValueIRI())) {
                        dateListIterator.remove();
                    } else {
                        if(!isEmpty(date.getType().getValueIRI())) {
                            if (!isValidIRI(date.getType().getValueIRI())) {
                                errors.rejectValue("distributions[" + distributionCounter + "].dates[" + dateCounter + "].type.valueIRI", "NotEmpty.dataset.valueIRI");
                            }
                        }

                        dateCounter++;
                    }
                }

                //Clean up ConformsTo
                ListIterator<DataStandard> conformsToIterator = distribution.getConformsTo().listIterator();
                Integer conformsToCounter = 0;
                while (conformsToIterator.hasNext()) {
                    DataStandard conformsTo = conformsToIterator.next();

                    ListIterator<License> licenseListIterator = conformsTo.getLicenses().listIterator();
                    while (licenseListIterator.hasNext()) {
                        License license = licenseListIterator.next();
                        if (isEmpty(license.getIdentifier()) && isEmpty(license.getIdentifierSource()) && isEmpty(license.getVersion())) {
                            licenseListIterator.remove();
                        }
                    }

                    clearExtraProperties(conformsTo.getExtraProperties(),"distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "]." , errors);

                    if (isEmpty(conformsTo.getIdentifier()) && isEmpty(conformsTo.getName()) && isEmpty(conformsTo.getDescription()) && isEmpty(conformsTo.getVersion()) && conformsTo.getExtraProperties().size() == 0 && isEmpty(conformsTo.getType().getValueIRI()) && isEmpty(conformsTo.getType().getValue()) && conformsTo.getLicenses().size() == 0) {
                        conformsToIterator.remove();
                    } else {
                        conformsToCounter++;
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
                Integer typesCounter = 0;
                while (typesIterator.hasNext()) {
                    Annotation annotation = typesIterator.next();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        typesIterator.remove();
                    } else {
                        if(!isEmpty(annotation.getValueIRI())){
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue("distributions[" + distributionCounter + "].storedIn.types[" + typesCounter + "].valueIRI", "NotEmpty.dataset.valueIRI");
                            }
                        }
                        typesCounter++;
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
                } else {
                    distributionCounter++;
                }
            }
        }
    }

    public static void clearExtraProperties(List<CategoryValuePair> extraProperties, String errorLocation, Errors errors) {
        if(extraProperties.size() > 0) {
            ListIterator<CategoryValuePair> iterator = extraProperties.listIterator();
            int cvpCounter = 0;
            while (iterator.hasNext()) {
                CategoryValuePair property = iterator.next();
                if (!isEmpty(property.getCategoryIRI())) {
                    if (!isValidIRI(property.getCategoryIRI())) {
                        errors.rejectValue(errorLocation + "extraProperties[" + Integer.toString(cvpCounter) + "].categoryIRI", "NotEmpty.dataset.valueIRI");
                    }
                }
                ListIterator<Annotation> valueIterator = property.getValues().listIterator();
                int annotationCounter = 0;
                while(valueIterator.hasNext()) {
                    Annotation annotation = valueIterator.next();
                    if(isEmpty(annotation.getValue()) && isEmpty(annotation.getValueIRI())) {
                        valueIterator.remove();
                    } else {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                errors.rejectValue(errorLocation + "extraProperties[" + Integer.toString(cvpCounter) + "].values["
                                        + Integer.toString(annotationCounter) + "].valueIRI", "NotEmpty.dataset.valueIRI");
                            }
                        }

                        annotationCounter++;
                    }

                }

                if(isEmpty(property.getCategory()) && isEmpty(property.getCategoryIRI()) && property.getValues().size() == 0) {
                    iterator.remove();
                } else {
                    cvpCounter++;
                }
            }
        }
    }

    public static void clearTypes(List<Type> types, Errors errors) {
        if (types.size() == 0) {
            errors.rejectValue("types[0]", "NotEmpty.dataset.type");
        } else {
            boolean hasError = true;
            ListIterator<Type> iterator = types.listIterator();
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
    }
}

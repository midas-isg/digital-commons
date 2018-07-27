package edu.pitt.isg.dc.validator;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.*;
import edu.pitt.isg.mdc.v1_0.Identifier;
import edu.pitt.isg.mdc.v1_0.NestedIdentifier;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.validation.Errors;

import java.util.List;
import java.util.ListIterator;

import static edu.pitt.isg.dc.utils.TagUtil.isBiologicalEntity;
import static edu.pitt.isg.dc.utils.TagUtil.isPerson;

public class ValidatorHelperMethods {
    public static List<ValidatorError> validatorErrors(List<ValidatorError> errors){
        ListIterator<? extends ValidatorError> iterator = errors.listIterator();
        while (iterator.hasNext()) {
            ValidatorError validatorError = iterator.next();
            if(validatorError.getPath().contains("coordinates")){
                iterator.remove();
            }
        }
        return errors;
    }

    public static void clearStringList(ListIterator<String> listIterator) {
        while (listIterator.hasNext()) {
            String string = listIterator.next();
            if (isEmpty(string)) {
                listIterator.remove();
            }
        }
    }

    public static void clearNestedIdentifier(ListIterator<NestedIdentifier> nestedIdentifierListIterator) {
        while (nestedIdentifierListIterator.hasNext()) {
            NestedIdentifier nestedIdentifier = nestedIdentifierListIterator.next();
            Identifier identifier = nestedIdentifier.getIdentifier();
            if (identifier == null) {
                nestedIdentifierListIterator.remove();
                continue;
            }
            if (isEmpty(identifier.getIdentifier()) && isEmpty(identifier.getIdentifierDescription()) && isEmpty(identifier.getIdentifierSource())) {
                nestedIdentifierListIterator.remove();
            }
        }

    }

    public static boolean isIdentifierEmpty(Identifier identifier) {
        if (isEmpty(identifier.getIdentifier()) && isEmpty(identifier.getIdentifierSource()) && isEmpty(identifier.getIdentifierDescription())) {
            return true;
        }
        return false;
    }

    public static boolean isDataIdentifierEmpty(edu.pitt.isg.mdc.dats2_2.Identifier identifier) {
        try {
            if (isEmpty(identifier.getIdentifier()) && isEmpty(identifier.getIdentifierSource())) {
                return true;
            }

        } catch (NullPointerException e) {
            return true;
        }
        return false;
    }

    public static PersonComprisedEntity convertPersonOrganization(PersonOrganization personOrganization) {
        if (isPerson(personOrganization)) {
            Person person = new Person();
            person.setFullName(personOrganization.getFullName());
            person.setFirstName(personOrganization.getFirstName());
            person.setMiddleInitial(personOrganization.getMiddleInitial());
            person.setLastName(personOrganization.getLastName());
            person.setEmail(personOrganization.getEmail());
            person.setAffiliations(personOrganization.getAffiliations());
            person.setRoles(personOrganization.getRoles());
            person.setIdentifier(personOrganization.getIdentifier());
            person.setAlternateIdentifiers(personOrganization.getAlternateIdentifiers());

            return person;
        } else {
            Organization organization = new Organization();
            organization.setIdentifier(personOrganization.getIdentifier());
            organization.setAlternateIdentifiers(personOrganization.getAlternateIdentifiers());
            organization.setName(personOrganization.getName());
            organization.setAbbreviation(personOrganization.getAbbreviation());
            organization.setLocation(personOrganization.getLocation());

            return organization;
        }
    }


    public static IsAbout convertIsAboutItems(IsAboutItems isAbout) {
            if (isBiologicalEntity(isAbout)) {
                BiologicalEntity biologicalEntity = new BiologicalEntity();
                biologicalEntity.setAlternateIdentifiers(isAbout.getAlternateIdentifiers());
                biologicalEntity.setDescription(isAbout.getDescription());
                biologicalEntity.setIdentifier(isAbout.getIdentifier());
                biologicalEntity.setName(isAbout.getName());
                return biologicalEntity;
            } else {
                Annotation annotation = new Annotation();
                annotation.setValue(isAbout.getValue());
                annotation.setValueIRI(isAbout.getValueIRI());
                return annotation;
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
        if (isEmpty(string)) {
            return false;
        } else if (string.toLowerCase().contains("http:") || string.toLowerCase().contains("https:")) {
            return true;
        }
        return false;
    }

    public static void checkURLString(String urlString, Errors errors, String errorMessageLocation, String errorMessage) {
        try {
            if (!isEmpty(urlString)) {
                if (!isValidIRI(urlString)) {
                    errors.rejectValue(errorMessageLocation, errorMessage);
                }
            }
        } catch (NullPointerException e) {
        }
    }

    public static void checkAnnotation(Annotation annotation, Errors errors, String errorMessageLocation) {
        if (!isEmpty(annotation.getValueIRI())) {
            if (!isValidIRI(annotation.getValueIRI())) {
                errors.rejectValue(errorMessageLocation, "NotEmpty.dataset.valueIRI");
            } // end if
        }
        //require valueIRI if value is populated
        //  if yes, uncomment and then remove same code in distributions -> conformsTo -> type below
//        if (!isEmpty(annotation.getValue()) && isEmpty(annotation.getValueIRI())) {
//            errors.rejectValue(errorMessageLocation, "NotEmpty.dataset.valueIRI");
//        }
    }


    public static void clearPersonComprisedEntity(List<? extends PersonComprisedEntity> personComprisedEntities, Errors errors, String errorMessageLocation) {

        // Validate and remove empty creators
        ListIterator<? extends PersonComprisedEntity> iterator = personComprisedEntities.listIterator();
        while (iterator.hasNext()) {
            PersonComprisedEntity personComprisedEntity = iterator.next();
            if (personComprisedEntity instanceof Person) {
                Person person = (Person) personComprisedEntity;
                if (isEmpty(person.getFirstName()) && isEmpty(person.getLastName()) && isEmpty(person.getEmail())) {
                    iterator.remove();
                }
            }
            if (personComprisedEntity instanceof Organization) {
                Organization organization = (Organization) personComprisedEntity;
                if (isEmpty(organization.getName()) && isEmpty(organization.getAbbreviation()) && isEmpty(organization.getLocation().getName()) && isEmpty(organization.getLocation().getDescription()) && isEmpty(organization.getLocation().getPostalAddress())) {
                    iterator.remove();
                } else if (isEmpty(organization.getName())) {
                    errors.rejectValue(errorMessageLocation + "[" + iterator.previousIndex() + "].name", "NotEmpty.dataset.creator.name");
                }
            }
        }

//        // Validate and remove empty creators
//        if (dataset.getCreators().size() == 0) {
//            errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
//        } else {
//            ListIterator<Organization> iterator = dataset.getCreators().listIterator();
//            while (iterator.hasNext()) {
//                Organization organization = iterator.next();
//                if (isEmpty(organization.getName())) {
//                    errors.rejectValue("creators[" + iterator.previousIndex() + "].name", "NotEmpty.dataset.creator.name");
//                }
//                if (isEmpty(organization.getName()) && isEmpty(organization.getAbbreviation()) && isEmpty(organization.getLocation().getName()) && isEmpty(organization.getLocation().getDescription()) && isEmpty(organization.getLocation().getPostalAddress())) {
//                    iterator.remove();
//                }
//            }
//            if (dataset.getCreators().size() == 0) {
//                errors.rejectValue("creators[0]", "NotEmpty.dataset.creator");
//            }
//        }
    }

    public static void clearDateType(Date date, Errors errors, String errorMessageLocation) {
        try {
            if (isEmpty(date.getType().getValueIRI()) && isEmpty(date.getType().getValue())) {
                date.setType(null);
            } else if (!isEmpty(date.getType())) {
                checkAnnotation(date.getType(), errors, errorMessageLocation);
            }
        } catch (NullPointerException e) {
        }
    }

    public static boolean isLicenseEmtpy(License license) {
        try {
            if (isEmpty(license.getIdentifier()) /*&& isEmpty(license.getIdentifierSource())*/ && isEmpty(license.getVersion())) {
                return true;
            } else return false;
        } catch (NullPointerException e) {
            return true;
        }
    }

    public static void clearBiologicalEntities(List<? extends IsAbout> isAbouts, Errors errors, String errorMessageLocation) {
//        ListIterator<BiologicalEntity> iterator = biologicalEntities.listIterator();
        ListIterator<? extends IsAbout> iterator = isAbouts.listIterator();
        while (iterator.hasNext()) {
            IsAbout isAbout = iterator.next();
            if (isAbout instanceof BiologicalEntity) {
                BiologicalEntity entity = (BiologicalEntity) isAbout;
//            BiologicalEntity entity = iterator.next();
                if (isEmpty(entity)) {
                    iterator.remove();
                } else {
                    if (isDataIdentifierEmpty(entity.getIdentifier())) {
                        entity.setIdentifier(null);
                    }
                    ListIterator<edu.pitt.isg.mdc.dats2_2.Identifier> listIterator = entity.getAlternateIdentifiers().listIterator();
                    while (listIterator.hasNext()) {
                        edu.pitt.isg.mdc.dats2_2.Identifier identifier = listIterator.next();
                        if (isDataIdentifierEmpty(identifier)) {
                            listIterator.remove();
                        }
                    }
                    if (/*isEmpty(entity.getDescription()) &&*/ isEmpty(entity.getName()) && entity.getAlternateIdentifiers().size() == 0 && isEmpty(entity.getIdentifier())) {
                        iterator.remove();
                    }
                    if (isEmpty(entity.getName()) && (/*!isEmpty(entity.getDescription()) ||*/ entity.getAlternateIdentifiers().size() > 0 || !isEmpty(entity.getIdentifier()))) {
                        errors.rejectValue(errorMessageLocation + "[" + iterator.previousIndex() + "].name", "NotEmpty.dataset.name");
                    }
                }
            }
        }
    }

    public static void clearStudy(Study study, Errors errors) {
//        boolean hasError = true;
        if (!isEmpty(study)) {

            //Clean up Location
            if (isEmpty(study.getLocation().getPostalAddress())) {
                study.setLocation(null);
            }

            //Clean up Start Date
            clearDateType(study.getStartDate(), errors, "producedBy.startDate.type.valueIRI");
            if (isEmpty(study.getStartDate().getDate()) && isEmpty(study.getStartDate().getType())) {
                study.setStartDate(null);
            }

            //Clean up End Date
            clearDateType(study.getEndDate(), errors, "producedBy.endDate.type.valueIRI");
            if (isEmpty(study.getEndDate().getDate()) && isEmpty(study.getEndDate().getType())) {
                study.setEndDate(null);
            }

            //Show error is Name not populated and other Study info is populated
            if (isEmpty(study.getName()) && (!isEmpty(study.getLocation()) || !isEmpty(study.getStartDate()) || !isEmpty(study.getEndDate()))) {
                errors.rejectValue("producedBy.name", "NotEmpty.dataset.name");
            }

        }
    }

    public static void clearDistributions(List<Distribution> distributions, Errors errors) {
        if (distributions.size() > 0) {
            ListIterator<Distribution> iterator = distributions.listIterator();
            Integer distributionCounter = 0;
            while (iterator.hasNext()) {
                Distribution distribution = iterator.next();

                //Clean up Identifier
                if (isDataIdentifierEmpty(distribution.getIdentifier())) {
                    distribution.setIdentifier(null);
                }

                //Clean up Access
                if (isEmpty(distribution.getAccess().getAccessURL()) && isEmpty(distribution.getAccess().getLandingPage())) {
                    distribution.setAccess(null);
                } else {
                    checkURLString(distribution.getAccess().getLandingPage(), errors, "distributions[" + distributionCounter + "].access.landingPage", "NotEmpty.dataset.access.landingPage.invalid");
                    checkURLString(distribution.getAccess().getAccessURL(), errors, "distributions[" + distributionCounter + "].access.accessURL", "NotEmpty.dataset.access.accessURL.invalid");
                }

                //Clean up Unit
                if (isEmpty(distribution.getUnit().getValue()) && isEmpty(distribution.getUnit().getValueIRI())) {
                    distribution.setUnit(null);
                } else {
                    checkAnnotation(distribution.getUnit(), errors, "distributions[" + distributionCounter + "].unit.valueIRI");
                }

                //Clean up Dates
                ListIterator<Date> dateListIterator = distribution.getDates().listIterator();
                Integer dateCounter = 0;
                while (dateListIterator.hasNext()) {
                    Date date = dateListIterator.next();
                    if (isEmpty(date.getDate()) && isEmpty(date.getType().getValue()) && isEmpty(date.getType().getValueIRI())) {
                        dateListIterator.remove();
                    } else {
                        clearDateType(date, errors, "distributions[" + distributionCounter + "].dates[" + dateCounter + "].type.valueIRI");

                        dateCounter++;
                    }
                }

                //Clean up ConformsTo
                ListIterator<DataStandard> conformsToIterator = distribution.getConformsTo().listIterator();
                Integer conformsToCounter = 0;
                while (conformsToIterator.hasNext()) {
                    DataStandard conformsTo = conformsToIterator.next();

                    //Clean up Identifier
                    if (isDataIdentifierEmpty(conformsTo.getIdentifier())) {
                        conformsTo.setIdentifier(null);
                    }

                    //Clean up type
                    if (isEmpty(conformsTo.getType().getValue()) && isEmpty(conformsTo.getType().getValueIRI())) {
                        conformsTo.setType(null);
                    } else {
                        checkAnnotation(conformsTo.getType(), errors, "distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "].type.valueIRI");
                        if (isEmpty(conformsTo.getType().getValue())) {
                            errors.rejectValue("distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "].type", "NotEmpty.dataset.type");
                        }
                        if (isEmpty(conformsTo.getType().getValueIRI())) {
                            errors.rejectValue("distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "].type.valueIRI", "NotEmpty.dataset.valueIRI");
                        }
                    }

                    //Clean up License
                    ListIterator<License> licenseListIterator = conformsTo.getLicenses().listIterator();
                    while (licenseListIterator.hasNext()) {
                        License license = licenseListIterator.next();
                        if (isLicenseEmtpy(license)) {
                            licenseListIterator.remove();
                        }
                    }

                    clearExtraProperties(conformsTo.getExtraProperties(), "distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "].", errors);

                    if (isEmpty(conformsTo.getIdentifier()) && isEmpty(conformsTo.getName()) && isEmpty(conformsTo.getDescription()) && isEmpty(conformsTo.getVersion()) && conformsTo.getExtraProperties().size() == 0 && isEmpty(conformsTo.getType()) && conformsTo.getLicenses().size() == 0) {
                        conformsToIterator.remove();
                    } else {
                        //Name empty but distribution populated
                        if (isEmpty(conformsTo.getName()) && (!isEmpty(conformsTo.getIdentifier()) || !isEmpty(conformsTo.getDescription()) || !isEmpty(conformsTo.getVersion()) || conformsTo.getExtraProperties().size() > 0 || !isEmpty(conformsTo.getType().getValueIRI()) || !isEmpty(conformsTo.getType().getValue()) || conformsTo.getLicenses().size() > 0)) {
                            errors.rejectValue("distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "].name", "NotEmpty.dataset.name");
                        }
                        //Type empty but distribution populated
                        if (isEmpty(conformsTo.getType()) && (!isEmpty(conformsTo.getName()) || !isEmpty(conformsTo.getIdentifier()) || !isEmpty(conformsTo.getDescription()) || !isEmpty(conformsTo.getVersion()) || conformsTo.getExtraProperties().size() > 0 || conformsTo.getLicenses().size() > 0)) {
                            errors.rejectValue("distributions[" + distributionCounter + "].conformsTo[" + conformsToCounter + "].type", "NotEmpty.dataset.type");
                        }
                        conformsToCounter++;
                    }
                }


                //Clean up Stored In
                DataRepository storedIn = distribution.getStoredIn();
                if (isDataIdentifierEmpty(storedIn.getIdentifier())) {
                    storedIn.setIdentifier(null);
                }
                ListIterator<License> licenseListIterator = storedIn.getLicenses().listIterator();
                while (licenseListIterator.hasNext()) {
                    License license = licenseListIterator.next();
                    if (isLicenseEmtpy(license)) {
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
                        checkAnnotation(annotation, errors, "distributions[" + distributionCounter + "].storedIn.types[" + typesCounter + "].valueIRI");
                        typesCounter++;
                    }
                }
                if (isEmpty(storedIn.getName()) && isEmpty(storedIn.getIdentifier()) && isEmpty(storedIn.getVersion()) && storedIn.getLicenses().size() == 0 && storedIn.getTypes().size() == 0) {
                    distribution.setStoredIn(null);
                } else {
                    if (isEmpty(storedIn.getName()) && (!isEmpty(storedIn.getIdentifier()) || !isEmpty(storedIn.getVersion()) || storedIn.getLicenses().size() > 0 || storedIn.getTypes().size() > 0)) {
                        errors.rejectValue("distributions[" + distributionCounter + "].storedIn.name", "NotEmpty.dataset.name");
                    }
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
                    if ((isEmpty(distribution.getAccess()) || isEmpty(distribution.getAccess().getLandingPage())) && !(isEmpty(distribution.getIdentifier()) && isEmpty(distribution.getSize()) && distribution.getDates().size() == 0 && distribution.getConformsTo().size() == 0 && isEmpty(distribution.getStoredIn()) && isEmpty(distribution.getUnit()) && distribution.getFormats().size() == 0)) {
                        errors.rejectValue("distributions[" + distributionCounter + "].access.landingPage", "NotEmpty.dataset.access.landingPage.empty");
                    }
                    distributionCounter++;
                }
            }
        }
    }

    public static void clearExtraProperties(List<CategoryValuePair> extraProperties, String errorLocation, Errors errors) {
        if (extraProperties.size() > 0) {
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
                while (valueIterator.hasNext()) {
                    Annotation annotation = valueIterator.next();
                    if (isEmpty(annotation.getValue()) && isEmpty(annotation.getValueIRI())) {
                        valueIterator.remove();
                    } else {
                        checkAnnotation(annotation, errors, errorLocation + "extraProperties[" + Integer.toString(cvpCounter) + "].values["
                                + Integer.toString(annotationCounter) + "].valueIRI");

                        annotationCounter++;
                    }

                }

                if (isEmpty(property.getCategory()) && isEmpty(property.getCategoryIRI()) && property.getValues().size() == 0) {
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
                        checkAnnotation(annotation, errors, "types[" + Integer.toString(counter) + "].information.valueIRI");
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getMethod();
                    if (isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue())) {
                        type.setMethod(null);
                    } else {
                        checkAnnotation(annotation, errors, "types[" + Integer.toString(counter) + "].method.valueIRI");
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

    public static boolean clearTypes(List<Type> types, MessageContext messageContext) {
        if (types.size() == 0) {
            messageContext.addMessage(new MessageBuilder().error().source(
                    "types").defaultText("Types cannot be empty").build());
            return false;
        } else {
            boolean hasError = true;
            ListIterator<Type> iterator = types.listIterator();
            int counter = 0;
            while (iterator.hasNext()) {
                Type type = iterator.next();
                Annotation annotation;
                try {
                    annotation = type.getInformation();
                    if (!(isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue()))) {
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getMethod();
                    if (!(isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue()))) {
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

                try {
                    annotation = type.getPlatform();
                    if (!(isEmpty(annotation.getValueIRI()) && isEmpty(annotation.getValue()))) {
                        if (!isEmpty(annotation.getValueIRI())) {
                            if (!isValidIRI(annotation.getValueIRI())) {
                                messageContext.addMessage(new MessageBuilder().error().source(
                                        "types[" + Integer.toString(counter) + "].platform.valueIRI").defaultText("Not a valid IRI!").build());

                            }
                        }
                        hasError = false;
                    }
                } catch (NullPointerException e) {
                }

//                if (isEmpty(type.getInformation()) && isEmpty(type.getMethod()) && isEmpty(type.getPlatform())) {
//                    iterator.remove();
//                    counter--;
//                }
                counter++;
            }

            if (hasError) {
                messageContext.addMessage(new MessageBuilder().error().source(
                        "types[0]").defaultText("Type is required!").build());
                return false;
            }
        }
        return true;
    }
}

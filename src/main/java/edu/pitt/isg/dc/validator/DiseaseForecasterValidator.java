package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DiseaseForecasters;
import edu.pitt.isg.mdc.v1_0.Identifier;
import edu.pitt.isg.mdc.v1_0.NestedIdentifier;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

@Component
public class DiseaseForecasterValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DiseaseForecasters.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DiseaseForecasters diseaseForecaster = (DiseaseForecasters) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(diseaseForecaster.getDataInputFormats().listIterator());
        clearStringList(diseaseForecaster.getDataOutputFormats().listIterator());
        clearStringList(diseaseForecaster.getWebApplication().listIterator());
        clearStringList(diseaseForecaster.getDevelopers().listIterator());
        clearStringList(diseaseForecaster.getPublicationsThatUsedRelease().listIterator());
        clearStringList(diseaseForecaster.getExecutables().listIterator());
        clearStringList(diseaseForecaster.getVersion().listIterator());
        clearStringList(diseaseForecaster.getPublicationsAboutRelease().listIterator());
        clearStringList(diseaseForecaster.getGrants().listIterator());
        //////////////////////

        ListIterator<NestedIdentifier> nestedIdentifierListIterator = diseaseForecaster.getDiseases().listIterator();
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

        nestedIdentifierListIterator = diseaseForecaster.getLocationCoverage().listIterator();
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

        clearStringList(diseaseForecaster.getNowcasts().listIterator());
        clearStringList(diseaseForecaster.getOutcomes().listIterator());
        clearStringList(diseaseForecaster.getForecasts().listIterator());
        if(diseaseForecaster.getForecasts().size()==0) {
            errors.rejectValue("forecasts[0]", "NotEmpty.software.diseaseForecaster");
        }


    }

    public static void clearStringList(ListIterator<String> listIterator) {
        while (listIterator.hasNext()) {
            String string = listIterator.next();
            if (isEmpty(string)) {
                listIterator.remove();
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
package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DiseaseForecasters;
import edu.pitt.isg.mdc.v1_0.Identifier;
import edu.pitt.isg.mdc.v1_0.NestedIdentifier;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.*;

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

        if(isIdentifierEmpty(diseaseForecaster.getIdentifier())) {
            diseaseForecaster.setIdentifier(null);
        }

        clearStringList(diseaseForecaster.getDataInputFormats().listIterator());
        clearStringList(diseaseForecaster.getDataOutputFormats().listIterator());
        clearStringList(diseaseForecaster.getWebApplication().listIterator());
        clearStringList(diseaseForecaster.getDevelopers().listIterator());
        clearStringList(diseaseForecaster.getPublicationsThatUsedRelease().listIterator());
        clearStringList(diseaseForecaster.getExecutables().listIterator());
        clearStringList(diseaseForecaster.getVersion().listIterator());
        clearStringList(diseaseForecaster.getPublicationsAboutRelease().listIterator());
        clearStringList(diseaseForecaster.getGrants().listIterator());
        clearNestedIdentifier(diseaseForecaster.getLocationCoverage().listIterator());
        //////////////////////

        clearNestedIdentifier(diseaseForecaster.getDiseases().listIterator());

        clearStringList(diseaseForecaster.getNowcasts().listIterator());
        clearStringList(diseaseForecaster.getOutcomes().listIterator());
        clearStringList(diseaseForecaster.getForecasts().listIterator());
        if(diseaseForecaster.getForecasts().size()==0) {
            errors.rejectValue("forecasts[0]", "NotEmpty.software.diseaseForecaster");
        }

    }
}
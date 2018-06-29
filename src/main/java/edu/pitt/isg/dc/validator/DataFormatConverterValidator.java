package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DataFormatConverters;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isIdentifierEmpty;

@Component
public class DataFormatConverterValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DataFormatConverters.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DataFormatConverters dataFormatConverters = (DataFormatConverters) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        if(isIdentifierEmpty(dataFormatConverters.getIdentifier())) {
            dataFormatConverters.setIdentifier(null);
        }

        clearStringList(dataFormatConverters.getDataInputFormats().listIterator());
        clearStringList(dataFormatConverters.getDataOutputFormats().listIterator());
        clearStringList(dataFormatConverters.getWebApplication().listIterator());
        clearStringList(dataFormatConverters.getDevelopers().listIterator());
        clearStringList(dataFormatConverters.getPublicationsThatUsedRelease().listIterator());
        clearStringList(dataFormatConverters.getExecutables().listIterator());
        clearStringList(dataFormatConverters.getVersion().listIterator());
        clearStringList(dataFormatConverters.getPublicationsAboutRelease().listIterator());
        clearStringList(dataFormatConverters.getGrants().listIterator());
        clearNestedIdentifier(dataFormatConverters.getLocationCoverage().listIterator());
        //////////////////////
    }
}
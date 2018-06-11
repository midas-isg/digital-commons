package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.ModelingPlatforms;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;

@Component
public class ModelingPlatformValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return ModelingPlatforms.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        ModelingPlatforms modelingPlatform = (ModelingPlatforms) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(modelingPlatform.getDataInputFormats().listIterator());
        clearStringList(modelingPlatform.getDataOutputFormats().listIterator());
        clearStringList(modelingPlatform.getWebApplication().listIterator());
        clearStringList(modelingPlatform.getDevelopers().listIterator());
        clearStringList(modelingPlatform.getPublicationsThatUsedRelease().listIterator());
        clearStringList(modelingPlatform.getExecutables().listIterator());
        clearStringList(modelingPlatform.getVersion().listIterator());
        clearStringList(modelingPlatform.getPublicationsAboutRelease().listIterator());
        clearStringList(modelingPlatform.getGrants().listIterator());
        clearNestedIdentifier(modelingPlatform.getLocationCoverage().listIterator());
        //////////////////////
    }
}
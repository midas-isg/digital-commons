package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.SyntheticEcosystemConstructors;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isIdentifierEmpty;

@Component
public class SyntheticEcosystemConstructorValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return SyntheticEcosystemConstructors.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        SyntheticEcosystemConstructors syntheticEcosystemConstructor = (SyntheticEcosystemConstructors) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        if(isIdentifierEmpty(syntheticEcosystemConstructor.getIdentifier())) {
            syntheticEcosystemConstructor.setIdentifier(null);
        }

        clearStringList(syntheticEcosystemConstructor.getDataInputFormats().listIterator());
        clearStringList(syntheticEcosystemConstructor.getDataOutputFormats().listIterator());
        clearStringList(syntheticEcosystemConstructor.getWebApplication().listIterator());
        clearStringList(syntheticEcosystemConstructor.getDevelopers().listIterator());
        clearStringList(syntheticEcosystemConstructor.getPublicationsThatUsedRelease().listIterator());
        clearStringList(syntheticEcosystemConstructor.getExecutables().listIterator());
        clearStringList(syntheticEcosystemConstructor.getVersion().listIterator());
        clearStringList(syntheticEcosystemConstructor.getPublicationsAboutRelease().listIterator());
        clearStringList(syntheticEcosystemConstructor.getGrants().listIterator());
        clearNestedIdentifier(syntheticEcosystemConstructor.getLocationCoverage().listIterator());
        //////////////////////
    }
}
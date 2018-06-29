package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.MetagenomicAnalysis;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isIdentifierEmpty;

@Component
public class MetagenomicAnalysisValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return MetagenomicAnalysis.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        MetagenomicAnalysis metagenomicAnalysis = (MetagenomicAnalysis) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        if(isIdentifierEmpty(metagenomicAnalysis.getIdentifier())) {
            metagenomicAnalysis.setIdentifier(null);
        }

        clearStringList(metagenomicAnalysis.getDataInputFormats().listIterator());
        clearStringList(metagenomicAnalysis.getDataOutputFormats().listIterator());
        clearStringList(metagenomicAnalysis.getWebApplication().listIterator());
        clearStringList(metagenomicAnalysis.getDevelopers().listIterator());
        clearStringList(metagenomicAnalysis.getPublicationsThatUsedRelease().listIterator());
        clearStringList(metagenomicAnalysis.getExecutables().listIterator());
        clearStringList(metagenomicAnalysis.getVersion().listIterator());
        clearStringList(metagenomicAnalysis.getPublicationsAboutRelease().listIterator());
        clearStringList(metagenomicAnalysis.getGrants().listIterator());
        clearNestedIdentifier(metagenomicAnalysis.getLocationCoverage().listIterator());
        //////////////////////
    }
}
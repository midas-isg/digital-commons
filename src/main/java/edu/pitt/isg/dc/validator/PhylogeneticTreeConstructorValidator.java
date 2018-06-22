package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.PhylogeneticTreeConstructors;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isIdentifierEmpty;

@Component
public class PhylogeneticTreeConstructorValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return PhylogeneticTreeConstructors.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        PhylogeneticTreeConstructors phylogeneticTreeConstructor = (PhylogeneticTreeConstructors) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        if(isIdentifierEmpty(phylogeneticTreeConstructor.getIdentifier())) {
            phylogeneticTreeConstructor.setIdentifier(null);
        }

        clearStringList(phylogeneticTreeConstructor.getDataInputFormats().listIterator());
        clearStringList(phylogeneticTreeConstructor.getDataOutputFormats().listIterator());
        clearStringList(phylogeneticTreeConstructor.getWebApplication().listIterator());
        clearStringList(phylogeneticTreeConstructor.getDevelopers().listIterator());
        clearStringList(phylogeneticTreeConstructor.getPublicationsThatUsedRelease().listIterator());
        clearStringList(phylogeneticTreeConstructor.getExecutables().listIterator());
        clearStringList(phylogeneticTreeConstructor.getVersion().listIterator());
        clearStringList(phylogeneticTreeConstructor.getPublicationsAboutRelease().listIterator());
        clearStringList(phylogeneticTreeConstructor.getGrants().listIterator());
        clearNestedIdentifier(phylogeneticTreeConstructor.getLocationCoverage().listIterator());
        //////////////////////
    }
}
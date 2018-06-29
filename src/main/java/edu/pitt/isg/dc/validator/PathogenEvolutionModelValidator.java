package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.PathogenEvolutionModels;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isIdentifierEmpty;

@Component
public class PathogenEvolutionModelValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return PathogenEvolutionModels.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        PathogenEvolutionModels pathogenEvolutionModel = (PathogenEvolutionModels) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        if(isIdentifierEmpty(pathogenEvolutionModel.getIdentifier())) {
            pathogenEvolutionModel.setIdentifier(null);
        }

        clearStringList(pathogenEvolutionModel.getDataInputFormats().listIterator());
        clearStringList(pathogenEvolutionModel.getDataOutputFormats().listIterator());
        clearStringList(pathogenEvolutionModel.getWebApplication().listIterator());
        clearStringList(pathogenEvolutionModel.getDevelopers().listIterator());
        clearStringList(pathogenEvolutionModel.getPublicationsThatUsedRelease().listIterator());
        clearStringList(pathogenEvolutionModel.getExecutables().listIterator());
        clearStringList(pathogenEvolutionModel.getVersion().listIterator());
        clearStringList(pathogenEvolutionModel.getPublicationsAboutRelease().listIterator());
        clearStringList(pathogenEvolutionModel.getGrants().listIterator());
        clearNestedIdentifier(pathogenEvolutionModel.getLocationCoverage().listIterator());
        //////////////////////

        clearNestedIdentifier(pathogenEvolutionModel.getPathogens().listIterator());
    }
}
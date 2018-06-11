package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.PopulationDynamicsModel;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;

@Component
public class PopulationDynamicsModelValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return PopulationDynamicsModel.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        PopulationDynamicsModel populationDynamicsModel = (PopulationDynamicsModel) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(populationDynamicsModel.getDataInputFormats().listIterator());
        clearStringList(populationDynamicsModel.getDataOutputFormats().listIterator());
        clearStringList(populationDynamicsModel.getWebApplication().listIterator());
        clearStringList(populationDynamicsModel.getDevelopers().listIterator());
        clearStringList(populationDynamicsModel.getPublicationsThatUsedRelease().listIterator());
        clearStringList(populationDynamicsModel.getExecutables().listIterator());
        clearStringList(populationDynamicsModel.getVersion().listIterator());
        clearStringList(populationDynamicsModel.getPublicationsAboutRelease().listIterator());
        clearStringList(populationDynamicsModel.getGrants().listIterator());
        clearNestedIdentifier(populationDynamicsModel.getLocationCoverage().listIterator());
        //////////////////////

        clearNestedIdentifier(populationDynamicsModel.getPopulationSpeciesIncluded().listIterator());
        if(populationDynamicsModel.getPopulationSpeciesIncluded().size() == 0) {
            errors.rejectValue("populationSpeciesIncluded[0]", "NotEmpty.software.populationSpeciesIncluded");
        }
    }
}
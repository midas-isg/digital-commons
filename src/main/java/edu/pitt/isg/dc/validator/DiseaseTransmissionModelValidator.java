package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DiseaseForecasters;
import edu.pitt.isg.mdc.v1_0.DiseaseTransmissionModel;
import edu.pitt.isg.mdc.v1_0.Identifier;
import edu.pitt.isg.mdc.v1_0.NestedIdentifier;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isIdentifierEmpty;

@Component
public class DiseaseTransmissionModelValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DiseaseTransmissionModel.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DiseaseTransmissionModel diseaseTransmissionModel = (DiseaseTransmissionModel) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        if(isIdentifierEmpty(diseaseTransmissionModel.getIdentifier())) {
            diseaseTransmissionModel.setIdentifier(null);
        }

        clearStringList(diseaseTransmissionModel.getDataInputFormats().listIterator());
        clearStringList(diseaseTransmissionModel.getDataOutputFormats().listIterator());
        clearStringList(diseaseTransmissionModel.getWebApplication().listIterator());
        clearStringList(diseaseTransmissionModel.getDevelopers().listIterator());
        clearStringList(diseaseTransmissionModel.getPublicationsThatUsedRelease().listIterator());
        clearStringList(diseaseTransmissionModel.getExecutables().listIterator());
        clearStringList(diseaseTransmissionModel.getVersion().listIterator());
        clearStringList(diseaseTransmissionModel.getPublicationsAboutRelease().listIterator());
        clearStringList(diseaseTransmissionModel.getGrants().listIterator());
        clearNestedIdentifier(diseaseTransmissionModel.getLocationCoverage().listIterator());
        //////////////////////

        clearNestedIdentifier(diseaseTransmissionModel.getControlMeasures().listIterator());
        clearNestedIdentifier(diseaseTransmissionModel.getHostSpeciesIncluded().listIterator());
        clearNestedIdentifier(diseaseTransmissionModel.getPathogenCoverage().listIterator());

    }

}
package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DiseaseTransmissionTreeEstimators;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;


import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearNestedIdentifier;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;

@Component
public class DiseaseTransmissionTreeEstimatorValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DiseaseTransmissionTreeEstimators.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DiseaseTransmissionTreeEstimators diseaseTransmissionTreeEstimators = (DiseaseTransmissionTreeEstimators) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(diseaseTransmissionTreeEstimators.getDataInputFormats().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getDataOutputFormats().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getWebApplication().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getDevelopers().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getPublicationsThatUsedRelease().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getExecutables().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getVersion().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getPublicationsAboutRelease().listIterator());
        clearStringList(diseaseTransmissionTreeEstimators.getGrants().listIterator());
        clearNestedIdentifier(diseaseTransmissionTreeEstimators.getLocationCoverage().listIterator());
        //////////////////////

        clearNestedIdentifier(diseaseTransmissionTreeEstimators.getHostSpeciesIncluded().listIterator());
        clearNestedIdentifier(diseaseTransmissionTreeEstimators.getPathogenCoverage().listIterator());

    }
}
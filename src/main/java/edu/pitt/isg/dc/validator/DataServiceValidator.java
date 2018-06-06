package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DataFormatConverters;
import edu.pitt.isg.mdc.v1_0.DataService;
import edu.pitt.isg.mdc.v1_0.DataServiceDescription;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.clearStringList;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.isEmpty;

@Component
public class DataServiceValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DataService.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DataService dataService = (DataService) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(dataService.getDataInputFormats().listIterator());
        clearStringList(dataService.getDataOutputFormats().listIterator());
        clearStringList(dataService.getWebApplication().listIterator());
        clearStringList(dataService.getDevelopers().listIterator());
        clearStringList(dataService.getPublicationsThatUsedRelease().listIterator());
        clearStringList(dataService.getExecutables().listIterator());
        clearStringList(dataService.getVersion().listIterator());
        clearStringList(dataService.getPublicationsAboutRelease().listIterator());
        clearStringList(dataService.getGrants().listIterator());
        //////////////////////

        ListIterator<DataServiceDescription> descriptionListIterator = dataService.getDataServiceDescription().listIterator();
        while(descriptionListIterator.hasNext()) {
            DataServiceDescription dataServiceDescription = descriptionListIterator.next();
            if(isEmpty(dataServiceDescription.getAccessPointDescription()) && isEmpty(dataServiceDescription.getAccessPointUrl())) {
                descriptionListIterator.remove();
                continue;
            }
            if(isEmpty(dataServiceDescription.getAccessPointDescription()) || isEmpty(dataServiceDescription.getAccessPointUrl())) {
                errors.rejectValue("dataServiceDescription[" + descriptionListIterator.previousIndex() + "]", "NotEmpty.software.allFieldsRequired");
            }
        }
        if(dataService.getDataServiceDescription().size() == 0) {
            errors.rejectValue("dataServiceDescription[0]", "NotEmpty.software.dataServiceDescription");
        }
    }
}
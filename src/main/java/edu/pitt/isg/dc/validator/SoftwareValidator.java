package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.Software;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.List;
import java.util.ListIterator;

@Component
public class SoftwareValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return Software.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Software software = (Software) target;

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");



        clearStringList(software.getDataInputFormats().listIterator());
        clearStringList(software.getDataOutputFormats().listIterator());
        clearStringList(software.getWebApplication().listIterator());
        clearStringList(software.getDevelopers().listIterator());
        clearStringList(software.getPublicationsThatUsedRelease().listIterator());
        clearStringList(software.getExecutables().listIterator());
        clearStringList(software.getVersion().listIterator());
        clearStringList(software.getPublicationsAboutRelease().listIterator());
        clearStringList(software.getGrants().listIterator());
    }

    public static void clearStringList(ListIterator<String> listIterator) {
        while(listIterator.hasNext()) {
            String string = listIterator.next();
            if(isEmpty(string)) {
                listIterator.remove();
            }
        }
    }


    public static boolean isEmpty(Object object) {
        if (object == null) {
            return true;
        }
        return false;
    }


    public static boolean isEmpty(Object[] array) {
        if (array == null || array.length == 0) {
            return true;
        }
        return false;
    }


    public static boolean isEmpty(String string) {
        if (string == null || string.trim().length() == 0) {
            return true;
        }
        return false;
    }
    
}
package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DataFormatConverters;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

@Component
public class SoftwareValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DataFormatConverters.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DataFormatConverters dataFormatConverters = (DataFormatConverters) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(dataFormatConverters.getDataInputFormats().listIterator());
        clearStringList(dataFormatConverters.getDataOutputFormats().listIterator());
        clearStringList(dataFormatConverters.getWebApplication().listIterator());
        clearStringList(dataFormatConverters.getDevelopers().listIterator());
        clearStringList(dataFormatConverters.getPublicationsThatUsedRelease().listIterator());
        clearStringList(dataFormatConverters.getExecutables().listIterator());
        clearStringList(dataFormatConverters.getVersion().listIterator());
        clearStringList(dataFormatConverters.getPublicationsAboutRelease().listIterator());
        clearStringList(dataFormatConverters.getGrants().listIterator());
        //////////////////////
    }

    public static void clearStringList(ListIterator<String> listIterator) {
        while (listIterator.hasNext()) {
            String string = listIterator.next();
            if (isEmpty(string)) {
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
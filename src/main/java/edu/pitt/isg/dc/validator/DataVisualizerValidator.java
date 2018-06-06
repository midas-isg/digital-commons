package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.DataVisualizers;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.ListIterator;

@Component
public class DataVisualizerValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return DataVisualizers.class.equals(aClass);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DataVisualizers dataVisualizer = (DataVisualizers) target;

        //USED FOR SOFTWARE//
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "NotEmpty.software.title");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "humanReadableSynopsis", "NotEmpty.software.humanReadableSynopsis");

        clearStringList(dataVisualizer.getDataInputFormats().listIterator());
        clearStringList(dataVisualizer.getDataOutputFormats().listIterator());
        clearStringList(dataVisualizer.getWebApplication().listIterator());
        clearStringList(dataVisualizer.getDevelopers().listIterator());
        clearStringList(dataVisualizer.getPublicationsThatUsedRelease().listIterator());
        clearStringList(dataVisualizer.getExecutables().listIterator());
        clearStringList(dataVisualizer.getVersion().listIterator());
        clearStringList(dataVisualizer.getPublicationsAboutRelease().listIterator());
        clearStringList(dataVisualizer.getGrants().listIterator());
        //////////////////////

        clearStringList(dataVisualizer.getVisualizationType().listIterator());

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
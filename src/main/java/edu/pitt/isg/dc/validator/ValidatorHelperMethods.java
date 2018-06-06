package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.v1_0.Identifier;
import edu.pitt.isg.mdc.v1_0.NestedIdentifier;

import java.util.ListIterator;

public class ValidatorHelperMethods {
    public static void clearStringList(ListIterator<String> listIterator) {
        while (listIterator.hasNext()) {
            String string = listIterator.next();
            if (isEmpty(string)) {
                listIterator.remove();
            }
        }
    }

    public static void clearNestedIdentifier(ListIterator<NestedIdentifier> nestedIdentifierListIterator) {
        while(nestedIdentifierListIterator.hasNext()) {
            NestedIdentifier nestedIdentifier = nestedIdentifierListIterator.next();
            Identifier identifier = nestedIdentifier.getIdentifier();
            if(identifier == null) {
                nestedIdentifierListIterator.remove();
                continue;
            }
            if(isEmpty(identifier.getIdentifier()) && isEmpty(identifier.getIdentifierDescription()) && isEmpty(identifier.getIdentifierSource())) {
                nestedIdentifierListIterator.remove();
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

    public static boolean isValidIRI(String string) {
        if (string.toLowerCase().contains("http:") || string.toLowerCase().contains("https:")) {
            return true;
        }
        return false;
    }
}

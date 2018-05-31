package edu.pitt.isg.dc.validator;

import java.beans.PropertyEditorSupport;

public class CustomDatasetEditor extends PropertyEditorSupport{
    public void setAsText(String text) {
        setValue(text.replaceAll("(,)*$", ""));
//        if(text.equals(",")) {
//            setValue(null);
//        } else {
//            setValue(text);
//        }
    }
}

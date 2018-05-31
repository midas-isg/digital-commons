package edu.pitt.isg.dc.validator;

import java.beans.PropertyEditorSupport;

public class CustomDatasetEditor extends PropertyEditorSupport{
    public void setAsText(String text) {
        if(text.equals(",")) {
            setValue(null);
        } else {
            setValue(text);
        }
    }
}

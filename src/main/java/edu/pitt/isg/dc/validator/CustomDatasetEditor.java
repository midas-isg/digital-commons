package edu.pitt.isg.dc.validator;

import java.beans.PropertyEditorSupport;

public class CustomDatasetEditor extends PropertyEditorSupport{
    public void setAsText(String text) {
        text = text.replaceAll("(,)*$", "");

        if("".equals(text)) {
            this.setValue((Object)null);
        } else {
            this.setValue(text);
        }
    }
}

package edu.pitt.isg.dc.validator;

import java.beans.PropertyEditorSupport;
import java.lang.reflect.Array;

public class CustomDatasetEditor extends PropertyEditorSupport{
    public void setAsText(String text) {
        text = text.replaceAll("(,)*$", "");

//        if("".equals(text)) {
//            this.setValue((Object)null);
//        } else {
//            this.setValue(text);
//        }

        if("".equals(text)) {
            this.setValue((Object)null);
        } else {
            String[] arrayText = text.split("(,)");
            int arraySize = arrayText.length;
            if(arraySize == 2){
                if(arrayText[0].equals(arrayText[1])){
                    this.setValue(arrayText[0]);
                }
            } else {
                this.setValue(text);
            }
        }
    }
}

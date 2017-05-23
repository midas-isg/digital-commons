package edu.pitt.isg.dc.utils;

import edu.pitt.isg.Converter;
import edu.pitt.isg.mdc.v1_0.Software;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mas400 on 1/18/17.
 */
public class DigitalCommonsHelper {

    public static List<String> jsonToXml(String json) {
        Converter converter = new Converter();
        List<Software> softwareList = converter.convertToJava(json);
        List<String> xmlSoftwareList = new ArrayList<String>();

        for (Software sw : softwareList) {
            try {
                String xml = converter.convertToXml(sw);
                xmlSoftwareList.add(xml);
            } catch(Exception e) {
                System.out.println("Error: " + e);
            }
        }

        return xmlSoftwareList;
    }
}

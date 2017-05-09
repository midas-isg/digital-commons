package edu.pitt.isg.dc.utils;

import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.digital.dap.DapFolder;
import edu.pitt.isg.dc.digital.dap.DataAugmentedPublication;
import edu.pitt.isg.mdc.v1_0.Software;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mas400 on 1/18/17.
 */
public class DigitalCommonsHelper {

    public static String generateDisplayTitle(DapFolder dap) {
        String title = "";

        DataAugmentedPublication paper = dap.getPaper();
        String author = paper.getAuthorsText().split(",")[0];
        String[] authorNames = author.split("\\s+");
        title += authorNames[authorNames.length-1] + ", ";

        for(int i=0; i<authorNames.length-1;i++) {
            title+= authorNames[i].charAt(0) + "";
        }

        title += " et al. ";

        title += dap.getName();

        return title;
    }

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

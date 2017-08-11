package edu.pitt.isg.dc.utils;

import edu.pitt.isg.Converter;
import edu.pitt.isg.mdc.v1_0.Software;
import org.jsoup.Jsoup;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mas400 on 1/18/17.
 */
public class DigitalCommonsHelper {

    public static String jsonToXml(Software sw) {
        Converter converter = new Converter();

        String xml = null;
        try {
            xml = converter.convertToXml(sw);
            xml = xml.replaceAll("<humanReadableSynopsis> ", "<humanReadableSynopsis>");
        } catch(Exception e) {
            System.out.println("Error: " + e);
        }

        return xml;
    }
}

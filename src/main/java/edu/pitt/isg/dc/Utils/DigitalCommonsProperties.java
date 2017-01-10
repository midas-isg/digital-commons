package edu.pitt.isg.dc.Utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

/**
 * Created by mas400 on 1/9/17.
 */
public class DigitalCommonsProperties extends Properties {

    public static final String LIBRARY_VIEWER_URL = "libraryViewerUrl";

    private static class DigitalCommonsPropertiesHolder {

        private static final DigitalCommonsProperties INSTANCE;

        static {
            InputStream input = null;
            INSTANCE = new DigitalCommonsProperties();
            try {
                input = DigitalCommonsProperties.class.getClassLoader().getResourceAsStream("config.properties");
                if(input==null){
                    System.out.println("Sorry, unable to find " + "config.properties");
                }

                // load a properties file
                INSTANCE.load(input);

            } catch (IOException ex) {
                ex.printStackTrace();
            } finally {
                if (input != null) {
                    try {
                        input.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    private DigitalCommonsProperties() {

    }

    public static String getConfigProperty(String property) {
        return DigitalCommonsPropertiesHolder.INSTANCE.getProperty(property);
    }

    public static Properties getProperties() {
        return DigitalCommonsPropertiesHolder.INSTANCE;
    }
}

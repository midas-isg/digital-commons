package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.digital.dap.DapFolder;
import edu.pitt.isg.dc.digital.dap.DapForm;
import edu.pitt.isg.dc.digital.dap.DataAugmentedPublication;
import edu.pitt.isg.dc.digital.software.SoftwareFolder;

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
}

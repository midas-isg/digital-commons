package edu.pitt.isg.dc;

import edu.pitt.isg.dc.Utils.DigitalCommonsProperties;
import edu.pitt.isg.dc.digital.dap.DapRule;
import edu.pitt.isg.dc.digital.dap.DapUtil;
import edu.pitt.isg.dc.digital.software.SoftwareFolder;
import edu.pitt.isg.dc.digital.software.SoftwareRule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Properties;

@Controller
public class HelloController {
 private static String VIEWER_URL = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        VIEWER_URL = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_VIEWER_URL);
    }

    @Autowired
    private DapRule dapRule;
    @Autowired
    private SoftwareRule softwareRule;


    @RequestMapping(value = "/home", method = RequestMethod.GET)
    public String hello(Model model) {
        model.addAttribute("dataAugmentedPublications", DapUtil.convertDapTreeToBootstrapTree(dapRule.tree()));
        final Iterable<SoftwareFolder> tree = softwareRule.tree();
        System.out.println(tree);
        model.addAttribute("libraryViewerUrl", VIEWER_URL);
        return "commons";
    }
}

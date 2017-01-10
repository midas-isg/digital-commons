package edu.pitt.isg.dc;

import edu.pitt.isg.dc.Utils.DigitalCommonsProperties;
import edu.pitt.isg.dc.digital.dap.DapRule;
import edu.pitt.isg.dc.digital.dap.DapUtil;
import edu.pitt.isg.dc.digital.software.Software;
import edu.pitt.isg.dc.digital.software.SoftwareFolder;
import edu.pitt.isg.dc.digital.software.SoftwareRule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.stream.Collectors;

import static java.util.stream.StreamSupport.stream;

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
        model.addAttribute("software", toSoftwareFolderList(softwareRule.tree()));
        //model.addAttribute("software", new ArrayList<SoftwareFolder>());
        model.addAttribute("libraryViewerUrl", VIEWER_URL);
        return "commons";
    }

    private List<SoftwareFolder> toSoftwareFolderList(Iterable<SoftwareFolder> tree) {
        return stream(tree.spliterator(), false).collect(Collectors.toList());
    }

    @RequestMapping(value = "/software/{id}", method = RequestMethod.GET)
    public String softwareInfo(Model model, @PathVariable("id") long id) {
        List<SoftwareFolder> tree = new ArrayList<>();

        Software softwareToReturn = new Software();
        for(SoftwareFolder folder : tree) {
            for(Software software : folder.getList()) {
                // TODO - uncommon when database is complete
                /*if(software.getId() == id) {
                    softwareToReturn = software;
                    break;
                }*/
            }
        }

        model.addAttribute("software", softwareToReturn);    // placeholder for iterable to be returned from DB
        return "softwareInfo";
    }
}

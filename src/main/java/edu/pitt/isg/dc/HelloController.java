package edu.pitt.isg.dc;

import edu.pitt.isg.dc.digital.AugmentedData;
import edu.pitt.isg.dc.digital.DataAugmentedPublication;
import edu.pitt.isg.dc.digital.Paper;
import edu.pitt.isg.dc.digital.Publication;
import edu.pitt.isg.dc.digital.dap.DapFolder;
import edu.pitt.isg.dc.digital.dap.DapRule;
import edu.pitt.isg.dc.digital.dap.DapUtil;
import org.springframework.beans.factory.annotation.Autowired;
import edu.pitt.isg.dc.Utils.DigitalCommonsProperties;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import java.util.Properties;

@Controller
public class HelloController {
 private static String VIEWER_URL = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        VIEWER_URL = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_VIEWER_URL);
    }    @Autowired
    private DapRule rule;

    @RequestMapping(value = "/home", method = RequestMethod.GET)
    public String hello(Model model) {
        /*model.addAttribute("dataAugmentedPublications", dummyModels());
        Iterable<DapFolder> tree = rule.tree();
        System.out.println(tree);*/
        model.addAttribute("dataAugmentedPublications", DapUtil.convertDapTreeToBootstrapTree(rule.tree()));
        model.addAttribute("libraryViewerUrl", VIEWER_URL);
        return "commons";
    }

    private List<Map<String, Object>> dummyModels() {
        final ArrayList<Map<String, Object>> list = new ArrayList<>();
        list.add(dummyDataAugmentedPublication().toBootstrapTree());
        list.add(dummyDataAugmentedPublication("Waiting time to infectious disease emergence",
                dummyFromScratch("Christopher J. Dibble, Eamon B. O'Dea, Andrew W. Park, John M. Drake", "10-19-2016", "Waiting time to infectious disease emergence", "10.1098/rsif.2016.0540", "Paper", "The Royal Society", "http://dx.doi.org/10.1098/rsif.2016.0540"), dummyFromScratch("Dibble CJ, O'Dea EB, Park AW, Drake JM", "10-27-2016", "Data from: Waiting time to infectious disease emergence", "10.5061/dryad.dp4kb", "Dryad Data Package", "Dryad Digital Repository", "http://dx.doi.org/10.5061/dryad.dp4kb")).toBootstrapTree());
        list.add(dummyDataAugmentedPublication("Spatial spread of the West Africa Ebola epidemic",
                dummyFromScratch("Andrew M. Kramer, J. Tomlin Pulliam, Laura W. Alexander, Andrew W. Park, Pejman Rohani, John M. Drake", "8-3-2016", "Spatial spread of the West Africa Ebola epidemic", "10.1098/rsos.160294", "Paper", "The Royal Society", "http://dx.doi.org/10.1098/rsos.160294"), dummyFromScratch("Kramer AM, Pulliam JT, Alexander LW, Park AW, Rohani P, Drake JM", "9-8-2016", "Data from: Spatial spread of the West Africa Ebola epidemic", "10.5061/dryad.k95j3.2", "Dryad Data Package", "Dryad Digital Repository", "http://dx.doi.org/10.5061/dryad.k95j3.2")).toBootstrapTree());
        return list;
    }

    private DataAugmentedPublication dummyDataAugmentedPublication() {
        final DataAugmentedPublication dataAugmentedPublication = new DataAugmentedPublication();
        dataAugmentedPublication.setName("Ebola Cases and Health System Demand in Liberia");
        dataAugmentedPublication.setPaper(dummyPaper());
        dataAugmentedPublication.setData(dummyAugmentedData());
        return dataAugmentedPublication;
    }

    private DataAugmentedPublication dummyDataAugmentedPublication(String title, Publication paper, Publication data) {
        final DataAugmentedPublication dataAugmentedPublication = new DataAugmentedPublication();
        dataAugmentedPublication.setName(title);
        dataAugmentedPublication.setPaper((Paper) paper);
        dataAugmentedPublication.setData((AugmentedData) data);
        return dataAugmentedPublication;
    }

    private Paper dummyPaper() {
        final Paper paper = new Paper();
        fillDummyEbola(paper);
        paper.setName("Ebola Cases and Health System Demand in Liberia");
        paper.setDoi("10.1371/journal.pbio.1002056");
        paper.setTypeText("Paper");
        paper.setJournal("PLOS Biology");
        paper.setUrl("http://dx.doi.org/10.1371/journal.pbio.1002056");
        return paper;
    }

    private AugmentedData dummyAugmentedData() {
        final AugmentedData data = new AugmentedData();
        fillDummyEbola(data);
        data.setName("Data from: Ebola cases and health system demand in Liberia");
        data.setDoi("10.5061/dryad.17m5q");
        data.setTypeText("Dryad Data Package");
        data.setJournal("Dryad Digital Repository");
        data.setUrl("http://dx.doi.org/10.5061/dryad.17m5q");
        return data;
    }

    private void fillDummyEbola(Publication data) {
        data.setAuthorsText("Drake JM, Kaul RB, Alexander LW, O'Regan SM, Kramer AM, Pulliam JT, Ferrari MJ, Park AW");
        data.setPublicationDateText("1-13-2015");
    }

    private Publication dummyFromScratch(String author, String date, String name, String doi, String typeText, String journal, String url) {
        Publication data = new AugmentedData();

        if(typeText.equals("Paper")) {
            data = new Paper();
        }

        data.setAuthorsText(author);
        data.setPublicationDateText(date);
        data.setName(name);
        data.setDoi(doi);
        data.setTypeText(typeText);
        data.setJournal(journal);
        data.setUrl(url);
        return data;
    }
}

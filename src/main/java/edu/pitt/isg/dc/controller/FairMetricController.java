package edu.pitt.isg.dc.controller;

import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.fm.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.*;

import javax.transaction.Transactional;

import static edu.pitt.isg.dc.controller.MediaType.Application.JSON;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/fair-metrics")
@ApiIgnore
@RequiredArgsConstructor
public class FairMetricController {
    private final FairMetricService service;
    @Autowired
    private FairMetricReportRepo fairMetricReportRepo;

    @GetMapping("")
    @Transactional
    public String report(ModelMap model) {
        List<String> keys = getKeys();
        Map<String, String> scores = getSummaryScore(keys);
        model.addAttribute("keys", keys);
        model.addAttribute("scores", scores);
        model.addAttribute("report", currentReport());
        model.addAttribute("running", service.runningReport());
        return "fairMetricReport";
    }

    private Map<String, String> getSummaryScore(List<String> keys) {
        Map<String, String> scores = new HashMap<String, String>();

/*
        Map<String, String> metricToShortNameLookupTable = getLookupTable();
*/


        for(Object[] obj : fairMetricReportRepo.getFairMetricReportSummary()){
            DecimalFormat decimalFormat = new DecimalFormat("0.#####");
            scores.put(obj[0].toString(), String.valueOf(decimalFormat.format(obj[1])));

        }
        return scores;

    }

    @PostMapping(value = "/run", produces = JSON)
    @ResponseBody
    public FairMetricReport post() {
        return service.run();
    }

    @GetMapping(value = "/reports/current", produces = JSON)
    @ResponseBody
    @Transactional
    public FairMetricReport currentReport() {
        final FairMetricReport report = service.currentReport();
        ensureInitialization(report);
        return report;
    }

    private int ensureInitialization(FairMetricReport report) {
        int count = 0;
        for (FairMetricResultRow row : report.getResults())
            for (FairMetricResult r : row.getResults())
                count++;
        return count;
    }

    @RequestMapping(value = "/detailed-view", method = RequestMethod.GET)
    public String detailedViewFAIRMetrics(Model model, HttpSession session, @RequestParam(value = "key") String key) throws Exception {
        model.addAttribute("key", key);
        model.addAttribute("keys", getKeys());

        Properties prop = new Properties();
        prop = getFairMetricProperties();
        String exampleText = prop.getProperty(key + "-Examples");
        model.addAttribute("exampleText", exampleText);

        return "detailedViewFAIRMetrics";
    }

    @RequestMapping(value = "/description", method = RequestMethod.GET)
    public String descriptionFAIRMetrics(Model model, HttpSession session) throws Exception {
        model.addAttribute("keys", getKeys());

        return "descriptionFAIRMetrics";
    }

    private Properties getFairMetricProperties() throws IOException {
        InputStream inputStream;
        Properties prop = new Properties();
        String propFileName = "fairMetricsDescriptions.properties";
        try {
            inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);

            if (inputStream != null) {
                prop.load(inputStream);
            } else {
                throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");
            }
        } catch (Exception e) {
            System.out.println("Exception: " + e);
        }

        return prop;
    }


    private List<String> getKeys() {
        ArrayList<String> keys = new ArrayList<String>();
        keys.add("FM-F1A");
        keys.add("FM-F1B");
        keys.add("FM-F2");
        keys.add("FM-F3");
        keys.add("FM-F4");
        keys.add("FM-A1.1");
        keys.add("FM-A1.2");
        keys.add("FM-A2");
        keys.add("FM-I1");
        keys.add("FM-I2");
        keys.add("FM-I3");
        keys.add("FM-R1.1");
        keys.add("FM-R1.2");
        return keys;
    }

    private Map<String, String> getLookupTable() {
        Map<String, String> lookupTable = new HashMap<>();
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_unique_identifier", "F1A");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_identifier_persistence", "F1B");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_machine_readable_metadata", "F2");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_identifier_in_metadata", "F3");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_searchable_index", "F4");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_access_protocol", "A1.1");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_access_authorization", "A1.2");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_metadata_longevity", "A2");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_knowledge_language", "I1");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_fair_vocabularies", "I2");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_has_linkset", "I3");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_accessible_license", "R1.1");
        lookupTable.put("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/metric_detailed_provenance_A", "R1.2");
        return lookupTable;
    }
}
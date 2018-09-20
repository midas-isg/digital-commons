package edu.pitt.isg.dc.controller;

import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.fm.FairMetricReport;
import edu.pitt.isg.dc.fm.FairMetricResult;
import edu.pitt.isg.dc.fm.FairMetricResultRow;
import edu.pitt.isg.dc.fm.FairMetricService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.transaction.Transactional;

import static edu.pitt.isg.dc.controller.MediaType.Application.JSON;

@Controller
@RequestMapping("/fm")
@ApiIgnore
@RequiredArgsConstructor
public class FairMetricController {
    private final FairMetricService service;

    @GetMapping("")
    @Transactional
    public String report(ModelMap model){
        model.addAttribute("report", currentReport());
        model.addAttribute("running", service.runningReport());
        return "fairMetricReport";
    }

    @GetMapping(value = "/run", produces = JSON)
    @ResponseBody
    public FairMetricReport run(){
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
        for (FairMetricResultRow row: report.getResults())
            for (FairMetricResult r: row.getResults())
                count++;
        return count;
    }
}

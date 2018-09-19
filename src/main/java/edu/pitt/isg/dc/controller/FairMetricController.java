package edu.pitt.isg.dc.controller;

import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.fm.FairMetricReport;
import edu.pitt.isg.dc.fm.FairMetricService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static edu.pitt.isg.dc.controller.MediaType.Application.JSON;

@RestController
@RequestMapping("/fm")
@ApiIgnore
@RequiredArgsConstructor
public class FairMetricController {
    private final FairMetricService service;

    @GetMapping(value = "/run", produces = JSON)
    public FairMetricReport run(){
        return service.run();
    }
}

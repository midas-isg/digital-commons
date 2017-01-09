package edu.pitt.isg.dc.digital;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class DigitalController {
    @Autowired
    private DigitalRepository digitalRepository;
    @Autowired
    private TypeRepository typeRepository;

    @RequestMapping("api/digital-objects")
    public Iterable<Digital> listDigitalObjects(){
        return digitalRepository.findAll();
    }

    @RequestMapping("api/digital-types")
    public Iterable<Type> listDigitalTypes(){
        return typeRepository.findAll();
    }
}

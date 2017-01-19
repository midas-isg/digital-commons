package edu.pitt.isg.dc.digital.spew;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

import static java.util.stream.StreamSupport.stream;

@Service
public class SpewRule {
    @Autowired
    private SpewDao dao;

    public Iterable<SpewLocation> tree(){
        final List<SpewLocation> countries = dao.listCountries();
        countries.stream().forEach(c -> c.setUrl(dao.toDownloadUrlAtQuickView(c)));
        return countries;
    }
}

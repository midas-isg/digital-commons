package edu.pitt.isg.dc.digital.spew;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SpewRule {
    @Autowired
    private SpewDao dao;

    public Iterable<SpewLocation> tree(){
        List<SpewLocation> countries = dao.listCountries();
        countries.stream().forEach(this::customize);
        return countries;
    }

    private void customize(SpewLocation country) {
        country.setChildren(null);
        country.setUrl(dao.toDownloadUrlWithSummary(country));
    }

    public Iterable<SpewLocation> treeRegions(){
        final List<SpewLocation> regions = dao.listRegions();
        regions.stream()
                .flatMap(r -> r.getChildren().values().stream())
                .flatMap(s -> s.getChildren().values().stream())
                .filter(dao::isCountry)
                .forEach(this::customize);
        return regions;
    }
}

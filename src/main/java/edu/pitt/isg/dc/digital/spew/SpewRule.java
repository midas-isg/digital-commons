package edu.pitt.isg.dc.digital.spew;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SpewRule {
    @Autowired
    private SpewDao dao;
    private Iterable<SpewLocation> cachedTreeRegions;

    public Iterable<SpewLocation> tree(){
        List<SpewLocation> countries = dao.listCountries();
        countries.stream().forEach(this::customize);
        return countries;
    }

    private void customize(SpewLocation country) {
        if(!country.getName().equals("united states of america")) {
            country.setChildren(null);
        }
        // country.setUrl(dao.toDownloadUrlWithSummary(country));
    }

    public Iterable<SpewLocation> treeRegions(){
        if(cachedTreeRegions != null) {
            return cachedTreeRegions;
        } else {
            final List<SpewLocation> regions = dao.listRegions();
            regions.stream()
                    .flatMap(r -> r.getChildren().values().stream())
                    .flatMap(s -> s.getChildren().values().stream())
                    .filter(dao::isCountry)
                    .forEach(this::customize);
            cachedTreeRegions = regions;
            return regions;
        }
    }
}

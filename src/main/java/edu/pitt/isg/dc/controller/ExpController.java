package edu.pitt.isg.dc.controller;

import com.google.gson.Gson;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.Ncbi;
import edu.pitt.isg.dc.entry.NcbiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static edu.pitt.isg.dc.controller.MediaType.Application.JSON;
import static edu.pitt.isg.dc.controller.MediaType.Text.XML;
import static java.util.Arrays.asList;
import static org.springframework.web.bind.annotation.RequestMethod.GET;


@RestController
public class ExpController {
    private static final String KEY_ENTRY = "entry";

    private static final String KEY_CONTROL_MEASURES = "controlMeasures";
    private static final String KEY_LOCATION_COVERAGE = "locationCoverage";
    private static final String KEY_HOST_SPECIES = "hostSpeciesIncluded";
    private static final String KEY_PATHOGENS = "pathogenCoverage";

    @Autowired
    private EntryRepository repo;

    @Autowired
    private NcbiRepository ncbiRepo;

    @Value("${app.identifierSource.ncbi}")
    private String ncbiIdentifierSource;

    @Value("${app.identifierSource.ls}")
    private String lsIdentifierSource;

    @RequestMapping(value = "/entries/by-about-ncbi/{id}",
            method = GET,
            produces = {JSON, XML})
    public Object findAllByAboutNcbiId(@PathVariable Long id) {
        return repo.findAllByAboutNcbiId(ncbiIdentifierSource, "%" + id);
    }

    @Transactional
    @RequestMapping(value = "/entries/by-ontology",
            method = GET,
            produces = {JSON, XML})
    public Object listUsedNcbisAsIsAboutInEntries(
            @RequestParam(value = "aboutNcbiId", required = false) Long aboutNcbiId,
            @RequestParam(value = "coverageLsId", required = false) Long coverageLsId) {
        List<BigInteger> results = null;
        if (aboutNcbiId != null)
            results = repo.findAllByIsAboutIdentifierViaOntology(ncbiIdentifierSource, toNcbiIds(aboutNcbiId));
        if (coverageLsId != null)
            results = merge(results, repo.findAllBySpatialCoverageIdentifierViaOntology(lsIdentifierSource, toLsIds(coverageLsId)));
        final List<Long> longs = toLongs(results);
        if (longs == null)
            return repo.findAll();
        return repo.findAll(longs);
    }

    private List<BigInteger> merge(List<BigInteger> list1, List<BigInteger> list2) {
        if (list1 == null)
            return list2;
        list1.retainAll(list2);
        return list1;
    }

    private List<Long> toLongs(List<BigInteger> results) {
        if (results == null)
            return null;
        return results.stream()
                .map(BigInteger::longValueExact)
                .collect(Collectors.toList());
    }

    private List<String> toLsIds(Long lsId) {
        final List<String> urls = new ArrayList<>();
        urls.add(toLsUrl(lsId));
        System.out.println(urls);
        return urls;
    }

    private String toLsUrl(Long id) {
        return id.toString();
    }


    private List<String> toNcbiIds(long ncbiId) {
        final List<String> urls = new ArrayList<>();
        Ncbi ncbi = ncbiRepo.findOne(ncbiId);
        while (ncbi != null){
            urls.add(toNcbiUrl(ncbi.getId()));
            ncbi = ncbi.getParent();
        }
        //System.out.println(urls);
        final Set<String> descendants = findNcbiIdsByPathContaining(ncbiId);
        urls.addAll(descendants.stream()
                .mapToLong(Long::parseLong)
                .mapToObj(this::toNcbiUrl)
                .collect(Collectors.toList())
        );
        System.out.println(urls);
        return urls;
    }

    private String toNcbiUrl(long id) {
        //return "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=" + id;
        return "" + id;
    }

    @RequestMapping(value = "/ncbis/used-in-entry-as-about",
            method = GET,
            produces = {JSON, XML})
    public Object listNcbisUsedAsIsAboutInEntries() {
        return ncbiRepo.findAll(toIds(repo.listAboutNcbiIds(ncbiIdentifierSource)));
    }

    @RequestMapping(value = "/ncbis/by-path/{id}",
            method = GET,
            produces = {JSON, XML})
    public Object findNcbisByPathContaining(@PathVariable Long id) {
        return findNcbiIdsByPathContaining(id);
    }

    private Set<String> findNcbiIdsByPathContaining(Long id) {
        final Ncbi one = ncbiRepo.findOne(id);
        final String path = one.getPath();
        final List<Ncbi> ncbis = ncbiRepo.findAllByPathContaining("/" + id + "/");
        final Set<String> set = ncbis.stream()
                .filter(Ncbi::getLeaf)
                .map(Ncbi::getPath)
                .map(p -> p.replace(path + "/", ""))
                .flatMap(p -> asList(p.split("/")).stream())
                .collect(Collectors.toSet());
        //System.out.println(id + " has descendants: " + set.size());
        return set;
    }

    @RequestMapping(value = "/ncbis/{id}",
            method = GET,
            produces = {JSON, XML})
    public Object readNcbi(@PathVariable Long id) {
        return ncbiRepo.findOne(id);
    }

    private Set<Long> toIds(List<String> urls) {
        return urls.stream()
                .map(this::takeInteger)
                .map(s -> s.replace(")", ""))
                .map(s -> Long.parseLong(s))
                .collect(Collectors.toSet());
    }

    private String takeInteger(String s) {
        final String[] tokens = s.split("[_=]");
        if (tokens.length > 1)
            return tokens[1];
        return s;
    }

    @RequestMapping(value = "/ls/used-in-entry-as-spatial-coverage",
            method = GET,
            produces = {JSON, XML})
    public Object listUsedNcbiAsSpatialCoverageInEntries() {
        return toIds(repo.listSpatialCoverageLsIds(lsIdentifierSource));
    }

    @RequestMapping(value = "/exp",
            method = GET,
            produces = {JSON, XML})
    public Object exp(@RequestParam(value = "exp", required = true, name = "exp") String exp) {
        return repo.findAllByContentContainingJson(exp);
    }

    @RequestMapping(value = "/entries/by-content",
            method = GET,
            produces = {JSON, XML})
    public Object findEntriesByJsonContent(
            @RequestParam(value = KEY_CONTROL_MEASURES, required = false) String[] controlMeasures,
            @RequestParam(value = KEY_HOST_SPECIES, required = false) String[] hostSpecies,
            @RequestParam(value = KEY_LOCATION_COVERAGE, required = false) String[] locations,
            @RequestParam(value = KEY_PATHOGENS, required = false) String[] pathogens
    ) {
        final Map<String, Object> map = newMapWithEntry();
        putIntoEntryMap(map, KEY_CONTROL_MEASURES, controlMeasures);
        putIntoEntryMap(map, KEY_HOST_SPECIES, hostSpecies);
        putIntoEntryMap(map, KEY_LOCATION_COVERAGE, locations);
        putIntoEntryMap(map, KEY_PATHOGENS, pathogens);
        final String json = new Gson().toJson(map);

        return repo.findAllByContentContainingJson(json);
    }

    private static void putIntoEntryMap(Map<String, Object> map, String key, Object value) {
        final Map<String, Object> entry = (Map<String, Object>)map.get(KEY_ENTRY);
        entry.put(key, value);
    }

    private static Map<String, Object> simpleMap(String key, Object value){
        final Map<String, Object> map = newMapWithEntry();
        putIntoEntryMap(map, key, value);
        return map;
    }

    private static Map<String, Object> newMapWithEntry() {
        final HashMap<String, Object> map = new HashMap<>();
        final HashMap<String, Object> entry = new HashMap<>();
        map.put(KEY_ENTRY, entry);
        return map;
    }
}

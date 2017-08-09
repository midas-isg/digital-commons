package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class EntryRule {
    private static final String KEY_ENTRY = "entry";

    private static final String KEY_CONTROL_MEASURES = "controlMeasures";
    private static final String KEY_LOCATION_COVERAGE = "locationCoverage";
    private static final String KEY_HOST_SPECIES = "hostSpeciesIncluded";
    private static final String KEY_PATHOGENS = "pathogenCoverage";
    public static final String FIELD_IS_ABOUT = "isAbout";

    @Autowired
    private EntryRepository repo;
    @Autowired
    private NcbiRule ncbi;


    @Value("${app.identifierSource.ncbi}")
    private String ncbiIdentifierSource;
    @Value("${app.identifierSource.ls}")
    private String lsIdentifierSource;

    public Page<Entry> findViaOntology(EntryOntologyQuery q, Pageable pageRequest) {
        List<BigInteger> results = findByHostNcbiId(q.getHostNcbiId());
        results = merge(results, findByPathogenNcbiId(q.getPathogenNcbiId()));
        results = merge(results, findByLsId(q.getCoverageLsId()));

        final List<Long> longs = toLongs(results);
        if (longs == null)
            return repo.findAllByStatus("approved", pageRequest);
        return repo.findByIdIn(longs, pageRequest);
    }

    private List<BigInteger> findByLsId(Long lsId) {
        if (lsId == null)
            return null;
        final List<String> lsIds = toLsIds(lsId);
        final List<BigInteger> entityIds = repo.filterIdsByFieldAndIdentifierSource("spatialCoverage", lsIdentifierSource, lsIds);
        entityIds.addAll(repo.filterIdsByFieldAndIdentifierSource(KEY_LOCATION_COVERAGE, lsIdentifierSource, lsIds));
        return entityIds;
    }

    private List<BigInteger> findByPathogenNcbiId(Long id) {
        List<BigInteger> results = null;
        if (id != null) {
            final List<String> ncbiIds = ncbi.toAllRelativeNcbiIds(id);
            results = findByFieldPlusIsAboutAndIds(ncbi.findPathogensInEntries(), KEY_PATHOGENS, ncbiIds);
        }
        return results;
    }

    private List<BigInteger> findByHostNcbiId(Long id) {
        List<BigInteger> results = null;
        if (id != null) {
            final List<String> ncbiIds = ncbi.toAllRelativeNcbiIds(id);
            results = findByFieldPlusIsAboutAndIds(ncbi.findHostsInEntries(), KEY_HOST_SPECIES, ncbiIds);
        }
        return results;
    }

    private List<BigInteger> findByFieldPlusIsAboutAndIds(List<Ncbi> ncbiIdsInEntries, String field, List<String> ncbiIds) {
        final Set<Long> ncbis = ncbiIdsInEntries.stream()
                .map(Ncbi::getId)
                .collect(Collectors.toSet());
        List<String> filteredIds = ncbiIds.stream()
                .map(Long::parseLong)
                .filter(ncbis::contains)
                .map(Object::toString)
                .collect(Collectors.toList());
        final Set<BigInteger> set = new HashSet<>(repo.filterIdsByFieldAndIdentifierSource(FIELD_IS_ABOUT, ncbiIdentifierSource, filteredIds));
        set.addAll(repo.filterIdsByFieldAndIdentifierSource(field, ncbiIdentifierSource, filteredIds));
        final List<BigInteger> entryIds = new ArrayList<>(set);
        System.out.println(field + ":" +
                ncbiIds.size() + "->" + filteredIds.size() + " ncbis:"
                + filteredIds + "=>" + entryIds.size() + " entries:" + entryIds);
        return entryIds;
    }

    private List<BigInteger> merge(List<BigInteger> list1, List<BigInteger> list2) {
        if (list1 == null)
            return list2;
        if (list2 == null)
            return list1;
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
        //System.out.println(urls);
        return urls;
    }

    private String toLsUrl(Long id) {
        return id.toString();
    }
}

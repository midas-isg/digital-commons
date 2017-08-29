package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.vm.EntryComplexQuery;
import edu.pitt.isg.dc.vm.EntrySimpleQuery;
import edu.pitt.isg.dc.vm.MatchedSoftware;
import edu.pitt.isg.dc.vm.OntologyQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;
import static edu.pitt.isg.dc.entry.Keys.HOST_SPECIES;
import static edu.pitt.isg.dc.entry.Keys.IS_ABOUT;
import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PATHOGEN_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.SPATIAL_COVERAGE;
import static java.lang.System.out;
import static java.util.Arrays.asList;
import static java.util.stream.Collectors.toList;

@Service
public class EntryRule {
    @Autowired
    private EntryRepository repo;
    @Autowired
    private NcbiRule ncbi;
    @Autowired
    private AsvRule asv;
    @Autowired
    private LocationRule ls;
    @Value("${app.identifierSource.ncbi}")
    private String ncbiIdentifierSource;
    @Value("${app.identifierSource.ls}")
    private String lsIdentifierSource;
    @Value("${app.identifierSource.sv}")
    private String svIdentifierSource;

    public Page<Entry> findViaOntology(EntrySimpleQuery q, Pageable pageRequest) {
        //return search(q, pageRequest);
        return search(EntryComplexQuery.of(q), pageRequest);
    }

    private Page<Entry> search(EntrySimpleQuery q, Pageable pageRequest) {
        List<EntryId> results = listIdsByHostRelativesOfNcbiId(q.getHostId());
        results = merge(results, listIdsByPathogenRelativesOfNcbiId(q.getPathogenId()));
        results = merge(results, listIdsByRelativesOfLsId(q.getLocationId()));
        results = merge(results, listIdsByRelativesOfControlMeasureId(q.getControlMeasureId()));
        results = merge(results, listIdsByType(q.getType()));

        if (results == null)
            return repo.findAllByIsPublic(true, pageRequest);
        return repo.findByIdIn(results, pageRequest);
    }

    public Page<Entry> search(EntryComplexQuery q, Pageable pageRequest) {
        List<EntryId> results = listIdsByHostRelativesOfNcbiId(firstId(q.getHosts()));
        results = merge(results, listIdsByPathogenRelativesOfNcbiId(firstId(q.getPathogens())));
        results = merge(results, listIdsByRelativesOfLsId(firstId(q.getLocations())));
        results = merge(results, listIdsByRelativesOfControlMeasureId(firstId(q.getControlMeasures())));
        results = merge(results, listIdsByType(firstId(q.getTypes())));

        if (results == null)
            return repo.findAllByIsPublic(true, pageRequest);
        return repo.findByIdIn(results, pageRequest);
    }

    private <T> T firstId(List<OntologyQuery<T>> list) {
        if (list == null)
            return null;
        return list.get(0).getId();
    }

    public List<MatchedSoftware> listSoftwareMatched(){
        final List<Object[]> list = repo.match2Software();
        return list.stream()
                .map(MatchedSoftware::of)
                .collect(toList());
    }

    private List<EntryId> listIdsByType(String... types) {
        if (types == null || types.length == 0 || types[0] == null)
            return null;
        return toEntryIdList(repo.filterIdsByTypes(types));
    }

    private List<EntryId> toEntryIdList(List<Object[]> list) {
        return list.stream()
                .map(EntryId::new)
                .collect(toList());
    }

    private List<EntryId> listIdsByRelativesOfControlMeasureId(String iri) {
        if (iri == null)
            return null;
        final List<String> asvIris = new ArrayList<>(asv.toAllRelativeAsvIds(iri));
        // out.println(iri + "->" + asvIris);
        final Stream<String> stream = Stream.of(CONTROL_MEASURES);
        final List<EntryId> ids = parallelFilter(stream, svIdentifierSource, asvIris);
        out.println("ASV:" + asvIris +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private List<EntryId> listIdsByRelativesOfLsId(Long lsId) {
        if (lsId == null)
            return null;
        final List<String> lsIds = ls.toRelativeAlcs(lsId);
        final Stream<String> stream = Stream.of(SPATIAL_COVERAGE, LOCATION_COVERAGE);
        final List<EntryId> ids = parallelFilter(stream, lsIdentifierSource, lsIds);
        out.println("LS:" +lsIds +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private List<EntryId> listIdsByPathogenRelativesOfNcbiId(Long id) {
        List<EntryId> results = null;
        if (id != null) {
            final List<String> ncbiIds = ncbi.toAllRelativeNcbiIds(id);
            results = listIdsByFieldPlusIsAboutAndNcbiIds(ncbi.findPathogensInEntries(), PATHOGEN_COVERAGE, ncbiIds);
        }
        return results;
    }

    private List<EntryId> listIdsByHostRelativesOfNcbiId(Long id) {
        List<EntryId> results = null;
        if (id != null) {
            final List<String> ncbiIds = ncbi.toAllRelativeNcbiIds(id);
            results = listIdsByFieldPlusIsAboutAndNcbiIds(ncbi.findHostsInEntries(), HOST_SPECIES, ncbiIds);
        }
        return results;
    }

    private List<EntryId> listIdsByFieldPlusIsAboutAndNcbiIds(
            List<Ncbi> ncbiIdsInEntries, String field, List<String> ncbiIds) {
        final Set<Long> ncbis = ncbiIdsInEntries.stream()
                .map(Ncbi::getId)
                .collect(Collectors.toSet());
        final List<String> filteredIds = ncbiIds.stream()
                .map(Long::parseLong)
                .filter(ncbis::contains)
                .map(Object::toString)
                .collect(toList());
        final Stream<String> stream = Stream.of(IS_ABOUT, field);
        final List<EntryId> ids = parallelFilter(stream, ncbiIdentifierSource, filteredIds);
        out.println(field + ":" +
                ncbiIds.size() + "->" + filteredIds.size() + " ncbis:"
                + filteredIds + "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private List<EntryId> parallelFilter(Stream<String> stream, String idSrc, List<String> onlyIds) {
        return stream.parallel()
                .map(f -> repo.filterIdsByFieldAndIdentifierSource(f, idSrc, onlyIds))
                .flatMap(Collection::stream)
                .map(EntryId::new)
                .collect(toList());
    }

    private <T> List<T> merge(List<T> list1, List<T> list2) {
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
                .collect(toList());
    }

    public Entry read(EntryId entryId) {
        return repo.findOne(entryId);
    }
}

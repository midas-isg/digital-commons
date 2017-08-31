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

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;
import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.SPATIAL_COVERAGE;
import static java.lang.System.out;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toSet;

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
    @Value("${app.identifierSource.ls}")
    private String lsIdentifierSource;
    @Value("${app.identifierSource.sv}")
    private String svIdentifierSource;

    public Page<Entry> findViaOntology(EntrySimpleQuery q, Pageable pageRequest) {
        return search(EntryComplexQuery.of(q), pageRequest);
    }

    public Page<Entry> search(EntryComplexQuery q, Pageable pageRequest) {
        Set<EntryId> results = ncbi.listEntryIdsByHost(q.getHosts());
        results = merge(results, ncbi.listEntryIdsByPathogens(q.getPathogens()));
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

    private Set<EntryId> listIdsByType(String... types) {
        if (types == null || types.length == 0 || types[0] == null)
            return null;
        return toEntryIdList(repo.filterIdsByTypes(types));
    }

    private Set<EntryId> toEntryIdList(List<Object[]> list) {
        return list.stream()
                .map(EntryId::new)
                .collect(toSet());
    }

    private Set<EntryId> listIdsByRelativesOfControlMeasureId(String iri) {
        if (iri == null)
            return null;
        final List<String> asvIris = new ArrayList<>(asv.toAllRelativeAsvIds(iri));
        // out.println(iri + "->" + asvIris);
        final Stream<String> stream = Stream.of(CONTROL_MEASURES);
        final Set<EntryId> ids = parallelFilter(stream, svIdentifierSource, asvIris);
        out.println("ASV:" + asvIris +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private Set<EntryId> listIdsByRelativesOfLsId(Long lsId) {
        if (lsId == null)
            return null;
        final List<String> lsIds = ls.toRelativeAlcs(lsId);
        final Stream<String> stream = Stream.of(SPATIAL_COVERAGE, LOCATION_COVERAGE);
        final Set<EntryId> ids = parallelFilter(stream, lsIdentifierSource, lsIds);
        out.println("LS:" +lsIds +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private Set<EntryId> parallelFilter(Stream<String> stream, String idSrc, List<String> onlyIds) {
        return stream.parallel()
                .map(f -> repo.filterIdsByFieldAndIdentifierSource(f, idSrc, onlyIds))
                .flatMap(Collection::stream)
                .map(EntryId::new)
                .collect(toSet());
    }

    private <T> Set<T> merge(Set<T> list1, Set<T> list2) {
        if (list1 == null)
            return list2;
        if (list2 == null)
            return list1;
        list1.retainAll(list2);
        return list1;
    }

    public Entry read(EntryId entryId) {
        return repo.findOne(entryId);
    }
}

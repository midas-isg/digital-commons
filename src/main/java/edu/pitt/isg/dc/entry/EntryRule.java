package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.vm.EntryComplexQuery;
import edu.pitt.isg.dc.vm.EntrySimpleQuery;
import edu.pitt.isg.dc.vm.MatchedSoftware;
import edu.pitt.isg.dc.vm.OntologyQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

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

    public Page<Entry> findViaOntology(EntrySimpleQuery q, Pageable pageRequest) {
        return search(EntryComplexQuery.of(q), pageRequest);
    }

    public Page<Entry> search(EntryComplexQuery q, Pageable pageRequest) {
        final Set<EntryId> results = searchEntryIds(q);
        if (results == null)
            return repo.findAllByIsPublic(true, pageRequest);
        return repo.findByIdIn(results, pageRequest);
    }

    private Set<EntryId> searchEntryIds(EntryComplexQuery q) {
        Set<EntryId> results = ncbi.searchEntryIdsByHost(q.getHosts());
        results = merge(results, ncbi.searchEntryIdsByPathogens(q.getPathogens()));
        results = merge(results, ls.searchEntryIdsByAlc(q.getLocations()));
        results = merge(results, asv.searchEntryIdsByControlMeasureId(firstId(q.getControlMeasures())));
        results = merge(results, listEntryIdsByType(toIds(q.getTypes())));
        return results;
    }

    private <T> T firstId(List<OntologyQuery<T>> list) { //TODO 2 be removed
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

    private Set<EntryId> listEntryIdsByType(Set<String> types) {
        if (types == null || types.isEmpty() || types.contains(null))
            return null;
        return toEntryIdList(repo.filterIdsByTypes(types));
    }

    private Set<EntryId> toEntryIdList(List<Object[]> list) {
        return list.stream()
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

    private static Set<String> toIds(List<OntologyQuery<String>> types) {
        if (types == null)
            return null;
        return types.stream()
                .map(OntologyQuery::getId)
                .collect(toSet());
    }
}

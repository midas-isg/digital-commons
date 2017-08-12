package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.entry.Keys.HOST_SPECIES;
import static edu.pitt.isg.dc.entry.Keys.IS_ABOUT;
import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PATHOGEN_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.SPATIAL_COVERAGE;
import static edu.pitt.isg.dc.entry.Values.APPROVED;
import static java.lang.System.out;

@Service
public class EntryRule {
    @Autowired
    private EntryRepository repo;
    @Autowired
    private NcbiRule ncbi;
    @Value("${app.identifierSource.ncbi}")
    private String ncbiIdentifierSource;
    @Value("${app.identifierSource.ls}")
    private String lsIdentifierSource;

    public Page<Entry> findViaOntology(EntryOntologyQuery q, Pageable pageRequest) {
        List<EntryId> results = listIdsByHostRelativesOfNcbiId(q.getHostId());
        results = merge(results, listIdsByPathogenRelativesOfNcbiId(q.getPathogenId()));
        results = merge(results, listIdsByRelativesOfLsId(q.getLocationId()));
        results = merge(results, listIdsByType(q.getType()));

        if (results == null)
            return repo.findByStatus(APPROVED, pageRequest);
        return repo.findByIdIn(results, pageRequest);
    }

    private List<EntryId> listIdsByType(String... types) {
        if (types == null || types.length == 0 || types[0] == null)
            return null;
        return toEntryIdList(repo.filterIdsByTypes(types));
    }

    private List<EntryId> toEntryIdList(List<Object[]> list) {
        return list.stream()
                .map(EntryId::new)
                .collect(Collectors.toList());
    }

    private List<EntryId> listIdsByRelativesOfLsId(Long lsId) {
        if (lsId == null)
            return null;
        final List<String> lsIds = toLsRelativeIds(lsId);
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
                .collect(Collectors.toList());
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
                .collect(Collectors.toList());
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
                .collect(Collectors.toList());
    }

    private List<String> toLsRelativeIds(long lsId) {
        final List<String> urls = new ArrayList<>();
        urls.add(toLsUrl(lsId));
        return urls;
    }

    private String toLsUrl(Long id) {
        return id.toString();
    }
}

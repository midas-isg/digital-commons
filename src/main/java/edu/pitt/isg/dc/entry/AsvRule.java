package edu.pitt.isg.dc.entry;

import com.google.common.annotations.VisibleForTesting;
import edu.pitt.isg.dc.vm.OntologyQuery;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.entry.EntryAid.optimizeIdentifiers;
import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;
import static java.util.function.Function.identity;
import static java.util.stream.Collectors.toMap;
import static java.util.stream.Collectors.toSet;

@Service
@RequiredArgsConstructor
@Slf4j
public class AsvRule {
    private static final String SEPARATOR = ",";
    private final EntryRepository entryRepo;
    private final AsvRepository repo;

    @Value("${app.identifierSource.sv}")
    private String identifierSource;

    public Set<String> listAsvIrisAsControlMeasureInEntries() {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(CONTROL_MEASURES, identifierSource);
    }

    public List<Asv> findControlMeasuresInEntries() {
        return repo.findByIriIn(listAsvIrisAsControlMeasureInEntries());
    }

    Set<EntryId> searchEntryIdsByIri(List<OntologyQuery<String>> queries) {
        final Set<String> iris = toRelevantIdentifiers(queries);
        if (iris == null)
            return null;
        if (iris.isEmpty())
            return Collections.emptySet();
        final Set<String> irisInEntries = listAsvIrisAsControlMeasureInEntries();
        final Set<String> optimizedIds = optimizeIdentifiers(irisInEntries, iris);
        if (optimizedIds.isEmpty())
            return Collections.emptySet();

        final Stream<String> stream = Stream.of(CONTROL_MEASURES);
        final Set<EntryId> ids = filterEntryId(stream, iris);
        log.debug("ASV: " + iris +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    @VisibleForTesting
    Set<String> toRelevantIdentifiers(List<OntologyQuery<String>> queries) {
        if (queries == null || queries.isEmpty())
            return null;
        final Map<String, OntologyQuery<String>> map = queries.stream()
                .collect(toMap(OntologyQuery::getId, identity()));
        return repo.findByIriIn(map.keySet()).stream()
                .map(asv -> toIdentifiers(asv, map.get(asv.getIri())))
                .flatMap(Collection::stream)
                .collect(toSet());
    }

    private Set<String> toIdentifiers(Asv asv, OntologyQuery<String> option) {
        final Set<String> identifiers = new HashSet<>();
        if (option.isIncludeAncestors())
            identifiers.addAll(Arrays.stream(asv.getPath().split(SEPARATOR))
                    .collect(toSet()));
        else
            identifiers.add(asv.getIri());

        if (option.isIncludeDescendants())
            identifiers.addAll(listDescendantIdentifiers(asv));
        return identifiers;
    }

    private Set<String> listDescendantIdentifiers(Asv asv) {
        final String path = asv.getAncestors();
        final String like = asv.getIri();//  +SEPARATOR;
        final List<Asv> asvs = repo.findByAncestorsContaining(like);
        return asvs.stream()
                .filter(Asv::getLeaf)
                .map(Asv::getAncestors)
                .map(p -> p.replace(path, ""))
                .flatMap(p -> Arrays.stream(p.split(SEPARATOR)))
                .filter(s -> ! s.isEmpty())
                .collect(toSet());
    }

    private Set<EntryId> filterEntryId(Stream<String> stream, Set<String> onlyIds) {
        return EntryAid.filterEntryId(entryRepo, stream, identifierSource, onlyIds);
    }
}

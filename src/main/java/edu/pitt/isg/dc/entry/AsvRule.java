package edu.pitt.isg.dc.entry;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;

@Service
@RequiredArgsConstructor
@Slf4j
public class AsvRule {
    public static final String SEPARATOR = ",";
    private final EntryRepository entryRepo;
    private final AsvRepository repo;

    @Value("${app.identifierSource.sv}")
    private String identifierSource;

    public Set<String> listAsvIdsAsControlMeasureInEntries() {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(CONTROL_MEASURES, identifierSource);
    }

    public Set<Asv> findControlMeasuresInEntries() {
        return repo.findByIriIn(listAsvIdsAsControlMeasureInEntries());
    }

    Set<EntryId> searchEntryIdsByControlMeasureId(String iri) {
        if (iri == null)
            return null;
        final Set<String> asvIris = toAllRelativeAsvIds(iri);
        final Stream<String> stream = Stream.of(CONTROL_MEASURES);
        final Set<EntryId> ids = filterEntryId(stream, asvIris);
        log.debug("ASV:" + asvIris +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private Set<String> toAllRelativeAsvIds(String iri) {
        final List<Asv> asvs = repo.findByAncestorsContaining(iri);
        return asvs.stream()
                .filter(Asv::getLeaf)
                .map(Asv::getAncestors)
                .flatMap(p -> Arrays.stream(p.split(SEPARATOR)))
                .collect(Collectors.toSet());
    }

    private Set<EntryId> filterEntryId(Stream<String> stream, Set<String> onlyIds) {
        return EntryAid.filterEntryId(entryRepo, stream, identifierSource, onlyIds);
    }
}

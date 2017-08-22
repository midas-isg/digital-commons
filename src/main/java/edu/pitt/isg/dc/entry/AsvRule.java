package edu.pitt.isg.dc.entry;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;
import static edu.pitt.isg.dc.entry.Values.PATH_SEPARATOR;

@Service
@RequiredArgsConstructor
public class AsvRule {
    public static final String SEPARATOR = ",";
    private final EntryRepository entryRepo;
    private final AsvRepository repo;

    @Value("${app.identifierSource.sv}")
    private String identifierSource;

    public List<String> listAsvIdsAsControlMeasureInEntries() {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(CONTROL_MEASURES, identifierSource);
    }

    public List<Asv> findControlMeasuresInEntries() {
        return repo.findByIriIn(listAsvIdsAsControlMeasureInEntries());
    }

    Set<String> toAllRelativeAsvIds(String iri) {
        final List<Asv> asvs = repo.findByAncestorsContaining(iri);
        return asvs.stream()
                .filter(Asv::getLeaf)
                .map(Asv::getAncestors)
                .flatMap(p -> Arrays.stream(p.split(SEPARATOR)))
                .collect(Collectors.toSet());
    }
}

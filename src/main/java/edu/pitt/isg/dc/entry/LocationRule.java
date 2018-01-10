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
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.entry.EntryAid.optimizeIdentifiers;
import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.SPATIAL_COVERAGE;
import static java.util.Arrays.asList;
import static java.util.function.Function.identity;
import static java.util.stream.Collectors.toMap;
import static java.util.stream.Collectors.toSet;

@Service
@RequiredArgsConstructor
@Slf4j
public class LocationRule {
    private static final List<String> fields = asList(
            SPATIAL_COVERAGE,
            LOCATION_COVERAGE);
    private final EntryRepository entryRepo;
    private final LocationProxy proxy;

    @Value("${app.identifierSource.ls}")
    private String identifierSource;

    public List<Location> findLocationsInEntries() {
        return findAll(listAlcsAsLocationInEntries());
    }

    public Set<EntryId> searchEntryIdsByAlc(Set<OntologyQuery<Long>> queries) {
        final Set<String> alcs = toRelevantIdentifiers(queries);
        if (alcs == null)
            return null;
        if (alcs.isEmpty())
            return Collections.emptySet();
        final Set<String> alcsInEntries = listAlcsAsLocationInEntries();
        final Set<String> optimizedIds = optimizeIdentifiers(alcsInEntries, alcs);
        if (optimizedIds.isEmpty())
            return Collections.emptySet();

        final Stream<String> stream = fields.stream().parallel();
        final Set<EntryId> ids = filterEntryId(stream, optimizedIds);
        log.debug("LS: " + optimizedIds +  "=>" + ids.size() + " entries:" + ids);
        return ids;
    }

    private Set<EntryId> filterEntryId(Stream<String> stream, Set<String> lsIds) {
        return EntryAid.filterEntryId(entryRepo, stream, identifierSource, lsIds);
    }

    private Set<String> listAlcsAsLocationInEntries() {
        return fields.stream().parallel()
                .map(this::listAlcsAs)
                .flatMap(Collection::stream)
                .collect(toSet());
    }

    private Set<String> listAlcsAs(String field) {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(field, identifierSource);
    }

    @VisibleForTesting
    Set<String> toRelevantIdentifiers(Set<OntologyQuery<Long>> queries) {
        if (queries == null || queries.isEmpty())
            return null;
        final Map<Long, OntologyQuery<Long>> map = queries.stream()
                .collect(toMap(OntologyQuery::getId, identity()));
        final List<Location> locations = proxy.findAllByIds(map.keySet());
        return locations.stream()
                .map(l -> toIdentifiers(l, map.get(l.getId())))
                .flatMap(Collection::stream)
                .collect(toSet());
    }

    private Set<String> toIdentifiers(Location l, OntologyQuery<Long> option) {
        final Set<String> identifiers = new HashSet<>();
        final boolean a = option.isIncludeAncestors();
        final boolean d = option.isIncludeDescendants();
        if (a && d)
            identifiers.addAll(toAllRelatives(l));
        else if (a) // a only
            identifiers.addAll(toAllAncestors(l));
        else if (d) // d only
            identifiers.addAll(toAllDescendants(l));
        identifiers.add(l.getId() + "");
        return identifiers;
    }

    private Set<String> toAllDescendants(Location l) {
        final Set<String> relatives = toAllRelatives(l);
        relatives.removeAll(toAllAncestors(l));
        return relatives;
    }

    private Set<String> toAllAncestors(Location l) {
        return Arrays.stream(l.getPath().split("/"))
                .collect(Collectors.toSet());
    }

    private Set<String> toAllRelatives(Location l) {
        return Arrays.stream(l.getRelatives().split(",")).collect(toSet());
    }


    @VisibleForTesting
    public List<Location> findAll(Set<String> alcs) {
        return proxy.findAll(alcs);
    }
}

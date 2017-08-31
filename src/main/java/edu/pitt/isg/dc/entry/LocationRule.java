package edu.pitt.isg.dc.entry;

import com.google.common.annotations.VisibleForTesting;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.SPATIAL_COVERAGE;
import static java.util.stream.Collectors.toList;

@Service
@RequiredArgsConstructor
public class LocationRule {
    private final EntryRepository entryRepo;
    private final LocationProxy proxy;

    @Value("${app.identifierSource.ls}")
    private String identifierSource;

    public List<Location> findLocationsInEntries() {
        return proxy.findAll(listAlcsAsLocationInEntries());
    }

    Set<String> listAlcsAsLocationInEntries() {
        final Set<String> locations = listAlcsAs(LOCATION_COVERAGE);
        final Set<String> alcs = new HashSet<>(locations);
        alcs.addAll(listAlcsAs(SPATIAL_COVERAGE));
        return alcs;
    }

    private Set<String> listAlcsAs(String field) {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(field, identifierSource);
    }

    @VisibleForTesting
    public List<String> toRelativeAlcs(long alc) {
        final List<Long> longs = proxy.findRelatives(alc);
        final Set<String> alcs = listAlcsAsLocationInEntries();
        final List<String> result = longs.stream()
                .map(Object::toString)
                .filter(alcs::contains)
                .collect(toList());
        final String id = alc + "";
        if (alcs.contains(id))
            result.add(id);
        return result;
    }
}

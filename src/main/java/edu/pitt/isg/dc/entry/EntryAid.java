package edu.pitt.isg.dc.entry;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toSet;

class EntryAid {
    private EntryAid(){
    }

    static Set<EntryId> filterEntryId(
            EntryRepository repo,
            Stream<String> stream,
            String idSrc,
            Set<String> onlyIds) {
        return stream
                .map(f -> repo.filterIdsByFieldAndIdentifierSource(f, idSrc, onlyIds))
                .flatMap(Collection::stream)
                .map(edu.pitt.isg.dc.entry.EntryId::new)
                .collect(toSet());
    }

    static Set<String> optimizeIdentifiersWithIds(Set<String> relevantIdentifiers, Set<Long> idsInEntries) {
        return relevantIdentifiers.stream()
                .map(Long::parseLong)
                .filter(idsInEntries::contains)
                .map(Object::toString)
                .collect(toSet());
    }

    static Set<String> optimizeIdentifiers(Set<String> relevantIdentifiers, Set<String> idsInEntries) {
        return relevantIdentifiers.stream()
                .filter(idsInEntries::contains)
                .collect(toSet());
    }
}

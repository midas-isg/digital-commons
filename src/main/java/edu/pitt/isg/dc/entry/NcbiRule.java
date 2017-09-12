package edu.pitt.isg.dc.entry;

import com.google.common.annotations.VisibleForTesting;
import edu.pitt.isg.dc.vm.OntologyQuery;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
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

import static edu.pitt.isg.dc.entry.EntryAid.optimizeIdentifiersWithIds;
import static edu.pitt.isg.dc.entry.Keys.HOST_SPECIES;
import static edu.pitt.isg.dc.entry.Keys.IS_ABOUT;
import static edu.pitt.isg.dc.entry.Keys.PATHOGEN_COVERAGE;
import static edu.pitt.isg.dc.entry.Values.PATH_SEPARATOR;
import static java.util.Comparator.comparing;
import static java.util.function.Function.identity;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toMap;
import static java.util.stream.Collectors.toSet;

@Service
@Slf4j
public class NcbiRule {
    @Autowired
    private NcbiRepository repo;
    @Autowired
    private EntryRepository entryRepo;

    @Value("${app.identifierSource.ncbi}")
    private String identifierSource;
    @Value("${app.ncbi.host.root.path}")
    private String hostRootPath;

    public List<Ncbi> findHostsInEntries() {
        final Stream<String> stream = Stream.of(IS_ABOUT, HOST_SPECIES);
        final Set<Long> hosts = listIdsInEntries(stream.parallel());
        return repo.findAll(hosts).stream()
                .filter(this::isHost)
                .collect(toList());
    }

    public List<Ncbi> findPathogensInEntries() {
        final Stream<String> stream = Stream.of(IS_ABOUT, PATHOGEN_COVERAGE);
        final Set<Long> pathogens = listIdsInEntries(stream.parallel());
        return repo.findAll(pathogens).stream()
                .filter(n -> ! isHost(n))
                .collect(toList());
    }

    Set<EntryId> searchEntryIdsByHost(List<OntologyQuery<Long>> queries) {
        final List<Ncbi> hosts = findHostsInEntries();
        final Stream<String> stream = Stream.of(IS_ABOUT, HOST_SPECIES);
        return listEntryIds(queries, stream.parallel(), hosts);
    }

    Set<EntryId> searchEntryIdsByPathogens(List<OntologyQuery<Long>> queries) {
        final List<Ncbi> pathogens = findPathogensInEntries();
        final Stream<String> stream = Stream.of(IS_ABOUT, PATHOGEN_COVERAGE);
        return listEntryIds(queries, stream.parallel(), pathogens);
    }

    private boolean isHost(Ncbi ncbi) {
        return ncbi.getPath().startsWith(hostRootPath);
    }

    private Set<Long> listIdsInEntries(Stream<String> fields) {
        return fields
                .map(this::listIdentifiersInEntries)
                .flatMap(NcbiRule::toIdStream)
                .collect(toSet());
    }

    private Set<String> listIdentifiersInEntries(String field) {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(field, identifierSource);
    }

    private Set<EntryId> listEntryIds(
            List<OntologyQuery<Long>> queries,
            Stream<String> stream,
            List<Ncbi> ncbisInEntries) {
        final Set<String> relevantIds = toRelevantIdentifiers(queries);
        if (relevantIds == null)
            return null;
        if (relevantIds.isEmpty())
            return Collections.emptySet();
        final Set<String> optimizedIds = optimizeIds(ncbisInEntries, relevantIds);
        if (optimizedIds.isEmpty())
            return Collections.emptySet();

        final Set<EntryId> entryIds = filterEntryIds(stream, optimizedIds);
        log.debug("NCBI:" +  optimizedIds.size() + " ncbiIdsInEntries:"
                + optimizedIds + "=>" + entryIds.size() + " entries:" + entryIds);
        return entryIds;
    }

    private Set<EntryId> filterEntryIds(Stream<String> stream, Set<String> ids) {
        return EntryAid.filterEntryId(entryRepo, stream, identifierSource, ids);
    }

    @VisibleForTesting
    Set<String> toRelevantIdentifiers(List<OntologyQuery<Long>> queries) {
        if (queries == null || queries.isEmpty())
            return null;
        final Map<Long, OntologyQuery<Long>> map = queries.stream()
                .collect(toMap(OntologyQuery::getId, identity()));
        return repo.findAll(map.keySet()).stream()
                .map(n -> toIdentifiers(n, map.get(n.getId())))
                .flatMap(Collection::stream)
                .collect(toSet());
    }

    private Set<String> toIdentifiers(Ncbi ncbi, OntologyQuery<Long> option) {
        final Set<String> identifiers = new HashSet<>();
        if (option.isIncludeAncestors())
            identifiers.addAll(Arrays.stream(ncbi.getPath().split(PATH_SEPARATOR))
                .collect(toSet()));
        else
            identifiers.add(ncbi.getId() + "");

        if (option.isIncludeDescendants())
            identifiers.addAll(listDescendantIdentifiers(ncbi));
        return identifiers;
    }

    private Set<String> listDescendantIdentifiers(Ncbi ncbi) {
        final String path = ncbi.getPath();
        final String like = PATH_SEPARATOR + ncbi.getId() + PATH_SEPARATOR;
        final List<Ncbi> ncbis = repo.findAllByPathContaining(like);
        return ncbis.stream()
                .filter(Ncbi::getIsLeaf)
                .map(Ncbi::getPath)
                .map(p -> p.replace(path + PATH_SEPARATOR, ""))
                .flatMap(p -> Arrays.stream(p.split(PATH_SEPARATOR)))
                .collect(toSet());
    }

    static Set<String> optimizeIds(List<Ncbi> ncbisInEntries, Set<String> relevantIds) {
        final Set<Long> ncbiIdsInEntries = ncbisInEntries.stream()
                .map(Ncbi::getId)
                .collect(toSet());
        return optimizeIdentifiersWithIds(relevantIds, ncbiIdsInEntries);
    }

    static Stream<Long> toIdStream(Set<String> identifiers) {
        return identifiers.stream()
                .filter(s -> ! s.isEmpty())   // Bad Data
                .map(NcbiRule::takeInteger)    // Bad Data
                .map(s -> s.replace(")", "")) // Bad Data
                .map(Long::parseLong);
    }

    private static String takeInteger(String s) {
        final String[] tokens = s.split("[_=]");
        if (tokens.length > 1)
            return tokens[1];
        return s;
    }
}

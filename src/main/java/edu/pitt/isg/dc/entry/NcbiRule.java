package edu.pitt.isg.dc.entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class NcbiRule {
    @Autowired
    private NcbiRepository repo;
    @Autowired
    private EntryRepository entryRepo;

    @Value("${app.identifierSource.ncbi}")
    private String identifierSource;
    @Value("${app.ncbi.host.root.path}")
    private String hostRootPath;

    private Set<Long> listHostPlusIsAboutNcbiIdsInEntries() {
        final Set<Long> abouts = toIds(listIdsByIsAbout());
        final Set<Long> hosts = listNcbiIdsAsHostInEntries();
        hosts.addAll(abouts);
        return hosts;
    }

    private Set<Long> listPathogenPlusIsAboutNcbiIdsInEntries() {
        final Set<Long> abouts = toIds(listIdsByIsAbout());
        final Set<Long> hosts = listNcbiIdsAsPathogenInEntries();
        hosts.addAll(abouts);
        return hosts;
    }

    private List<String> listIdsByIsAbout() {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource("isAbout", identifierSource);
    }

    private Set<Long> toIds(List<String> urls) {
        return urls.stream()
                .filter(s -> ! s.isEmpty())   // Bad Data
                .map(this::takeInteger)       // Bad Data
                .map(s -> s.replace(")", "")) // Bad Data
                .map(Long::parseLong)
                .collect(Collectors.toSet());
    }

    private String takeInteger(String s) {
        final String[] tokens = s.split("[_=]");
        if (tokens.length > 1)
            return tokens[1];
        return s;
    }

    List<String> toAllRelativeNcbiIds(long ncbiId) {
        Ncbi ncbi = repo.findOne(ncbiId);
        final List<String> urls = Arrays.stream(ncbi.getPath().split("/"))
                .collect(Collectors.toList());
        //System.out.println(urls);
        final Set<String> descendants = findNcbiIdsByPathContaining(ncbiId);
        urls.addAll(descendants.stream()
                .mapToLong(Long::parseLong)
                .mapToObj(this::toNcbiUrl)
                .collect(Collectors.toList())
        );
        // System.out.println(urls);
        return urls;
    }

    private String toNcbiUrl(long id) {
        //return "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=" + id;
        return "" + id;
    }

    private Set<String> findNcbiIdsByPathContaining(Long id) {
        final Ncbi one = repo.findOne(id);
        final String path = one.getPath();
        final List<Ncbi> ncbis = repo.findAllByPathContaining("/" + id + "/");
        return ncbis.stream()
                .filter(Ncbi::getLeaf)
                .map(Ncbi::getPath)
                .map(p -> p.replace(path + "/", ""))
                .flatMap(p -> Arrays.stream(p.split("/")))
                .collect(Collectors.toSet());
    }

    @Transactional
    public Ncbi read(Long id) {
        return repo.findOne(id);
    }

    public List<Ncbi> findHostsInEntries() {
        return repo.findAll(listHostPlusIsAboutNcbiIdsInEntries()).stream()
                .filter(n -> n.getPath().startsWith(hostRootPath))
                .collect(Collectors.toList());
    }

    private Set<Long> listNcbiIdsAsHostInEntries() {
        return toIds(entryRepo.listIdentifiersByFieldAndIdentifierSource("hostSpeciesIncluded", identifierSource));
    }

    public List<Ncbi> findPathogensInEntries() {
        return repo.findAll(listPathogenPlusIsAboutNcbiIdsInEntries()).stream()
                .filter(n -> ! n.getPath().startsWith(hostRootPath))
                .collect(Collectors.toList());
    }

    private Set<Long> listNcbiIdsAsPathogenInEntries() {
        return toIds(entryRepo.listIdentifiersByFieldAndIdentifierSource("pathogenCoverage", identifierSource));
    }
}

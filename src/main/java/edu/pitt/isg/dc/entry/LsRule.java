package edu.pitt.isg.dc.entry;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;

@Service
@RequiredArgsConstructor
public class LsRule {
    private final EntryRepository entryRepo;

    @Value("${app.identifierSource.ls}")
    private String identifierSource;

    public List<String> listlsIdsAsLocationInEntries() {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(LOCATION_COVERAGE, identifierSource);
    }
}

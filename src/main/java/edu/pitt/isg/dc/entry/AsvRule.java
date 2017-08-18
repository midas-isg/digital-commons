package edu.pitt.isg.dc.entry;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;

@Service
@RequiredArgsConstructor
public class AsvRule {
    private final EntryRepository entryRepo;

    @Value("${app.identifierSource.sv}")
    private String identifierSource;

    public List<String> listAsvIdsAsControlMeasureInEntries() {
        return entryRepo.listIdentifiersByFieldAndIdentifierSource(CONTROL_MEASURES, identifierSource);
    }
}

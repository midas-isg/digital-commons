package edu.pitt.isg.dc.entry;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TypeRule {
    private final EntryRepository entryRepo;

    public List<String> findAll() {
        return entryRepo.listTypes();
    }
}

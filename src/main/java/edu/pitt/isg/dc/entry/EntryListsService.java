package edu.pitt.isg.dc.entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service
public class EntryListsService {
    @Autowired
    private EntryListsRepository entryListsRepository;

    public EntryLists findOne(Long id) {
        return entryListsRepository.findOne(id);
    }

    public List<EntryLists> findEntryLists(String type){
        return entryListsRepository.findEntryLists(type);
    }

    public List<EntryLists> findEntryListsWithSubType(String type, String subtype) {
        return entryListsRepository.findEntryListsWithSubType(type, subtype);
    }

    public HashMap findContentForEntryListsByIdentifier(Integer identifier){
        return entryListsRepository.findContentForEntryListsByIdentifier(identifier);
    }

}

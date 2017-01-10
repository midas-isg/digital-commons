package edu.pitt.isg.dc.digital.software;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SoftwareRule {
    @Autowired
    private SoftwareRepository repository;

    public Iterable<SoftwareFolder> tree() {
        Map<String, SoftwareFolder> root = new HashMap<>();
        Iterable<Software> all = repository.findAll();
        for (Software item : all){
            final String type = item.getTypeText();
            final SoftwareFolder folder = toFolder(root, type);
            final List<Software> list = toList(folder);
            list.add(item);
        }

        return root.values();
    }

    private List<Software> toList(SoftwareFolder folder) {
        final List<Software> list = folder.getList();
        if (list != null)
            return list;

        return  addNewList(folder);
    }

    private List<Software> addNewList(SoftwareFolder folder) {
        List<Software> list = new ArrayList<>();
        folder.setList(list);
        return list;
    }

    private SoftwareFolder toFolder(Map<String, SoftwareFolder> root, String type) {
        final SoftwareFolder folder = root.get(type);
        if (folder != null)
            return folder;

        final SoftwareFolder newFolder = newFolder(type);
        root.put(type, newFolder);
        return newFolder;

    }

    private SoftwareFolder newFolder(String name) {
        final SoftwareFolder folder = new SoftwareFolder();
        folder.setName(name);
        return folder;
    }

}

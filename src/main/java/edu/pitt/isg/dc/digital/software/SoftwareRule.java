package edu.pitt.isg.dc.digital.software;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class SoftwareRule {
    private static final String DISEASE_TRANSMISSION_MODELS = "Disease transmission models";
    private static final String VIRAL_BACTERIAL_EVOLUTION_SIMULATORS = "Viral and bacterial evolution models";
    private static final String DATA_VISUALIZERS = "Data visualizers";
    private static final String INFERRING_OUTBREAK_TRANSMISSION_TREES = "Inferring outbreak transmission trees";
    private static final String DISEASE_SURVEILLANCE_ALGORITHMS_SYSTEMS = "Disease surveillance algorithms and systems";
    private static final String OTHER_SOFTWARE = "Other software";


    @Autowired
    private SoftwareRepository repository;
    private Iterable<SoftwareFolder> cachedSoftwareRule;

    public Iterable<SoftwareFolder> tree() {
        if(cachedSoftwareRule != null) {
            return cachedSoftwareRule;
        } else {
            LinkedHashMap<String, SoftwareFolder> root = new LinkedHashMap<>();
            Iterable<Software> all = repository.findAllByOrderByName();
            createSortedFolder(root);
            for (Software item : all) {
                final String type = item.getTypeText();
                final SoftwareFolder folder = toFolder(root, type);
                final List<Software> list = toList(folder);
                list.add(item);
            }

            cachedSoftwareRule = root.values();
            return root.values();
        }
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

    private void createSortedFolder(Map<String, SoftwareFolder> root) {
        toFolder(root, DISEASE_TRANSMISSION_MODELS);
        toFolder(root, VIRAL_BACTERIAL_EVOLUTION_SIMULATORS);
        toFolder(root, DATA_VISUALIZERS);
        toFolder(root, INFERRING_OUTBREAK_TRANSMISSION_TREES);
        toFolder(root, DISEASE_SURVEILLANCE_ALGORITHMS_SYSTEMS);
        toFolder(root, OTHER_SOFTWARE);
    }

    private SoftwareFolder newFolder(String name) {
        final SoftwareFolder folder = new SoftwareFolder();
        folder.setName(name);
        return folder;
    }

}

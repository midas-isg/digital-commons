package edu.pitt.isg.dc.digital.dap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by amd176 on 1/10/17.
 */
public class DapUtil {
    public static List<Map<String, Object>> convertDapTreeToBootstrapTree(Iterable<DapFolder> tree) {
        final ArrayList<Map<String, Object>> list = new ArrayList<>();

        for(DapFolder folder : tree) {
            Map<String, Object> map = new HashMap<>();
            List<Map<String, Object>> nodes = new ArrayList<>();

            String name = folder.getName();

            if(name != null) {
                map.put("text", name);
            }

            DataAugmentedPublication paper = folder.getPaper();
            if(paper != null) {
                nodes.add(mapDataAugmentedPublication(paper));
            }

            DataAugmentedPublication data = folder.getData();
            if(data != null) {
                nodes.add(mapDataAugmentedPublication(data));
            }

            map.put("nodes", nodes);

            list.add(map);
        }

        return list;
    }

    public static Map<String, Object> mapDataAugmentedPublication(DataAugmentedPublication dap) {
        Map<String,Object> map = new HashMap<>();
        String publicationInfo = "";
        String doiInfo = "";

        if(dap.getAuthorsText() != null) {
            publicationInfo += dap.getAuthorsText() + " ";
        }

        if(dap.getPublicationDateText() != null) {
            publicationInfo += "(" + dap.getPublicationDateText() + ") ";
        }

        if(dap.getName() != null) {
            publicationInfo += dap.getName() + ". ";
        }

        if(dap.getJournal() != null) {
            doiInfo += dap.getJournal() + ". ";
        }

        if(dap.getDoi() != null) {
            doiInfo += "doi: " + dap.getDoi() + " ";
        }

        if(dap.getUrl() != null) {
            doiInfo += dap.getUrl();
        }

        map.put("type", dap.getTypeText());
        map.put("publicationInfo", publicationInfo);
        map.put("doiInfo", doiInfo);
        map.put("url", dap.getUrl());

        return map;
    }
}

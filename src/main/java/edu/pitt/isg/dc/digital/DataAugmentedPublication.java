package edu.pitt.isg.dc.digital;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class DataAugmentedPublication {
    private String name;
    private Paper paper;
    private AugmentedData data;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Paper getPaper() {
        return paper;
    }

    public void setPaper(Paper paper) {
        this.paper = paper;
    }

    public AugmentedData getData() {
        return data;
    }

    public void setData(AugmentedData data) {
        this.data = data;
    }

    public Map<String, Object> toBootstrapTree() {
        Map<String, Object> tree = new HashMap<>();

        if(this.name != null) {
            tree.put("text", this.name);
        }

        List<Map<String, Object>> nodes = new ArrayList<>();
        if(this.paper != null) {
            nodes.add(this.paper.getCitation());
        }

        if(this.data != null) {
            nodes.add(this.data.getCitation());
        }

        tree.put("nodes", nodes);

        return tree;
    }

    @Override
    public String toString() {
        return "DataAugmentedPublication{" +
                "name='" + name + '\'' +
                ", paper=" + paper +
                ", data=" + data +
                '}';
    }
}

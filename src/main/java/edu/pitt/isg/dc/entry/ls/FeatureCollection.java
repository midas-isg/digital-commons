package edu.pitt.isg.dc.entry.ls;

import lombok.Data;

import java.util.List;

@Data
public class FeatureCollection {
    private String type;
    private List<Feature> features;
}

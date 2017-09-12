package edu.pitt.isg.dc.entry.ls;

import lombok.Data;

import java.util.List;

@Data
public class Properties {
    private Long gid;
    private String locationTypeName;
    private String name;
    private List<Properties> lineage;
}

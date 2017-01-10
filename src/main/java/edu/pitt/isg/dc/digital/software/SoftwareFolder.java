package edu.pitt.isg.dc.digital.software;

import java.util.List;

public class SoftwareFolder {
    private String name;
    private List<Software> list;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Software> getList() {
        return list;
    }

    public void setList(List<Software> list) {
        this.list = list;
    }

    @Override
    public String toString() {
        return "SoftwareFolder{" +
                "name='" + name + '\'' +
                ", list=" + list +
                '}';
    }
}

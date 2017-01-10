package edu.pitt.isg.dc.digital.dap;

public class DapFolder {
    private String name;
    private DataAugmentedPublication paper;
    private DataAugmentedPublication data;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public DataAugmentedPublication getPaper() {
        return paper;
    }

    public void setPaper(DataAugmentedPublication paper) {
        this.paper = paper;
    }

    public DataAugmentedPublication getData() {
        return data;
    }

    public void setData(DataAugmentedPublication data) {
        this.data = data;
    }
}

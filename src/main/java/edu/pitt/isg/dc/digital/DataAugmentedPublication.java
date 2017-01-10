package edu.pitt.isg.dc.digital;

/** TODO: to be removed */
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

    @Override
    public String toString() {
        return "DataAugmentedPublication{" +
                "name='" + name + '\'' +
                ", paper=" + paper +
                ", data=" + data +
                '}';
    }
}

package edu.pitt.isg.dc.digital.dap;

import javax.persistence.Entity;

@Entity
public class DapForm extends DataAugmentedPublication {
    private String paperDoi;

    public String getPaperDoi() {
        return paperDoi;
    }

    public void setPaperDoi(String paperDoi) {
        this.paperDoi = paperDoi;
    }
}

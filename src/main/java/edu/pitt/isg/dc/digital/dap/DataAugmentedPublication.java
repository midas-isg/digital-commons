package edu.pitt.isg.dc.digital.dap;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.pitt.isg.dc.digital.Digital;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;

@Entity(name = "dap")
public class DataAugmentedPublication extends Digital {
    private String authorsText;
    private String publicationDateText;
    private String journal;
    private DataAugmentedPublication paper;

    public String getAuthorsText() {
        return authorsText;
    }

    public void setAuthorsText(String authorsText) {
        this.authorsText = authorsText;
    }

    public String getPublicationDateText() {
        return publicationDateText;
    }

    public void setPublicationDateText(String publicationDateText) {
        this.publicationDateText = publicationDateText;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnore
    public DataAugmentedPublication getPaper() {
        return paper;
    }

    public void setPaper(DataAugmentedPublication paper) {
        this.paper = paper;
    }

    public String getJournal() {
        return journal;
    }

    public void setJournal(String journal) {
        this.journal = journal;
    }
}

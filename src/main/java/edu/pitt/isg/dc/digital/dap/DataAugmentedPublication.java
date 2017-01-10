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
    private String typeText;
    private String doi;
    private String url;
    private String journal;
    private DataAugmentedPublication paper;

    public String getAuthorsText() {
        return authorsText;
    }

    public void setAuthorsText(String authorsText) {
        this.authorsText = authorsText;
    }

    public String getDoi() {
        return doi;
    }

    public void setDoi(String doi) {
        this.doi = doi;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getPublicationDateText() {
        return publicationDateText;
    }

    public void setPublicationDateText(String publicationDateText) {
        this.publicationDateText = publicationDateText;
    }

    public String getTypeText() {
        return typeText;
    }

    public void setTypeText(String typeText) {
        this.typeText = typeText;
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

    @Override
    public String toString() {
        return "DataAugmentedPublication{" +
                "authorsText='" + authorsText + '\'' +
                ", publicationDateText='" + publicationDateText + '\'' +
                ", typeText='" + typeText + '\'' +
                ", doi='" + doi + '\'' +
                ", url='" + url + '\'' +
                ", journal='" + journal + '\'' +
                ", paper=" + paper +
                '}';
    }
}
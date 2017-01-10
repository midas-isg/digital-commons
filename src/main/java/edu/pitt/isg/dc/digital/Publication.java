package edu.pitt.isg.dc.digital;

import java.util.Map;
import java.util.HashMap;

public abstract class Publication {
    private String authorsText;
    private String publicationDateText;
    private String typeText;
    private String doi;
    private String url;
    private String name;
    private String journal;

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getJournal() {
        return journal;
    }

    public void setJournal(String journal) {
        this.journal = journal;
    }

    public Map<String, Object> getCitation() {
        Map<String,Object> citationMap = new HashMap<>();
        String publicationInfo = "";
        String doiInfo = "";

        if(authorsText != null) {
            publicationInfo += authorsText + " ";
        }

        if(publicationDateText != null) {
            publicationInfo += "(" + publicationDateText + ") ";
        }

        if(name != null) {
            publicationInfo += name + ". ";
        }

        if(journal != null) {
            doiInfo += journal + ". ";
        }

        if(doi != null) {
            doiInfo += "doi: " + doi + " ";
        }

        if(url != null) {
            doiInfo += url;
        }

        citationMap.put("type", typeText);
        citationMap.put("publicationInfo", publicationInfo);
        citationMap.put("doiInfo", doiInfo);
        citationMap.put("url", url);

        return citationMap;
    }

    @Override
    public String toString() {
        return "Publication{" +
                "authorsText='" + authorsText + '\'' +
                ", publicationDateText='" + publicationDateText + '\'' +
                ", typeText='" + typeText + '\'' +
                ", doi='" + doi + '\'' +
                ", url='" + url + '\'' +
                '}';
    }
}

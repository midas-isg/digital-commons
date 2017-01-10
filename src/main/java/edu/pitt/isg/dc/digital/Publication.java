package edu.pitt.isg.dc.digital;

/** TODO: to be removed */
public abstract class Publication {
    private String authorsText;
    private String publicationDateText;
    private String typeText;
    private String doi;
    private String url;

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

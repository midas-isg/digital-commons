package edu.pitt.isg.dc.digital.software;

import edu.pitt.isg.dc.digital.Digital;

import javax.persistence.Entity;

@Entity
public class Software extends Digital {
    private String version;
    private String developer;
    private String sourceCodeUrl;

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getDeveloper() {
        return developer;
    }

    public void setDeveloper(String developer) {
        this.developer = developer;
    }

    public String getSourceCodeUrl() {
        return sourceCodeUrl;
    }

    public void setSourceCodeUrl(String sourceCodeUrl) {
        this.sourceCodeUrl = sourceCodeUrl;
    }
}

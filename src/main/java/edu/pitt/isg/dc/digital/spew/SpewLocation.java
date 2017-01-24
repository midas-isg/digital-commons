package edu.pitt.isg.dc.digital.spew;

import java.util.Map;

public class SpewLocation {
    private String code;
    private String name;
    private String url;
    private String type;
    private Map<String, SpewLocation> children;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Map<String, SpewLocation> getChildren() {
        return children;
    }

    public void setChildren(Map<String, SpewLocation> children) {
        this.children = children;
    }
}

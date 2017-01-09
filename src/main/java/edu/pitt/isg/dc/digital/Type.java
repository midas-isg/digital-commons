package edu.pitt.isg.dc.digital;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Type {
    private Long id;
    private String code;
    private Type parent;

    public Type() {
    }

    public Type(String code, Type parent) {
        this.code = code;
        this.parent = parent;
    }

    @Id()
    @GeneratedValue(strategy= GenerationType.AUTO)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public String toString() {
        return (parent == null ? "" : parent + "/") + code;
    }
}

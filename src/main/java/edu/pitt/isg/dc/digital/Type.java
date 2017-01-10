package edu.pitt.isg.dc.digital;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

@Entity
public class Type {
    private Long id;
    private String name;
    private Type parent;

    public Type() {
    }

    public Type(String name, Type parent) {
        this.name = name;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Transient
    public String getCode() {
        return (parent == null ? "" : parent.getCode() + "/") + name;
    }

    @ManyToOne(fetch= FetchType.EAGER)
    @JsonIgnore
    public Type getParent() {
        return parent;
    }

    public void setParent(Type parent) {
        this.parent = parent;
    }

    @Override
    public String toString() {
        return getCode();
    }
}

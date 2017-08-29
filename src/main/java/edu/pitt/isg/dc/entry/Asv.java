package edu.pitt.isg.dc.entry;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
@Data
public class Asv {
    @Id @GeneratedValue
    private Long id;
    private String name;
    @Column(unique = true)
    private String iri;
    private String ancestors;
    private Boolean leaf;
}

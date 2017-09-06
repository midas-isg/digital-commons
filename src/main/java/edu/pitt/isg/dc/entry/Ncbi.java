package edu.pitt.isg.dc.entry;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
@Data
public class Ncbi {
    @Id
    private Long id;
    private String name;
    private String path;
    @Column(name = "leaf")
    private Boolean isLeaf;
}

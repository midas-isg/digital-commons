package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.entry.util.Treeable;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class Ncbi implements Treeable {
    @Id
    private Long id;
    private String name;
    private String path;
    @Column(name = "leaf")
    private Boolean isLeaf;
}

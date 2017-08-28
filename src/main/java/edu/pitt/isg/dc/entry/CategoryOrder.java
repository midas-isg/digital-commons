package edu.pitt.isg.dc.entry;

import javax.persistence.*;

import java.math.BigInteger;

import static javax.persistence.GenerationType.IDENTITY;

@Entity
public class CategoryOrder {
    private Long id;
    private Category category;
    private Category subcategory;
    private Integer ordering;

    @Id
    @GeneratedValue(strategy = IDENTITY)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @ManyToOne
    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    @ManyToOne
    public Category getSubcategory() {
        return subcategory;
    }

    public void setSubcategory(Category subcategory) {
        this.subcategory = subcategory;
    }

    public Integer getOrdering() {
        return ordering;
    }

    public void setOrdering(Integer ordering) {
        this.ordering = ordering;
    }


}

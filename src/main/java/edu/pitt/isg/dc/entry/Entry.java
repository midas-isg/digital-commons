package edu.pitt.isg.dc.entry;


import edu.pitt.isg.dc.config.hibernate.JsonbType;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashMap;

import static javax.persistence.GenerationType.IDENTITY;

@Entity
@TypeDef(name = JsonbType.NAME, typeClass = JsonbType.class, parameters = {
        @Parameter(name = JsonbType.CLASS, value = "java.util.HashMap")})
public class Entry {
    @EmbeddedId
    private EntryId id;
    @Type(type = JsonbType.NAME)
    private HashMap content;
    private String status;
    private boolean isPublic;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    public EntryId getId() {
        return id;
    }

    public void setId(EntryId id) {
        this.id = id;
    }

    public HashMap getContent() {
        return content;
    }

    public void setContent(HashMap content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }
}

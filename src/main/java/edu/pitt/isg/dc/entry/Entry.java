package edu.pitt.isg.dc.entry;


import edu.pitt.isg.dc.config.hibernate.JsonbType;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import javax.persistence.*;
import java.util.HashMap;
import java.util.Set;

@Entity
@TypeDef(name = JsonbType.NAME, typeClass = JsonbType.class, parameters = {
        @Parameter(name = JsonbType.CLASS, value = "java.util.HashMap")})
public class Entry {
    @EmbeddedId
    private EntryId id;
    @Type(type = JsonbType.NAME)
    private HashMap content;
    private String status = Values.PENDING;
    private boolean isPublic;
    private String displayName;

    @ElementCollection(fetch = FetchType.EAGER)
    private Set<String> tags;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    public EntryId getId() {
        return id;
    }

    public void setId(EntryId id) {
        this.id = id;
    }

    @Type(type = JsonbType.NAME)
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

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public Set<String> getTags() {
        return tags;
    }

    public void setTags(Set<String> tags) {
        this.tags = tags;
    }
}

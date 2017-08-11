package edu.pitt.isg.dc.entry;

import javax.persistence.ElementCollection;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.util.Set;

@Entity
public class Comments {
    @EmbeddedId
    private EntryId id;

    @ElementCollection
    private Set<String> content;

    public EntryId getId() {
        return id;
    }

    public void setId(EntryId id) {
        this.id = id;
    }

    public Set<String> getContent() {
        return content;
    }

    public void setContent(Set<String> content) {
        this.content = content;
    }
}

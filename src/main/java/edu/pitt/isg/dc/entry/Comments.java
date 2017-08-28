package edu.pitt.isg.dc.entry;

import org.hibernate.annotations.Fetch;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Entity
public class Comments {
    @EmbeddedId
    private EntryId id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private Users users;

    @ElementCollection(fetch = FetchType.EAGER)
    private List<String> content;

    public EntryId getId() {
        return id;
    }

    public void setId(EntryId id) {
        this.id = id;
    }

    public List<String> getContent() {
        return content;
    }

    public void setContent(List<String> content) {
        this.content = content;
    }

    public Users getUsers() {
        return users;
    }

    public void setUsers(Users users) {
        this.users = users;
    }
}

package edu.pitt.isg.dc.entry;

import javax.persistence.*;
import java.util.List;

import static javax.persistence.GenerationType.IDENTITY;

@Entity
public class Comments {
    @Id
    @GeneratedValue(strategy = IDENTITY)
    private Long id;
//    @ManyToOne(fetch=FetchType.EAGER)
//    @JoinColumns ({
//            @JoinColumn(name="entry_id", referencedColumnName = "entry_id"),
//            @JoinColumn(name="revision_id", referencedColumnName = "revision_id")
//            })
    private EntryId entryId;
    private String content;
    @OneToOne
    @JoinColumn(name = "user_id")
    private Users users;

    public EntryId getEntryId() {
        return entryId;
    }

    public void setEntryId(EntryId entryId) {
        this.entryId = entryId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Users getUsers() {
        return users;
    }

    public void setUsers(Users users) {
        this.users = users;
    }
}

package edu.pitt.isg.dc.entry;

import javax.persistence.*;

import static javax.persistence.GenerationType.IDENTITY;

@Entity
@Table(name = "users", uniqueConstraints = @UniqueConstraint(columnNames = {"userId", "email", "name"}))
public class Users {
    private Long id;
    private String userId;
    private String email;
    private String name;

    public Users() {
    }

    public Users(String userId, String email, String name) {
        this.userId = userId;
        this.email = email;
        this.name = name;
    }

    @Id
    @GeneratedValue(strategy = IDENTITY)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}


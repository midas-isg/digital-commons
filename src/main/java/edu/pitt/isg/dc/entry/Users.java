package edu.pitt.isg.dc.entry;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.pitt.isg.dc.security.jpa.Role;

import javax.persistence.*;
import java.util.Set;

import static javax.persistence.GenerationType.IDENTITY;

@Entity
@Table(name = "users", uniqueConstraints = @UniqueConstraint(columnNames = {"userId", "email", "name"}))
public class Users {
    @Id
    @GeneratedValue(strategy = IDENTITY)
    private Long id;
    private String userId;
    private String email;
    private String name;
    private String password;
    private String resetToken;

    @Transient
    private String passwordConfirm;

    @ManyToMany(fetch=FetchType.EAGER)
    private Set<Role> roles;

    public Users() {
    }

    public Users(String userId, String email, String name) {
        this.userId = userId;
        this.email = email;
        this.name = name;
    }


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

   public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPasswordConfirm() {
        return passwordConfirm;
    }

    public void setPasswordConfirm(String passwordConfirm) {
        this.passwordConfirm = passwordConfirm;
    }

    @JsonIgnore
    public Set<Role> getRoles() {
        return roles;
    }

    public void setRoles(Set<Role> roles) {
        this.roles = roles;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }
}


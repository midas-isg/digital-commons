package edu.pitt.isg.dc.security.service;

import edu.pitt.isg.dc.security.jpa.User;

public interface UserService {
    void save(User user);

    User findByUsername(String username);
}
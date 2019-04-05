package edu.pitt.isg.dc.security.service;

import edu.pitt.isg.dc.entry.Users;

public interface UserService {
    void save(Users user);

    Users findUserForSubmissionByUserId(String userId);

    Users findByUserId(String userId);

    Users findByEmail(String email);

    Users findByResetToken(String resetToken);
}
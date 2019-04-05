package edu.pitt.isg.dc.security.service;

import edu.pitt.isg.dc.entry.UserRepository;
import edu.pitt.isg.dc.entry.Users;
import edu.pitt.isg.dc.security.repo.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Override
    public void save(Users user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        user.setRoles(new HashSet<>(roleRepository.findAll()));
        userRepository.save(user);
    }

    @Override
    public Users findUserForSubmissionByUserId(String userId) {
        Users user = userRepository.findByUserId(userId);
        user.setRoles(null);
        return user;
    }

    @Override
    public Users findByUserId(String userId) {
        return userRepository.findByUserId(userId);
    }

    @Override
    public Users findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public Users findByResetToken(String resetToken) {
        return userRepository.findByResetToken(resetToken);
    }
}
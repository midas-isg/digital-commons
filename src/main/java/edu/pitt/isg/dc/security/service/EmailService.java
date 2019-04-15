package edu.pitt.isg.dc.security.service;

import org.springframework.mail.SimpleMailMessage;


public interface EmailService {
	public void sendEmail(SimpleMailMessage email);
}
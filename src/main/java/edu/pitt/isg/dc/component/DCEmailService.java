package edu.pitt.isg.dc.component;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;

/**
 * Created by TPS23 on 5/15/2017.
 */

public class DCEmailService {
    private static final String USERNAME;
    private static final String HOST;
    private static final String PROTOCOL;
    private static final String PASSWORD;
    private static final String ADMIN_EMAIL;
    private static final Properties EMAIL_CONFIG;

    static {
        String adminEmail = "";
        String username = "";
        String password = "";
        String host = "";
        String protocol = "";
        EMAIL_CONFIG = new Properties();

        try{
            EMAIL_CONFIG.load(DCEmailService.class.getClassLoader()
                .getResourceAsStream("mail.properties"));
            adminEmail = EMAIL_CONFIG.getProperty("mail.receivers");
            username = EMAIL_CONFIG.getProperty("mail.sender");
            password = EMAIL_CONFIG.getProperty("mail.sender_password");
            host = EMAIL_CONFIG.getProperty("mail.host");
            protocol = EMAIL_CONFIG.getProperty("mail.protocol");
        }
        catch(Exception exception) {
            System.err.print(exception);
        }

        ADMIN_EMAIL = adminEmail;
        USERNAME = username;
        PASSWORD = password;
        HOST = host;
        PROTOCOL = protocol;
    }

    public static void mailToAdmin(String subject, String payload) throws Exception {
        sendMail(subject, payload, ADMIN_EMAIL);

    }

    public static void mailToUser(String subject, String payload, String userEmail) throws Exception {
        sendMail(subject, payload, userEmail);
    }

    private static void sendMail(String subject, String payload, String email) throws Exception {
        Transport t = null;
        try {
            Properties props = new Properties();

            // set any needed mail.smtps.* properties here
            Session session = Session.getInstance(props);
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(USERNAME));

            msg.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(email));

            msg.setSubject(subject);
            msg.setSentDate(new Date());
            msg.setText(payload);

            t = session.getTransport(PROTOCOL);
            t.connect(HOST, USERNAME, PASSWORD);
            t.sendMessage(msg, msg.getAllRecipients());
        }
        catch (MessagingException messagingException) {
            messagingException.printStackTrace();
        }
        finally {
            t.close();
        }
    }
}
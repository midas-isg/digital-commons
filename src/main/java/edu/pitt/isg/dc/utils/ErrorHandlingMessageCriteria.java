package edu.pitt.isg.dc.utils;

import org.springframework.binding.message.Message;
import org.springframework.binding.message.MessageCriteria;

public class ErrorHandlingMessageCriteria implements MessageCriteria {

    private String path;

    public ErrorHandlingMessageCriteria(String path) {
        this.path = path;
    }

    @Override
    public boolean test(Message message) {

        return  ((String) message.getSource()).startsWith(path);

    }
}

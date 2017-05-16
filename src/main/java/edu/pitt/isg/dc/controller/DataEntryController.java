package edu.pitt.isg.dc.controller;

import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.component.DCEmailService;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by TPS23 on 5/10/2017.
 */

@Controller
public class DataEntryController {
    @RequestMapping(value = "/add-entry" , method = RequestMethod.POST)
    public @ResponseBody String addNewEntry(@RequestBody String rawInputString) throws Exception {
        Converter xml2JSONConverter = new Converter();
        String xmlString = java.net.URLDecoder.decode(rawInputString, "UTF-8");
        String jsonString = null;
System.out.println(xmlString);

        try {
            jsonString = xml2JSONConverter.xmlToJson(xmlString);
System.out.println("~~~~~~~~~~~~");
System.out.println(jsonString);
        }
        catch(Exception exception) {
            System.err.println(exception);
        }

        //E-mail to someone it concerns
        DCEmailService emailService = new DCEmailService();
        emailService.mailToAdmin("Digital Commons New Entry Request", jsonString);

        return jsonString;
    }
}

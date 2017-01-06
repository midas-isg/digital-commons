package edu.pitt.isg.dc;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HelloController {
    @RequestMapping(value = "/home", method = RequestMethod.GET)
    public String hello(Model model, @RequestParam(value="name", required=false, defaultValue="World") String name) {

        return "commons";
    }


}

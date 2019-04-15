package edu.pitt.isg.dc.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Interceptor implements HandlerInterceptor {
    public static final String ISG_ADMIN_TOKEN = "ISG_ADMIN";
    public static final String MDC_EDITOR_TOKEN = "MDC_EDITOR";

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse res,
                             Object handler) throws Exception {
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest req, HttpServletResponse res,
                           Object handler, ModelAndView modelAndView) throws Exception {
        HttpSession session = req.getSession();
        try {
            if (ifLoggedIn(session))
                modelAndView.addObject("loggedIn", true);

            if (ifMDCEditor(session))
                modelAndView.addObject("adminType", MDC_EDITOR_TOKEN);

            if (ifISGAdmin(session))
                modelAndView.addObject("adminType", ISG_ADMIN_TOKEN);
        } catch (NullPointerException e) {}
    }

    @Override
    public void afterCompletion(HttpServletRequest req,
                                HttpServletResponse res, Object handler, Exception ex)
            throws Exception {

    }

    public static Boolean ifLoggedIn(HttpSession session) {
        SecurityContext ctx = (SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
        if (ctx != null) {
            Authentication authentication = ctx.getAuthentication();
            session.setAttribute("username", ((User)authentication.getPrincipal()).getUsername());
            return true;
        }

        return false;
    }

    public static Boolean ifMDCEditor(HttpSession session) {
        SecurityContext ctx = (SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
        if (ctx != null) {
            Authentication authentication = ctx.getAuthentication();
            for (GrantedAuthority simpleGrantedAuthority : authentication.getAuthorities()) {
                if (simpleGrantedAuthority.getAuthority().equals("MDC_EDITOR"))
                    return true;
            }
        }
        return false;
    }

    public static Boolean ifISGAdmin(HttpSession session) {
        SecurityContext ctx = (SecurityContext) session.getAttribute("SPRING_SECURITY_CONTEXT");
        if (ctx != null) {
            Authentication authentication = ctx.getAuthentication();
            for (GrantedAuthority simpleGrantedAuthority : authentication.getAuthorities()) {
                if (simpleGrantedAuthority.getAuthority().equals("ISG_ADMIN"))
                    return true;
            }
        }
        return false;
    }
}

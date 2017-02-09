package edu.pitt.isg.dc.config;

/**
 * Created by mas400 on 9/9/15.
 */


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class CacheFilter implements Filter {

    private boolean isPublic;
    private Integer months = 1;

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        if (months > -1) {
            HttpServletRequest req = (HttpServletRequest) request;
//            if(((HttpServletRequest) request).getRequestURI().contains("js") || ((HttpServletRequest) request).getRequestURI().contains("css") ||((HttpServletRequest) request).getRequestURI().contains("ico")) {
//                months = 12;
//                System.out.println(((HttpServletRequest) request).getRequestURI());
//            }
            Calendar c = Calendar.getInstance();
            c.setTime(new Date());
            c.add(Calendar.MONTH, months);

            // HTTP header date format: Thu, 01 Dec 1994 16:00:00 GMT
            String o = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss zzz").format(c.getTime());
            ((HttpServletResponse) response).setHeader("Expires", o);
            if(isPublic == true)
                ((HttpServletResponse) response).setHeader("Cache-Control", "public");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init( FilterConfig filterConfig )
    {
        String expiresAfter = filterConfig.getInitParameter("months");
        isPublic = Boolean.parseBoolean(filterConfig.getInitParameter("public"));
        if ( expiresAfter != null )
        {
            try
            {
                months = Integer.parseInt( expiresAfter );
            }
            catch ( NumberFormatException nfe )
            {
                //badly configured
            }
        }
    }
}
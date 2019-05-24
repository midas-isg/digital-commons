package edu.pitt.isg.dc.validator;

import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DatasetFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        // next handler
        if(!request.getRequestURI().contains("/api/")){
            filterChain.doFilter(new DatasetRequestWrapper(request), response);
        } else filterChain.doFilter(request, response);
    }
}

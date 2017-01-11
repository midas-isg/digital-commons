package edu.pitt.isg.dc.config;

import com.auth0.web.Auth0Config;
import com.auth0.web.Auth0Filter;
import org.springframework.boot.context.embedded.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.annotation.*;

@Configuration
@ComponentScan(basePackages = {"edu.pitt.isg.auth0", "com.auth0"})
@ForceSpringToPickThisComponent
public class Auth0Configuration extends Auth0Config {
    @Bean
    @Override
    public FilterRegistrationBean filterRegistration() {
        return fixAuth0FilterBugNotSupportingContextPath();
    }

    private FilterRegistrationBean fixAuth0FilterBugNotSupportingContextPath() {
        final FilterRegistrationBean registration = super.filterRegistration();
        registration.setFilter(new Auth0FilterSupportingContextPath(this));
        return registration;
    }

    private class Auth0FilterSupportingContextPath extends Auth0Filter {
        private String currentContextPath = "";

        public Auth0FilterSupportingContextPath(final Auth0Config auth0Config) {
            super(auth0Config);
        }

        @Override
        public void doFilter(final ServletRequest request, final ServletResponse response, final FilterChain next)
                throws IOException, ServletException {
            currentContextPath = ((HttpServletRequest) request).getContextPath();
            super.doFilter(request, response, next);
        }

        @Override
        protected void onReject(final HttpServletResponse res) throws IOException, ServletException {
            res.sendRedirect(currentContextPath + getLoginRedirectOnFail());
        }
    }
}

@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited

@Primary
@interface ForceSpringToPickThisComponent {
}

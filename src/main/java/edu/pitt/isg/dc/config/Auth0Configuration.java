package edu.pitt.isg.dc.config;

import com.auth0.spring.security.mvc.Auth0Config;
import org.springframework.boot.autoconfigure.security.SecurityProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity(debug = true)
@EnableGlobalMethodSecurity(prePostEnabled = true)
@Order(SecurityProperties.ACCESS_OVERRIDE_ORDER)
@ComponentScan(basePackages = {"com.auth0"})
@PropertySources({@PropertySource("classpath:auth0.properties")})
public class Auth0Configuration extends Auth0Config {
    @Override
    protected void authorizeRequests(final HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/public/**", "/webjars/**", "/logoutFromAuth0", "/callback").permitAll()
                //.antMatchers("/secured/**").hasAnyAuthority(ISG_USER)
                //.antMatchers("/admin/**").hasAnyAuthority(ISG_ADMIN)
                .antMatchers(securedRoute).authenticated()
                .and()
                .logout()
                .logoutSuccessHandler(logoutSuccessHandler())
                .and()
                .formLogin()
                .loginPage("/login")
                .permitAll();
    }

    private LogoutSuccessHandler logoutSuccessHandler() {
        return new SimpleUrlLogoutSuccessHandler(){
            @Override
            public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
                setDefaultTargetUrl("/logoutFromAuth0");
                super.handle(request, response, authentication);
            }
        };
    }
}

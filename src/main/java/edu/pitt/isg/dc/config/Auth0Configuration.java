package edu.pitt.isg.dc.config;

import com.auth0.Tokens;
import com.auth0.spring.security.mvc.Auth0AuthenticationFilter;
import com.auth0.spring.security.mvc.Auth0Config;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Base64;

@Configuration
@EnableWebSecurity(debug = !true)
@EnableGlobalMethodSecurity(prePostEnabled = true)
@Order(SecurityProperties.ACCESS_OVERRIDE_ORDER)
@ComponentScan(basePackages = {"com.auth0"})
@PropertySources({@PropertySource("classpath:auth0.properties")})
public class Auth0Configuration extends Auth0Config {
    @Override
    protected void authorizeRequests(final HttpSecurity http) throws Exception {
        http.headers()
            .frameOptions().sameOrigin();

        http.authorizeRequests()
                .antMatchers("/public/**", "/webjars/**", "/logoutFromAuth0", "/callback").permitAll()
                //.antMatchers("/secured/**").hasAnyAuthority(ISG_USER)
                //.antMatchers("/admin/**").hasAnyAuthority(ISG_ADMIN)
                .antMatchers(securedRoute).authenticated()
                .antMatchers("/**").permitAll()
                .and()
                    .logout()
                    .logoutSuccessHandler(logoutSuccessHandler())
                .and()
                    .formLogin()
                    .loginPage("/login")
                    .permitAll()
                .and()
                    .addFilterBefore(new FilterAddingRequestUrlIntoSession(), Auth0AuthenticationFilter.class);
    }

    private class FilterAddingRequestUrlIntoSession extends GenericFilterBean {
        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException{
            fillRequestUrlIntoSession((HttpServletRequest) request);

            HttpServletRequest req = (HttpServletRequest) request;
            HttpSession session = req.getSession();
            if(session.getAttribute("tokens") != null) {
                String token = ((Tokens)session.getAttribute("tokens")).getIdToken();

                Base64.Decoder decoder = Base64.getUrlDecoder();
                String[] parts = token.split("\\.");
                String jsonString = new String(decoder.decode(parts[1]));

                try {
                    Object obj = new JSONParser().parse(jsonString);
                    JSONObject jsonObject = (JSONObject) obj;
                    long expire = (long)jsonObject.get("exp");
                    long epoch = (System.currentTimeMillis() / 1000L);

                    if (epoch > expire) {
                        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                        if (auth != null) {
                            new SecurityContextLogoutHandler().logout(req, (HttpServletResponse)response, auth);
                        }
                        SecurityContextHolder.getContext().setAuthentication(null);
                        SecurityContextHolder.clearContext();
                        session.invalidate();
                    }
                } catch (Exception e){}
            }
            chain.doFilter(request, response);
        }

        private void fillRequestUrlIntoSession(HttpServletRequest request) {
            final HttpSession session = request.getSession(true);// true == allow create
            final String parameter = request.getParameter("url");
            String url = request.getRequestURI().substring(request.getContextPath().length()) + "?url=" + parameter;
            if(parameter == null) {
                url = request.getRequestURI().substring(request.getContextPath().length());
            }
           if(!url.contains("login") && !url.contains("auth") && !url.contains("callback") && !url.contains("null"))
                session.setAttribute("requestUrl", url);
            //System.out.println(url);
        }
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

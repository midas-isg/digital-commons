package edu.pitt.isg.dc.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * Created by jdl50 on 6/5/17.
 */
@Configuration
@PropertySource("classpath:application.properties")
public class H2Configuration {

    @Value("${h2.db.driver}")
    public static String DB_DRIVER;

    @Value("${h2.db.url}")
    public static String DB_CONNECTION;

    @Value("${h2.db.user}")
    public static String DB_USER = "";

    @Value("${h2.db.password}")
    public static String DB_PASSWORD = "";


}

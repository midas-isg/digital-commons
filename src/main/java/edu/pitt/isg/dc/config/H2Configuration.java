package edu.pitt.isg.dc.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Properties;

/**
 * Created by jdl50 on 6/5/17.
 */

public class H2Configuration {

    private String dbDriver;
    private  String dbConnection;
    private String dbUser;
    private String dbPassword;

    public H2Configuration() throws IOException {
        Properties p = new Properties();
        p.load(this.getClass().getResourceAsStream("/config.properties"));
        dbDriver = p.getProperty("h2.db.driver");
        dbConnection = p.getProperty("h2.db.url");
        dbUser = p.getProperty("h2.db.user");
        dbPassword = p.getProperty("h2.db.password");
    }

    public String getDbDriver() {
        return dbDriver;
    }

    public void setDbDriver(String dbDriver) {
        this.dbDriver = dbDriver;
    }

    public String getDbConnection() {
        return dbConnection;
    }

    public void setDbConnection(String dbConnection) {
        this.dbConnection = dbConnection;
    }

    public String getDbUser() {
        return dbUser;
    }

    public void setDbUser(String dbUser) {
        this.dbUser = dbUser;
    }

    public String getDbPassword() {
        return dbPassword;
    }

    public void setDbPassword(String dbPassword) {
        this.dbPassword = dbPassword;
    }
}

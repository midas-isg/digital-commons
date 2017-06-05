package edu.pitt.isg.dc.entry.impl;

/**
 * Created by jdl50 on 6/5/17.
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import org.apache.commons.io.FileUtils;
import org.h2.tools.DeleteDbFiles;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// H2 File Database Example shows about storing the database contents into file system.

public class H2Datastore implements MdcEntryDatastoreInterface {

    private static final String DB_DRIVER = "org.h2.Driver";
    private static final String DB_CONNECTION = "jdbc:h2:/Users/amd176/Documents/mdcDB";
    private static final String DB_USER = "";
    private static final String DB_PASSWORD = "";

    static {
        try {
            // delete the H2 database named 'test' in the user home directory
            DeleteDbFiles.execute("/Users/amd176/Documents/", "mdcDB", true);
            insertWithPreparedStatement();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /*public static void main(String[] args) throws Exception {
        try {
            // delete the H2 database named 'test' in the user home directory
            DeleteDbFiles.execute("~", "mdcDB", true);
            insertWithPreparedStatement();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }*/

    private static void insertWithPreparedStatement() throws SQLException {
        PreparedStatement createPreparedStatement = null;
        PreparedStatement insertPreparedStatement = null;
        PreparedStatement selectPreparedStatement = null;

        String CreateQuery1 = "CREATE TABLE ENTRIES(ID int auto_increment primary key, CONTENT CLOB, CLASS VARCHAR)";
        String CreateQuery2 = "CREATE TABLE ENTRY_PROPERTIES(id int primary key, ENTRY_ID int, foreign key (ENTRY_ID) references ENTRIES(ID), PROPERTY_NAME VARCHAR, PROPERTY_VALUE VARCHAR )";


        try (Connection connection = getDBConnection()) {
            connection.setAutoCommit(false);

            createPreparedStatement = connection.prepareStatement(CreateQuery1);
            createPreparedStatement.executeUpdate();
            createPreparedStatement.close();
            createPreparedStatement = connection.prepareStatement(CreateQuery2);
            createPreparedStatement.executeUpdate();
            createPreparedStatement.close();

            connection.commit();
        } catch (SQLException e) {
            System.out.println("Exception Message " + e.getLocalizedMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private static Connection getDBConnection() {
        Connection dbConnection = null;
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        try {
            dbConnection = DriverManager.getConnection(DB_CONNECTION, DB_USER,
                    DB_PASSWORD);
            return dbConnection;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return dbConnection;
    }

    @Override
    public String addEntry(EntryObject entryObject) throws MdcEntryDatastoreException {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(entryObject);
        try (Connection connection = getDBConnection()) {

            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO ENTRIES (CONTENT) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setClob(1, new StringReader(json));
            preparedStatement.executeUpdate();
            ResultSet rs = preparedStatement.getGeneratedKeys();
            if (rs.next()) {
                int newId = rs.getInt(1);
                return String.valueOf(newId);
            }
        } catch (SQLException e) {
            throw new MdcEntryDatastoreException(e);
        }
        return "error";
    }

    @Override
    public EntryObject getEntry(String id) {
        try {
            try (Connection connection = getDBConnection()) {
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT CONTENT FROM ENTRIES WHERE ID = ?");
                preparedStatement.setInt(1, Integer.valueOf(id));
                ResultSet rs = preparedStatement.executeQuery();
                if (rs.next()) {
                    Clob content = rs.getClob(1);
                    Gson gson = new Gson();
                    return gson.fromJson(content.getCharacterStream(), EntryObject.class);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    @Override
    public List<String> getEntryIds() {
        List<String> list = new ArrayList<>();
        try {
            try (Connection connection = getDBConnection()) {
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT ID FROM ENTRIES");
                ResultSet rs = preparedStatement.executeQuery();
                while (rs.next()) {
                    list.add(rs.getString(1));
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());

        }
        return list;
    }

    @Override
    public String editEntry(String id, EntryObject entryObject) throws MdcEntryDatastoreException {
        return null;
    }

    @Override
    public String deleteEntry(String id) throws MdcEntryDatastoreException {
        return null;
    }

    @Override
    public boolean setEntryProperty(String id, String key, String value) {
        return false;
    }

    @Override
    public String getEntryProperty(String id, String key) {
        return null;
    }

    @Override
    public void dump() {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        List<String> ids = this.getEntryIds();
        for(String id : ids) {
            EntryObject entryObject = (EntryObject) this.getEntry(id);
            JsonElement jsonElement = gson.toJsonTree(entryObject.getEntry());
            String json = gson.toJson(jsonElement);

            String filepath = entryObject.getId();
            File file = Paths.get(filepath).toFile();
            try {
                FileUtils.writeStringToFile(file, json, "UTF-8");
            } catch(IOException e) {
                e.printStackTrace();
            }
        }
    }
}
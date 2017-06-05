package edu.pitt.isg.dc.entry.impl;

/**
 * Created by jdl50 on 6/5/17.
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import edu.pitt.isg.dc.config.H2Configuration;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.MdcEntryDatastoreInterface;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
public class H2Datastore implements MdcEntryDatastoreInterface {


    private H2Configuration h2Configuration;


    public H2Datastore() {
        try {
            h2Configuration = new H2Configuration();
            createDatabase();
        } catch (Exception e) {
            new MdcEntryDatastoreException(e.getMessage());
        }
        /*this.wipeDatabaseIfExists = wipeDatabaseIfExists;
        if (wipeDatabaseIfExists) {
            //jdbc:h2:/Users/jdl50/mdcDB
            String path = h2Configuration.DB_CONNECTION.substring(h2Configuration.DB_CONNECTION.lastIndexOf(":")+1);
            int idx = path.lastIndexOf("/");
            if (idx == -1)
                idx = path.lastIndexOf("\\");

            String name = path.substring(idx+1);
            path = path.substring(0, idx+1);
            DeleteDbFiles.execute(path, name, true);
            try {
                createDatabase();
            } catch (SQLException e) {
                new MdcEntryDatastoreException(e.getMessage());
            }
        }*/
    }

    private Connection getDBConnection() {
        Connection dbConnection = null;
        try {
            Class.forName(h2Configuration.getDbDriver());
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        try {
            dbConnection = DriverManager.getConnection(h2Configuration.getDbConnection(), h2Configuration.getDbUser(),
                    h2Configuration.getDbPassword());
            return dbConnection;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return dbConnection;
    }

    private void createDatabase() throws SQLException {
        PreparedStatement createPreparedStatement = null;

        String createEntries = "CREATE TABLE IF NOT EXISTS ENTRIES(ID int auto_increment primary key, CONTENT CLOB, STATUS VARCHAR)";

        try (Connection connection = getDBConnection()) {
            connection.setAutoCommit(false);

            createPreparedStatement = connection.prepareStatement(createEntries);
            createPreparedStatement.executeUpdate();
            createPreparedStatement.close();
            connection.commit();
        } catch (SQLException e) {
            System.out.println("Exception Message " + e.getLocalizedMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String addEntry(EntryObject entryObject) throws MdcEntryDatastoreException {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(entryObject);
        try (Connection connection = getDBConnection()) {

            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO ENTRIES (CONTENT, STATUS) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setClob(1, new StringReader(json));
            preparedStatement.setString(2, entryObject.getProperty("status"));
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
    public String editEntry(String id, EntryObject entryObject) throws MdcEntryDatastoreException {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(entryObject);
        try (Connection connection = getDBConnection()) {
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE ENTRIES SET CONTENT = ?, STATUS = ? WHERE ID = ?");
            preparedStatement.setClob(1, new StringReader(json));
            preparedStatement.setString(2, entryObject.getProperty("status"));
            preparedStatement.setString(3, id);

            preparedStatement.executeUpdate();
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
    public List<String> getPendingEntryIds() throws MdcEntryDatastoreException {
        List<String> list = new ArrayList<>();
        try {
            try (Connection connection = getDBConnection()) {
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT ID FROM ENTRIES WHERE STATUS = ?");
                preparedStatement.setString(1, "pending");
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
    public String deleteEntry(String id) throws MdcEntryDatastoreException {
        return null;
    }

    @Override
    public void exportDatastore(MdcDatastoreFormat mdcDatastoreFormat) throws MdcEntryDatastoreException {
        switch (mdcDatastoreFormat) {
            case MDC_DATA_DIRECTORY_FORMAT:
                Gson gson = new GsonBuilder().setPrettyPrinting().create();
                List<String> ids = this.getEntryIds();
                for (String id : ids) {
                    EntryObject entryObject = this.getEntry(id);
                    JsonElement jsonElement = gson.toJsonTree(entryObject.getEntry());
                    String json = gson.toJson(jsonElement);

                    String filepath = entryObject.getId();
                    File file = Paths.get(filepath).toFile();
                    try {
                        FileUtils.writeStringToFile(file, json, "UTF-8");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            default:
                throw new MdcEntryDatastoreException("Unsupported mdcDatastoreFormat" + mdcDatastoreFormat);
        }

    }
}
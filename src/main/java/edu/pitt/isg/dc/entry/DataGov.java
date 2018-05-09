package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import edu.pitt.isg.CkanToDatsConverter;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.DataGovGeneralException;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import eu.trentorise.opendata.jackan.CkanClient;
import eu.trentorise.opendata.jackan.model.CkanDataset;
import org.springframework.beans.factory.annotation.Autowired;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.stereotype.Service;


/**
 * Created by jbs82 on 5/1/2018.
 */
@Service
public class DataGov implements DataGovInterface {
    @Autowired
    private EntryRepository repo;
    @Autowired
    private EntrySubmissionInterface entrySubmissionInterface;
    @Autowired
    private UsersSubmissionInterface usersSubmissionInterface;

    private static final String CKAN_DATE_CREATED = "CKAN metadata_created";
    private static final String CKAN_DATE_MODIFIED = "CKAN metadata_modified";
    private static final String CKAN_DATE_REVISIONID = "CKAN revision_id";
    private static final String SDF_PATTERN = "yyyy-MM-dd";
    private static final String DATASET_SET = "edu.pitt.isg.mdc.dats2_2.Dataset";
    private static String ENTRIES_AUTHENTICATION = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        ENTRIES_AUTHENTICATION = configurationProperties.getProperty(DigitalCommonsProperties.ENTRIES_AUTHENTICATION);
    }


    @Override
    public String searchForTag(String tagId) {
        return null;
    }

    @Override
    public CkanDataset getDatasetFromClient(String catalogURL, String dataGovIdentifier) {
        CkanClient ckanClient = new CkanClient(catalogURL);
        CkanDataset dataset = ckanClient.getDataset(dataGovIdentifier);
        return dataset;
    }

    @Override
    public String getIdentifierFromPackage(DatasetWithOrganization dataGovPackage) {
        return dataGovPackage.getIdentifier().getIdentifier();
    }

    @Override
    public Boolean identifierExistsInMDC(String identifier) {
        Boolean doesIdentifierExist = false;
        if (!identifier.isEmpty()) {
            List<String> identifiersList = repo.getAllIdentifiers();
            if (identifiersList.contains(identifier)) {
                doesIdentifierExist = true;
            }
        }
        return doesIdentifierExist;
    }

    @Override
    public String getidentifierStatus(String identifier) {
        return repo.getStatusForIdentifier(identifier);
    }

    @Override
    public Entry getEntryFromMDC(String identifier) {
        return repo.findByMetadataIdentifierIncludeNotPublic(identifier);
    }

    @Override
    public Long getEntryId(Entry entry) {
        EntryId entryId = entry.getId();
        return entryId.getEntryId();
    }

    @Override
    public Long getRevisionId(Entry entry) {
        EntryId entryId = entry.getId();
        return entryId.getRevisionId();
    }

    @Override
    public Long getCategoryId(Entry entry) {
        Category category = entry.getCategory();
        return category.getId();
    }

    @Override
    public Date getlastModifiedDataGov(DatasetWithOrganization dataGovPackage) throws DataGovGeneralException {
        SimpleDateFormat sdf = new SimpleDateFormat(SDF_PATTERN);
        Date dateCreated = new Date();
        Date dateModified = new Date();
        try {
            dateCreated = sdf.parse("2000-01-01");
            dateModified = sdf.parse("2000-01-01");

            for (CategoryValuePair categoryValuePair : dataGovPackage.getExtraProperties()) {
                if (categoryValuePair.getCategory().equalsIgnoreCase(CKAN_DATE_CREATED)) {
                    for (Annotation annotation : categoryValuePair.getValues()) {
                        String strCreationDate = annotation.getValue();
                        dateCreated = sdf.parse(strCreationDate);
                    } // for
                } // if

                if (categoryValuePair.getCategory().equalsIgnoreCase(CKAN_DATE_MODIFIED)) {
                    for (Annotation annotation : categoryValuePair.getValues()) {
                        String strModifiedDate = annotation.getValue();
                        dateModified = sdf.parse(strModifiedDate);
                    } // for
                } // if
            } // for
        } catch (ParseException e) {
            e.printStackTrace();
            throw new DataGovGeneralException("There was an error..." + e.getMessage());
        }

        if (dateModified.after(dateCreated)) {
            return dateModified;
        } else return dateCreated;
    }

    @Override
    public Date getlastModifiedEntry(Entry entry) throws DataGovGeneralException {
        SimpleDateFormat sdf = new SimpleDateFormat(SDF_PATTERN);
        Date date = new Date();
        Date creationDate = new Date();
        Date modifiedDate = new Date();
        try {
            date = sdf.parse("2000-01-01"); //default to super old date -- only used if date doesn't exist in entry
            creationDate = sdf.parse("2000-01-01"); //default to super old date -- only used if date doesn't exist in entry
            modifiedDate = sdf.parse("2000-01-01"); //default to super old date -- only used if date doesn't exist in entry

            if (((Map)entry.getContent().get("entry")).containsKey("extraProperties")) {
                Map entryMap = (Map) entry.getContent().get("entry");
                List<Map> extraPropertiesList = (List<Map>) entryMap.get("extraProperties");
                for (Map extraPropertiesMap : extraPropertiesList) {
                    if (extraPropertiesMap.containsKey("category")) {
                        String category = extraPropertiesMap.get("category").toString();
                        if (!category.equalsIgnoreCase(CKAN_DATE_REVISIONID) && extraPropertiesMap.containsKey("values")) {
                            List<Map> valuesList = (List<Map>) extraPropertiesMap.get("values");
                            for (Map value : valuesList) {
                                if (value.containsKey("value")) {
                                    date = sdf.parse(value.get("value").toString());
                                } // if
                            } // for
                        } // if

                        if (category.equalsIgnoreCase(CKAN_DATE_CREATED)) {
                            creationDate = date;
                        }
                        if (category.equalsIgnoreCase(CKAN_DATE_MODIFIED)) {
                            modifiedDate = date;
                        }

                    } // if
                } // for
            }
        } catch (ParseException e) {
            e.printStackTrace();
            throw new DataGovGeneralException("There was an error..." + e.getMessage());
        }


        if (modifiedDate.after(creationDate)) {
            return modifiedDate;
        } else return creationDate;
    }

    @Override
    public String getRevisionIdFromDataGovPackage(DatasetWithOrganization dataGovPackage){
        String revisionId = "";

        for (CategoryValuePair categoryValuePair : dataGovPackage.getExtraProperties()) {
            if (categoryValuePair.getCategory().equalsIgnoreCase(CKAN_DATE_REVISIONID)) {
                for (Annotation annotation : categoryValuePair.getValues()) {
                    revisionId = annotation.getValue();
                } // for
            } // if
        } // for

        return revisionId;
    }

    @Override
    public String getRevisionIdFromEntry(Entry entry) {
        String revisionId = "";

        if (((Map)entry.getContent().get("entry")).containsKey("extraProperties")) {
            Map entryMap = (Map) entry.getContent().get("entry");
            List<Map> extraPropertiesList = (List<Map>) entryMap.get("extraProperties");
            for (Map extraPropertiesMap : extraPropertiesList) {
                if (extraPropertiesMap.containsKey("category")) {
                    String category = extraPropertiesMap.get("category").toString();
                    if (category.equalsIgnoreCase(CKAN_DATE_REVISIONID) && extraPropertiesMap.containsKey("values")) {
                        List<Map> valuesList = (List<Map>) extraPropertiesMap.get("values");
                        for (Map value : valuesList) {
                            if (value.containsKey("value")) {
                                revisionId = value.get("value").toString();
                            } // if
                        } // for
                    } // if
                } // if
            } // for
        }

        return revisionId;
    }


    @Override
    public Boolean modifiedDataGovPackage(Entry entry, DatasetWithOrganization dataGovPackage) throws DataGovGeneralException{
        Boolean hasBeenModified = false;
        if (!getRevisionIdFromDataGovPackage(dataGovPackage).equalsIgnoreCase(getRevisionIdFromEntry(entry))) {
            hasBeenModified = true;
        }
        if (!hasBeenModified && getlastModifiedDataGov(dataGovPackage).after(getlastModifiedEntry(entry))) {
            hasBeenModified = true;
        }

        return hasBeenModified;
    }

    @Override
    public JsonObject datasetToJSonObject(DatasetWithOrganization dataGovPackage) {
        JsonObject entry = null;
        Converter converter = new Converter();
        entry = converter.datasetWithOrganizationToJSonObject(dataGovPackage);
        return entry;
    }

    @Override
    public String submitDataGovEntry(Users user, String catalogURL, Long categoryId, String dataGovIdentifier, String title) throws DataGovGeneralException{
        EntryView entryObject = new EntryView();
        JsonObject entry = null;
        Entry entryFromMDC;
        Long category = null;
        Long entryId = null;
        Long revisionId = null;
        Boolean addOrUpdateEntry = false;
        String message = "";

        CkanDataset dataset = getDatasetFromClient(catalogURL, dataGovIdentifier);
        CkanToDatsConverter.ConverterResult result = new CkanToDatsConverter().convertCkanToDats(dataset, catalogURL);
        DatasetWithOrganization dataGovPackage = (DatasetWithOrganization)result.getDataset();

        if(!title.isEmpty()){
            dataGovPackage.setTitle(title);
        }

        String identifier = getIdentifierFromPackage(dataGovPackage);
        List<String> logMessagesList = result.getDiseaseLookupLogMessages();

        String logmessages = ""; //this needs updated to get log messages from array

        if (identifierExistsInMDC(identifier)) {
            String status = getidentifierStatus(identifier);
            if (status.equals("pending") || status.equals("approved")) {
                entryFromMDC = getEntryFromMDC(identifier);
                if (modifiedDataGovPackage(entryFromMDC, dataGovPackage)) {
                    addOrUpdateEntry = true;
                    category = getCategoryId(entryFromMDC);
                    entryId = getEntryId(entryFromMDC);
                    revisionId = getRevisionId(entryFromMDC);
                } else {
                    addOrUpdateEntry = false; // entry has not been updated by data.gov since last check
                    message = "This identifier has not been updated since last check";
                }
            } else {
                addOrUpdateEntry = false;  // entry has previously been rejected
                message = "This identifier has previously been rejected";
            }
        } else addOrUpdateEntry = true; // entry is new

        if (addOrUpdateEntry) {
            if (category == null) {
                category = categoryId; //191L = Root: Data: Disease surveillance data: Americas: (United States of America)
            }

            //Serialize or Marshall Java to JSON
            entry = datasetToJSonObject(dataGovPackage);

            entryObject.setProperty("type", "edu.pitt.isg.mdc.dats2_2.DatasetWithOrganization");

            entry.remove("class");
            entryObject.setEntry(entry);

            try {
                //Users user = usersSubmissionInterface.submitUser("auth0|5aa0446e88eaf04ed4039052", "jbs82@pitt.edu", "jbs82@pitt.edu");
                entrySubmissionInterface.submitEntry(entryObject, entryId, revisionId, category, user, ENTRIES_AUTHENTICATION);
                message = "This record has been inserted into the MDC<br><br>";
            } catch (MdcEntryDatastoreException e) {
                System.out.println(e.toString());
                message = "There was an error inserting the record";
            }


        } else return message;

        if(logMessagesList != null){
            for(String line : logMessagesList){
                logmessages += "\t" + line + "<br>";
            }
        }

        return message + "Log messages = " + "<br>"  + logmessages;
    }


}

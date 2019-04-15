package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.WebApplication;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.exceptions.DataGovGeneralException;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import eu.trentorise.opendata.jackan.CkanClient;
import eu.trentorise.opendata.jackan.model.CkanDataset;
import edu.pitt.isg.CkanToDatsConverter;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.text.SimpleDateFormat;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;

/**
 * Created by jbs82 on 5/1/2018.
 */
@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class DataGovTest {
    @Autowired
    private EntryService repo;
    @Autowired
    private EntrySubmissionInterface entrySubmissionInterface;
    @Autowired
    private UsersSubmissionInterface usersSubmissionInterface;
    @Autowired
    private DataGovInterface dg;

    @Test
    public void getEntryRevisionCategoryId(){
        String identifier = "MIDAS-ISG:epidemiological-bulletin-national-system-of-epidemiological-surveillance-system-v1.0";
        Entry entryFromMDC = dg.getEntryFromMDC(identifier);

        Long entryId = 1102L;
        Long revisionId = 5L;
        Long categoryId = 4L;
        assertEquals(entryId, dg.getEntryId(entryFromMDC));
        assertEquals(revisionId,dg.getRevisionId(entryFromMDC));
        assertEquals(categoryId,dg.getCategoryId(entryFromMDC));
    }


    @Test
    public void lastModifiedDataGov(){
        String catalogURL = "http://catalog.data.gov/";
        CkanClient ckanClient = new CkanClient(catalogURL);
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        //System.out.println(dataset.getNotes());
        //Dataset dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");
        CkanToDatsConverter.ConverterResult result = new CkanToDatsConverter().convertCkanToDats(dataset, catalogURL);
        Dataset dataGovPackage = (Dataset) result.getDataset();


        DataGov dg = new DataGov();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            assertEquals("2018-04-05",sdf.format(dg.getlastModifiedDataGov(dataGovPackage)));
        } catch (DataGovGeneralException e){
            e.printStackTrace();
            e.getMessage();
            assertTrue(false);
        }
    }

    @Test
    public void lastModifiedEntry(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        Entry entryFromMDC = dg.getEntryFromMDC(identifier);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            assertEquals("2018-04-05",sdf.format(dg.getlastModifiedEntry(entryFromMDC)));
        } catch (DataGovGeneralException e){
            e.printStackTrace();
            e.getMessage();
            assertTrue(false);
        }
    }

    @Test
    public void getRevisionIdFromDataGovPackageTest(){
        String catalogURL = "http://catalog.data.gov/";
        CkanClient ckanClient = new CkanClient(catalogURL);
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        //Dataset dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");
        CkanToDatsConverter.ConverterResult result = new CkanToDatsConverter().convertCkanToDats(dataset, catalogURL);
        Dataset dataGovPackage = (Dataset)result.getDataset();

        assertEquals("e60ad9ce-4333-43bd-bcbf-3b58d5767d77",dg.getRevisionIdFromDataGovPackage(dataGovPackage));
    }

    @Test
    public void getRevisionIdFromEntryTest(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        Entry entryFromMDC = dg.getEntryFromMDC(identifier);

        assertEquals("e60ad9ce-4333-43bd-bcbf-3b58d5767d77", dg.getRevisionIdFromEntry(entryFromMDC));
    }


    @Test
    public void getIdentifierFromPackageTest(){
        String catalogURL = "http://catalog.data.gov/";
        CkanClient ckanClient = new CkanClient(catalogURL);
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        //CkanDataset dataset = ckanClient.getDataset("dfedaac8-8ede-4c1a-a988-17c230fe63ac");
        //CkanDataset dataset = ckanClient.getDataset("75b2f0dc-ed03-454a-b02d-951da90c91c1");
        System.out.println(dataset.getNotes());
        //Dataset dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");
        CkanToDatsConverter.ConverterResult result = new CkanToDatsConverter().convertCkanToDats(dataset, catalogURL);
        Dataset dataGovPackage = (Dataset)result.getDataset();

        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";

        assertEquals(identifier, dg.getIdentifierFromPackage(dataGovPackage));
    }

    @Test
    public void identifierExistsInMDCTest(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        assertTrue(dg.identifierExistsInMDC(identifier));
    }

    @Test
    public void getIdentifierStatusTest(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        assertEquals("pending", dg.getidentifierStatus(identifier));

        identifier = "10.25337/T7/ptycho.v2.0/US.409498004";
        assertEquals("approved", dg.getidentifierStatus(identifier));
    }

    @Test
    public void modifiedDataGovPackageTest(){
        String catalogURL = "http://catalog.data.gov/";
        CkanClient ckanClient = new CkanClient(catalogURL);
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        System.out.println(dataset.getNotes());
        //Dataset dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");
        CkanToDatsConverter.ConverterResult result = new CkanToDatsConverter().convertCkanToDats(dataset, catalogURL);
        Dataset dataGovPackage = (Dataset)result.getDataset();

        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        Entry entryFromMDC = dg.getEntryFromMDC(identifier);
        try {
            assertFalse(dg.modifiedDataGovPackage(entryFromMDC, dataGovPackage));
        } catch (DataGovGeneralException e){
            e.printStackTrace();
            e.getMessage();
            assertTrue(false);
        }
    }

//    @Test
//    public void submitDataGovEntryTest(){
//        String catalogURL = "http://catalog.data.gov/";
//        Long categoryId = 191L;
//        String identifier = "02b5e413-d746-43ee-bd52-eac4e33ecb41";
//        String title = "NNDSS - Table I. infrequently reported notifiable diseases (2017)";
//        String result = "";
//        Users user = null;
//        try {
//            user = usersSubmissionInterface.submitUser("auth0|5aa0446e88eaf04ed4039052", "jbs82@pitt.edu", "jbs82@pitt.edu");
//        } catch (MdcEntryDatastoreException e) {
//            e.printStackTrace();
//            e.getMessage();
//            assertTrue(false);
//        }
//
//        try {
//            result = dg.submitDataGovEntry(user, catalogURL, categoryId, identifier, title);
//        } catch (DataGovGeneralException e){
//            e.printStackTrace();
//            e.getMessage();
//        }
//        assertEquals("Success", result);
//
//    }

}

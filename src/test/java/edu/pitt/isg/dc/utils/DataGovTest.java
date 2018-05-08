package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.WebApplication;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.exceptions.DataGovGeneralException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.mdc.dats2_2.DatasetWithOrganization;
import eu.trentorise.opendata.jackan.CkanClient;
import eu.trentorise.opendata.jackan.model.CkanDataset;
import edu.pitt.isg.CkanToDatsConverter;
import org.junit.Test;
import edu.pitt.isg.dc.entry.DataGov;
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
    private EntryRepository repo;
    @Autowired
    private EntrySubmissionInterface entrySubmissionInterface;
    @Autowired
    private UsersSubmissionInterface usersSubmissionInterface;

    @Test
    public void getEntryRevisionCategoryId(){
        String identifier = "MIDAS-ISG:epidemiological-bulletin-national-system-of-epidemiological-surveillance-system-v1.0";
        DataGov dg = new DataGov();
        Entry entryFromMDC = dg.getEntryFromMDC(identifier, repo);

        Long entryId = 1102L;
        Long revisionId = 5L;
        Long categoryId = 4L;
        assertEquals(entryId, dg.getEntryId(entryFromMDC));
        assertEquals(revisionId,dg.getRevisionId(entryFromMDC));
        assertEquals(categoryId,dg.getCategoryId(entryFromMDC));
    }

    @Test
    public void lastModifiedDataGov(){
        CkanClient ckanClient = new CkanClient("http://catalog.data.gov/");
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        //System.out.println(dataset.getNotes());
        DatasetWithOrganization dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");

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
        DataGov dg = new DataGov();
        Entry entryFromMDC = dg.getEntryFromMDC(identifier, repo);
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
        CkanClient ckanClient = new CkanClient("http://catalog.data.gov/");
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        //System.out.println(dataset.getNotes());
        DatasetWithOrganization dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");

        DataGov dg = new DataGov();
        assertEquals("e60ad9ce-4333-43bd-bcbf-3b58d5767d77",dg.getRevisionIdFromDataGovPackage(dataGovPackage));
    }

    @Test
    public void getRevisionIdFromEntryTest(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        DataGov dg = new DataGov();
        Entry entryFromMDC = dg.getEntryFromMDC(identifier, repo);

        assertEquals("e60ad9ce-4333-43bd-bcbf-3b58d5767d77", dg.getRevisionIdFromEntry(entryFromMDC));
    }


    @Test
    public void getIdentifierFromPackageTest(){
        CkanClient ckanClient = new CkanClient("http://catalog.data.gov/");
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        System.out.println(dataset.getNotes());
        DatasetWithOrganization dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");

        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";

        DataGov dg = new DataGov();
        assertEquals(identifier, dg.getIdentifierFromPackage(dataGovPackage));
    }

    @Test
    public void identifierExistsInMDCTest(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        DataGov dg = new DataGov();
        assertTrue(dg.identifierExistsInMDC(identifier, repo));
    }

    @Test
    public void getIdentifierStatusTest(){
        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        DataGov dg = new DataGov();
        assertEquals("pending", dg.getidentifierStatus(identifier, repo));

        identifier = "10.25337/T7/ptycho.v2.0/US.409498004";
        assertEquals("approved", dg.getidentifierStatus(identifier, repo));
    }

    @Test
    public void modifiedDataGovPackageTest(){
        CkanClient ckanClient = new CkanClient("http://catalog.data.gov/");
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        System.out.println(dataset.getNotes());
        DatasetWithOrganization dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");

        String identifier = "https://data.cdc.gov/api/views/pb4z-432k";
        DataGov dg = new DataGov();
        Entry entryFromMDC = dg.getEntryFromMDC(identifier, repo);
        try {
            assertFalse(dg.modifiedDataGovPackage(entryFromMDC, dataGovPackage));
        } catch (DataGovGeneralException e){
            e.printStackTrace();
            e.getMessage();
            assertTrue(false);
        }
    }

    @Test
    public void submitDataGovEntryTest(){
        CkanClient ckanClient = new CkanClient("http://catalog.data.gov/");
        CkanDataset dataset = ckanClient.getDataset("02b5e413-d746-43ee-bd52-eac4e33ecb41");
        System.out.println(dataset.getNotes());
        DatasetWithOrganization dataGovPackage = CkanToDatsConverter.convertCkanToDats(dataset, "http://catalog.data.gov/");
        String result = "";
        DataGov dg = new DataGov();
        try {
            result = dg.submitDataGovEntry(dataGovPackage, repo, entrySubmissionInterface, usersSubmissionInterface);
        } catch (DataGovGeneralException e){
            e.printStackTrace();
            e.getMessage();
        }
        assertEquals("Success", result);

    }
}

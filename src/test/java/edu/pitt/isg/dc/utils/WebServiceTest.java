package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.WebApplication;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openarchives.oai._2.*;
import org.openarchives.oai._2_0.oai_dc.OaiDcType;
import org.purl.dc.elements._1.ElementType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.ui.ModelMap;

import javax.xml.bind.JAXBElement;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by jdl50 on 4/23/18.
 */
//@RunWith(SpringJUnit4ClassRunner.class)
@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class WebServiceTest {
    //static WebService ws = new WebService();
    private static Jaxb2Marshaller marshaller;

    @Autowired
    private WebService ws;

    @BeforeClass
    public static void setup() {
        //ws.setupApiUtilForTesting();

        marshaller = new Jaxb2Marshaller();
        marshaller.setClassesToBeBound(new Class[]{
                //all the classes the context needs to know about
                org.openarchives.oai._2.ObjectFactory.class,
                org.openarchives.oai._2_0.oai_dc.ObjectFactory.class,
                org.purl.dc.elements._1.ObjectFactory.class,
        }); //"alternatively" setContextPath(<jaxb.context>),


        marshaller.setMarshallerProperties(new HashMap<String, Object>() {{
            put(javax.xml.bind.Marshaller.JAXB_FORMATTED_OUTPUT, true);
        }});
    }

    private OAIPMHtype getOAIPMHtypeFromBody(ResponseEntity responseEntity) {
        JAXBElement<OAIPMHtype> oaipmHtypeJAXBElement = (JAXBElement<OAIPMHtype>) unmarshal(responseEntity.getBody().toString());
        return oaipmHtypeJAXBElement.getValue();

    }

    private OaiDcType getOaiDcTypeFromBody(Object object) {
        JAXBElement<OaiDcType> oaiDcTypeJAXBElement = (JAXBElement<OaiDcType>) object;
        return oaiDcTypeJAXBElement.getValue();

    }

    private JAXBElement<?> unmarshal(String xml) {
        InputStream stream = new ByteArrayInputStream(xml.getBytes());
        return (JAXBElement<?>) marshaller.unmarshal(new StreamSource(stream));
    }

    @Test
    public void testGetRecordForIdentifier1() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordForIdentifierWebService(model, "10.25337/T7/ptycho.v2.0/AG.722862003","oai_dc");
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        GetRecordType getRecordType = oaipmhType.getGetRecord();

        //Test Dublin Core elements
        OaiDcType oaiDcType = getOaiDcTypeFromBody(getRecordType.getRecord().getMetadata().getAny());

        JAXBElement<ElementType> elementTypeTitle = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(0));
        assertTrue(elementTypeTitle.getName().getLocalPart().equals("title"));
        assertEquals("Counts of Dengue without warning signs reported in ANTIGUA AND BARBUDA: 1960-2005", elementTypeTitle.getValue().getValue());
        JAXBElement<ElementType> elementTypeIdentifier = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(1));
        assertTrue(elementTypeIdentifier.getName().getLocalPart().equals("identifier"));
        assertEquals("10.25337/T7/ptycho.v2.0/AG.722862003", elementTypeIdentifier.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(3));
        assertTrue(elementTypeSubject.getName().getLocalPart().equals("subject"));
        assertEquals("Dengue without warning signs", elementTypeSubject.getValue().getValue());
        JAXBElement<ElementType> elementTypeCreator1 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(4));
        assertTrue(elementTypeCreator1.getName().getLocalPart().equals("creator"));
        assertEquals("Willem G Van Panhuis", elementTypeCreator1.getValue().getValue());
        JAXBElement<ElementType> elementTypeCreator2 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(5));
        assertTrue(elementTypeCreator2.getName().getLocalPart().equals("creator"));
        assertEquals("Anne L Cross", elementTypeCreator2.getValue().getValue());
        JAXBElement<ElementType> elementTypeCreator3 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(6));
        assertTrue(elementTypeCreator3.getName().getLocalPart().equals("creator"));
        assertEquals("Donald S Burke", elementTypeCreator3.getValue().getValue());
        JAXBElement<ElementType> elementTypePublisher = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(7));
        assertTrue(elementTypePublisher.getName().getLocalPart().equals("publisher"));
        assertEquals("Project Tycho", elementTypePublisher.getValue().getValue());
        JAXBElement<ElementType> elementTypeCoverage = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(9));
        assertTrue(elementTypeCoverage.getName().getLocalPart().equals("coverage"));
        assertEquals("ANTIGUA AND BARBUDA", elementTypeCoverage.getValue().getValue());
        JAXBElement<ElementType> elementTypeFormat = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(10));
        assertTrue(elementTypeFormat.getName().getLocalPart().equals("format"));
        assertEquals("CSV", elementTypeFormat.getValue().getValue());

        assertEquals("10.25337/T7/ptycho.v2.0/AG.722862003", getRecordType.getRecord().getHeader().getIdentifier());
        assertEquals("[Root: Data: Disease surveillance data: Americas: Antigua and Barbuda: ([Project Tycho Datasets])]", getRecordType.getRecord().getHeader().getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetRecordForIdentifier2() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordForIdentifierWebService(model, "http://www.epimodels.org/drupal/?q=node/81","oai_dc");
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        GetRecordType getRecordType = oaipmhType.getGetRecord();

        //Test Dublin Core elements
        OaiDcType oaiDcType = getOaiDcTypeFromBody(getRecordType.getRecord().getMetadata().getAny());

        JAXBElement<ElementType> elementTypeTitle = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(0));
        assertTrue(elementTypeTitle.getName().getLocalPart().equals("title"));
        assertEquals("2010 U.S. Synthetic Populations by County", elementTypeTitle.getValue().getValue());
        JAXBElement<ElementType> elementTypeIdentifier = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(1));
        assertTrue(elementTypeIdentifier.getName().getLocalPart().equals("identifier"));
        assertEquals("http://www.epimodels.org/drupal/?q=node/81", elementTypeIdentifier.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject1 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(3));
        assertTrue(elementTypeSubject1.getName().getLocalPart().equals("subject"));
        assertEquals("Individual", elementTypeSubject1.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject2 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(4));
        assertTrue(elementTypeSubject2.getName().getLocalPart().equals("subject"));
        assertEquals("Homo sapiens", elementTypeSubject2.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject3 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(5));
        assertTrue(elementTypeSubject3 .getName().getLocalPart().equals("subject"));
        assertEquals("Household", elementTypeSubject3.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject4 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(6));
        assertTrue(elementTypeSubject4.getName().getLocalPart().equals("subject"));
        assertEquals("Group quarters", elementTypeSubject4.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject5 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(7));
        assertTrue(elementTypeSubject5.getName().getLocalPart().equals("subject"));
        assertEquals("Schools", elementTypeSubject5.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject6 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(8));
        assertTrue(elementTypeSubject6.getName().getLocalPart().equals("subject"));
        assertEquals("Workplace facility", elementTypeSubject6.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject7 = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(9));
        assertTrue(elementTypeSubject7.getName().getLocalPart().equals("subject"));
        assertEquals("United States of America", elementTypeSubject7.getValue().getValue());
        JAXBElement<ElementType> elementTypeCreator = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(10));
        assertTrue(elementTypeCreator.getName().getLocalPart().equals("creator"));
        assertEquals("William Wheaton", elementTypeCreator.getValue().getValue());
        JAXBElement<ElementType> elementTypeCoverage = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(11));
        assertTrue(elementTypeCoverage.getName().getLocalPart().equals("coverage"));
        assertEquals("United States of America", elementTypeCoverage.getValue().getValue());

        assertEquals("http://www.epimodels.org/drupal/?q=node/81", getRecordType.getRecord().getHeader().getIdentifier());
        assertEquals("[Root: Data: Synthetic populations and ecosystems: (Synthia datasets)]", getRecordType.getRecord().getHeader().getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetIdentityInfo() {
        ResponseEntity responseEntity = ws.getIdentifyInfo();
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        IdentifyType identifyType = oaipmhType.getIdentify();

        assertEquals("isg-feedback@list.pitt.edu", identifyType.getAdminEmail().get(0));
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetIdentifiers() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getIdentifiersWebService(model, null, null , "oai_dc", null, null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        MetadataFormatType metadataFormatType = oaipmhType.getListMetadataFormats().getMetadataFormat().get(0);
        assertEquals("oai_dc", metadataFormatType.getMetadataPrefix());
        assertEquals("http://www.openarchives.org/OAI/2.0/oai_dc/", metadataFormatType.getSchema());
        assertEquals("http://www.openarchives.org/OAI/2.0/oai_dc.xsd", metadataFormatType.getMetadataNamespace());

        ListIdentifiersType listIdentifiersType = oaipmhType.getListIdentifiers();
        assertTrue(listIdentifiersType.getHeader().size() > 550);
        assertEquals("10.25337/T7/ptycho.v2.0/MH.20927009",listIdentifiersType.getHeader().get(0).getIdentifier());
        assertEquals("[Root: Data: Disease surveillance data: Oceania: Marshall Islands: ([Project Tycho Datasets])]",listIdentifiersType.getHeader().get(0).getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetIdentifiersWithDateAndSet() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getIdentifiersWebService(model, "2018-03-01T12:00:00", "2018-03-30T12:00:00","oai_dc" , "Root: Software: (Data visualizers)", null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        ListIdentifiersType listIdentifiersType = oaipmhType.getListIdentifiers();
        assertTrue(listIdentifiersType.getHeader().size() == 1);
        assertEquals("MIDAS-ISG:WS-000532",listIdentifiersType.getHeader().get(0).getIdentifier());
        assertEquals("[Root: Software: (Data visualizers)]",listIdentifiersType.getHeader().get(0).getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetMetadataFormats() {
        ModelMap model = null;
        Optional<String> identifier = Optional.of("http://www.epimodels.org/drupal/?q=node/81");
        ResponseEntity responseEntity = ws.getMetadataFormatsWebService(model, identifier);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        MetadataFormatType metadataFormatType = oaipmhType.getListMetadataFormats().getMetadataFormat().get(0);

        assertEquals("oai_dc", metadataFormatType.getMetadataPrefix());
        assertEquals("http://www.openarchives.org/OAI/2.0/oai_dc/", metadataFormatType.getSchema());
        assertEquals("http://www.openarchives.org/OAI/2.0/oai_dc.xsd", metadataFormatType.getMetadataNamespace());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetRecordsAll() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordsWebService(model, null, null,"oai_dc" , null, null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        ListRecordsType listRecordsType = oaipmhType.getListRecords();
        assertTrue(listRecordsType.getRecord().size() > 600);
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetRecordsWithDate() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordsWebService(model, "2018-04-01T12:00:00", "2018-04-23T12:00:00","oai_dc" , null, null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        ListRecordsType listRecordsType = oaipmhType.getListRecords();
        assertTrue(listRecordsType.getRecord().size() <= 4);
        assertEquals("MIDAS-ISG:epidemiological-bulletin-national-system-of-epidemiological-surveillance-system-v1.0", listRecordsType.getRecord().get(0).getHeader().getIdentifier());
        assertEquals("[Root: (Data Formats)]", listRecordsType.getRecord().get(0).getHeader().getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());

        //Test Dublin Core elements
        OaiDcType oaiDcType = getOaiDcTypeFromBody(listRecordsType.getRecord().get(0).getMetadata().getAny());

        JAXBElement<ElementType> elementTypeIdentifier = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(0));
        assertTrue(elementTypeIdentifier.getName().getLocalPart().equals("identifier"));
        assertEquals("MIDAS-ISG:epidemiological-bulletin-national-system-of-epidemiological-surveillance-system-v1.0", elementTypeIdentifier.getValue().getValue());

        //additional from/until tests
        ResponseEntity responseEntityFromNull = ws.getRecordsWebService(model, null, "2018-04-01T12:00:00","oai_dc" , null, null);
        OAIPMHtype oaipmhTypeFromNull = getOAIPMHtypeFromBody(responseEntityFromNull);
        ListRecordsType listRecordsTypeFromNull = oaipmhTypeFromNull.getListRecords();
        assertTrue(listRecordsTypeFromNull.getRecord().size() == 1);

        ResponseEntity responseEntityToNull = ws.getRecordsWebService(model, "2018-04-01T12:00:00", null,"oai_dc" , null, null);
        OAIPMHtype oaipmhTypeToNull = getOAIPMHtypeFromBody(responseEntityToNull);
        ListRecordsType listRecordsTypeToNull = oaipmhTypeToNull.getListRecords();
        assertTrue(listRecordsTypeToNull.getRecord().size() >= 4);
    }

    @Test
    public void testGetRecordsWithSet() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordsWebService(model, null, null,"oai_dc" , "Root: (Software)", null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        ListRecordsType listRecordsType = oaipmhType.getListRecords();
        assertTrue(listRecordsType.getRecord().size() > 40);
/*
        assertEquals("MIDAS-ISG:WS-000164", listRecordsType.getRecord().get(0).getHeader().getIdentifier());
        assertEquals("[Root: Data: Websites with data: (Americas)]", listRecordsType.getRecord().get(0).getHeader().getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());

        //Test Dublin Core elements
        OaiDcType oaiDcType = getOaiDcTypeFromBody(listRecordsType.getRecord().get(0).getMetadata().getAny());

        JAXBElement<ElementType> elementTypeTitle = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(0));
        assertTrue(elementTypeTitle.getName().getLocalPart().equals("title"));
        assertEquals("Demographics in Honduras, 2008", elementTypeTitle.getValue().getValue());
        JAXBElement<ElementType> elementTypeIdentifier = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(1));
        assertTrue(elementTypeIdentifier.getName().getLocalPart().equals("identifier"));
        assertEquals("MIDAS-ISG:WS-000164", elementTypeIdentifier.getValue().getValue());
        JAXBElement<ElementType> elementTypeSubject = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(3));
        assertTrue(elementTypeSubject.getName().getLocalPart().equals("subject"));
        assertEquals("Statistics on demographic in Honduras", elementTypeSubject.getValue().getValue());
        JAXBElement<ElementType> elementTypeCreator = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(4));
        assertTrue(elementTypeCreator.getName().getLocalPart().equals("creator"));
        assertEquals("Wikidot", elementTypeCreator.getValue().getValue());
        JAXBElement<ElementType> elementTypeDate = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(5));
        assertTrue(elementTypeDate.getName().getLocalPart().equals("date"));
        assertEquals("2008", elementTypeDate.getValue().getValue());
        JAXBElement<ElementType> elementTypeCoverage = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(6));
        assertTrue(elementTypeCoverage.getName().getLocalPart().equals("coverage"));
        assertEquals("Honduras", elementTypeCoverage.getValue().getValue());
        JAXBElement<ElementType> elementTypeFormat = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(7));
        assertTrue(elementTypeFormat.getName().getLocalPart().equals("format"));
        assertEquals("HTML", elementTypeFormat.getValue().getValue());
*/
    }

    @Test
    public void testGetSets() {
        ModelMap model = null;
        Optional<String> identifier = Optional.of("http://www.epimodels.org/drupal/?q=node/81");
        ResponseEntity responseEntity = ws.getSetsWebService(model);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        MetadataFormatType metadataFormatType = oaipmhType.getListMetadataFormats().getMetadataFormat().get(0);

        ListSetsType listSetsType = oaipmhType.getListSets();

        assertEquals("oai_dc", metadataFormatType.getMetadataPrefix());
        assertEquals("http://www.openarchives.org/OAI/2.0/oai_dc/", metadataFormatType.getSchema());
        assertEquals("http://www.openarchives.org/OAI/2.0/oai_dc.xsd", metadataFormatType.getMetadataNamespace());

        assertTrue(listSetsType.getSet().size() > 225);
        assertEquals("Root", listSetsType.getSet().get(0).getSetSpec());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    //Error Testing -- Identify and GetSets do not take any arguments
    @Test
    public void testGetRecordForIdentifierErrorTest() {
        ModelMap model = null;
        ResponseEntity responseEntityOaiDC = ws.getRecordForIdentifierWebService(model, "10.25337/T7/ptycho.v2.0/AG.722862003","oai_d");
        assertEquals("cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.",responseEntityOaiDC.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityOaiDC.getStatusCode());

        ResponseEntity responseEntityBadIdentifier = ws.getRecordForIdentifierWebService(model, "MIDAS-ISG:WS-000078A","oai_dc");
        assertEquals("idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.",responseEntityBadIdentifier.getBody());
        assertEquals(HttpStatus.NOT_FOUND,responseEntityBadIdentifier.getStatusCode());

        ResponseEntity responseEntityNoIdentifier = ws.getRecordForIdentifierWebService(model, "","oai_dc");
        assertEquals("idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.",responseEntityNoIdentifier.getBody());
        assertEquals(HttpStatus.NOT_FOUND,responseEntityNoIdentifier.getStatusCode());

    }


    @Test
    public void testGetIdentifiersErrorTest() {
        ModelMap model = null;

        ResponseEntity responseEntityOaiDC = ws.getIdentifiersWebService(model, null, null,"ai_dc" , null, null);
        assertEquals("cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.",responseEntityOaiDC.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityOaiDC.getStatusCode());

        ResponseEntity responseEntityBadFromFormat = ws.getIdentifiersWebService(model, "2018-03-01 12:00:00", "2018-03-30T12:00:00","oai_dc" , "Root: Software: (Data visualizers)", null);
        assertEquals("badArgument - The request includes illegal arguments or is missing required arguments.",responseEntityBadFromFormat.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityBadFromFormat.getStatusCode());

        ResponseEntity responseEntityBadToFormat = ws.getIdentifiersWebService(model, "2018-03-01T12:00:00", "2018-03-30","oai_dc" , null, null);
        assertEquals("badArgument - The request includes illegal arguments or is missing required arguments.",responseEntityBadToFormat.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityBadToFormat.getStatusCode());

        ResponseEntity responseEntityNoRecords = ws.getIdentifiersWebService(model, "2018-03-01T12:00:00", "2018-03-30T12:00:00","oai_dc" , "Root: (Data formats)", null);
        assertEquals("noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.",responseEntityNoRecords.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityNoRecords.getStatusCode());

    }

    @Test
    public void testGetRecordsErrorTest() {
        ModelMap model = null;

        ResponseEntity responseEntityOaiDC = ws.getRecordsWebService(model, null, null,"oaidc" , null, null);
        assertEquals("cannotDisseminateFormat - The value of the metadataPrefix argument is not supported by the item identified by the value of the identifier argument.",responseEntityOaiDC.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityOaiDC.getStatusCode());

        ResponseEntity responseEntityBadFromFormat = ws.getRecordsWebService(model, "2018-03-01 T12:00:00", "2018-03-30T12:00:00","oai_dc" , "Root: Software: (Data visualizers)", null);
        assertEquals("badArgument - The request includes illegal arguments or is missing required arguments.",responseEntityBadFromFormat.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityBadFromFormat.getStatusCode());

        ResponseEntity responseEntityBadToFormat = ws.getRecordsWebService(model, "2018-03-01T12:00:00", "2018-03-30 12:00:00","oai_dc" , null, null);
        assertEquals("badArgument - The request includes illegal arguments or is missing required arguments.",responseEntityBadToFormat.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityBadToFormat.getStatusCode());

        ResponseEntity responseEntityNoRecords = ws.getRecordsWebService(model, "2018-04-01T12:00:00", "2018-04-23T12:00:00","oai_dc" , "Root: Software: (Data visualizers)", null);
        assertEquals("noRecordsMatch - The combination of the values of the from, until, and set arguments results in an empty list.",responseEntityNoRecords.getBody());
        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntityNoRecords.getStatusCode());

    }

    @Test
    public void testGetMetadataErrorTest() {
        ModelMap model = null;
        Optional<String> identifier = Optional.of("http://www.epimodels.org/drupal/?q=node/"); //"http://www.epimodels.org/drupal/?q=node/81"
        ResponseEntity responseEntityBadIdentifier = ws.getMetadataFormatsWebService(model, identifier);
        assertEquals("idDoesNotExist - The value of the identifier argument is unknown or illegal in this repository.",responseEntityBadIdentifier.getBody());
        assertEquals(HttpStatus.NOT_FOUND,responseEntityBadIdentifier.getStatusCode());
    }


}

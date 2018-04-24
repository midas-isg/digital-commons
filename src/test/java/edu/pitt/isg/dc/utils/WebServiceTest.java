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

        //((JAXBElement<OAIPMHtype>).getRecord().get(0).metadata.getAny()).getValue();
        OaiDcType oaiDcType = getOaiDcTypeFromBody(getRecordType.getRecord().getMetadata().getAny());
        JAXBElement<ElementType> elementType = ((JAXBElement<ElementType>)oaiDcType.getTitleOrCreatorOrSubject().get(0));
        //elementType.getValue()        .getValue()
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
        assertTrue(listIdentifiersType.getHeader().size() > 900);
        assertEquals("MIDAS-ISG:WS-000356",listIdentifiersType.getHeader().get(0).getIdentifier());
        assertEquals("[Root: Data: Disease surveillance data: Americas: (Peru)]",listIdentifiersType.getHeader().get(0).getSetSpec().toString());
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
/*
    @Test
    public void testGetRecordsAll() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordsWebService(model, null, null,"oai_dc" , null, null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        ListRecordsType listRecordsType = oaipmhType.getListRecords();
        assertTrue(listRecordsType.getRecord().size() > 1000);
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }
*/

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
    }

    @Test
    public void testGetRecordsWithSet() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordsWebService(model, null, null,"oai_dc" , "Root: Data: (Websites with data)", null);
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);

        ListRecordsType listRecordsType = oaipmhType.getListRecords();
        assertTrue(listRecordsType.getRecord().size() > 90);
        assertEquals("MIDAS-ISG:WS-000164", listRecordsType.getRecord().get(0).getHeader().getIdentifier());
        assertEquals("[Root: Data: Websites with data: (Americas)]", listRecordsType.getRecord().get(0).getHeader().getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetRecordsNoneReturned() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordsWebService(model, "2018-04-01T12:00:00", "2018-04-23T12:00:00","oai_dc" , "Root: Software: (Data visualizers)", null);

        assertEquals(HttpStatus.UNPROCESSABLE_ENTITY,responseEntity.getStatusCode());
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

        assertTrue(listSetsType.getSet().size() > 320);
        assertEquals("Root", listSetsType.getSet().get(0).getSetSpec());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }


}

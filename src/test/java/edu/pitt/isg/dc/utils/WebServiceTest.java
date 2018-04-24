package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.repository.utils.ApiUtil;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openarchives.oai._2.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
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
@RunWith(SpringJUnit4ClassRunner.class)
public class WebServiceTest {
    static WebService ws = new WebService();
    private static Jaxb2Marshaller marshaller;

    @BeforeClass
    public static void setup() {
        ws.setupApiUtilForTesting();

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

    private JAXBElement<?> unmarshal(String xml) {
        InputStream stream = new ByteArrayInputStream(xml.getBytes());
        return (JAXBElement<?>) marshaller.unmarshal(new StreamSource(stream));
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
    public void testGetRecordForIdentifier1() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordForIdentifierWebService(model, "10.25337/T7/ptycho.v2.0/AG.722862003","oai_dc");
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        GetRecordType getRecordType = oaipmhType.getGetRecord();

        assertEquals("10.25337/T7/ptycho.v2.0/AG.722862003", getRecordType.getRecord().getHeader().getIdentifier());
        assertEquals("Root: Data: Disease surveillance data: Americas: Antigua and Barbuda: ([Project Tycho Datasets])", getRecordType.getRecord().getHeader().getSetSpec().toString());
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    @Test
    public void testGetRecordForIdentifier2() {
        ModelMap model = null;
        ResponseEntity responseEntity = ws.getRecordForIdentifierWebService(model, "http://www.epimodels.org/drupal/?q=node/81","oai_dc");
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        GetRecordType getRecordType = oaipmhType.getGetRecord();

        assertEquals("http://www.epimodels.org/drupal/?q=node/81", getRecordType.getRecord().getHeader().getIdentifier());
        assertEquals("Root: Data: Synthetic populations and ecosystems: (Synthia datasets)", getRecordType.getRecord().getHeader().getSetSpec().toString());
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

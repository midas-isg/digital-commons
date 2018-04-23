package edu.pitt.isg.dc.utils;

import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openarchives.oai._2.IdentifyType;
import org.openarchives.oai._2.OAIPMHtype;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.xml.bind.JAXBElement;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.HashMap;

import static org.junit.Assert.assertEquals;

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

    @Test
    public void testGetIdentityInfo() {
        ResponseEntity responseEntity = ws.getIdentifyInfo();
        OAIPMHtype oaipmhType = getOAIPMHtypeFromBody(responseEntity);
        IdentifyType identifyType = oaipmhType.getIdentify();

        assertEquals("isg-feedback@list.pitt.edu", identifyType.getAdminEmail().get(0));
        assertEquals(HttpStatus.OK,responseEntity.getStatusCode());
    }

    private JAXBElement<?> unmarshal(String xml) {
        InputStream stream = new ByteArrayInputStream(xml.getBytes());
        return (JAXBElement<?>) marshaller.unmarshal(new StreamSource(stream));
    }
}

package edu.pitt.isg.dc.fm;

import org.junit.Test;

import static edu.pitt.isg.dc.fm.FairMetricService.FM_A1_1;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_A1_2;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_A2;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_F1A;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_F1B;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_F2;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_F3;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_F4;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_I1;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_I2;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_I3;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_R1_1;
import static edu.pitt.isg.dc.fm.FairMetricService.FM_R1_2;
import static edu.pitt.isg.dc.fm.JsonKit.dumpJsonFile;
import static org.assertj.core.api.Assertions.assertThat;

public class TychoAiaDengueTests {
//    final static private String body = dumpJsonFile("/examples/tycho.json"); //"{\"subject\":\"10.25337/T7/ptycho.v2.0/AI.38362002\",\"spec\":\"https://fairsharing.org/bsg-s001182\",\"persistence_doc\":\"https://www.tycho.pitt.edu/data-access/\",\"format\":\"https://fairsharing.org/FAIRsharing.znmpch\",\"metadata\":\"https://www.tycho.pitt.edu/dataset/AI.38362002\",\"identifier\":\"10.25337/T7/ptycho.v2.0/AI.38362002\",\"search_uri\":\"https://www4.bing.com/search?q=10.25337/T7/ptycho.v2.0/AI.38362002&qs=n&form=QBLH&sp=-1&pq=10.5061%2Fdryad.gn219&sc=0-19&sk=&cvid=FEC09C5AA1404CDEB062B76F00CC9180\",\"protocol_uri\":\"http://creativecommons.org/licenses/by-nc-sa/4.0/\",\"allows\":\"TRUE\",\"evidence\":\"https://www.tycho.pitt.edu/accounts/login/\",\"persistence_uri\":\"URL2thePersistencePolicyOf(meta)data\",\"bnf_uri\":\"URL2BNFForKnowledgeRepresentationLanguageUsedByTheResource\",\"vocab1_uri\":\"\",\"vocab2_uri\":\"\",\"vocab3_uri\":\"\",\"linkset_uri\":\"URL2VoIDLinkset\",\"datalicense_uri\":\"\",\"metadatalicense_uri\":\"\",\"prov_vocab_uri\":\"https://www.tycho.pitt.edu/dataset/AI.38362002/\"}";
    final static private String body = dumpJsonFile("/fair-metrics/examples/tychoAidDengueFairMetric.json"); //"{\"subject\":\"10.25337/T7/ptycho.v2.0/AI.38362002\",\"spec\":\"https://fairsharing.org/bsg-s001182\",\"persistence_doc\":\"https://www.tycho.pitt.edu/data-access/\",\"format\":\"https://fairsharing.org/FAIRsharing.znmpch\",\"metadata\":\"https://www.tycho.pitt.edu/dataset/AI.38362002\",\"identifier\":\"10.25337/T7/ptycho.v2.0/AI.38362002\",\"search_uri\":\"https://www4.bing.com/search?q=10.25337/T7/ptycho.v2.0/AI.38362002&qs=n&form=QBLH&sp=-1&pq=10.5061%2Fdryad.gn219&sc=0-19&sk=&cvid=FEC09C5AA1404CDEB062B76F00CC9180\",\"protocol_uri\":\"http://creativecommons.org/licenses/by-nc-sa/4.0/\",\"allows\":\"TRUE\",\"evidence\":\"https://www.tycho.pitt.edu/accounts/login/\",\"persistence_uri\":\"URL2thePersistencePolicyOf(meta)data\",\"bnf_uri\":\"URL2BNFForKnowledgeRepresentationLanguageUsedByTheResource\",\"vocab1_uri\":\"\",\"vocab2_uri\":\"\",\"vocab3_uri\":\"\",\"linkset_uri\":\"URL2VoIDLinkset\",\"datalicense_uri\":\"\",\"metadatalicense_uri\":\"\",\"prov_vocab_uri\":\"https://www.tycho.pitt.edu/dataset/AI.38362002/\"}";
    final private FairMetricService service = FairMetricServiceTests.newFairMetricService();

    @Test
    public void f1a() throws Exception {
        assertOkResult(service.assessMetric(FM_F1A, body));
    }

    @Test
    public void f1b() throws Exception {
        assertOkResult(service.assessMetric(FM_F1B, body));
    }

    @Test
    public void f2() throws Exception {
        assertOkResult(service.assessMetric(FM_F2, body));
    }

    @Test
    public void f3() throws Exception {
        assertOkResult(service.assessMetric(FM_F3, body));
    }

    @Test
    public void f4() throws Exception {
        assertOkResult(service.assessMetric(FM_F4, body));
    }

    @Test
    public void a1_1() throws Exception {
        assertResult(service.assessMetric(FM_A1_1, body),
                "0",
                "The URI https://creativecommons.org/licenses/by-nc-sa/4.0/ did not return a valid response");
    }

    @Test
    public void a1_2() throws Exception {
        assertOkResult(service.assessMetric(FM_A1_2, body));
    }

    @Test
    public void a2() throws Exception {
        assertResult(service.assessMetric(FM_A2, body),
                "0",
                "Failed to find a document at URL '' in the FAIRSharing Registry");
    }

    @Test
    public void i1() throws Exception {
        assertResult(service.assessMetric(FM_I1, body),
                "0",
                "The document at  does not appear to be a BNF definition");
    }

    @Test
    public void i2() throws Exception {
        assertResult(service.assessMetric(FM_I2, body),
                "0.99",
                "Three vocabularies confirmed...");
    }

    @Test
    public void i3() throws Exception {
        assertResult(service.assessMetric(FM_I3, body),"0","0");
    }

    @Test
    public void r1_1() throws Exception {
        assertResult(service.assessMetric(FM_R1_1, body),"1.0","");
    }

    @Test
    public void r1_2() throws Exception {
        assertOkResult(service.assessMetric(FM_R1_2, body));
    }

    private void assertOkResult(FairMetricResult result) {
        assertResult(result, "1", "All OK!");
    }

    private void assertResult(FairMetricResult result, String value, String comment) {
        assertThat(result.getHasValue()).isEqualToIgnoringCase(value);
        assertThat(result.getComment()).isEqualToIgnoringCase(comment);
    }
}

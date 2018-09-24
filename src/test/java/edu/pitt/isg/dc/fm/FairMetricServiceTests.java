package edu.pitt.isg.dc.fm;

import org.junit.Test;

import java.util.Map;

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

public class FairMetricServiceTests {
    @Test
    public void falsePositives() throws Exception {
        final String falsePositives = dumpJsonFile("/fm/examples/falsePositives.json");
        final String body = falsePositives;
        final Map<String, FairMetricResult> metricId2result = newFairMetricService().assessAllMetrics(body);
//        metricId2result.forEach((k, v) -> System.out.println(k + ": " + v));
        assertOkResult(metricId2result.get(FM_F1A));
        assertOkResult(metricId2result.get(FM_F1B));
        assertOkResult(metricId2result.get(FM_F2));
        assertOkResult(metricId2result.get(FM_F3));
        assertOkResult(metricId2result.get(FM_F4));
        assertOkResult(metricId2result.get(FM_A1_1));
        assertOkResult(metricId2result.get(FM_A1_2));
        assertOkResult(metricId2result.get(FM_A2));
        assertOkResult(metricId2result.get(FM_I1));
        assertResult(metricId2result.get(FM_I2), "0.99", "Three vocabularies confirmed...");
        assertOkResult(metricId2result.get(FM_I3));
        assertResult(metricId2result.get(FM_R1_1), "1.0", "");
        assertOkResult(metricId2result.get(FM_R1_2));
    }

    static FairMetricService newFairMetricService() {
        return FairMetricService.builder()
                .meta(new MetadataService())
                .build();
    }

    private void assertOkResult(FairMetricResult result) {
        assertResult(result, "1", "All OK!");
    }

    private void assertResult(FairMetricResult result, String value, String comment) {
        assertThat(result.getHasValue()).isEqualToIgnoringCase(value);
        assertThat(result.getComment()).isEqualToIgnoringCase(comment);
    }
}

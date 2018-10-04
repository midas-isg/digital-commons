package edu.pitt.isg.dc.fm;

import edu.pitt.isg.dc.config.hibernate.JsonbType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.annotations.Type;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import static javax.persistence.GenerationType.SEQUENCE;

@Entity @NoArgsConstructor
@Data
@Builder @AllArgsConstructor
@Slf4j
public class FairMetricResult {
    @Id
    @GeneratedValue(strategy = SEQUENCE, generator = "generator")
    @SequenceGenerator(name="generator", sequenceName = "fair_metric_result_seq")
    private Long id;
    private String metric;
    private String hasValue;
    @Column(length = 10_485_760)
    private String comment;
    private String fmId;
    @Type(type = JsonbType.NAME)
    private Map<String, Object> raw;

    public static FairMetricResult fromJsonMap(Map<String, Object> map){
        for (Map.Entry<String, Object> pair : map.entrySet()){
            String fmId = pair.getKey();
            if (fmId.startsWith("http://linkeddata.systems/cgi-bin/fair_metrics/Metrics/")){
                Map<String, Object> resultMap = (Map<String, Object>)pair.getValue();
                String key = "http://schema.org/comment";
                String comment = getFirstValue(resultMap, key);
                String hasValue = getFirstValue(resultMap, "http://semanticscience.org/resource/SIO_000300");
                String metric = fmId.split("/result#")[0];
                return newFairMetricResult(metric, fmId, hasValue, comment, map);
            }
        }
        return null;
    }

    static FairMetricResult newFairMetricResult(String metric, String fmId, String hasValue, String comment, Map<String, Object> raw) {
        return FairMetricResult.builder()
                .metric(metric)
                .fmId(fmId)
                .hasValue(hasValue)
                .comment(comment)
                .raw(raw)
                .build();
    }

    private static String getFirstValue(Map<String, Object> map, String key) {
        final List<Map<String, Object>> list = (List<Map<String, Object>>) map.get(key);
        if (list == null || list.isEmpty())
            return "";
        return Objects.toString(list.get(0).get("value"));
    }
}

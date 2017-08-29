package edu.pitt.isg.dc.vm;

import com.google.gson.Gson;
import lombok.Data;

@Data
public class MatchedSoftware {
    private static Gson gson = new Gson();

    private String sourceSoftwareName;
    private String sinkSoftwareName;
    private String linkDataFormatName;

    public static MatchedSoftware of(Object[] a) {
        final MatchedSoftware result = new MatchedSoftware();
        result.setSourceSoftwareName(text(a[0]));
        result.setSinkSoftwareName(text(a[2]));
        result.setLinkDataFormatName(text(a[1]));
        return result;
    }

    private static String text(Object o) {
        return o.toString();
    }
}

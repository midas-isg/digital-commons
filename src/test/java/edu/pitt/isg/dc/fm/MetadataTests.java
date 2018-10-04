package edu.pitt.isg.dc.fm;

import com.google.gson.Gson;
import org.junit.Test;

import java.util.List;
import java.util.Map;

import static edu.pitt.isg.dc.fm.FairMetricService.DATALICENSE_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.FORMAT;
import static edu.pitt.isg.dc.fm.FairMetricService.IDENTIFIER;
import static edu.pitt.isg.dc.fm.FairMetricService.METADATA;
import static edu.pitt.isg.dc.fm.FairMetricService.METADATALICENSE_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.PROTOCOL_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.PROV_VOCAB_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.SEARCH_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.SPEC;
import static edu.pitt.isg.dc.fm.FairMetricService.SUBJECT;
import static edu.pitt.isg.dc.fm.FairMetricService.VOCAB_1_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.VOCAB_2_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.VOCAB_3_URI;
import static edu.pitt.isg.dc.fm.JsonKit.dumpJsonFile;
import static edu.pitt.isg.dc.fm.JsonKit.toStringObjectMap;
import static org.assertj.core.api.Assertions.assertThat;

public class MetadataTests {
    final private MetadataService metas = new MetadataService();
    final private String id = "10.25337/T7/ptycho.v2.0/AI.38362002";

    @Test
    public void file() {
        String body = dumpJsonFile("/fair-metrics/examples/tychoAiaDengueMeta.json");
        assertMeta(toStringObjectMap(body));
    }

    @Test
    public void fairMetricBody() {
        String body = dumpJsonFile("/fair-metrics/examples/tychoAiaDengueMeta.json");
        final Map<String, String> fmBody = metas.metadata2fmBody(toStringObjectMap(body));
        System.out.println(new Gson().toJson(fmBody));
        assertThat(fmBody.get(SUBJECT)).isEqualTo(id);
        assertThat(fmBody.get(SPEC)).isEqualTo("https://fairsharing.org/bsg-s001182");
        assertThat(fmBody.get(IDENTIFIER)).isEqualTo(id);
        assertThat(fmBody.get(VOCAB_1_URI)).isEqualTo("http://purl.obolibrary.org/obo/APOLLO_SV_00000545");
        assertThat(fmBody.get(VOCAB_2_URI)).isEqualTo("http://purl.obolibrary.org/obo/IDO_0000479");
        assertThat(fmBody.get(VOCAB_3_URI)).isEqualTo("http://purl.obolibrary.org/obo/IDO_0000479");
        assertThat(fmBody.get(PROV_VOCAB_URI)).isEqualTo("https://orcid.org/0000-0002-7278-9982");
        assertThat(fmBody.get(FORMAT)).isEqualTo("https://fairsharing.org/bsg-s000718");
        assertThat(fmBody.get(METADATA)).isEqualTo("http://betaweb.rods.pitt.edu/digital-commons-dev/api/v1/identifiers/metadata?identifier=10.25337%2FT7%2Fptycho.v2.0%2FAI.38362002");
        assertThat(fmBody.get(SEARCH_URI)).isEqualTo("https://www4.bing.com/search?q=" + id);
        assertThat(fmBody.get(PROTOCOL_URI)).isEqualTo("https://creativecommons.org/licenses/by-nc-sa/4.0/");
        assertThat(fmBody.get(DATALICENSE_URI)).isEqualTo("https://creativecommons.org/licenses/by-nc-sa/4.0/");
        assertThat(fmBody.get(METADATALICENSE_URI)).isEqualTo("https://creativecommons.org/licenses/by-nc-sa/4.0/");
    }

    @Test
    public void webservice() {
        assertMeta(metas.getMetadata(id));
    }

    private void assertMeta(Map<String, Object> meta) {
        assertThat(metas.getString(meta, "title")).isEqualTo("Counts of Dengue reported in ANGUILLA: 1980-2012");
        assertThat(metas.getString(meta, "identifier.identifier")).isEqualTo(id);
        assertThat(metas.getString(meta, "identifier.identifierSource")).isEqualTo("https://fairsharing.org/bsg-s001182");
        final List<Map<String, Object>> types = metas.getArray(meta, "types");
        assertThat(metas.getString(types.get(0), "method.valueIRI")).isEqualTo("http://purl.obolibrary.org/obo/APOLLO_SV_00000545");
        assertThat(metas.getString(types.get(0), "information.valueIRI")).isEqualTo("http://purl.obolibrary.org/obo/IDO_0000479");
        assertThat(metas.getString(types.get(1), "information.valueIRI")).isEqualTo("http://purl.obolibrary.org/obo/IDO_0000479");
        final List<Map<String, Object>> creators = metas.getArray(meta, "creators");
        assertThat(metas.getString(creators.get(0), "identifier.identifier")).isEqualTo("0000-0002-7278-9982");
        final List<Map<String, Object>> distributions = metas.getArray(meta, "distributions");
        final List<Map<String, Object>> conformsTo = metas.getArray(distributions.get(0), "conformsTo");
        assertThat(metas.getString(conformsTo.get(0), "identifier.identifier")).isEqualTo("https://fairsharing.org/bsg-s000718");
        final List<Map<String, Object>> licenses = metas.getArray(meta, "licenses");
        assertThat(metas.getString(licenses.get(0), "identifier.identifier")).isEqualTo("https://creativecommons.org/licenses/by-nc-sa/4.0/");
    }
}


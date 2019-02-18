package edu.pitt.isg.dc.fm;

import com.google.gson.JsonSyntaxException;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Stream;

import static edu.pitt.isg.dc.fm.FairMetricService.DATALICENSE_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.FORMAT;
import static edu.pitt.isg.dc.fm.FairMetricService.IDENTIFIER;
import static edu.pitt.isg.dc.fm.FairMetricService.METADATA;
import static edu.pitt.isg.dc.fm.FairMetricService.METADATALICENSE_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.PERSISTENCE_DOC;
import static edu.pitt.isg.dc.fm.FairMetricService.PROTOCOL_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.PROV_VOCAB_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.SEARCH_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.SPEC;
import static edu.pitt.isg.dc.fm.FairMetricService.SUBJECT;
import static edu.pitt.isg.dc.fm.FairMetricService.VOCAB_1_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.VOCAB_2_URI;
import static edu.pitt.isg.dc.fm.FairMetricService.VOCAB_3_URI;
import static edu.pitt.isg.dc.fm.JsonKit.toStringObjectMap;
import static java.util.Collections.singletonList;

@Service
@Slf4j
public class MetadataService {
//    private static final String baseUrl = "http://betaweb.rods.pitt.edu/digital-commons-dev";
//    private static final String baseUrl = "http://betaweb.rods.pitt.edu/digital-commons";
//    private static final String baseUrl = "http://localhost:8080/digital-commons/";
    public static final String metadataUrl = "/api/v1/identifiers/metadata";
    private Map<String, String> translator = initTranslator();

    private Map<String, String> initTranslator() {
        final Map<String, String> map = new HashMap<>();
        // F1A: spec
        map.put("Project Tycho", "https://fairsharing.org/bsg-s001182");
        map.put("zenodo", "https://fairsharing.org/bsg-s001182");
        map.put("https://doi.org/", "https://fairsharing.org/bsg-s001182"); // Also all DOI identifiers
        // format
        map.put("bsg-s000718", "https://fairsharing.org/bsg-s000718");
        // subject
        map.put("Brazil Ministry of Health public disease surveillance website", "BR");
        map.put("CDC WONDER US cause of death 1968-2015", "CDC'68");
        map.put("CDC WONDER US cause of death 1995-2015", "CDC'95");
        map.put("CDCEpi Zika Github", "CDCEpi-Zika-Github");
        map.put("Federal Center against HIV/AIDS of Russia", "RU-AIDS");
        map.put("MMWR morbidity and mortality tables", "MMWR");
        map.put("Singapore Routine Surveillance", "SG");
        map.put("identifier will be created at time of release", "TBR");
        map.put("https://zenodo.org/record/319937#.WKxb1xLytPV", "10.5281/zenodo.319937"); // F4
        map.put("https://zenodo.org/record/439078#.WNvahxLytzq", "10.5281/zenodo.439078"); // F4
//        map.put("http://www.epimodels.org/drupal/?q=node/80", "???"); //http://www.epimodels.org/drupal/?q=node/80=>HTTP: NOT FOUND
//        map.put("http://www.epimodels.org/drupal/?q=node/81", "???"); //http://www.epimodels.org/drupal/?q=node/81=>HTTP: NOT FOUND        map.put("https://zenodo.org/record/319937#.WKxb1xLytPV", "10.5281/zenodo.319937");

        return map;
    }

    public Map<String, Object> getMetadataWithLoggingException(String identifier) {
        try {
            return getMetadata(identifier);
        }catch (Exception e){
            log.error("Failed to get metadata for " + identifier, e);
            return null;
        }
    }

    public Map<String, Object> getMetadata(String identifier) throws IOException {
        try {
            String json = getJson(identifier);
            return toStringObjectMap(json);
        } catch (Exception e) {
            log.error("Failed to get metadata for identifier: " + identifier, e);
//            File file  = new File("/Users/mas400/Downloads/identifier_issues.txt");
//            file.createNewFile();
//            FileOutputStream oFile = new FileOutputStream(file, true);
//            oFile.write(identifier.getBytes());
//            oFile.write("\n".getBytes());
        }
        return null;
    }

    public Map<String, String> metadata2fmBody(Map<String, Object> meta) {
        final Map<String, String> fmBody = new LinkedHashMap<>();
        fmBody.put("title", getString(meta, "title")); // e.g. "Counts of Dengue reported in ANGUILLA: 1980-2012"
        final String identifier = getString(meta, "identifier.identifier"); // e.g. "10.25337/T7/ptycho.v2.0/AI.38362002"
        fmBody.put(SUBJECT, identifier);
        final String spec = getString(meta, "identifier.identifierSource");
        fmBody.put(SPEC, spec); // e.g. "https://fairsharing.org/bsg-s001182"
        if (spec != null && spec.equalsIgnoreCase("https://fairsharing.org/bsg-s001182"))
            fmBody.put(PERSISTENCE_DOC, "http://www.doi.org/doi_handbook/6_Policies.html#6.5");
        fmBody.put(IDENTIFIER, identifier);
        fillVocabs(meta, fmBody);
        fillProvVocab(meta, fmBody);
        fillUsingDistribution(meta, fmBody);
        try {
            fmBody.put(METADATA, toMetadataUrl(identifier)); // e.g. api/v1/identifiers/metadata?identifier=10.25337/T7/ptycho.v2.0/AI.38362002
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        fmBody.put(SEARCH_URI, toBingSearchUrl(identifier)); // e.g. "https://www4.bing.com/search?q=10.25337/T7/ptycho.v2.0/AI.38362002"
        fillLicenses(meta, fmBody);
        return fmBody;
    }

    private void fillLicenses(Map<String, Object> meta, Map<String, String> fmBody) {
        try {
            final List<Map<String, Object>> licenses = getArray(meta, "licenses");
            final String licenseUrl = getString(licenses.get(0), "identifier.identifier");  // e.g. "https://creativecommons.org/licenses/by-nc-sa/4.0/
            fmBody.put(PROTOCOL_URI, licenseUrl);
            fmBody.put(DATALICENSE_URI, licenseUrl);
            fmBody.put(METADATALICENSE_URI, licenseUrl);
        } catch (Exception e) {
            //log.warn("License", e);
        }
    }

    private void fillUsingDistribution(Map<String, Object> meta, Map<String, String> fmBody) {
        try {
            final List<Map<String, Object>> distributions = getArray(meta, "distributions");
            final Map<String, Object> distribution = distributions.get(0);
            final List<Map<String, Object>> conformsTo = getArray(distribution, "conformsTo");
            fmBody.put(FORMAT, getString(conformsTo.get(0), "identifier.identifier")); // e.g. "https://fairsharing.org/bsg-s000718"
            final List<Map<String, Object>> authentications = getArray(distribution, "access.authentications");
            final String authentication = getString(authentications.get(0), "value");
            if (authentication != null && ! authentication.isEmpty()) {
                fmBody.put("allows", "true");
                fmBody.put("evidence", getString(distribution, "access.accessURL"));
            }
        } catch (Exception e) {
            //log.warn("Format", e);
        }
    }

    private void fillProvVocab(Map<String, Object> meta, Map<String, String> fmBody) {
        try {
            final List<Map<String, Object>> creators = getArray(meta, "creators");
            final String creatorId = getString(creators.get(0), "identifier.identifier"); // e.g. "0000-0002-7278-9982"
            fmBody.put(PROV_VOCAB_URI, toOrcidUrl(creatorId));
        } catch (Exception e){
            //log.warn("Prov Vocab", e);
        }
    }

    private void fillVocabs(Map<String, Object> meta, Map<String, String> fmBody) {
        try {
            final List<Map<String, Object>> types = getArray(meta, "types");
            fmBody.put(VOCAB_1_URI, getString(types.get(0), "method.valueIRI")); // e.g. "http://purl.obolibrary.org/obo/APOLLO_SV_00000545"
            fmBody.put(VOCAB_2_URI, getString(types.get(0), "information.valueIRI")); // e.g. "http://purl.obolibrary.org/obo/IDO_0000479"
            fmBody.put(VOCAB_3_URI, getString(types.get(1), "information.valueIRI")); // e.g. "http://purl.obolibrary.org/obo/IDO_0000479"
        } catch (Exception e) {
            //log.warn("Vocabs", e);
        }
    }

    private String toOrcidUrl(String creatorId) {
        return "https://orcid.org/" + creatorId;
    }

    private String getJson(String identifier){
        try {
            return Jsoup.connect(toMetadataUrl(identifier)).timeout(60_000).ignoreContentType(true)
                        .header("Content-Type", "application/json")
                        .execute()
                        .body();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public Stream<Map<String, Object>> getAllMetadata(long skip){
        try {
            String baseUrl = getURLBase(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
            final String body = Jsoup.connect(baseUrl + "/api/v1/identifiers").timeout(60_000).ignoreContentType(true)
                    .header("Content-Type", "application/json")
                    .header("Accept", "application/json")
                    .execute()
                    .body();
//            System.out.println(body);
            final List<Object> list = JsonKit.toObjectList(body);
            log.info("Got all metadata: " + list.size()
                    + "; Skips = " + skip
                    + "; from " + baseUrl);
            return list.stream()
                    .skip(skip)
//                    .peek(System.out::println)
                    .map(obj -> getMetadataWithLoggingException(obj.toString()))
//                    .peek(System.out::println)
                    .filter(Objects::nonNull);
//                    .collect(Collectors.toList());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private String toMetadataUrl(String identifier) throws MalformedURLException {
        final List<BasicNameValuePair> list = singletonList(new BasicNameValuePair("identifier", identifier));
        final String query = URLEncodedUtils.format(list, "utf-8");
        String url = getURLBase(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest()) + metadataUrl;

        return url + "?" + query;
    }

    private String toBingSearchUrl(String identifier) {
        return "https://www4.bing.com/search?q=" + identifier;
    }

    public String getString(Map<String, Object> map, String jsonPath) {
        try {
            final String[] keys = jsonPath.split("\\.");
            Object value = map;
            for (String key : keys)
                value = ((Map<String, Object>) value).get(key);
            final String raw = value.toString();
            final String result = translator.get(raw);
            return result != null ? result : raw;
        } catch (Exception e) {
            //log.warn("getString", e);
            return null;
        }
    }

    public List<Map<String, Object>> getArray(Map<String, Object> map, String jsonPath) {
        try {
            final String[] keys = jsonPath.split("\\.");
            Object value = map;
            for (String key : keys)
                value = ((Map<String, Object>) value).get(key);
            return (List<Map<String, Object>>) value;
        } catch (Exception e){
            return null;
        }
    }

    public String getURLBase(HttpServletRequest request) throws MalformedURLException {
        return request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
    }
}

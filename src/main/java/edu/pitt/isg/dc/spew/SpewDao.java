package edu.pitt.isg.dc.spew;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

import static org.springframework.http.HttpMethod.GET;


@Service
public class SpewDao {
    @Value("${app.servers.spew.ws.url}")
    private String baseUrl;

    public List<SpewLocation> listCountries() {
        return getLocations(toSpewCountriesUrl(baseUrl));
    }

    public List<SpewLocation> listRegions() {
        return getLocations(toSpewRegionsUrl(baseUrl));
    }

    private List<SpewLocation> getLocations(String url) {
        final HttpEntity<SpewLocationLot> requestEntity = new HttpEntity<>(null, toHttpHeaders());
        final ResponseEntity<SpewLocationLot> exchange = toRestTemplate().exchange(url, GET, requestEntity, SpewLocationLot.class);
        if (exchange.getStatusCode().is2xxSuccessful()) {
            final SpewLocationLot body = exchange.getBody();
            return body.getResources();
        }
        return null;
    }

    private RestTemplate toRestTemplate() {
        final RestTemplate rest = new RestTemplate();
        final HttpClient httpClient = HttpClients.createDefault();
        rest.setRequestFactory(new HttpComponentsClientHttpRequestFactory(httpClient));
        return rest;
    }

    private HttpHeaders toHttpHeaders() {
        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        return headers;
    }

    static String toSpewCountriesUrl(String baseUrl) {
        return getSpewUrl(baseUrl, "countries");
    }

    static String toSpewRegionsUrl(String baseUrl) {
        return getSpewUrl(baseUrl, "regions");
    }

    private static String getSpewUrl(String baseUrl, String entities) {
        return toApiBuilder(baseUrl)
                .pathSegment(entities)
                .build().toUriString();
    }

    private static UriComponentsBuilder toApiBuilder(String baseUrl) {
        return toSpewUrlBuilder(baseUrl)
                .pathSegment("api");
    }

    private static UriComponentsBuilder toSpewUrlBuilder(String baseUrl) {
        return UriComponentsBuilder.newInstance()
                .uri(toUri(baseUrl));
    }

    private static URI toUri(String baseUrl) {
        try {
            return new URI(baseUrl);
        } catch (Exception e){
            throw new RuntimeException(e);
        }
    }

    public String toDownloadUrlWithSummary(SpewLocation location){
        return toSpewUrlBuilder(baseUrl)
                .pathSegment("spe")
                .queryParam("adminCodePath", location.getCode())
                .queryParam("openSummary", true)
                .toUriString();
    }

    public boolean isCountry(SpewLocation location) {
        return location.getType().equals("country");
    }
}

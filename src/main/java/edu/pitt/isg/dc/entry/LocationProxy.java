package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.entry.ls.FeatureCollection;
import edu.pitt.isg.dc.entry.ls.Properties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static edu.pitt.isg.dc.entry.Location.of;
import static java.util.Arrays.asList;
import static java.util.Arrays.stream;
import static java.util.stream.Collectors.toList;
import static java.util.stream.Collectors.toSet;

@Service
@RequiredArgsConstructor
@Slf4j
public class LocationProxy {
    @Value("${app.servers.ls.ws.url}")
    private String lsUrl;

    private final LocationRepository repo;

    List<Long> findRelatives(long alc) {
        final Location one = findOrCache(alc);
        return stream(one.getRelatives().split(","))
                .map(Long::parseLong)
                .collect(toList());
    }

    private Location findOrCache(long alc) {
        final Location one = repo.findOne(alc);
        if (one != null)
            return one;
        return fetchThenCache(alc);
    }

    private List<Long> fetchRelatives(long alc) {
        final RestTemplate rest = new RestTemplate();
        Map<String, Object> body = new HashMap<>();
        body.put("ALC", alc);
        final HttpEntity<Map> requestEntity = new HttpEntity<>(body, toHttpHeaders());

        final ResponseEntity<Long[]> exchange = rest.postForEntity(toAbsoluteUrlOfRelative(), requestEntity, Long[].class);
        if (exchange.getStatusCode().is2xxSuccessful()) {
            final Long[] alcs = exchange.getBody();
            return asList(alcs);
        }
        return Collections.emptyList();
    }

    private String toAbsoluteUrlOfRelative() {
        return toLocationAbsoluteUrl() + "/relative";
    }

    private Location fetchLocation(long alc) {
        final RestTemplate rest = new RestTemplate();
        Map<String, String> query = new HashMap<>();
        query.put("_onlyFeatureFields", "properties.name,properties.locationTypeName,properties.gid,properties.lineage");
        try {
            final ResponseEntity<FeatureCollection> exchange = rest.getForEntity(toLocationUri(alc), FeatureCollection.class, query);
            if (exchange.getStatusCode().is2xxSuccessful()) {
                final FeatureCollection fc = exchange.getBody();
                final Properties properties = fc.getFeatures().get(0).getProperties();
                return of(properties, fetchRelatives(alc));
            }
        } catch (RestClientException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    private String toLocationUri(long alc) {
        return toLocationAbsoluteUrl() + "/" + alc;
    }

    private String toLocationAbsoluteUrl() {
        final String lsApi = lsUrl + "/api";
        return lsApi + "/locations";
    }

    private HttpHeaders toHttpHeaders() {
        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        return headers;
    }

    public List<Location> findAll(Set<String> lsIds) {
        final Set<Long> ids = lsIds.stream()
                .filter(s -> !s.isEmpty()) // Bad data
                .map(Long::parseLong)
                .collect(toSet());
        return findAllByIds(ids);
    }

    List<Location> findAllByIds(Set<Long> ids) {
        try {
            ids.stream()
                    .filter(id -> !repo.exists(id))
                    .forEach(this::fetchThenCache);
        } catch (Exception e){
            log.error(e.getMessage(), e);
        }
        return repo.findAll(ids);
    }

    private Location fetchThenCache(Long id) {
        final Location location = fetchLocation(id);
        repo.save(location);
        return location;
    }
}

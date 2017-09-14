package edu.pitt.isg.dc.repository.utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.dc.entry.classes.EntryObject;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.repository.RepositoryEntry;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.v1_0.Software;
import org.jsoup.Jsoup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by jdl50 on 5/27/17.
 */
@Component
public class ApiUtil {
    @Autowired
    private EntryRepository repo;

    public List<String> getIdentifiers() {
        List<String> unparsedIdentifiers = repo.findPublicIdentifiers();
        List<String> parsedIdentifiers = new ArrayList<>();
        for(String unparsedIdentifier : unparsedIdentifiers) {
            String parsedIdentifier = Jsoup.parse(unparsedIdentifier).text();
            parsedIdentifier = parsedIdentifier.replaceAll("https?://doi\\.org/", "");
            parsedIdentifiers.add(parsedIdentifier);
        }
        Collections.sort(parsedIdentifiers);
        return parsedIdentifiers;
    }

    public String getAccessUrl(String identifier, String distributionId) {
        if(distributionId == null) distributionId = "0";
        String accessUrl = repo.findAccessUrlByIdentifierAndDistributionId(identifier, distributionId);
        if(accessUrl == null) {
            Map<String, String> parsedToUnparsedIdentifierMap = getParsedToUnparsedIdentifierMapping();
            if(parsedToUnparsedIdentifierMap.containsKey(identifier)) {
                accessUrl = repo.findAccessUrlByIdentifierAndDistributionId(parsedToUnparsedIdentifierMap.get(identifier), distributionId);
            }
        }
        return accessUrl;
    }

    public String getMetadata(String identifier, String header) {
        EntryView entryView = this.getEntryView(identifier);
        if(entryView != null) {
            String metadata = null;
            if(header.equalsIgnoreCase("application/xml")) {
                metadata = entryView.getXmlString();
            } else {
                metadata = entryView.getUnescapedEntryJsonString();
            }
            return metadata;
        }
        return null;
    }

    public String getMetadataType(String identifier) {
        EntryView entryView = this.getEntryView(identifier);

        if (entryView != null) {
            return entryView.getEntryType();
        }

        return null;
    }

    public List<Entry> getPublicEntryContents() {
        return repo.findPublicEntries();
    }

    private Map<String, String> getParsedToUnparsedIdentifierMapping() {
        Map<String, String> parsedToUnparsedIdentifierMap = new HashMap<>();
        for(String unparsedIdentifier : repo.findPublicIdentifiers()) {
            String parsedIdentifier = Jsoup.parse(unparsedIdentifier).text();
            parsedIdentifier = parsedIdentifier.replaceAll("https?://doi\\.org/", "");
            parsedToUnparsedIdentifierMap.put(parsedIdentifier, unparsedIdentifier);
        }
        return parsedToUnparsedIdentifierMap;
    }

    private EntryView getEntryView(String identifier) {
        Entry entry = repo.findByMetadataIdentifier(identifier);

        if(entry == null) {
            Map<String, String> parsedToUnparsedIdentifierMap = getParsedToUnparsedIdentifierMapping();
            if(parsedToUnparsedIdentifierMap.containsKey(identifier)) {
                entry = repo.findByMetadataIdentifier(parsedToUnparsedIdentifierMap.get(identifier));
            }
        }

        if (entry != null) {
            return new EntryView(entry);
        }

        return null;
    }

}

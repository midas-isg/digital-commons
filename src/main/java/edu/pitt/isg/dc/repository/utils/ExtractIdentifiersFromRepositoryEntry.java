package edu.pitt.isg.dc.repository.utils;

import edu.pitt.isg.dc.repository.RepositoryEntry;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.v1_0.Software;
import org.jsoup.Jsoup;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by jdl50 on 5/27/17.
 */
public class ExtractIdentifiersFromRepositoryEntry {
    public static String extractIdentifiers(RepositoryEntry repositoryEntry) {
        Object o = repositoryEntry.getInstance();
        String possibleDoi = null;
        if (o instanceof Software) {
            Software s = (Software) o;
            if (s.getIdentifier() != null)
                possibleDoi = s.getIdentifier().getIdentifier();
        }

        if (o instanceof Dataset) {
            Dataset d = (Dataset) o;
            if (d.getIdentifier() != null)
                possibleDoi = d.getIdentifier().getIdentifier();
        }

        if (o instanceof DataStandard) {
            DataStandard d = (DataStandard) o;
            if (d.getIdentifier() != null)
                possibleDoi = d.getIdentifier().getIdentifier();

        }

        if (possibleDoi != null) {
            possibleDoi = Jsoup.parse(possibleDoi).text();
            possibleDoi = possibleDoi.replaceAll("https?://doi\\.org/", "");
        }
        return possibleDoi;

    }

    public static String extractDois(RepositoryEntry repositoryEntry) {
        String possibleDoi = extractIdentifiers(repositoryEntry);
        if (possibleDoi != null) {
            Pattern p = Pattern.compile("^10\\..*");
            Matcher m = p.matcher(possibleDoi);
            if (!m.matches()) {
                possibleDoi = null;
            }
        }
        return possibleDoi;

    }

}

package edu.pitt.isg.dc.repository.utils;

import edu.pitt.isg.dc.repository.RepositoryEntry;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.v1_0.Software;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by jdl50 on 5/27/17.
 */
public class ExtractDoisFromRepositoryEntry {
    public static String execute(RepositoryEntry repositoryEntry) {
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
           possibleDoi = possibleDoi.replaceAll("https?://doi\\.org/", "");
            System.out.println(possibleDoi);
           Pattern p =  Pattern.compile("^10\\..*");
           Matcher m = p.matcher(possibleDoi);
           if (!m.matches()) {
               possibleDoi = null;
           }
        }
        return possibleDoi;

    }

}

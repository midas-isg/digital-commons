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
public class ExtractDataFromEntry {
    public static String execute(RepositoryEntry repositoryEntry) {
        Object o = repositoryEntry.getInstance();
        String possibleDoi = null;


        if (o instanceof Dataset) {
            Dataset d = (Dataset) o;
            if (d.getIdentifier() != null)
                possibleDoi = d.getDistributions().get(0).getAccess().getAccessURL();
        }

        return possibleDoi;

    }
}

package edu.pitt.isg.dc;


import edu.pitt.isg.JsonConverter;
import edu.pitt.isg.dc.entry.impl.JsonMdcEntryDatastoreImpl;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.junit.Test;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.fail;

/**
 * Created by jdl50 on 5/23/17.
 */

public class testParseDats {

    @Test
    public void testParseSpewDats() {
        assertTrue(true);
        File spewDatsDir = new File(this.getClass().getResource("/resources/spew-dats-json/").getFile());
        assertTrue(spewDatsDir.isDirectory());
        File[] files = spewDatsDir.listFiles(new FileFilter() {
            @Override
            public boolean accept(File pathname) {
                return pathname.getName().endsWith("json");
            }
        });

        Iterator<File> it = Arrays.asList(files).iterator();
        while (it.hasNext()) {
            File f = it.next();
            JsonConverter<Dataset> jsonConverter = new JsonConverter<>();
            try {
                jsonConverter.convert(FileUtils.readFileToString(f), new Dataset());
            } catch (IOException e) {
                fail(e.getMessage());
            }
        }
    }
    
}

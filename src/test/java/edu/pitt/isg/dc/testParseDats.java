package edu.pitt.isg.dc;


import edu.pitt.isg.JsonConverter;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.apache.commons.io.FileUtils;
import org.junit.Test;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.Arrays;
import java.util.Iterator;

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

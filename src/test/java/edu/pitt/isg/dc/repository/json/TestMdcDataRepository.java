package edu.pitt.isg.dc.repository.json;

import org.junit.Test;

import java.io.File;
import java.util.Iterator;

import static junit.framework.TestCase.assertTrue;

/**
 * Created by jdl50 on 5/26/17.
 */
public class TestMdcDataRepository {

    @Test
    public void testLoad() {
        DirectoryResolver mdcDataRepository = new DirectoryResolver();
        Iterator<File> it = mdcDataRepository.repo.keySet().iterator();
        while (it.hasNext()) {
            File f = it.next();
            assertTrue("File: " + f.getName() + " not found!", f.exists());
            assertTrue("Directory expected, but file found: " + f.getName(), f.isDirectory());
        }
        assertTrue(mdcDataRepository.repo.size() > 0);
    }
}
